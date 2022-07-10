//const { Router } = require('express');
/*const express = require('express');
const projectRouter = express.Router(); 
const { get , testRouter } = require('../controllers/projects.controller')



projectRouter.get('/', get);
projectRouter.get('/test', testRouter);

*/
const express = require("express");
const projectsRouter = express.Router();
const { get , testRouter } = require('../controllers/projects.controller')

projectsRouter.get("/",get);
projectsRouter.get("/test", testRouter);



module.exports = {
  projectsRouter,
};