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
