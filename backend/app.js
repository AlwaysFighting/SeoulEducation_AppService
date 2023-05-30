import express from "express";
import dotenv from "dotenv";
import http from "http";
import cors from "cors";
import cron from "cron";
import { Server } from "socket.io";
import db from "./models/index.js";
import renewalData from "./utils/renewal/renewalData.js";
import socket from "./utils/socket.js";
import Auth from "./routes/Auth.js";
import Course from "./routes/Course.js";
import Post from "./routes/Post.js";
import Comment from "./routes/Comment.js";
import Mypage from "./routes/Mypage.js";
import Search from "./routes/Search.js";
import Notification from "./routes/Notification.js";
import Recommend from "./routes/Recommend.js";

// 데이터 갱신
const update = async () => {
  const start = new Date().toISOString();
  console.log(`[ Data Update ] In progress. ${start}`);

  const { updateResult, newLength } = await renewalData();

  const end = new Date().toISOString();
  console.log(`[ Data Update ] Completed. ${end}`);
  console.log(
    `[ Data Update ] Result - Offline: ${updateResult.off} ${newLength.off} | Online: ${updateResult.on} ${newLength.on} | Dept: ${updateResult.dept} ${newLength.dept}`
  );
};

// env
dotenv.config();

// express
const app = express();
const db_app = express();
app.use(express.json());
db_app.use(express.json());

// CORS
app.use(cors());

// server
const server = http.createServer(app);
const db_server = http.createServer(db_app);

// sequelize ORM
await db.sequelize
  .sync({ force: false })
  .then(() => {
    console.log(`Database Connected`);
  })
  .catch((err) => {
    console.error(err);
  });

// routers
app.use("/auth", Auth);
app.use("/course", Course);
app.use("/post", Post);
app.use("/comment", Comment);
app.use("/mypage", Mypage);
app.use("/search", Search);
app.use("/notif", Notification);
app.use("/rec", Recommend);

// PORT
const PORT = process.env.SERVER_PORT;
const DB_PORT = process.env.DATABASE_SERVER_PORT;
server.listen(PORT, () => {
  console.log(`Server 1 listening on PORT ${PORT}`);
});
db_server.listen(DB_PORT, async () => {
  console.log(`Server 2 listening on PORT ${DB_PORT}`);

  await update();

  // Scheduling - every 5:00
  new cron.CronJob(
    "00 00 5 * * *",
    async () => {
      await update();
    },
    null,
    true,
    "Asia/Seoul"
  );
});

// socket
const io = new Server(server);
socket(io); // def. path: /socket.io
