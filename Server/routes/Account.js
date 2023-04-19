const User = require("../models/User");
const Token = require("../models/Token");

// Bcryptjs
var bcrypt = require('bcryptjs');

var jwt = require('jsonwebtoken');
var privateKey = "123456789";

module.exports = function (app) {


  // REGISTER ROUTE
  app.post("/register", function (req, res) {

    console.log("Post register");
    console.log(req.body);

    // Check available Username/Email
    User.find({
      "$or": [{ "Username": req.body.Username }, { "Email": req.body.Email }]
    })
      .then((data, err) => {
        if (data.length == 0) {

          //Ma hoa password voi Bcryptjs
          bcrypt.genSalt(10, function (err, salt) {
            bcrypt.hash(req.body.Password, salt, function (err, hash) {
              if (err) {
                res.json({ "result": 0, "errMsg": "Password encode error!" });
              } else {

                // Save user to Mongo Server
                var newUser = new User({
                  Username: req.body.Username,
                  Password: hash,
                  Name: req.body.Name,
                  Image: req.body.Image,
                  Email: req.body.Email,
                  Address: req.body.Address,
                  PhoneNumber: req.body.PhoneNumber,
                  Active: true,
                  RegisterDate: Date.now()
                });

                // Save data 
                newUser.save()
                  .then(() => {
                    res.json({
                      "result": 1,
                      "errMsg": "User register successfully."
                    });
                  })
                  .catch((err) => {
                    res.json({
                      "result": 0,
                      "errMsg": "Mongo save user error"
                    });
                  })
              }
            });
          });
        } else {
          res.json({
            "result": 0,
            "errMsg": "Email/Username is not available."
          })
        }
      })
      .catch(err => {
        res.json({
          "result": 0,
          "errMsg": err.message
        })
      });
  });


  // LOGIN ROUTE
  app.post("/login", (req, res) => {

    // Check Username if exist
    User.findOne({ Username: req.body.Username })
      .then(data => {
        if (!data) {
          res.json({
            result: 0,
            errMsg: "Wrong username, please try again!"
          });
        } else {
          //check Password
          bcrypt.compare(req.body.Password, data.Password, (err, resUser) => {
            if (err) {
              res.json({
                result: 0,
                errMsg: err
              });
            } else {
              if (resUser === true) {
                // Login Successfully
                jwt.sign(
                  // Data info receive after logging in
                  {
                    IdUser: data._id,
                    Username: data.Username,
                    Name: data.Name,
                    Image: data.Image,
                    Email: data.Email,
                    Address: data.Address,
                    PhoneNumber: data.PhoneNumber,
                    Active: data.Active,
                    RegisterDate: Date.now(),
                    // DeviceInfo: req.headers,  // Tracking with browser user login by
                  },
                  // Private Key
                  privateKey,
                  // Duration for staying in Login
                  { expiresIn: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30 },
                  // Callback
                  (err, token) => {
                    if (err) {
                      res.json({
                        result: 0,
                        errMsg: err
                      });
                    } else {
                      // Create Token successfully
                      // Save Tokens
                      var currentToken = new Token({
                        Token: token,
                        User: data._id,
                        RegisterDate: Date.now(),
                        State: true
                      });

                      currentToken.save()
                        .then(() => {
                          res.json({
                            result: 1,
                            Token: token
                          });
                        })
                        .catch(err => {
                          res.json({
                            result: 0,
                            errMsg: err
                          });
                        })
                    }
                  });

              } else {
                res.json({
                  result: 0,
                  errMsg: "Wrong password, please try again!"
                });
              }
            }
          });
        }
      })
      .catch(err => {
        res.json({
          result: 0,
          errMsg: err
        });
      });
  });

  // VERIFY TOKEN
  app.post("/verifyToken", function (req, res) {
    Token.findOne({ Token: req.body.Token, State: true })
      .select("_id")
      .lean()
      .then(data => {
        if (!data) {
          res.json({
            result: 0,
            errMsg: "Error Token"
          });
        } else {
          jwt.verify(req.body.Token, privateKey, (err, decoded) => {
            if (!err && decoded !== undefined) {
              res.json({
                result: 1,
                User: decoded
              });
            } else {
              res.json({
                result: 0,
                errMsg: "Token error."
              });
            }
          });
        }
      });
  });

  // LOGOUT ROUTE
  app.post("/logout", (req, res) => {
    Token.updateOne({ Token: req.body.Token }, { State: false })
    .then(() => {
      res.json({
        result: 1,
        errMsg: "Logout Successfully."
      });
    })
    .catch(err => {
      res.json({
        result: 0,
        errMsg: err
      });
    })
  })

}

