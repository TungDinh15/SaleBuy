const City = require('../models/City');

module.exports = (app) => {

  app.get("/city", (req, res) => {
    res.render("admin_master", { content: "./city/city.ejs" });
  });

  app.post("/city/add", (req, res, next) => {
    var newCity = City({
      Name: req.body.Name
    });
    newCity.save()
      .then(() => {
        res.json({
          result: 1,
          message: "Save new city successfully!"
        })
      })
      .catch(err => {
        res.json({
          result: 0,
          message: err
        })
      })
  });

  app.post("/city", (req, res) => {
    City.find()
      .then(data => {
        res.json({ result: 1, list: data });
      })
      .catch(err => {
        res.json({ result: 0, message: err.message });
      })
  });
}