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
  const err = new HttpException(404, `Endpoint ${req.url} Not Found`);
  next(err);
});



const startServer = async () => {
  try {
    await connect();
    app.listen(port, () => console.log(`Server running on port ${port}!`));
  } catch (e) {
    console.error(e);
  }
};

startServer();