USE `missionx`;

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
 password varchar(60),
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
password varchar(60),
school varchar(100),  
profilepic varchar(200),  
date_of_birth date,  
contact_number varchar(15),  
course_id int,  PRIMARY KEY (student_id),       

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

CREATE OR REPLACE VIEW `projects_filter_vw` AS    
( SELECT `p`.`project_id`, `p`.`name`,`p`.`projectpic`,`p`.`learning_object`,`p`.`instructions`, `p`.`video`,  `p`.`activity_type_id`, `pv`.`activity`,`p`.`year_level_id`,`pv`.`years`,
         `p`.`course_id`,`pv`.`course`, `p`.`subscription_id`, `pv`.`subscription`,`p`.`subject_matter_id`, `pv`.`subject_m`  FROM  `project` AS `p`
         INNER JOIN `projects_vw` AS `pv` ON `p`.`project_id` = `pv`.`project_id`  ORDER BY project_id      );

CREATE  OR REPLACE VIEW `student_projects_vw` AS     
(SELECT `p`.`project_id`,`p`.`name`,`p`.`projectpic`, `p`.`learning_object`,`p`.`instructions`, `p`.`video` , 
`p`.`activity_type_id`,`p`.`year_level_id`,`p`.`course_id`, `p`.`subscription_id`, `p`.`subject_matter_id`, `student_id`
 FROM  `project` AS `p`
 INNER JOIN `progress_history` AS `h` ON `p`.`project_id` = `h`.`project_id`  ORDER BY project_id);

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


INSERT INTO project  (projectpic, name,learning_object, instructions, video, activity_type_id, year_level_id, course_id, subscription_id, subject_matter_id) 
VALUES
('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/09/image-67.png?fit=300%2C227&amp;ssl=1',
'<b>Project 01</b> – Introduction',
'Learning Objectives: course introduction, Scratch introduction,basic ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,1,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/07/result.gif?fit=300%2C225&amp;ssl=1',
  'Project 02 – The First Clicker Game',
  'Learning Objectives: Add Backdrop, the concept of ...',
  '<h1>HTML Markup providing the Project instructions</h1>',
  'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
2,2,2,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/image-6.png?fit=300%2C227&amp;ssl=1',
  'Project 02a – My Birthday',
  'Learning Objectives: Add Sprites and Backdrop, the...',
 '<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
2,1,3,1,3),
  
  ('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-42.png?fit=300%2C223&amp;ssl=1',
 'Project 03 – 10-Block Challenge',
 'Learning Objectives: explore Scratch blocks, learn the ...',
 '<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
2,2,1,1,4),
 
('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Screenshot_20190124-232557-e1582175457196.jpg?fit=300%2C194&amp;ssl=1',
 'Project 03 – Activity: Bossy Boss',
 'Learning Objectives: sequential instructions Today we will ...',
  '<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
3,1,2,1,1),
 
('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/07/IMG_20181117_144225_header.jpg?fit=300%2C144&amp;ssl=1',
'Project 04 – Activity: Feedback',
'Learning Objective: provide feedback 1. Class Activity ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
4,4,3,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-43.png?fit=300%2C226&amp;ssl=1',
'Project 04 – Build a Band',
'Learning Objectives: Make sound, User interaction, repeat ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,3,1,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Level05-output.gif?fit=300%2C223&amp;ssl=1',
'Project 05 – The Bear and the Monkey',
'Learning Objectives: Repeat, Costumes, Starting Position We ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,2,2,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-50.png?fit=300%2C227&amp;ssl=1',
'Project 06 – Debugging',
'Learning Objectives: debugging This time we are ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
2,1,3,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-56.png?fit=300%2C227&amp;ssl=1',
'Project 07 – About Me',
'Learning Objectives: Mind mapping, imagine and implement ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,2,3,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Level08-output.gif?fit=300%2C226&amp;ssl=1',
'Project 08 – I am Here!',
'Learning Objectives: coordinates, starting positions At this...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,2,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Level09-output.gif?fit=300%2C224&amp;ssl=1',
'Project 09 – Funny Faces',
'Learning Objectives: drawing Sprites, coordinates, click detection...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,3,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/03/image-1.png?fit=300%2C204&amp;ssl=1',
'Project 10 – Activity: Finding Common Grounds',
'Learning Objective: Finding commonality with another person ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
2,1,3,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Level10-output.gif?fit=300%2C226&amp;ssl=1',
'Project 10 – It Tickles!',
'Learning Objective: Forever loop, touch-detection, if-then conditional ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,1,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Level11-output.gif?fit=300%2C226&amp;ssl=1',
'Project 11 – Penguin in a Desert',
'Learning Objectives: if-then-else block, practice forever loop,...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,1,1,2),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Level12-output.gif?fit=300%2C227&amp;ssl=1',
'Project 12 – Time Travel',
'Learning Objectives: backdrop change and its related ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
2,2,1,1,2),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-197.png?fit=300%2C226&amp;ssl=1',
'Project 12a – Teleporting',
'Learning Objectives: backdrop change and its related ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,2,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/07/image-56.png?fit=300%2C227&amp;ssl=1',
'Project 13 – Animated Birthday Card',
'Learning Objectives: message, scene transition We will ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,3,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/01/storyboard-small.jpg?fit=300%2C225&amp;ssl=1',
'Project 14 – Activity: Story Boarding',
'Learning Objectives: use story boards to outline ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,1,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-151.png?fit=300%2C228&amp;ssl=1',
'Project 14 – The Lion and the Mouse – Part 1',
'Learning Objectives: design complex animations This time ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,2,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-162.png?fit=300%2C229&amp;ssl=1',
'Project 15 – The Lion and the Mouse – Part 2',
'Learning Objectives: design complex animations We will ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,3,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-67.png?fit=300%2C293&amp;ssl=1',
'Project 16 – Drawing a Smiley',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,1,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/07/image-33.png?fit=300%2C226&amp;ssl=1',
'Project 17 – Feed the Cat',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,2,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/01/image-41.png?fit=300%2C209&amp;ssl=1',
'Project 18 – Memory Fish',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,3,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-72.png?fit=300%2C225&amp;ssl=1',
'Project 19 – Build a Quiz',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,1,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/08/IMG_20190929_101320-1-e1596969060818.jpg?fit=300%2C212&amp;ssl=1',
'Project 20 – Activity: Relay',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,2,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-87.png?fit=300%2C225&amp;ssl=1',
'Project 20 – Debugging',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,3,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/11/image-24.png?fit=300%2C226&amp;ssl=1',
'Project 21 – Maze Game',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,1,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/11/image-24.png?fit=300%2C226&amp;ssl=1',
'Project 22 – Maze Game Variant',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,2,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/11/image-57.png?fit=300%2C224&amp;ssl=1',
'Project 23 – Maze Game with 2 Players',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,3,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/07/image-20.png?fit=300%2C220&amp;ssl=1',
'Project 24 – Pong Game',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,1,2,2),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/10/image-75.png?fit=300%2C227&amp;ssl=1',
'Project 24a – Pong Game with Levels',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,2,2,3),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/12/image-4.png?fit=300%2C227&amp;ssl=1',
'Project 25 – Eat More Apples',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,3,2,4),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/07/image-36.png?fit=300%2C225&amp;ssl=1',
'Project 26 – Baby Shark',
'Learning Objectives: random block, clone, mouse-control, keep',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,1,1,5),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/07/image-45.png?fit=300%2C226&amp;ssl=1',
'Project 27 – Double Dino Game',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,2,2,6),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/09/image-35.png?fit=300%2C228&amp;ssl=1',
'Project 28 – Shooting Hoop',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,3,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/01/image-66.png?fit=300%2C225&amp;ssl=1',
'Project 29 – Falling Bricks',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,1,2,2),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/10/image-50.png?fit=300%2C224&amp;ssl=1',
'Project 30 – Long Jump Game',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,2,2,3),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-88.png?fit=300%2C224&amp;ssl=1',
'Project 31 – Debugging',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,4,3,2,4),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/10/image-110.png?fit=300%2C227&amp;ssl=1',
'Project 32 – Snake Game',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,4,1,2,5),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/11/image-64.png?fit=300%2C227&amp;ssl=1',
'Project 33 – Catcoin Miner with Levels',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,4,1,2,6),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/01/image-73.png?fit=300%2C227&amp;ssl=1',
'Project 34 – Numbers Crab',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,4,1,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/01/image-128.png?fit=300%2C226&amp;ssl=1',
'Project 35 – The Gift Stack',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,4,1,2,2),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/01/image-160.png?fit=300%2C225&amp;ssl=1',
'Project 36 – Repeat the Tune',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,3,1,2,3),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/07/image-1.png?fit=300%2C238&amp;ssl=1',
'Project 37 – Keep off the Chick!',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,3,1,2,4),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/10/image-6.png?fit=300%2C226&amp;ssl=1',
'Project 39 – A Random Show',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,3,1,2,5),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/09/image-28.png?fit=300%2C229&amp;ssl=1',
'Project 40 – Guessing Game',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,3,1,2,6),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image.png?fit=300%2C226&amp;ssl=1',
'Project 41 – Chatbot',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,3,1,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/image-216.png?fit=300%2C227&amp;ssl=1',
'Project 43 – Bubble Sort',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,2,1,2,2),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/09/image.png?fit=300%2C226&amp;ssl=1',
'Project 44 – Learn to Jump',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,2,1,2,3),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Level45-output.gif?fit=300%2C226&amp;ssl=1',
'Project 45 – Save Gobo',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,2,1,2,4),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/Level46-output.gif?fit=300%2C223&amp;ssl=1',
'Project 46 – Platformer – Part 1',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,1,1,2,5),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/Level46-output.gif?fit=300%2C223&amp;ssl=1',
'Project 47 – Platformer – Part 2',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
2,1,1,2,6),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2019/08/Level46-output.gif?fit=300%2C223&amp;ssl=1',
'Project 48 – Platformer – Part 3',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
1,4,1,2,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Level50-output.gif?fit=300%2C226&amp;ssl=1',
'Project 50 – Sentiment Analysis – Part 1',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
2,3,1,2,2),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2020/02/Level50-output.gif?fit=300%2C226&amp;ssl=1',
'Project 51 – Sentiment Analysis – Part 2',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
2,2,1,2,3),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2021/04/image-13.png?fit=300%2C210&amp;ssl=1',
'Project 54 – Web Page for Your Game',
'This content is password protected. Please enter ..',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
3,1,1,2,4),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2021/04/image-13.png?fit=300%2C210&amp;ssl=1',
'Project 55 – Make Words Pretty',
'Learning Objectives: css text styling This time ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
3,4,1,1,5),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2021/05/image-25.png?fit=300%2C300&amp;ssl=1',
'Project 56 – What am I?',
'Learning Objectives: introduction to JavaScript and HTML ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
3,3,1,1,6),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2021/05/image-37.png?fit=300%2C212&amp;ssl=1',
'Project 57 – Number Quiz Part 1',
'Learning Objectives: Variables, arithmetic operation, string manipulation, ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
3,2,1,1,1),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2021/06/image-7.png?fit=300%2C213&amp;ssl=1',
'Project 58 – Number Quiz Part 2',
'Learning Objectives: functions, conditional (if else), hide/show ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
3,1,1,1,2),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2021/06/image-21.png?fit=300%2C300&amp;ssl=1',
'Project 59 – Draw on Click',
'Learning Objectives: drawing on Canvas This time ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
4,4,1,1,3),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2021/06/image-38.png?fit=300%2C298&amp;ssl=1',
'Project 60 – Random Squares',
'Learning Objectives: drawing filled rectangles on Canvas, ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
4,3,1,1,4),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2021/06/image-46.png?fit=300%2C232&amp;ssl=1',
'Project 61 – Typing Game – Part 1',
'Learning Objectives: events, string manipulation This time ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
4,2,1,1,5),

('https://i0.wp.com/levelupworks.com.wonderbean.a2hosted.com/levels/wp-content/uploads/2021/06/image-51.png?resize=697%2C403&amp;ssl=1',
'Project 62 – Typing Game Part 2','Learning Objectives: string functions (replace, includes),onkeydown ...',
'<h1>HTML Markup providing the Project instructions</h1>',
'https://i.vimeocdn.com/video/436649156-57cfbe171abdc7a1cd3641923b13d911fb079996c8e94a2f31473075d7e5f745-d?mw=700&mh=437',
4,1,1,1,6);
INSERT INTO teacher (name, email, password, school, profilepic, date_of_birth, contact_number) VALUES( 'Deadpool', 'Wade.WinstonWilsonl@marvel.com', "$2b$10$MajzoXR8croWcu6z9CqNTuRgXRdgZ/Khpv1W07jzHWzEPt/BQszRK", 'Marvel Academy', 'https://cdn.filestackcontent.com/1tUaNY7wQVHae2E3KbEN', '1973-11-22', '55-555-5555' ), ( 'Stan Lee', 'Stan.Lee@marvel.com', "$2b$10$F16DcN8fBf/CCIaBlWONiuyoz7G2TnLOmpUCILIIpYJ3P538hOv7S", 'Marvel Academy', 'https://cdn.filestackcontent.com/MdSjgm9yQPqAqhR7sNrR', '1922-12-28', '55-555-5555' );

INSERT INTO student (teacher_id,name, email, password, school, profilepic, date_of_birth, contact_number, course_id) VALUES( '1', 'Groot', 'Groot@marvel.com', '$2b$10$qvcZHjfWTQDti7RPW9dOU.U4HvkMwwmh0mkNcewY3ccEbeEI3lyoi', 'Marvel Academy', 'https://cdn.filestackcontent.com/CjZlRoDdQcaiL0DLwMRi', '1960-11-01', '55-555-5555', '1'), ( '1', 'Spiderman', 'peter.parker@marvel.com', '$2b$10$zgs8btmO2hqV.HrXUZZvM.h/lbDyRYSORNMf9O.wEThcS0FN8k65u', 'Marvel Academy', 'https://cdn.filestackcontent.com/L2EqDKS2RFa4E3eOPYeq', '2001-08-10', '55-555-5555', '2');

INSERT INTO help_request (request_id,student_id, date_created, done) VALUES( '1', '1', '2021-11-20 13:45:00', null)

INSERT INTO `progress_history` (`student_id`, `project_id`, `date_started`, `date_submitted`, `date_completed`, `submission`) VALUES ('1','1','2021-10-20','2021-11-01','2021-11-20','https//studentsub.sub@edu.co');

INSERT INTO `progress_history` (`student_id`, `project_id`) VALUES (1,3),(1,4),(1,3),(1,10),(1,20),(1,21),(1,22),(1,23),(1,30),(1,31),(1,32),(1,34),(1,35),(1,50),(1,51), (2,11),(2,12),(2,13),(2,5),(2,6),(2,34),(2,35),(2,36),(2,37),(2,41),(2,42),(2,59);
