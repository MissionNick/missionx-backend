const router = require('express').Router();
const { getStudentProjects, getAll,testRouter,getAllPaged } = require('../controllers/projects.controller');


router.use((req, res, next) => {
  console.log('Time: ', Date.now())
  next()
})



router.post('/teacher', getAll);

router.post('/test', testRouter);

router.post('/student', getStudentProjects);

router.post('/', getAllPaged);

//router.get('/':studentId,getStudentProjects)
//router.get('/':id,getOne)

// PATCH /api/project + /
// router.patch('/', update);


module.exports = router;
