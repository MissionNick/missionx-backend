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



module.exports = router;
