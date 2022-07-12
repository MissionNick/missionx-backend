const express = require('express');
const app = express();
const connection = require('../db/db')


const testRouter = (_req, _res) => {
    console.log('Received GET api/projects/test on teacher controller');
    res.send('Received GET api/projects/test on teacher controller');
};


const getOld = async (req, res) => {
    const { student } = req.body;
    console.log('Received a GET request to api/projects/ for studentId ',student);
    try {
        const data = (await connection).query(
            `SELECT * FROM PROJECT LIMIT 2;`
        )
        res.send(data);
    } catch (err) {
        res.send(`Error ${JSON.stringify(err)}`);
    }
}
const get = async (req, res) => {
    const { student } = req.body;
    console.log('Received a GET request to api/projects/ for studentId ', student);
    try {
        const [rows] = await connection.query
            (`SELECT * FROM studentprojects WHERE studentid = ?;`,
            [student]);
        console.log(rows, new Date().toISOString());
        res.send(rows);
    } catch (error) {
        console.log('Error', error);
        res.send("You' got an error ! " + error.code);
    }
}

const post = async (req, res) => {
    const { student } = req.body;
    console.log('Received a Post request to api/projects/ for studentId ',student);
    try {
        const data = (await connection).query(
            `SELECT * FROM PROJECT LIMIT 2;`
        )
        res.send(data);
    } catch (err) {
        res.send(`Error ${JSON.stringify(err)}`);
    }
}


    
    



module.exports = { get, testRouter, post };