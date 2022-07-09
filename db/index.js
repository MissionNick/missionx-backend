const mysql = require("mysql2");
const { config } = require("../config/db.config");

let isConnected = false;

const connect = async () => {
  const connectConfig = {
    ...config,
  };
  mysql.createConnection(connectConfig);
  isConnected = true;
};

module.exports = { connect };
