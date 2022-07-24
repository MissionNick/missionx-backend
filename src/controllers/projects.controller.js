const express = require('express');
const app = express();
const connection = require('../db/db')
const helper = require('../utils/helper');


const getStudentProjects = async (req, res) => {
    const { student_id } = req.body;
    console.log('Received a GET request to api/projects/student for student_id ', student_id);
    
    try {
        const [rows] = await connection.query
            (`SELECT * FROM student_projects_filter_vw WHERE student_id = ${student_id}`);
            
        console.log(rows[0], new Date().toISOString());
        res.send(rows);
    } catch (error) {
        console.log('Error', error);
        res.send("You' got an error ! " + error.code);
    }
}


const getAllPaged = async (req, res) => {
    const { page } = req.body;
    const listPerPage = parseInt(process.env.PROJECT_LIST_PER_PAGE);
    const offset = helper.getOffset(page,listPerPage);
    console.log('Received a GET request to api/projects/page all projects paged ', offset, listPerPage);
    
    try {
        const [rows] = await connection.query
            (`SELECT * FROM projects_filter_vw LIMIT ?,?`,[offset,5]);
        console.log(rows[0], new Date().toISOString());
        res.send(rows);
    } catch (error) {
        console.log('Error', error);
        res.send("You' got an error ! " + error.code);
    }
}

const getAll = async (req, res) => {
    
    console.log('Received a GET request to api/projects/ for teacher - all projects');
   
    try {
        const [rows] = await connection.query
            ('SELECT * FROM projects_filter_vw');
        console.log(rows[0], new Date().toISOString());
        res.send(rows);
    } catch (error) {
        console.log('Error', error);
        res.send("You' got an error ! " + error.code);
    }
}


module.exports = { getStudentProjects,getAllPaged,getAll };