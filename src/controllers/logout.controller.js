const express = require("express");

//Logout destroys session so user won't automatically sign in again when they return to the page
const logout = async (req, res) => {
  req.session.destroy((err) => {
    res.send(err);
  });
};
  //Tests to check if session was working
const sessionTest = async (req, res) => {
  res.send(`${req.session.userID}`);
}
module.exports = {
    logout,
    sessionTest
};