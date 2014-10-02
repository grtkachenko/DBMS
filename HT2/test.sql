insert into Groups
    (Id, GroupName) values
    (1, '4537'),
    (2, '4538'),
    (3, '4539');

insert into Students
    (Id, Name, Birthday, Phone, GroupId) values
    (1, 'Igor Kolobov', '29/Oct/94', '+79650783351', 1),
    (2, 'Ivan Samborsky', '21/Oct/93', '+73150583351', 2),
    (3, 'Denis Mekhanikov', '22/Oct/93', '+73150583441', 2),
    (4, 'Boris Minaev', '20/Jan/94', '+79650783351', 3);


insert into Teachers
    (Id, Name) values
    (1, 'Kostya Kokhas'),
    (2, 'Andrew Stankevich');

insert into Subjects
    (Id, SubjectName, TeacherId) values
    (1, 'Mathematical analysis', 1),
    (2, 'Complex theory', 2), 
    (3, 'Discrete maths', 2);

insert into Marks
    (StudentId, SubjectId, Value) values
    (1, 1, 3),
    (1, 2, 4),
    (1, 3, 3),
    (2, 2, 4),
    (3, 3, 5);

insert into Semesters
    (GroupId, SubjectId, Semester) values
    (1, 1, 1),
    (2, 1, 2),
    (2, 2, 1), 
    (3, 1, 1),
    (3, 2, 2),
    (3, 3, 3)
    ;

-- Marks of Igor Kolobov
select Students.Name, Marks.Value from Marks
inner join Students 
on Marks.StudentId=Students.Id and Students.Id = 1;

-- 
select Groups.GroupName, Subjects.SubjectName, Semesters.Semester from Semesters
inner join Groups
on Semesters.GroupId=Groups.Id
inner join Subjects
on Semesters.SubjectId=Subjects.Id and Groups.Id = 3;

select Teachers.Name, Groups.GroupName, Subjects.SubjectName, Semesters.Semester from Semesters
inner join Subjects
on Semesters.SubjectId=Subjects.Id
inner join Groups
on Semesters.GroupId=Groups.Id
inner join Teachers
on Teachers.Id=Subjects.TeacherId and Teachers.Id = 2;







