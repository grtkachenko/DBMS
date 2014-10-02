drop table if exists Semesters, Marks, Students, Subjects, Teachers, Groups;

create table Groups(
	Id int PRIMARY KEY, 
	GroupName char(4) NOT NULL
);

create table Teachers(
	Id int PRIMARY KEY, 
	Name varchar(50) NOT NULL
);

create table Subjects(
	Id int PRIMARY KEY, 
	SubjectName varchar(50) NOT NULL, 
	TeacherId int NOT NULL, 
	FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

create table Students(
	Id int PRIMARY KEY, 
	Name varchar(50) NOT NULL, 
	Birthday date NOT NULL, 
	Phone varchar(15), 
	GroupId int NOT NULL,
	FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);

create table Marks(
	StudentId int, 
	SubjectId int, 
	Value int NOT NULL, 
	FOREIGN KEY (StudentId) REFERENCES Students(Id), 
	FOREIGN KEY (SubjectId) REFERENCES Subjects(Id), 
	PRIMARY KEY (StudentId, SubjectId) 
);

create table Semesters(
	GroupId int, 
	SubjectId int, 
	Semester int NOT NULL, 
	FOREIGN KEY (GroupId) REFERENCES Groups(Id), 
	FOREIGN KEY (SubjectId) REFERENCES Subjects(Id), 
	PRIMARY KEY (GroupId, SubjectId) 
);
