const { Router } = require('express');
const { get } = require('../controllers/project.controller')

const router = Router(); // Express router instance

router.get('/', get);

module.exports = router;
