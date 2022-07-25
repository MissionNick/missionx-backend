const connection = require("../db/db");
    //Authenticate gets user pic and name to show in navbar
const authenticate = async (req, res) => {
    try {
        if (req.session.userID) {
            // console.log('UserID Exists');
            // console.log('User ID: ',req.session.userID, 'USerTYPE: ',req.session.userType);
            user = {
                id: req.session.userID,
                type: req.session.userType,
            };
            const connect = await connection.getConnection();
            const queryString = `SELECT name, profilepic from missio20_team4.${user.type} where ${user.type}_id = ${user.id};`;
            const [row] = await connect.query(queryString);
            if (row.length === 0) {
                res.send("Failed");
            } else {
                user.name = row[0].name;
                user.profilepic = row[0].profilepic;
                res.send(user);
            }
        } else {
            // console.log("UserID Not Exists");
            res.send("Failed");
        }
    }
    catch (error) {
        // console.log(error);
        res.send("Failed");
     }
};

const checkLogIn = async (req, res) => {
    /*Check if user has logged in before and not logged out
(for keeping user signed in if they leave page)*/
    try {
        if (req.session.userID) {
            res.send(true);
        }
        else {
            res.send(false);
        }
    }
    catch (error) {
        res.send(false);
    }
};

module.exports = {
    authenticate,
    checkLogIn,
};
