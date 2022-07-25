const connection = require("../db/db");

// controller to select all the informaiton from the student table that matches the logged in teacher ID
const getAllProfiles = async (req, res) => {
  console.log(`Received a GET request to api/students/ for student profiles`);
  try {
    console.log(`userID: ${req.session.userID}`);
    const connect = await connection.getConnection();
    const queryString = `SELECT  Name, profilepic, student_id FROM student WHERE teacher_id = ${req.session.userID}`;
    const [rows] = await connect.query(queryString);
    console.log(rows, new Date().toISOString());
    res.send(rows);
  } catch (error) {
    console.log("Error", error);
    res.send("You' got an error ! " + error.code);
  }
};

// controller to select all the informaiton from the progress_history and student tables that matches the logged in teacher ID
const getAllProgress = async (req, res) => {
  try {
    const connect = await connection.getConnection();
    const queryString = `SELECT 
    COUNT(date_completed) 'Total', s.Name, date_completed, project_id, p.student_id
    FROM
    progress_history p
        JOIN
    student s ON p.student_id = s.student_id where project_id <= 15 AND teacher_id = '${req.session.userID}'
    GROUP BY s.Name`;
    const [rows] = await connect.query(queryString);

    console.log(rows, new Date().toISOString());
    res.send(rows);
  } catch (error) {
    console.log("Error", error);
    res.send("You' got an error ! " + error.code);
  }
};

module.exports = { getAllProfiles, getAllProgress };
