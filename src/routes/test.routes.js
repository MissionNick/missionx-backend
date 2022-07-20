const router = require('express').Router();
const testRouter = require('../controllers/test.controller');


router.use((req, res, next) => {
  console.log('Time: ', Date.now())
  next()
})


router.post('/', testRouter);


module.exports = router;
