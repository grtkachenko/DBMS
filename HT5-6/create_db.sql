drop table if exists Semesters, Marks, Students, Courses, Lecturers, Groups;

create table Groups(
	Id int PRIMARY KEY, 
	GroupName char(4) NOT NULL
);

create table Lecturers(
	Id int PRIMARY KEY, 
	LecturerName varchar(50) NOT NULL
);


create table Courses(
	Id int PRIMARY KEY, 
	CourseName varchar(30) NOT NULL
);

create table Students(
	Id int PRIMARY KEY, 
	StudentName varchar(50) NOT NULL,
	GroupId int NOT NULL, 
	FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);

create table Marks(
	StudentId int, 
	CourseId int, 
	Value int NOT NULL, 
	FOREIGN KEY (StudentId) REFERENCES Students(Id), 
	FOREIGN KEY (CourseId) REFERENCES Courses(Id), 
	PRIMARY KEY (StudentId, CourseId) 
);

create table Schedules(
	GroupId int, 
	CourseId int, 
	LecturerId int NOT NULL, 
	FOREIGN KEY (GroupId) REFERENCES Groups(Id), 
	FOREIGN KEY (CourseId) REFERENCES Courses(Id), 
	FOREIGN KEY (LecturerId) REFERENCES Lecturers(Id), 
	PRIMARY KEY (GroupId, CourseId) 
);
