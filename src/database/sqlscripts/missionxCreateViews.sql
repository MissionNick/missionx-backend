USE `missionx`;
CREATE  OR REPLACE VIEW `project_view` AS
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
        
        
CREATE  OR REPLACE VIEW `studentprojects` AS
    SELECT 
        `p`.`ProjectID` AS `ProjectID`,
        `p`.`Name` AS `Name`,
        `p`.`ProjectPic` AS `ProjectPic`,
        `p`.`LearningObject` AS `LearningObject`,
        `p`.`Instructions` AS `Instructions`,
        `p`.`Video` AS `Video`,
        `p`.`ActivityTypeID` AS `ActivityTypeID`,
        `p`.`YearLevelID` AS `YearLevelID`,
        `p`.`CourseID` AS `CourseID`,
        `p`.`SubscriptionId` AS `SubscriptionId`,
        `p`.`SubjectMatterID` AS `SubjectMatterID`,
        `StudentID` 
    FROM
        (`project` `p`
        JOIN `progresshistory` `h` ON ((`p`.`ProjectID` = `h`.`ProjectID`)))
