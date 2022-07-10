<<<<<<< HEAD
const express = require('express');
const { connect } = require('./db');

require('dotenv').config();

const port = process.env.REACT_APP_PORT;



// Routes
const projectRouter = require('./routes/project.routes');

const app = express();

app.use(express.json());

app.use('/api/Project', projectRouter);
//app.use('/api/user/:ID', userRouter);
//app.use('/api/Student:ID', StudentRouter);
//app.use('/api/Teacher:ID', TeacherRouter);


app.all('*', (req, res, next) => {
=======
const express = require("express");
const app = express();
require("dotenv").config();

const { port } = require("./config/index");

// Middleware
const { connect } = require("./db");
const { errorHandler } = require("./middlewares/index");

// Routers to be used
const { studentsRouter } = require("./routes/students.routes");

// Register Routers
app.use("/api/students", studentsRouter);

// 404 error
app.all("*", (req, res, next) => {
>>>>>>> Development
  const err = new HttpException(404, `Endpoint ${req.url} Not Found`);
  next(err);
});

<<<<<<< HEAD

=======
app.use(errorHandler);
>>>>>>> Development

const startServer = async () => {
  try {
    await connect();
<<<<<<< HEAD
    app.listen(port, () => console.log(`Server running on port ${port}!`));
=======
    app.listen(port, () => console.log(`Server running on ${port}`));
>>>>>>> Development
  } catch (e) {
    console.error(e);
  }
};

<<<<<<< HEAD
startServer();
=======
startServer();
>>>>>>> Development
