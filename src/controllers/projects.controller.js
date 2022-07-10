const express = require('express');
const app = express();



const testRouter = (_req, res) => {
    console.log('Received GET api/projects/test on project controller');
    res.send('Received GET api/projects/test on project controller');
};


const get = (_req, res) => {
    console.log('Received a GET request to api/projects/');
    const data = queryDB(`SELECT * FROM project LIMIT 2;`)
    res.send(data)
    }
    

const queryDB= (sql) => {
    console.log('DB query=>',sql)   
    return('Projects data')
}

module.exports = { get, testRouter };

/*
const get = () => {
    
    app.get('/', async (_req, res) => {
        console.log('Received a GET request to api/projects/');
        
        try {
            const [rows] = await connection.query(`SELECT * FROM project LIMIT 2;`);
            console.log(rows, new Date().toISOString());
            res.send(rows);
        } catch (error) {
            console.log('Error', error);
            res.send("You' got an error ! " + error.code);
        }
    });
    
} */