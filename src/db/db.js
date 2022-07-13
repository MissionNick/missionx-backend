const mysql = require('mysql2/promise');
const { config } = require("../config/db.config");

const connectConfig = {
    ...config,
};

const connection = mysql.createPool(connectConfig);

module.exports = connection