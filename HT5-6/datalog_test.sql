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
    (2, 1, 2),
    (3, 1, 4),
    (1, 2, 3),
    (2, 2, 4),
    (3, 2, 4),
    (4, 2, 2),
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
select Students.StudentName, Students.StudentId from Students, Courses
where
Courses.CourseName = 'Database' and
(exists
  (select * from Marks
   where
   Students.StudentId = Marks.StudentId and
   4 = Marks.Value and
   Courses.CourseId = Marks.CourseId));
--2a--
select Students.StudentName, Students.StudentId from Students, Courses
where
Courses.CourseName = 'Database' and
(not exists
  (select * from Marks
   where
   Students.StudentId = Marks.StudentId and
   Courses.CourseId = Marks.CourseId));
--2b--
select Students.StudentName, Students.StudentId from Students, Courses
where
Courses.CourseName = 'Database' and
(not exists
  (select * from Marks
   where
   Students.StudentId = Marks.StudentId and
   Courses.CourseId = Marks.CourseId)) and
(exists
  (select * from Schedules
   where
   Schedules.GroupId = Students.GroupId and
   Schedules.CourseId = Courses.CourseId));
--3--
select Students.StudentId from Students, Marks, Schedules, Lecturers
where
Students.GroupId = Schedules.GroupId and
Schedules.CourseId = Marks.CourseId and
Schedules.LecturerId = Lecturers.LecturerId and
Marks.StudentId = Students.StudentId and
Lecturers.LecturerName = 'Korneev';
--4--
select Students.StudentId from Students, Schedules, Lecturers
where
Schedules.LecturerId = Lecturers.LecturerId and
Lecturers.LecturerName = 'Korneev' and
(not exists
    (select * from Marks 
    where
    Marks.StudentId = Students.StudentId and
    Marks.CourseId = Schedules.CourseId));

--5--
select Students.StudentId, Students.StudentName from Students, Lecturers
where
Lecturers.LecturerName = 'Korneev' and
(not exists
    (select * from Schedules
    where
    Schedules.LecturerId = Lecturers.LecturerId and
    Schedules.GroupId = Students.GroupId and
    (not exists 
        (select * from Marks 
        where 
        Marks.StudentId = Students.StudentId and
        Marks.CourseId = Schedules.CourseId))));
--6--
select Students.StudentName, Courses.CourseName from Students, Courses, Schedules
where
Students.GroupId = Schedules.GroupId and
Schedules.CourseId = Courses.CourseId;

--7--
select Lecturers.LecturerName, Students.StudentName from Students, Lecturers, Schedules
where
Schedules.LecturerId = Lecturers.LecturerId and
Schedules.GroupId = Students.GroupId;

--8--
select Students.StudentName, Courses.CourseName, Marks.Value from 
    Students natural join Marks natural join Courses;

select Students1.StudentName, Students2.StudentName from Students as Students1, Students as Students2
where
Students1.StudentId <> Students2.StudentId and
(not exists
    (select * from Courses, Marks as Marks1, Marks as Marks2
    where
    Marks1.CourseId = Courses.CourseId and
    Marks2.CourseId = Courses.CourseId and
    Marks1.StudentId = Students1.StudentId and
    Marks2.StudentId = Students2.StudentId and
    Marks1.Value > 2 and
    Marks2.Value < 3)) 
and
(not exists
    (select * from Courses, Marks as Marks1
    where
    Marks1.CourseId = Courses.CourseId and
    Marks1.StudentId = Students1.StudentId and
    Marks1.Value > 2 and
    (not exists 
        (select * from Marks as Marks2
        where 
        Marks2.StudentId = Students2.StudentId and
        Marks2.CourseId = Courses.CourseId))));




