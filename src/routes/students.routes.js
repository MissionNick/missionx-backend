const express = require("express");
const {
  getAllProfiles,
  getAllProgress,
} = require("../controllers/students.controller");
const studentsRouter = express.Router();

studentsRouter.get("/", getAllProfiles);
studentsRouter.get("/progress", getAllProgress);

module.exports = {
  studentsRouter,
};
