/* Create Report and Application filter views 
   - @ TODO Permission access controls to be applied */

CREATE OR REPLACE VIEW `teacher_profile_vw` AS
(SELECT
teacher_id, name, email, password, school, profilepic, date_of_birth, contact_number

FROM teacher);


CREATE  OR REPLACE VIEW `projects_vw` AS
    SELECT 
        ProjectID,
        Name,
        ProjectPic,
        LearningObject,
        Instructions,
        Video,
        Activity,
        YearRange,
        Course,
        Subscription,
        Subject
    FROM
        Project AS p
            INNER JOIN
        ActivityType AS a ON a.ActivityTypeID = p.ActivityTypeID
            INNER JOIN
        YearLevel AS y ON y.YearLevelID = p.YearLevelID
            INNER JOIN
        Course AS c ON c.CourseID = p.CourseID
            INNER JOIN
        Subscription AS s ON s.SubscriptionID = p.SubscriptionID
            INNER JOIN
        SubjectMatter AS sm ON sm.SubjectMatterID = p.SubjectMatterID;
        
        
CREATE OR REPLACE VIEW `student_profile_vw` AS
(SELECT
student_id, s.teacher_id, s.name, s.email, s.password, s.school, s.profilepic, s.date_of_birth, s.contact_number, s.course_id,
c.course as course, t.name as teacher_name

FROM student as s

INNER JOIN `course` AS `c` ON `s`.`course_id` = `c`.`id`
INNER JOIN `teacher` AS `t` ON `s`.`teacher_id` = `t`.`teacher_id`);


CREATE OR REPLACE VIEW `projects_filter_vw` AS
   ( SELECT 
        `p`.`ProjectID`,
        `p`.`Name`,
        `p`.`ProjectPic`,
        `p`.`LearningObject`,
        `p`.`Instructions`,
        `p`.`Video`,
        `p`.`ActivityTypeID`, 
        `pv`.`Activity`,
        `p`.`YearLevelID`,
        `pv`.`YearRange`,
        `p`.`CourseID`,
        `pv`.`Course`,
        `p`.`SubscriptionId`,
        `pv`.`Subscription`,
        `p`.`SubjectMatterID`,
        `pv`.`Subject`
	FROM  `project` AS `p`
        INNER JOIN `projects_vw` AS `pv` ON `p`.`ProjectID` = `pv`.`ProjectID`
	ORDER BY ProjectID
     )   ;
        
CREATE  OR REPLACE VIEW `student_projects_vw` AS
    (SELECT 
        `p`.`ProjectID`, 
        `p`.`Name`, 
        `p`.`ProjectPic`,
        `p`.`LearningObject`, 
        `p`.`Instructions`, 
        `p`.`Video` ,
        `p`.`ActivityTypeID`,
        `p`.`YearLevelID`,
        `p`.`CourseID`, 
        `p`.`SubscriptionId`, 
        `p`.`SubjectMatterID`,
        `StudentID`
    FROM  `project` AS `p`
        INNER JOIN `progresshistory` AS `h` ON `p`.`ProjectID` = `h`.`ProjectID`
	ORDER BY ProjectID
     )   ;
        
CREATE OR REPLACE VIEW `student_projects_filter_vw` AS
   ( SELECT 
        `p`.`ProjectID`,
        `p`.`Name`,
        `p`.`ProjectPic`,
        `p`.`LearningObject`,
        `p`.`Instructions`,
        `p`.`Video`,
        `p`.`ActivityTypeID`, 
        `pv`.`Activity`,
        `p`.`YearLevelID`,
        `pv`.`YearRange`,
        `p`.`CourseID`,
        `pv`.`Course`,
        `p`.`SubscriptionId`,
        `pv`.`Subscription`,
        `p`.`SubjectMatterID`,
        `pv`.`Subject`,
        `h`.`StudentID`
    FROM  `project` AS `p`
        INNER JOIN `progresshistory` AS `h` ON `p`.`ProjectID` = `h`.`ProjectID`
        INNER JOIN `projects_vw` AS `pv` ON `p`.`ProjectID` = `pv`.`ProjectID`
	ORDER BY ProjectID
) ;

/* Test Route call */

CREATE OR REPLACE VIEW `heartbeat_vw` AS

 (SELECT 
 NOW() AS `DB_PING`,
 CONNECTION_ID() AS `CONNECTION_ID`,
 LAST_INSERT_ID() AS `LAST_INSERT_ID`,
 DATABASE() as DB_NAME, 
 CURRENT_USER() as USER,
 VERSION() as DB_VERSION,
 USER(),
 ICU_VERSION() as REGEX_VERSION,
 BENCHMARK(1000000,AES_ENCRYPT('hello','goodbye')) as BENCHMARK_AES
 );
