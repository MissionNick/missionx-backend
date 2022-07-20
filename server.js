require("dotenv").config();
const connection = require("./src/db/db");
const express = require("express");
const cors = require('cors');
const { port } = require("./src/config");

const session = require('express-session');
const MySQLStore = require('express-mysql-session')(session);


// Middleware

const {errorHandler} = require("./src/middlewares");


// Routers to be used
const { studentsRouter } = require("./src/routes/students.routes");
const projectsRouter = require("./src/routes/projects.routes");
const testRouter = require("./src/routes/test.routes");
const profileRouter = require("./src/routes/profile.routes");
const {userRouter} = require('./src/routes/user.routes')



const app = express();

app.use(
  cors({
    origin: "http://localhost:3000",
    credentials: true,
  })
);
app.use(express.json())

//Session Initialisation

const sessionStore = new MySQLStore({}, connection);
app.use(
  session({
    name: "MissionX",
    resave: false,
    saveUninitialized: true,
    store: sessionStore,
    secret: process.env.SESSION_SECRET,
    cookie: {
      maxAge: 1000 * 60 * 60,
    },
  })
);

// Register Routers

app.use("/api/students", studentsRouter);
app.use("/api/projects", projectsRouter);
app.use("/api/profile", profileRouter)
app.use('/api/test', testRouter);
app.use(userRouter);


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

