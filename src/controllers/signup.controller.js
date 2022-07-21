const connection = require("../db/db");
const bcrypt = require("bcrypt");

const teachSignup = async (req, res) => {
  const { name, email, password, confirm } = req.body;
  if (password === confirm) {
    try {
      const hashedPass = bcrypt.hashSync(password, 10);
      const connect = await connection.getConnection();
      const result = await connect.query(
        `insert into missio20_team4.teacher (Name, Email, Password) Values (?,?,?)`,
        [name, email, hashedPass],
        (error, result) => {
          return result;
        }
      );
        const userID = result[0].insertId;
        req.session.userID = userID;
        req.session.userType = "teacher";
      // console.log(`Signed up teacher with id of ${userID}`);
      res.send(`Signed up teacher with id of ${userID}`);
    } catch (error) {
      // console.log(`Error creating the user. ${JSON.stringify(error?.message)}`);
      res.status(400).send(`${JSON.stringify(error?.message)}`);
    }
  } else {
    res.status(400).send("Passwords don't match");
  }
};

const studentSignup = async (req, res) => {
  const { name, email, password, confirm } = req.body;
  if (password === confirm) {
    try {
      const hashedPass = bcrypt.hashSync(password, 10);
      const connect = await connection.getConnection();
      const result = await connect.query(
        `insert into missio20_team4.student (teacher_id, Name, Email, Password) Values (1,?,?,?)`,
        [name, email, hashedPass],
        (result) => {
          return result;
        }
      );
      // console.log(result);
        const userID = result[0].insertId;
        req.session.userID = userID;
        req.session.userType = "student";
      // console.log(`Signed up student with id of ${userID}`);
      res.send(`Signed up student with id of ${userID}`);
    } catch (error) {
      // console.log(`Error creating the user. ${JSON.stringify(error?.message)}`);
      res
        .status(400)
        .send(`${JSON.stringify(error?.message)}`);
    }
  } else {
    res.status(400).send("Passwords don't match");
  }
};

module.exports = {
  teachSignup,
  studentSignup,
};
