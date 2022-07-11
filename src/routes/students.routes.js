const express = require("express");
const studentsRouter = express.Router();

studentsRouter.get("/", (req, res) => {
  res.send("Hello GET! on students router");
});

module.exports = {
  studentsRouter,
};
