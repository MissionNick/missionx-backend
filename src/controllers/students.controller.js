const connection = require("../db/db");

const getAllProfiles = async (req, res) => {
  console.log("Received a GET request to api/students/ for student profiles");

  try {
    const [rows] = await connection.query(
      `SELECT  Name, profilepic, student_id FROM student WHERE teacher_id = '1'`
    );
    console.log(rows, new Date().toISOString());
    res.send(rows);
  } catch (error) {
    console.log("Error", error);
    res.send("You' got an error ! " + error.code);
  }
};

const getAllProgress = async (req, res) => {
  console.log("Received a GET request to api/students/ for student profiles");

  try {
    const [rows] = await connection.query(
      `SELECT 
      COUNT(date_completed) 'Total', s.Name, date_completed, project_id, p.student_id
  FROM
      progress_history p
          JOIN
      student s ON p.student_id = s.student_id
  GROUP BY s.Name`
    );
    console.log(rows, new Date().toISOString());
    res.send(rows);
  } catch (error) {
    console.log("Error", error);
    res.send("You' got an error ! " + error.code);
  }
};

module.exports = { getAllProfiles, getAllProgress };
