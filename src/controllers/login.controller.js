const connection = require("../db/db");
const bcrypt = require("bcrypt");

const loginStudent = async (req, res) => {
  const { email, password } = req.body;
  try {
    const connect = await connection.getConnection();
    const [row] = await connect.query(
      `Select student_id, password from missio20_team4.student where email = ?;`,
      [email]
      //   (error, result) => { return result; }
    );
    // console.log(row[0].password)
    if (row.length === 0) {
      return res.status(400).send("Login Failed");
      }
    // console.log(row[0].password);
    const check = bcrypt.compareSync(password, row[0].password);
    if (check) {
      // console.log("Login Successfull");
        req.session.userID = row[0].student_id;
        req.session.userType = "student";
      res.send(
        `${row[0].student_id}`
      );
    } else {
      // console.log("Login Failed");
      res.status(400).send("Login Failed");
    }
  } catch (error) {
    // console.log(`Error creating the user. ${JSON.stringify(error?.message)}`);
    res.status(400).send("Login Failed");
  }
};

const loginTeacher = async (req, res) => {
  const { email, password } = req.body;
  try {
    const connect = await connection.getConnection();
    const [row] = await connect.query(
      `Select teacher_id, password from missio20_team4.teacher where email = ?;`,
      [email]
      //   (error, result) => { return result; }
    );
    // console.log(row[0].password)
    if (row.length === 0) {
      return res.status(400).send("Login Failed");
    }
    const check = bcrypt.compareSync(password, row[0].password);
    if (check) {
      // console.log("Login Successfull");
        req.session.userID = row[0].teacher_id;
        req.session.userType = 'teacher';
      res.send(
        `${row[0].teacher_id}`
      );
    } else {
      // console.log("Login Failed");
      res.status(400).send("Login Failed");
    }
  } catch (error) {
    // console.log(`Error creating the user. ${JSON.stringify(error?.message)}`);
    res.status(400).send("Login Failed");
  }
};

module.exports = {
  loginStudent,
  loginTeacher,
};
