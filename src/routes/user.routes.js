const express = require("express");
const { teachSignup, studentSignup } = require("../controllers/signup.controller");
const { loginStudent, loginTeacher } = require("../controllers/login.controller");
const { logout, sessionTest } = require("../controllers/logout.controller")
const { authenticate, checkLogIn } = require("../controllers/authenticate.controller")
const userRouter = express.Router();

userRouter.post("/signup/teacher", teachSignup);

userRouter.post("/signup/student", studentSignup);

userRouter.post("/login/student", loginStudent);

userRouter.post("/login/teacher", loginTeacher);

userRouter.post('/logout', logout);

userRouter.post('/sessiontest', sessionTest);

userRouter.post('/authenticate', authenticate);

userRouter.post('/checklogin', checkLogIn)



module.exports = {
  userRouter,
};
