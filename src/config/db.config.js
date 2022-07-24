const config = {
  
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASS,
  database: process.env.MYSQL_DATABASE,
  // Pool management  
  connectionLimit: process.env.MYSQL_CON_LIMIT,
  queueLimit: process.env.MYSQL_Q_LIMIT,
  waitForConnections: true,
};

module.exports = { config };
