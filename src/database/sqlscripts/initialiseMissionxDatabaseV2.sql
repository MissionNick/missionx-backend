USE `missio20_team4`;

DROP TABLE IF EXISTS `help_request`;
DROP TABLE IF EXISTS `progress_history`;
DROP TABLE IF EXISTS `project`;
DROP TABLE IF EXISTS `student`;
DROP TABLE IF EXISTS `teacher`;
DROP TABLE IF EXISTS `year_level`;
DROP TABLE IF EXISTS `course`;
DROP TABLE IF EXISTS `subject_matter`;
DROP TABLE IF EXISTS `subscription`;
DROP TABLE IF EXISTS `activity_type`;

CREATE TABLE activity_type (  
 id INT NOT NULL AUTO_INCREMENT,   
 activity VARCHAR(20) NULL,   
 PRIMARY KEY (id)   ) COMMENT = 'project Activity Types';

CREATE TABLE year_level ( 
 id INT NOT NULL AUTO_INCREMENT, 
 years VARCHAR(5) NOT NULL,  
 PRIMARY KEY (id)   )   COMMENT = 'project content education Year Levels ';
 
CREATE TABLE subscription (  
id INT NOT NULL AUTO_INCREMENT,  
subscription VARCHAR(20) NOT NULL,  
PRIMARY KEY (id)   )   COMMENT = 'student subscription types';

CREATE TABLE course ( 
 id INT NOT NULL AUTO_INCREMENT,  
 course VARCHAR(20) NOT NULL,  
 PRIMARY KEY (id)     )     COMMENT = 'course levels';

CREATE TABLE subject_matter (   
id INT NOT NULL AUTO_INCREMENT,   
subject_m VARCHAR(20) NOT NULL,   
PRIMARY KEY (id)   )   COMMENT = 'project subject. field name subject_m to avoid reserved word issues.';

Create TABLE project (   
project_id int NOT NULL AUTO_INCREMENT,  
name varchar(50),   
projectpic VARCHAR(512) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL,   
learning_object mediumtext,   
instructions mediumtext,   
video varchar(200),   
activity_type_id int,   
year_level_id int,   
course_id int,   
subscription_id int,     
subject_matter_id int,   
PRIMARY KEY (project_id),   

FOREIGN KEY(year_level_id)         
	REFERENCES year_level(id)         
	ON DELETE CASCADE,   
FOREIGN KEY(subscription_id)         
	REFERENCES subscription(id)         
    ON DELETE CASCADE,   
    
FOREIGN KEY(course_id)          
	REFERENCES course(id)        
    ON DELETE CASCADE,   
    
FOREIGN KEY(subject_matter_id)          
	REFERENCES subject_matter(id)        
    ON DELETE CASCADE,  
    
FOREIGN KEY(activity_type_id)          
	REFERENCES  activity_type(id)         
    ON DELETE CASCADE ) COMMENT = 'project content joined with project meta data. Activity, Subject etc';

Create TABLE teacher (  
 teacher_id int NOT NULL AUTO_INCREMENT,   
 name varchar(100),   
 email varchar(100) UNIQUE,   
 password binary(60),   
 school varchar(100),   
 profilepic varchar(200),   
 date_of_birth date,   
 contact_number varchar(15),   
 PRIMARY KEY(teacher_id)  );
 
Create TABLE student (  
student_id int NOT NULL AUTO_INCREMENT,     
teacher_id int,  
name varchar(100),  
email varchar(100) UNIQUE,  
password binary(60),  
school varchar(100),  
profilepic varchar(200),  
date_of_birth date,  
contact_number varchar(15),  
course varchar(20),  PRIMARY KEY (student_id),       

FOREIGN KEY(teacher_id)          
	REFERENCES teacher(teacher_id)         
    ON DELETE CASCADE );

Create TABLE help_request (  
request_id int NOT NULL AUTO_INCREMENT,     
student_id int,  
date_created datetime,  
done tinyint,  
PRIMARY KEY (request_id),  

FOREIGN KEY(student_id)    
	REFERENCES student(student_id)   
    ON DELETE CASCADE ) COMMENT = 'student help requests';

Create TABLE progress_history (   
student_id int,   
project_id int,   
date_started date DEFAULT (CURRENT_DATE),   
date_submitted date,   
date_completed date,   
submission VARCHAR(512) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci',      

FOREIGN KEY(student_id)          
	REFERENCES student(student_id)         
    ON DELETE CASCADE,           

FOREIGN KEY(project_id)          
	REFERENCES project(project_id)        
    ON DELETE CASCADE    ) COMMENT = 'student project progress history';
    
CREATE OR REPLACE VIEW `teacher_profile_vw` AS
(SELECT
teacher_id, name, email, password, school, profilepic, date_of_birth, contact_number

FROM teacher);

CREATE  OR REPLACE VIEW `projects_vw` AS     
SELECT 
	project_id,         
	name,        
    projectpic,         
    learning_object,         
    instructions,         
    video,         
    activity,         
    years,         
    course,         
    subscription,         
    subject_m     
    
    FROM  project AS p             
    
    INNER JOIN 
		activity_type AS a ON a.id = p.activity_type_id     
	
    INNER JOIN         
		year_level AS y ON y.id = p.year_level_id             
        
	INNER JOIN         
		course AS c ON c.id = p.course_id             
        
	INNER JOIN         
		subscription AS s ON s.id = p.subscription_id             
        
	INNER JOIN         
		subject_matter AS sm ON sm.id = p.subject_matter_id;

CREATE OR REPLACE VIEW `projects_filter_vw` AS    ( SELECT          `p`.`project_id`,         `p`.`name`,         `p`.`projectpic`,         `p`.`learning_object`,         `p`.`instructions`,         `p`.`video`,         `p`.`activity_type_id`,          `pv`.`activity`,         `p`.`year_level_id`,         `pv`.`years`,         `p`.`course_id`,         `pv`.`course`,         `p`.`subscription_id`,         `pv`.`subscription`,         `p`.`subject_matter_id`,         `pv`.`subject_m`  FROM  `project` AS `p`         INNER JOIN `projects_vw` AS `pv` ON `p`.`project_id` = `pv`.`project_id`  ORDER BY project_id      );

CREATE  OR REPLACE VIEW `student_projects_vw` AS     (SELECT          `p`.`project_id`,          `p`.`Name`,          `p`.`projectpic`,         `p`.`learning_object`,          `p`.`instructions`,          `p`.`video` ,         `p`.`activity_type_id`,         `p`.`year_level_id`,         `p`.`course_id`,          `p`.`subscription_id`,          `p`.`subject_matter_id`,         `student_id`     FROM  `project` AS `p`         INNER JOIN `progress_history` AS `h` ON `p`.`project_id` = `h`.`project_id`  ORDER BY project_id      );

CREATE OR REPLACE VIEW `student_projects_filter_vw` AS    ( SELECT          `p`.`project_id`,         `p`.`Name`,         `p`.`projectpic`,         `p`.`learning_object`,         `p`.`instructions`,         `p`.`video`,         `p`.`activity_type_id`,          `pv`.`activity`,         `p`.`year_level_id`,         `pv`.`years`,         `p`.`course_id`,         `pv`.`course`,         `p`.`subscription_id`,         `pv`.`subscription`,         `p`.`subject_matter_id`,         `pv`.`subject_m`,         `h`.`student_id`     FROM  `project` AS `p`         INNER JOIN `progress_history` AS `h` ON `p`.`project_id` = `h`.`project_id`         INNER JOIN `projects_vw` AS `pv` ON `p`.`project_id` = `pv`.`project_id`  ORDER BY project_id );

CREATE OR REPLACE VIEW `heartbeat_vw` AS   (SELECT   NOW() AS `db_ping`,  CONNECTION_ID() AS `connection_id`,  LAST_INSERT_ID() AS `last_insert_id`,  DATABASE() as db_name,   CURRENT_USER() as USER,  VERSION() as db_version,  USER(),  BENCHMARK(1000000,AES_ENCRYPT('hello','goodbye')) as benchmark_aes  );

CREATE OR REPLACE VIEW `student_profile_vw` AS
(SELECT
student_id, s.teacher_id, s.name, s.email, s.password, s.school, s.profilepic, s.date_of_birth, s.contact_number, s.course_id,
c.course as course, t.name as teacher_name

FROM student as s

INNER JOIN `course` AS `c` ON `s`.`course_id` = `c`.`id`
INNER JOIN `teacher` AS `t` ON `s`.`teacher_id` = `t`.`teacher_id`);


INSERT INTO `activity_type` (`activity`) VALUES ('Animation'), ('Game'), ('Chatbot'), ('Augmented Reality');

INSERT INTO `course` (`course`) VALUES ('Beginner'), ('Intermediate'), ('Advanced');

INSERT INTO `subject_matter` (`subject_m`) VALUES ('Computer science,'), ( 'Maths'), ( 'Science'), ( 'Language'), ('Art'), ('Music');

INSERT INTO `subscription` (`subscription`) VALUES ('Free'), ('Premium');

INSERT INTO `year_level` (`years`) VALUES ('1-4'), ('5-6'), ('7-8'), ('9-13');

INSERT INTO project  (projectPic,name,learning_object, instructions, video, activity_type_id, year_level_id, course_id, subscription_id, subject_matter_id)  VALUES ('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/09/image-67.png?fit=300%2C227&amp;ssl=1', '<b>project 01</b> – Introduction', 'Learning Objectives: course introduction, Scratch introduction,basic ...', '<h1>HTML Markup providing the project instructions</h1>', 'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437', 1,1,1,1,1),  ('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/07/result.gif?fit=300%2C225&amp;ssl=1',   'project 02 – The First Clicker Game',   'Learning Objectives: Add Backdrop, the concept of ...',   '<h1>HTML Markup providing the project instructions</h1>',   'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437', 2,2,2,1,1),  ('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/image-6.png?fit=300%2C227&amp;ssl=1',   'project 02a – My Birthday',   'Learning Objectives: Add Sprites and Backdrop, the...',  '<h1>HTML Markup providing the project instructions</h1>', 'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437', 2,1,3,1,3),      ('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-42.png?fit=300%2C223&amp;ssl=1',  'project 03 – 10-Block Challenge',  'Learning Objectives: explore Scratch blocks, learn the ...',  '<h1>HTML Markup providing the project instructions</h1>', 'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437', 2,2,1,1,4),   ('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Screenshot_20190124-232557-e1582175457196.jpg?fit=300%2C194&amp;ssl=1',  'project 03 – Activity: Bossy Boss',  'Learning Objectives: sequential instructions Today we will ...',   '<h1>HTML Markup providing the project instructions</h1>', 'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437', 3,1,2,1,1),   ('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/07/IMG_20181117_144225_header.jpg?fit=300%2C144&amp;ssl=1', 'project 04 – Activity: Feedback', 'Learning Objective: provide feedback 1. Class Activity ...', '<h1>HTML Markup providing the project instructions</h1>', 'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437', 4,4,3,1,1),  ('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-43.png?fit=300%2C226&amp;ssl=1', 'project 04 – Build a Band', 'Learning Objectives: Make sound, User interaction, repeat ...', '<h1>HTML Markup providing the project instructions</h1>', 'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437', 1,3,1,1,1),  ('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Level05-output.gif?fit=300%2C223&amp;ssl=1', 'project 05 – The Bear and the Monkey', 'Learning Objectives: Repeat, Costumes, Starting Position We ...', '<h1>HTML Markup providing the project instructions</h1>', 'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437', 1,2,2,1,1),  ('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-50.png?fit=300%2C227&amp;ssl=1', 'project 06 – Debugging', 'Learning Objectives: debugging This time we are ...', '<h1>HTML Markup providing the project instructions</h1>', 'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437', 2,1,3,1,1),  ...

INSERT INTO teacher (name, email, password, school, profilepic, date_of_birth, contact_number) VALUES( 'Deadpool', 'Wade.WinstonWilsonl@marvel.com', "$2b$10$MajzoXR8croWcu6z9CqNTuRgXRdgZ/Khpv1W07jzHWzEPt/BQszRK", 'Marvel Academy', 'https://cdn.filestackcontent.com/1tUaNY7wQVHae2E3KbEN', '1973-11-22', '55-555-5555' ), ( 'Stan Lee', 'Stan.Lee@marvel.com', "$2b$10$F16DcN8fBf/CCIaBlWONiuyoz7G2TnLOmpUCILIIpYJ3P538hOv7S", 'Marvel Academy', 'https://cdn.filestackcontent.com/MdSjgm9yQPqAqhR7sNrR', '1922-12-28', '55-555-5555' );

INSERT INTO student (teacher_id,name, email, password, school, profilepic, date_of_birth, contact_number, course) VALUES( '1', 'Groot', 'Groot@marvel.com', '$2b$10$qvcZHjfWTQDti7RPW9dOU.U4HvkMwwmh0mkNcewY3ccEbeEI3lyoi', 'Marvel Academy', 'https://cdn.filestackcontent.com/CjZlRoDdQcaiL0DLwMRi', '1960-11-01', '55-555-5555', '1'), ( '1', 'Spiderman', 'peter.parker@marvel.com', '$2b$10$zgs8btmO2hqV.HrXUZZvM.h/lbDyRYSORNMf9O.wEThcS0FN8k65u', 'Marvel Academy', 'https://cdn.filestackcontent.com/L2EqDKS2RFa4E3eOPYeq', '2001-08-10', '55-555-5555', '2');

INSERT INTO help_request (request_id,student_id, date_created, done) VALUES( '1', '1', '2021-11-20 13:45:00', null)

INSERT INTO `progress_history` (`student_id`, `project_id`, `date_started`, `date_submitted`, `date_completed`, `submission`) VALUES ('1','1','2021-10-20','2021-11-01','2021-11-20','https//studentsub.sub@edu.co');

INSERT INTO `progress_history` (`student_id`, `project_id`) VALUES (1,3),(1,4),(1,3),(1,10),(1,20),(1,21),(1,22),(1,23),(1,30),(1,31),(1,32),(1,34),(1,35),(1,50),(1,51), (2,11),(2,12),(2,13),(2,5),(2,6),(2,34),(2,35),(2,36),(2,37),(2,41),(2,42),(2,59);
