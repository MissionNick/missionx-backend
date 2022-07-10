
Create TABLE Project (
  ProjectID int NOT NULL AUTO_INCREMENT,
  Name varchar(50),
  ProjectPic VARCHAR(512) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL,
  LearningObject mediumtext,
  Instructions mediumtext,
  Video varchar(200),
  ActivityType varchar(20),
  YearLevel int,
  Course varchar(20),
  Subscription varchar(20),  
  SubjectMatter varchar(20),
  PRIMARY KEY (ProjectID)
  
);
Create TABLE Teacher (
  TeacherID int NOT NULL AUTO_INCREMENT,
  Name varchar(100),
  Email varchar(100),
  Password varchar(20),
  School varchar(100),
  ProfilePic varchar(200),
  DateOfBirth date,
  ContactNumber varchar(15),
  PRIMARY KEY(TeacherID)
 );
 
Create TABLE Student (
	StudentID int NOT NULL AUTO_INCREMENT,
    TeacherID int,
	Name varchar(100),
	Email varchar(100),
	Password varchar(20),
	School varchar(100),
	ProfilePic varchar(200),
	DateOfBirth date,
	ContactNumber varchar(15),
	Course varchar(20),
	PRIMARY KEY (StudentID),
	FOREIGN KEY(TeacherID) 
        REFERENCES Teacher(TeacherID)
        ON DELETE CASCADE
);

Create TABLE HelpRequest (
	RequestID int NOT NULL AUTO_INCREMENT,
    StudentID int,
	DateCreated datetime,
	Done tinyint,
	PRIMARY KEY (RequestID),
	FOREIGN KEY(StudentID) 
		REFERENCES Student(StudentID)
		ON DELETE CASCADE
);

 

Create TABLE ProgressHistory (
  StudentID int,
  ProjectID int,
  DateStarted date,
  DateSubmitted date,
  DateCompleted date,
  Submission VARCHAR(512) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL,
  
  FOREIGN KEY(StudentID) 
        REFERENCES Student(StudentID)
        ON DELETE CASCADE,
        
 FOREIGN KEY(ProjectID) 
        REFERENCES Project(ProjectID)
        ON DELETE CASCADE
  
);