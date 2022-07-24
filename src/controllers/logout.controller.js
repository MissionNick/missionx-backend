const express = require("express");
const logout = async (req, res) => {
  req.session.destroy((err) => {
    res.send(err);
  });
};

const sessionTest = async (req, res) => {
  res.send(`${req.session.userID}`);
}
module.exports = {
    logout,
    sessionTest
};