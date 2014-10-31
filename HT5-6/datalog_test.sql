drop table if exists Schedules, Marks, Students, Courses, Lecturers, Groups;

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
    FOREIGN KEY (GroupId) REFERENCES Groups(GroupId)
);

create table Marks(
    StudentId int, 
    CourseId int, 
    Value int NOT NULL, 
    FOREIGN KEY (StudentId) REFERENCES Students(StudentId), 
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId), 
    PRIMARY KEY (StudentId, CourseId) 
);

create table Schedules(
    GroupId int, 
    CourseId int, 
    LecturerId int NOT NULL, 
    FOREIGN KEY (GroupId) REFERENCES Groups(GroupId), 
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId), 
    FOREIGN KEY (LecturerId) REFERENCES Lecturers(LecturerId), 
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
    (2, 1, 3),
    (3, 1, 4),
    (1, 2, 3),
    (2, 2, 4),
    (3, 2, 4),
    (4, 2, 5),
    (1, 3, 3),
    (2, 3, 4),
    (3, 3, 4),
    (4, 3, 5);


insert into Schedules
    (GroupId, CourseId, LecturerId) values
    (2, 1, 1),
    (1, 2, 2),
    (2, 2, 2),
    (1, 3, 3),
    (2, 3, 3)
    ;
-----------------------------------------------

--1--
--2a--
--2b--
--3--
--4--
--5--
--6--
--7--
--8--