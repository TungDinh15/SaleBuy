const User = require("../models/User");
// const Token = require("../Models/Token");

// Bcryptjs
var bcrypt = require('bcryptjs');


module.exports = function (app) {

  app.post("/register", function (req, res) {

    console.log("Post register");
    console.log(req.body);

    // Check available Username/Email
    User.find({
      "$or": [{ "Username": req.body.Username }, { "Email": req.body.Email }]
    }, function (err, data) {
      if (data.length == 0) {

        //Ma hoa password voi Bcryptjs
        bcrypt.genSalt(10, function (err, salt) {
          bcrypt.hash(req.body.Password, salt, function (err, hash) {
            if (err) {
              res.json({
                "result": 0,
                "errMsg": "Password encode error!"
              });
            } else {

              // Save user to Mongo Server
              var newUser = User({
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

              newUser.save(function (err) {
                if (err) {
                  res.json({
                    "result": 0,
                    "errMsg": "Mongo save user error"
                  });
                } else {
                  res.json({
                    "result": 1,
                    "errMsg": "User register successfully."
                  });
                }
              });

            }
          });
        });

      } else {
        res.json({
          "result": 0,
          "errMsg": "Email/Username is not available."
        });
      }
    });
  });
}