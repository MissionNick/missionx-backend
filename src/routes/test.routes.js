/* Nick
Heart beat monitoring and dev test.  Returns DB info so you can confirm backend is up and as expected.
*/

const router = require("express").Router();
const testRouter = require("../controllers/test.controller");

router.use((req, res, next) => {
  console.log("Time: ", Date.now());
  next();
});

router.post("/", testRouter);

module.exports = router;
