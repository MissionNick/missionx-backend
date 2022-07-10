const mysql = require("mysql2/promise");
const { config } = require("../config/db.config");

let connection;
let isConnected = false;

const connect = async () => {
  const connectConfig = {
    ...config,
  };
  connection = await mysql.createConnection(connectConfig);
  isConnected = true;
};

module.exports = { connect };
