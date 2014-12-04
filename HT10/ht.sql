drop function if exists CompressSeats(int);
drop function if exists CompressHelp(int[], int[], int, int);
drop function if exists FlightStatistics();
drop function if exists BuyReserved(int, int);
drop function if exists BuyFree(int, int);
drop function if exists ExtendReservation(int, int);
drop function if exists Reserve(int, int);
drop function if exists FreeSeats(int);

drop view if exists AvailableForSellTickets, AvailableForBookTickets, BookedTickets;
drop table if exists Tickets, Seats, Flights, Planes;
drop type if exists TicketState;

create type TicketState as enum ('available', 'booked', 'sold', 'unavailable');

create table Planes (
    PlaneId int PRIMARY KEY
);

create table Flights (
    FlightId    int PRIMARY KEY,
    FlightTime  timestamp NOT NULL,
    PlaneId     int NOT NULL,
    FOREIGN KEY (PlaneId) REFERENCES Planes(PlaneId) on DELETE CASCADE
);

create table Seats (
    PlaneId     int,
    SeatNo      int,
    FOREIGN KEY (PlaneId) REFERENCES Planes(PlaneId) on DELETE CASCADE, 
    PRIMARY KEY (PlaneId, SeatNo)
);

create table Tickets (
    FlightId    int,
    PlaneId     int,
    SeatNo      int,
    BookTime    timestamp,
    State       TicketState NOT NULL,

    FOREIGN KEY (PlaneId, SeatNo) REFERENCES Seats(PlaneId, SeatNo) on DELETE CASCADE,
    FOREIGN KEY (FlightId) REFERENCES Flights(FlightId) on DELETE CASCADE, 
    PRIMARY KEY (FlightId, SeatNo)
);

insert into Planes (PlaneId) values(1);
insert into Flights (FlightId, FlightTime, PlaneId) values(1, '2021-09-28 01:00:00', 1);
insert into Seats (PlaneId, SeatNo) values 
	(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8);
insert into Tickets (FlightId, PlaneId, SeatNo, State) values 
	(1, 1, 1, 'available'), (1, 1, 2, 'available'), (1, 1, 3, 'available'), (1, 1, 4, 'available'), 
	(1, 1, 5, 'available'), (1, 1, 6, 'available'), (1, 1, 7, 'available'), (1, 1, 8, 'available');


-- Забронированные билеты, бронь на которые действительна
create view BookedTickets as
select *
from (Flights natural join Seats natural join Tickets)
where (State = 'booked' and (FlightTime - localtimestamp >= interval '1 day') and (localtimestamp - BookTime < interval '1 day'));

-- Все доступные к текущему моменту билеты для брони
create view AvailableForBookTickets as
select *
from (Flights natural join Seats natural join Tickets)
where 
((FlightTime - localtimestamp >= interval '1 day') and 
State = 'available' or (State = 'booked' and (localtimestamp - BookTime >= interval '1 day')));

-- Все доступные к текущему моменту билеты для продажи
create view AvailableForSellTickets as
select *
from (Flights natural join Seats natural join Tickets)
where 
((FlightTime - localtimestamp >= interval '2 hours') and 
State = 'available' or (State = 'booked' and (localtimestamp - BookTime >= interval '1 day' or FlightTime - localtimestamp < interval '1 day')));

------------------------------------------------------------------------------------------------------
-- 1
create function FreeSeats(fid int) returns table (seat_no int) as $$
begin
    return query
    (select SeatNo
    from AvailableForBookTickets natural join AvailableForSellTickets where
    FlightId = fid);
end;
$$ language plpgsql;

-- 2
create function Reserve(fid int, seat_no int) returns boolean as $$
begin
    if ((select count(*)
        from AvailableForBookTickets
        where FlightId = fid and SeatNo = seat_no) > 0) then
        update Tickets set State = 'booked', BookTime = localtimestamp 
        where (FlightId = fid and SeatNo = seat_no);
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

-- 3
create function ExtendReservation(fid int, seat_no int) returns boolean as $$
begin
    if ((select count(*)
        from BookedTickets
        where (FlightId = fid and SeatNo = seat_no)) > 0) then
        update Tickets set Time = localtimestamp
        where (FlightId = fid and SeatNo = seat_no);
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

-- 4
create function BuyFree(fid int, seat_no int) returns boolean as $$
begin
    if ((select count(*)
        from AvailableForSellTickets
        where FlightId = fid and SeatNo = seat_no) > 0) then
        update Tickets set State = 'sold', BookTime = localtimestamp 
        where (FlightId = fid and SeatNo = seat_no);
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

-- 5
create function BuyReserved(fid int, seat_no int) returns boolean as $$
begin
    if ((select count(*)
        from BookedTickets
        where FlightId = fid and SeatNo = seat_no) > 0) then
        update Tickets set State = 'sold' 
        where (FlightId = fid and SeatNo = seat_no);
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

-- 6
create function FlightStatistics() returns table (fid int, can_book boolean, can_sell boolean, available int, booked int, sold int) as $$
begin
    return query
        (select FlightId as fid,
                ((select count(*) from AvailableForBookTickets as A where A.FlightId = fid) > 0) as can_book, 
                ((select count(*) from AvailableForSellTickets as A where A.FlightId = fid) > 0) as can_sell, 
                (select count(*) from AvalabileForBookOrSelling(fid)) as available,
                (select count(*) from BookedTickets as B where B.FlightId = fid) as booked,
                (select count(*) from Tickets as T where T.State = 'sold' and T.FlightId = fid) as sold
        from Flights);
end;
$$ language plpgsql;

-- 7
create function CompressHelp(arr int[], help_arr int[], min_val int, fid int) returns int[] as $$
begin
	if (array_length(arr, 1) > 0) then
		for i IN min_val..array_length(arr, 1)+min_val-1 loop
			if (i <> arr[i-min_val+1]) then
				perform array_replace(arr, i, arr[i-min_val+1]);
				perform array_replace(help_arr, i, arr[i-min_val+1]);
				update Tickets set SeatNo = -1 where (FlightId = fid and SeatNo = i);
				update Tickets set SeatNo = i where (FlightId = fid and SeatNo = arr[i-min_val+1]);
				update Tickets set SeatNo = arr[i-min_val+1] where (FlightId = fid and SeatNo = -1);
		    end if;
		end loop;
    end if;	
    return help_arr;
end;
$$ language plpgsql;

create function CompressSeats(fid int) returns void as $$
declare sold_num int[];
		booked_num int[];
		plane_id int;
		sold_len int;

begin
	booked_num := array(select SeatNo from BookedTickets as B where B.FlightId = fid);
	sold_num := array(select SeatNo from Tickets as T where T.State = 'sold' and T.FlightId = fid);
	select PlaneId from Flights as F where F.FlightId = fid into plane_id;
	insert into Seats (PlaneId, SeatNo) values(plane_id, -1);
	select CompressHelp(sold_num, booked_num, 1, fid) into booked_num;
    if (array_length(sold_num, 1) > 0) then
    	sold_len := array_length(sold_num, 1);    
    else
        sold_len := 0;
    end if;	
	perform CompressHelp(booked_num, booked_num, sold_len + 1, fid);	
	delete from Seats where SeatNo = -1;
end;
$$ language plpgsql;


