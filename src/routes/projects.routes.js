const router = require('express').Router();
const { get, testRouter,post } = require('../controllers/projects.controller');

router.use((req, res, next) => {
  console.log('Time: ', Date.now())
  next()
})

router.get('/', get);

router.get('/test', testRouter);

router.post('/', post);
//router.get('/':studentId,getStudentProjects)
//router.get('/':id,getOne)

// PATCH /api/project + /
// router.patch('/', update);


module.exports = router;
