insert into Groups
    (Id, GroupName) values
    (1, '4537'),
    (2, '4538'),
    (3, '4539');

insert into Students
    (Id, StudentName, GroupId) values
    (1, 'Igor Kolobov', 1),
    (2, 'Ivan Samborsky', 2),
    (3, 'Denis Mekhanikov', 2),
    (4, 'Boris Minaev', 3);


insert into Lecturers
    (Id, LecturerName) values
    (1, 'Kostya Kokhas'),
    (2, 'Andrew Stankevich');

insert into Courses
    (Id, CourseName) values
    (1, 'Mathematical analysis'),
    (2, 'Complex theory'), 
    (3, 'Discrete maths');

insert into Marks
    (StudentId, CourseId, Value) values
    (1, 1, 3),
    (1, 2, 4),
    (1, 3, 3),
    (2, 2, 4),
    (3, 3, 5);

insert into Semesters
    (GroupId, CourseId, LecturerId) values
    (1, 1, 1),
    (2, 1, 2),
    (2, 2, 1), 
    (3, 1, 1),
    (3, 2, 2),
    (3, 3, 2)
    ;

-- Marks of Igor Kolobov
select Students.StudentName, Marks.Value from Marks
inner join Students 
on Marks.StudentId=Students.Id and Students.Id = 1;

-- All schedule
select Groups.GroupName, Courses.CourseName, Lecturers.LecturerName from Semesters
inner join Groups
on Semesters.GroupId=Groups.Id
inner join Courses
on Semesters.CourseId=Courses.Id 
inner join Lecturers
on Semesters.LecturerId=Lecturers.Id; 








