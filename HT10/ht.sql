drop function if exists Stats();
drop function if exists CloseFlight(int);
drop function if exists BuyBooked(int, int, int);
drop function if exists Buy(int, int, int);
drop function if exists ExtendBooking(int, int, int);
drop function if exists Book(int, int, int);
drop function if exists AvalabileForBookOrSelling(int);

drop view if exists AvailableForSellTickets, AvailableForBookTickets, BookedTickets;
drop table if exists Tickets, Seats, Flights, Customers, Planes;
drop type if exists TicketState;

create type TicketState as enum ('available', 'booked', 'sold', 'unavailable');

create table Planes (
    PlaneId int PRIMARY KEY
);

create table Customers (
    CustomerId int PRIMARY KEY
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
    CustomerId  int,
    BookTime    timestamp,
    State       TicketState NOT NULL,

    FOREIGN KEY (PlaneId, SeatNo) REFERENCES Seats(PlaneId, SeatNo) on DELETE CASCADE,
    FOREIGN KEY (FlightId) REFERENCES Flights(FlightId) on DELETE CASCADE, 
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId) on DELETE CASCADE, 
    PRIMARY KEY (FlightId, SeatNo)
);

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
create function FreeSeats(fid int) returns table (seatno int) as $$
begin
    set transaction isolation level serializable read only;
    return query
    (select SeatNo
    from AvailableForBookTickets, AvailableForSellTickets where
    FlightId = fid);
end;
$$ language plpgsql;

-- 2
create function Reserve(fid int, seatno int) returns boolean as $$
begin
    set transaction isolation level serializable read write;
    if ((select count(*)
        from AvailableForBookTickets
        where FlightId = fid and SeatNo = seatno) > 0) then
        update Tickets set State = 'booked', BookTime = localtimestamp 
        where (FlightId = fid and SeatNo = seatno);
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

-- 3
create function ExtendReservation(fid int, seatno int) returns boolean as $$
begin
    set transaction isolation level serializable read write;
    if ((select count(*)
        from BookedTickets
        where (FlightId = fid and SeatNo = seatno) > 0) then
        update Tickets set Time = localtimestamp
        where (FlightId = fid and SeatNo = seatno);
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

-- 4
create function BuyFree(fid int, seatno int) returns boolean as $$
begin
    set transaction isolation level serializable read write;
    if ((select count(*)
        from AvailableForSellTickets
        where FlightId = fid and SeatNo = seatno) > 0) then
        update Tickets set State = 'sold', BookTime = localtimestamp 
        where (FlightId = fid and SeatNo = seatno);
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

-- 5
create function BuyReserved(fid int, seatno int) returns boolean as $$
begin
    set transaction isolation level serializable read write;
    if ((select count(*)
        from BookedTickets
        where FlightId = fid and SeatNo = seatno) > 0) then
        update Tickets set State = 'sold' 
        where (FlightId = fid and SeatNo = seatno);
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

-- 6
create function FlightStatistics() returns table (fid int, can_book boolean, can_sell boolean, available int, booked int, sold int) as $$
begin
    set transaction isolation level serializable read only;
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
