const mysql = require("mysql2/promise");
const { config } = require("../config/db.config");
const connectConfig = {
    ...config,
};
const pool = mysql.createPool(connectConfig);
const connect = () => {
  pool.getConnection((err) => {
    if (err) {
      console.log(`Pool connection to ${connectConfig.database} DB failed. Error ${err}`);
      throw err;
    } else {
      console.log(`Pool connection to ${connectConfig.database} DB`);
    }
  })
};
module.exports = { connect };