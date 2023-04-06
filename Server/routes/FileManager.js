var multer = require('multer');

var storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "public/upload");
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + "-" + file.originalname);
  }
});

var upload = multer({
  storage: storage,
  fileFilter: (req, file, cb) => {
    console.log(file)
    if (
      file.mimetype == "image/bmp" ||
      file.mimetype == "image/png" ||
      file.mimetype == "image/jpeg" ||
      file.mimetype == "image/jpg"
    ) {
      cb(null, true);
    } else {
      return cb(new Error("File is not image."));
    }
  }
}).single("hinhdaidien")

// Route to upload image avatar
module.exports = (app) => {
  app.get("/testUpload", (req, res) => {
    res.render("testUpload")
  });

  app.post("/uploadFile", (req, res) => {
    upload(req, res, (err) => {
      // error relating to Multer's error
      if (err instanceof multer.MulterError) {
        res.json({
          result: 0,
          message: err
        });
      }
      // another errors
      else if (err) {
        res.json({
          result: 0,
          message: err
        });
      } else {
        res.json({
          result: 1,
          urlFile: req.file,
        });
      }
    });
  })
}