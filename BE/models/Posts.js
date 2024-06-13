// const mongoose = require('mongoose');
// const Images = require('./Images');
// const Users = require('./Users');
// const PostSchema = new mongoose.Schema(
// 	{
// 		_id: { type: mongoose.Types.ObjectId, required: true },
// 		message: { type: "string" },
// 		// date: { type: "string", required: true }, //string ??
// 		// images: [{ type: mongoose.Schema.Types.ObjectId, ref: 'images' }],
// 		images: { type: mongoose.Schema.Types.ObjectId, ref: "images" },
// 		likes: { type: Number, required: true },
// 		owner: { type: mongoose.Schema.Types.ObjectId, ref: "users" },
// 	},
// 	{ timestamps: true }
// );
// module.exports = mongoose.model("posts", PostSchema);
///////////////////////////////////////////
const mongoose = require("mongoose");
// const Images = require("./Images");
// const Users = require("./Users");
const PostSchema = new mongoose.Schema(
	{
		owner: {
			type: mongoose.Schema.Types.ObjectId,
			ref: "users",
			required: true,
		},
		message: { type: "string" },
		images: { type: "string" },
		likes: { type: Number, required: true },
		createdAt: { type: Date, default: Date.now },
	},
	{ timestamps: true }
);
module.exports = mongoose.model("posts", PostSchema);