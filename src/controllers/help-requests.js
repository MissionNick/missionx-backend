const connection = require("../db/db");

// controller to select all the informaiton from the help_request and studnet tables that match with the correct user ID
const getAllRequests = async (req, res) => {
  try {
    console.log(`userID: ${req.session.userID}`);
    const connect = await connection.getConnection();
    const queryString = `SELECT 
    request_id,
    dayname(date_created) 'day',
    time_format(date_created, '%h:%i %p') 'time',
    date_format(date_created, '%d %M %Y') 'date',
    done,
    s.Name,
    s.profilepic,
    s.student_id
FROM
    help_request hr
        INNER JOIN
    student s ON hr.student_id = s.student_id
WHERE
    teacher_id = ${req.session.userID}`;
    const [rows] = await connect.query(queryString);
    console.log(rows, new Date().toISOString());
    res.send(rows);
  } catch (error) {
    console.log("Error", error);
    res.send("You' got an error ! " + error.code);
  }
};
// controller to update the help_request table, done is set to 1 when the request id matches
const updatePostRequest = async (req, res) => {
  const { request_id } = req.body;

  try {
    const connect = await connection.getConnection();
    const queryString = `UPDATE help_request SET done = 1 WHERE request_id = ${request_id}`;
    await connect.query(queryString);
  } catch (error) {
    console.log("Error", error);
    res.send("You' got an error ! " + error.code);
  }
};

module.exports = { getAllRequests, updatePostRequest };
