const userRouter = require("./users");
const postsRouter = require("./posts");
const postsLocationRouter = require("./postLocations");

function route(app) {
	app.use("/user", userRouter);
	app.use("/post", postsRouter);
	app.use("/post-location", postsLocationRouter);
	
}

module.exports = route;
