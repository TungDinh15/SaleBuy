var express = require('express');
var app = express();
app.set("view engine", "ejs");
app.set("views", "./views");
app.use(express.static("public"));

const PORT = 3000;

app.listen(PORT, () => {
  console.log("Listening on port", PORT);
});

// MongoDB connect
const mongoose = require('mongoose');
mongoose
  .connect(
    'mongodb+srv://tungdinh:1234@cluster0.npaxga2.mongodb.net/SaleBuy?retryWrites=true&w=majority', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log('MongoDB is connected successfully!');
  })
  .catch(err => console.log(err.message));


// body-parser
app.get("/", function (req, res) {
  res.render("home");
});
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: false }));

require("./routes/FileManager")(app);
require("./routes/Account")(app);
