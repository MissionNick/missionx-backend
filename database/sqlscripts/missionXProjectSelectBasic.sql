SELECT ProjectID, Name, ProjectPic, LearningObject, Instructions, Video,
		Activity,YearRange, Course, Subscription, Subject
FROM Project as p
	INNER JOIN 
    ActivityType as a
    ON a.ActivityTypeID=p.ActivityTypeID 
	INNER JOIN 
	YearLevel as y
    ON y.YearLevelID=p.YearLevelID
	INNER JOIN 
    Course as c
    ON c.CourseID=p.CourseID
    INNER JOIN 
    Subscription as s 
    ON s.SubscriptionID=p.SubscriptionID
	INNER JOIN 
    SubjectMatter as sm 
    ON sm.SubjectMatterID= p.SubjectMatterID


