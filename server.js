const express = require('express');
const mysql = require('mysql2');
const app = express();

require('dotenv').config()
const DB_PASSWORD = process.env.DB_PASSWORD;

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: DB_PASSWORD,
  database: 'missionx',
});

app.get('/', (req, res) => {
    console.log('Received GET request to /');
    connection.query(`SELECT * FROM project LIMIT 2;`, (error, result) => {
        if (error) {
            console.log('Error', error);
            res.send("You' got an error ! " + error.code);
        } else {
            console.log(result);
            res.send(result);
        }
    });
});
console.log('Server running at port', 4001);
app.listen(4001);