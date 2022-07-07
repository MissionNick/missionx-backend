const express = require('express');
const mysql = require('mysql2');
const app = express();

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'Amwmrwcjwclaw!2',
  database: 'world',
});


app.get('/city', (req, res) => {
    console.log('Received a GET request to /');
     // Run the SQL query, when you get a request to /
  connection.query(
    `SELECT NAME FROM WORLD.CITY WHERE NAME LIKE 'A%';`,
    (error, result) => {
      if (error) {
        console.log('Error', error);
        res.send("You' got an error ! " + error.code);
      } else {
        const cityName = result.map((city) => city.NAME);
        console.log(cityName);
        res.send(cityName);
      }
    }
  );
});


app.get('/country/:code', (req, res) => {
    console.log('Received a GET request to /country');
    const { code } = req.params;
  // Run the SQL query, when you get a request to /
  connection.query(
      `SELECT * FROM country WHERE code = '${ code }';`,
    (error, result) => {
      if (error) {
        console.log('Error', error);
        res.send("You' got an error ! " + error.code);
      } else {
        res.send(result[0]);
      }
    }
  );
});




console.log('Server running at port', 4000);
app.listen(4000);

    /* without express
const { connect } = require('../mission-x/src/db');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'Amwmrwcjwclaw!2',
  database: 'world',
});
// Run the SQL query, when you get a request to /
connection.query(`SELECT * FROM WORLD.CITY LIMIT 2;`, (error, result) => {
  if (error) {
    console.log('Error', error);
  } else {
    console.log(result);
    }
    
});

connection.end();

*/
