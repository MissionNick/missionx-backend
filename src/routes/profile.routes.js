const router = require('express').Router();
const { getStudentProfile, getTeacherProfile } = require('../controllers/profile.controller');


router.use((req, res, next) => {
  console.log('Time: ', Date.now())
  next()
})

router.post('/teacher', getTeacherProfile);
router.post('/student', getStudentProfile);


module.exports = router;
