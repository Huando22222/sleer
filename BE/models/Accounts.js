const mongoose = require("mongoose");

const accountSchema = new mongoose.Schema({
	phone: { type: "string" },
	password: { type: "string" },
	createdAt: { type: Date, default: Date.now },
});


module.exports = mongoose.model("accounts", accountSchema);
