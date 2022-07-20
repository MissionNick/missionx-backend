const express = require('express');
const app = express();
const connection = require('../db/db')


// TO DO require('../utils/heartbeat')
const testRouter = async (req, res) => {

    const t = Date.now();       
    try {
        const [rows] = await connection.query(`SELECT * FROM heartbeat_vw;`);
        console.log(rows, new Date().toISOString());
        const responseTime = Date.now() - t;
        rows.push(`Response time:${responseTime}`);
        console.log(rows,`Heart beat response time  ${responseTime}`);//the time needed to do the request 
        res.send(rows);
    } catch (error) {
        console.log('Error', error);
        res.send("Heartbeat failed! " + error.code);
    }   
};

module.exports = testRouter;