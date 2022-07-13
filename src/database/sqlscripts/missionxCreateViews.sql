/* Create Report and Application filter views 
   - @ TODO Permission access controls to be applied */

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
) ;

/* Test Route call */

 SELECT 
 NOW() AS `DB_PING`,
 CONNECTION_ID() AS `CONNECTION_ID`,
 LAST_INSERT_ID() AS `LAST_INSERT_ID`,
 DATABASE() as DB_NAME, 
 CURRENT_USER() as USER,
 VERSION() as DB_VERSION,
 USER(),
 ICU_VERSION() as REGEX_VERSION,
 BENCHMARK(1000000,AES_ENCRYPT('hello','goodbye')) as BENCHMARK_AES;
