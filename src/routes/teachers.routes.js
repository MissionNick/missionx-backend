const router = require('express').Router();
const { get, testRouter} = require('../controllers/teachers.controller');

router.use((req, res, next) => {
  console.log('Time: ', Date.now())
  next()
})

router.get('/', get);

router.get('/test', testRouter);


module.exports = router;
