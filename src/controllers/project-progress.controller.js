const connection = require("../db/db");

const getCompletedProgress = async (req, res) => {
  try {
    console.log(`userID: ${req.session.userID}`);
    const connect = await connection.getConnection();
    const queryString = `SELECT student_id, project_id, date_completed 
                        FROM 
                            progress_history 
                        WHERE 
                            date_completed IS NOT NULL 
                        AND project_id <= 15 AND teacher_id = ${req.session.userID}`;
    const [rows] = await connect.query(queryString);
    console.log(rows, new Date().toISOString());
    res.send(rows);
  } catch (error) {
    console.log("Error", error);
    res.send("You' got an error ! " + error.code);
  }
};

module.exports = { getCompletedProgress };
