/* Create Tables */
CREATE TABLE ActivityType (
  ActivityTypeID INT NOT NULL AUTO_INCREMENT,
  Activity VARCHAR(20) NULL,
  Description MEDIUMTEXT NULL,
  PRIMARY KEY (ActivityTypeID)
    )
COMMENT = 'Project Activity Types';

CREATE TABLE Yearlevel (
  YearLevelID INT NOT NULL AUTO_INCREMENT,
  YearRange VARCHAR(5) NOT NULL,
  PRIMARY KEY (YearLevelID)
  )
  COMMENT = 'Project content education Year Levels ';
  
  CREATE TABLE Subscription (
	SubscriptionID INT NOT NULL AUTO_INCREMENT,
	Subscription VARCHAR(20) NOT NULL,
	PRIMARY KEY (SubscriptionID)
  )
  COMMENT = 'Student Subscription types';
  
  CREATE TABLE Course (
	CourseID INT NOT NULL AUTO_INCREMENT,
	Course VARCHAR(20) NOT NULL,
	Description MEDIUMTEXT NULL,
	PRIMARY KEY (CourseID)
    )
    COMMENT = 'Course levels';
    
CREATE TABLE Subjectmatter (
  SubjectMatterID INT NOT NULL AUTO_INCREMENT,
  Subject VARCHAR(20) NOT NULL,
  Description MEDIUMTEXT NULL,
  PRIMARY KEY (SubjectmatterID)
  )
  COMMENT = 'Project subject';
  
Create TABLE Project (
  ProjectID int NOT NULL AUTO_INCREMENT,
  Name varchar(50),
  ProjectPic VARCHAR(512) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL,
  LearningObject mediumtext,
  Instructions mediumtext,
  Video varchar(200),
  ActivityTypeID int,
  YearLevelID int,
  CourseID int,
  SubscriptionId int,  
  SubjectMatterID int,
  PRIMARY KEY (ProjectID),
  FOREIGN KEY(YearLevelID)
        REFERENCES YearLevel(YearLevelID)
        ON DELETE CASCADE,
  FOREIGN KEY(SubscriptionID) 
        REFERENCES Subscription(SubscriptionID)
        ON DELETE CASCADE,
  FOREIGN KEY(CourseID) 
        REFERENCES Course(CourseID)
        ON DELETE CASCADE,
  FOREIGN KEY(SubjectmatterID) 
        REFERENCES Subjectmatter(SubjectmatterID)
        ON DELETE CASCADE,
	FOREIGN KEY(ActivityTypeID) 
        REFERENCES  ActivityType(ActivityTypeID)
        ON DELETE CASCADE
)
COMMENT = 'Project content joined with project meta data. Activity, Subject etc';

Create TABLE Teacher (
  TeacherID int NOT NULL AUTO_INCREMENT,
  Name varchar(100),
  Email varchar(100) UNIQUE,
  Password binary(60),
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
	Email varchar(100) UNIQUE,
	Password binary(60),
	School varchar(100),
	ProfilePic varchar(200),
	DateOfBirth date,
	contactNumber varchar(15),
	course varchar(20),
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
)
COMMENT = 'Student help requests';

Create TABLE ProgressHistory (
  StudentID int,
  ProjectID int,
  DateStarted date DEFAULT (CURRENT_DATE),
  DateSubmitted date,
  DateCompleted date,
  Submission VARCHAR(512) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci',
  
  FOREIGN KEY(StudentID) 
        REFERENCES Student(StudentID)
        ON DELETE CASCADE,
        
 FOREIGN KEY(ProjectID) 
        REFERENCES Project(ProjectID)
        ON DELETE CASCADE
  
)
COMMENT = 'Student project progress history';