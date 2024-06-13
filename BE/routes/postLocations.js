const express = require("express");
const PostLocationController = require("../controllers/PostLocationController");
const router = express.Router();




router.post("/new", PostLocationController.NewPostLocation);
router.post("/delete", PostLocationController.DeletePostLocation);
router.get("/", PostLocationController.GetPostLocations);

module.exports = router;
