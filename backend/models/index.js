import Sequelize from "sequelize";
import Config from "../config/config.js";
import User from "./User.js";
import Post from "./Post.js";
import Notification from "./Notification.js";
import Dept from "./Dept.js";
import Course from "./Course.js";
import Wishlist from "./Wishlist.js";
import Comment from "./Comment.js";
import ReplyToComment from "./ReplyToComment.js";
import System from "./System.js";

const env = process.env.NODE_ENV || "development";
const config = Config[env];
const db = {};
const sequelize = new Sequelize(
  config.database,
  config.username,
  config.password,
  config
);

db.User = User(sequelize, Sequelize);
db.Post = Post(sequelize, Sequelize);
db.Notification = Notification(sequelize, Sequelize);
db.Dept = Dept(sequelize, Sequelize);
db.Course = Course(sequelize, Sequelize);
db.Wishlist = Wishlist(sequelize, Sequelize);
db.Comment = Comment(sequelize, Sequelize);
db.ReplyToComment = ReplyToComment(sequelize, Sequelize);
db.System = System(sequelize, Sequelize);

Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;

export default db;
