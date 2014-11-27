drop table if exists Schedules, Marks, Students, Courses, Lecturers, Groups CASCADE;

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

create index StudentsByGroups on Students(GroupId);
create index GroupIdByName on Groups(GroupName);
create index CourseIdByName on Courses(CourseName);
create index StudentIdByName on Students(StudentName);









