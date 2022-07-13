/* Test Data */
 

INSERT INTO TEACHER (Name, Email, Password, School, ProfilePic, DateOfBirth, ContactNumber)
VALUES(
'Deadpool',
'Wade.WinstonWilsonl@marvel.com',
"$2b$10$MajzoXR8croWcu6z9CqNTuRgXRdgZ/Khpv1W07jzHWzEPt/BQszRK",
'Marvel Academy',
'https://cdn.filestackcontent.com/1tUaNY7wQVHae2E3KbEN',
'1973-11-22',
'55-555-5555'
),
(
'Stan Lee',
'Stan.Lee@marvel.com',
"$2b$10$F16DcN8fBf/CCIaBlWONiuyoz7G2TnLOmpUCILIIpYJ3P538hOv7S",
'Marvel Academy',
'https://cdn.filestackcontent.com/MdSjgm9yQPqAqhR7sNrR',
'1922-12-28',
'55-555-5555'
);

INSERT INTO STUDENT (TeacherID,Name, Email, Password, School, ProfilePic, DateOfBirth, ContactNumber, Course)
VALUES(
'1',
'Groot',
'Groot@marvel.com',
'$2b$10$qvcZHjfWTQDti7RPW9dOU.U4HvkMwwmh0mkNcewY3ccEbeEI3lyoi',
'Marvel Academy',
'https://cdn.filestackcontent.com/CjZlRoDdQcaiL0DLwMRi',
'1960-11-01',
'55-555-5555',
'1'),
(
'1',
'Spiderman',
'peter.parker@marvel.com',
'$2b$10$zgs8btmO2hqV.HrXUZZvM.h/lbDyRYSORNMf9O.wEThcS0FN8k65u',
'Marvel Academy',
'https://cdn.filestackcontent.com/L2EqDKS2RFa4E3eOPYeq',
'2001-08-10',
'55-555-5555',
'2');

INSERT INTO `progresshistory`
(`StudentID`,
`ProjectID`,
`DateStarted`,
`DateSubmitted`,
`DateCompleted`,
`Submission`)
VALUES
('1','1','2021-10-20','2021-11-01','2021-11-20','https//studentsub.sub@edu.co');

INSERT INTO `missionx`.`progresshistory`
(`StudentID`,
`ProjectID`)
VALUES
(1,3),(1,4),(1,3),(1,10),(1,20),(1,21),(1,22),(1,23),(1,30),(1,31),(1,32),(1,34),(1,35),(1,50),(1,51),
(2,11),(2,12),(2,13),(2,5),(2,6),(2,34),(2,35),(2,36),(2,37),(2,41),(2,42),(2,59)





