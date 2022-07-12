const express = require('express');
const connection = require('../db/db')
const app = express();



const testRouter = (_req, res) => {
    console.log('Received GET api/teacher/test  Teacher controller');
    res.send('Received GET api/projects/test Teacher controller');
};


const get = (_req, res) => {
    console.log('Received GET api/teacher/Teacher controller');
    res.send('Received GET api/projects/ Teacher controller');
    }
    

module.exports = { get, testRouter };