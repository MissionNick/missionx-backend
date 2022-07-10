const express = require('express');
const app = express();

const get = () => {

    app.get('/', async (req, res) => {
        console.log('Received a GET request to /');
        
        try {
            const [rows] = await connection.query(`SELECT * FROM project LIMIT 2;`);
            console.log(rows, new Date().toISOString());
            res.send(rows);
        } catch (error) {
            console.log('Error', error);
            res.send("You' got an error ! " + error.code);
        }
    });
    
}

module.exports = { get };