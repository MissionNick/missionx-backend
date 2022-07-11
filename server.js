const express = require("express");
const app = express();

require("dotenv").config();
const { port } = require("./src/config");


// Middleware
const { connect } = require("./src/db");
const { errorHandler } = require("./src/middlewares");

// Routers to be used
const { studentsRouter } = require("./src/routes/students.routes");
const { projectsRouter } = require("./src/routes/projects.routes");
// Register Routers

app.use("/api/students", studentsRouter);
app.use("/api/projects", projectsRouter);

// 404 error
app.all("*", (req, res, next) => {
  const err = new HttpException(404, `Endpoint ${req.url} Not Found`);
  next(err);
});

app.use(errorHandler);


const startServer = async () => {
  try {
    await connect();
    app.listen(port, () => console.log(`Server running on ${port}`));
  } catch (e) {
    console.error(e);
  }
};

startServer();

