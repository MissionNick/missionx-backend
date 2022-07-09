const mysql = require('mysql2/promise')

require('dotenv').config();
const db_password = process.env.REACT_APP_DB_PASSWORD;

let connection;

const connect = async () => {
  connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: db_password,
    database: 'missionx',
  });
};


module.exports = { connect };
