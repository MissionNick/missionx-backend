const express = require("express");
const {
  getAllProfiles,
  getAllProgress,
} = require("../controllers/students.controller");

const {
  getCompletedProgress,
} = require("../controllers/project-progress.controller");
const {
  getAllRequests,
  updatePostRequest,
} = require("../controllers/help-requests");

const studentsRouter = express.Router();

studentsRouter.post("/", getAllProfiles);
studentsRouter.post("/progress", getAllProgress);
studentsRouter.post("/progress/completed", getCompletedProgress);
studentsRouter.post("/help-requests", getAllRequests);
studentsRouter.post("/help-requests/update", updatePostRequest);

module.exports = {
  studentsRouter,
};
