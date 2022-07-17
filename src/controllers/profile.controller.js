const express = require('express');
const app = express();
const connection = require('../db/db')

const getStudentProfile = async (req, res) => {
    const { student_id } = req.body;
    console.log('Received a GET request to api/profile/student for student_id ', student_id);
    
    try {
        const [rows] = await connection.query
            (`SELECT * FROM student WHERE student_id =  ${student_id}`);
            
        console.log(rows[0], new Date().toISOString());
        res.send(rows);
    } catch (error) {
        console.log('Error', error);
        res.send("You' got an error ! " + error.code);
    }
}


const getTeacherProfile = async (req, res) => {
    const { teacher_id } = req.body;
    console.log('Received a GET request to api/profile/teacher for teacher_id ', teacher_id);
    
    try {
        const [rows] = await connection.query
            (`SELECT * FROM teacher WHERE teacher_id = ${teacher_id}`);
            
        console.log(rows[0], new Date().toISOString());
        res.send(rows);
    } catch (error) {
        console.log('Error', error);
        res.send("You' got an error ! " + error.code);
    }
}

module.exports = { getStudentProfile,getTeacherProfile };