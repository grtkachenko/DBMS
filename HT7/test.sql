drop trigger if exists MarkTrigger on Marks;
drop trigger if exists MarkValueChangeTrigger on Marks;
drop function  if exists update_rows();
drop function  if exists check_if_change_values();
drop view Losers;
drop table if exists LoserT, Schedules, Marks, Students, Courses, Lecturers, Groups;

create table Groups(
    GroupId int PRIMARY KEY, 
    GroupName char(4) NOT NULL
);

create table Lecturers(
    LecturerId int PRIMARY KEY, 
    LecturerName varchar(50) NOT NULL
);


create table Courses(
    CourseId int PRIMARY KEY, 
    CourseName varchar(30) NOT NULL
);

create table Students(
    StudentId int PRIMARY KEY, 
    StudentName varchar(50) NOT NULL,
    GroupId int NOT NULL, 
    FOREIGN KEY (GroupId) REFERENCES Groups(GroupId) on DELETE CASCADE
);

create table Marks(
    StudentId int, 
    CourseId int, 
    Value int NOT NULL, 
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId) on DELETE CASCADE, 
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) on DELETE CASCADE, 
    PRIMARY KEY (StudentId, CourseId) 
);

create table Schedules(
    GroupId int, 
    CourseId int, 
    LecturerId int NOT NULL, 
    FOREIGN KEY (GroupId) REFERENCES Groups(GroupId) on DELETE CASCADE, 
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) on DELETE CASCADE, 
    FOREIGN KEY (LecturerId) REFERENCES Lecturers(LecturerId) on DELETE CASCADE, 
    PRIMARY KEY (GroupId, CourseId) 
);

insert into Groups
    (GroupId, GroupName) values
    (1, '4537'),
    (2, '4538');

insert into Students
    (StudentId, StudentName, GroupId) values
    (1, 'Igor Kolobov', 1),
    (2, 'Ivan Samborsky', 2),
    (3, 'Denis Mekhanikov', 2),
    (4, 'Boris Minaev', 2);


insert into Lecturers
    (LecturerId, LecturerName) values
    (1, 'Korneev'),
    (2, 'Stankevich'), 
    (3, 'Kokhas');

insert into Courses
    (CourseId, CourseName) values
    (1, 'Database'),
    (2, 'Complex theory'), 
    (3, 'Discrete maths');

insert into Marks
    (StudentId, CourseId, Value) values
    (1, 2, 33),
    (1, 3, 45),
    (2, 1, 80),
    (2, 2, 80),
    (2, 3, 59),
    (3, 1, 100),
    (3, 2, 100),
    (3, 3, 90),
    (4, 1, 50);


insert into Schedules
    (GroupId, CourseId, LecturerId) values
    (1, 1, 1),
    (2, 1, 1),
    (1, 2, 2),
    (2, 2, 2),
    (1, 3, 3),
    (2, 3, 3)
    ;
---------------------

--1--
delete from Students where 
    not exists (select * from Schedules, Marks where
        Students.StudentId = Marks.StudentId and
        Schedules.CourseId = Marks.CourseId and
        Marks.Value < 60);

--2--
delete from Students where 
    Students.StudentId in (select Losers.StudentId from 
        (select SC.StudentId, count (*) as Cnt from 
            (select * from Students natural join Schedules where 
                not exists (select * from Marks where 
                Marks.CourseId = Schedules.CourseId and
                Marks.StudentId = Students.StudentId and
                Marks.Value >= 60)
        ) as SC group by SC.StudentId) as Losers where Losers.Cnt >= 3);

--3--
delete from Groups where 
    not exists (select * from Students where Students.GroupId = Groups.GroupId);

--4--
create view Losers as 
select SC.StudentId, count (*) as Cnt from 
    (select * from Students natural join Schedules where 
        not exists (select * from Marks where 
        Marks.CourseId = Schedules.CourseId and
        Marks.StudentId = Students.StudentId and
        Marks.Value >= 60)
    ) as SC group by SC.StudentId;

--5--
create table LoserT as (select * from Losers);

create function update_rows() returns trigger AS $$
    DECLARE 
        stud_id int;
        old_ok boolean;
        new_ok boolean;
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            stud_id := OLD.StudentId;
            old_ok := OLD.Value >= 60;
            new_ok := false;
        ELSIF (TG_OP = 'INSERT') THEN
            stud_id := NEW.StudentId;
            old_ok := false;
            new_ok := NEW.Value >= 60;
        ELSE
            stud_id := NEW.StudentId;
            old_ok := OLD.Value >= 60;
            new_ok := NEW.Value >= 60;
        END IF;

        IF stud_id not in (select StudentId from LoserT) THEN
            insert into LoserT values (stud_id, 0);
        END IF;

        IF (old_ok and not new_ok) THEN
            update LoserT set Cnt = Cnt + 1 where LoserT.StudentId = stud_id;
        END IF;            
        IF (not old_ok and new_ok) THEN
            update LoserT set Cnt = Cnt - 1 where LoserT.StudentId = stud_id;
        END IF;            
        delete from LoserT where LoserT.Cnt = 0;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


create trigger MarkTrigger after update or insert or delete on Marks 
    for each row execute procedure update_rows();

--6--
drop trigger if exists MarkTrigger on Marks;

--8--
-- Для спроектированной БД это проверка будет всегда верна --


--9--
create function check_if_change_values() returns trigger AS $$
    BEGIN
        IF (NEW.Value < OLD.Value) THEN
            RETURN OLD;
        ELSE
            RETURN NEW;
        END IF;
    END;
$$ LANGUAGE plpgsql;


create trigger MarkValueChangeTrigger before update on Marks 
    for each row execute procedure check_if_change_values();






