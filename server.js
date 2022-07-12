require("dotenv").config();

const express = require("express");
const cors = require('cors');
const { port } = require("./src/config");



// Middleware

const {errorHandler} = require("./src/middlewares");


// Routers to be used
const { studentsRouter } = require("./src/routes/students.routes");
const projectsRouter = require("./src/routes/projects.routes");
const teachersRouter = require("./src/routes/teachers.routes");

const app = express();

app.use(cors());
app.use(express.json())


// Register Routers

app.use("/api/students", studentsRouter);
app.use("/api/projects", projectsRouter);
app.use("/api/teachers", teachersRouter);

// 404 error
app.all("*", (req, res, next) => {
  const err = new HttpException(404, `Endpoint ${req.url} Not Found`);
  next(err);
});

app.use(errorHandler);


const startServer = async () => {
  try {
    app.listen(port, () => console.log(`Server running on port ${port}`));
  } catch (e) {
    console.error(e);
  }
};

startServer();

