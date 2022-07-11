const mysql = require("mysql2");
const { config } = require("../config/db.config");


const connect = async (connection) => {
  const connectConfig = {
    ...config,
  };
  connection = await mysql.createConnection(connectConfig);
  };

module.exports = { connect };
