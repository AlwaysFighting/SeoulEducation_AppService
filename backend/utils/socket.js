import { Sequelize } from "sequelize";
import redisCli from "./redisCli.js";
import models from "../models/index.js";

const User = models.User;
const Post = models.Post;
const Comment = models.Comment;
const ReplyToComment = models.ReplyToComment;
const Course = models.Course;
const System = models.System;
const Wishlist = models.Wishlist;
const Notification = models.Notification;
const sequelize = models.sequelize;
const Op = Sequelize.Op;

const socket = (io) => {
  io.on("connection", (socket) => {
    console.log(`[ ${socket.id} ] Socket connection established.`);

    // 구독
    socket.on("subscribe", async (data) => {
      const userId = data;

      // redis에 id 저장
      await redisCli.set(`${userId}socket`, socket.id).then(() => {
        console.log(`[Redis] User ${userId} : Socket Id Saved Successfully.`);
      });
    });

    // 새로운 강좌
    socket.on("new", async (data) => {
      const recentDate = await System.findOne({
        where: { [Op.or]: [{ category: "off" }, { category: "on" }] },
        order: [["logDate", "DESC"]],
      }).then((res) => {
        return res ? res["logDate"] : res;
      });

      const now = new Date().getDate();

      // 최근 갱신 Log가 최근 날짜일 경우
      if (recentDate && recentDate.getDate() >= now - 1) {
        // 모든 user 조회
        const users = await User.findAll().then((res) => {
          return res;
        });

        // notification 데이터 저장 (모든 user)
        for (const user of users) {
          await Notification.create({
            category: "new",
            userId: user["id"],
          });
        }

        // notification 전달 내용
        const notify = {
          target: "everyone",
          isNewAvailable: true,
        };

        // 알림 전송
        io.to(socket.id).emit("new", notify);
      }
    });

    // 관심 강좌 수강신청 마지막 날 임박
    socket.on("last", async (data) => {
      const now = new Date().getDate();

      // userId 유효성 검사
      const userId = data;
      const user = await User.findOne({
        where: { id: userId },
      }).then((res) => {
        return res;
      });

      if (!user) {
        // user validation 실패한 경우
        io.to(socket.id).emit("last", `[ Failed ] Invalid UserId.`);
      } else {
        // 관심 강좌 조회
        const list = await Wishlist.findAll({
          where: { userId: userId },
          attributes: [
            [sequelize.literal("Course.id"), "courseId"],
            [sequelize.literal("Course.type"), "type"],
            [sequelize.literal("Course.applyEndDate"), "applyEndDate"],
          ],
          include: [{ model: Course, attributes: [] }],
        }).then((res) => {
          return res;
        });

        for (const item of list) {
          const applyEndDate = new Date(
            item["dataValues"]["applyEndDate"]
          ).getDate();

          if (now <= applyEndDate && now >= applyEndDate - 7) {
            // notification 데이터 저장
            await Notification.create({
              category: "last",
              userId: userId,
              courseId: item["dataValues"]["courseId"],
            });

            // notification 전달 내용
            const notify = {
              target: userId,
              courseId: item["dataValues"]["courseId"],
              type: item["dataValues"]["type"],
              remaining: applyEndDate - now,
            };

            // 알림 전송
            io.to(socket.id).emit("last", notify);
          }
        }
      }
    });

    // 댓글 작성
    socket.on("comment", async (data) => {
      // 댓글이 작성된 postId, 댓글 작성자 userId
      const postId = Number(data.postId);
      const userId = Number(data.userId);
      let writer = null;

      if (postId) {
        // postId로 게시글 작성자 조회
        writer = await Post.findOne({
          where: { id: postId },
        }).then((res) => {
          if (res) {
            return res["userId"];
          }
        });
      }

      if (writer) {
        // 해당 게시글 작성자가 댓글 작성자가 아닐 경우에만 알림 전송
        if (writer !== userId) {
          // notification 데이터 저장
          await Notification.create({
            category: "comment",
            userId: writer,
            postId: postId,
          });

          // notification 전달 내용
          const notify = {
            target: writer,
            postId: postId,
          };

          // 게시글 작성자 socket id 조회
          const writerId = await redisCli.get(`${writer}socket`);

          // 알림 전송
          if (writerId) {
            io.to(writerId).emit("comment", notify);
          }
        }
      } else {
        const message = !data
          ? "[ Transmission Failed ] Value Required."
          : "[ Transmission Failed ] Invalid Value.";

        io.to(socket.id).emit("comment", message);
      }
    });

    // 댓글-답글 작성
    socket.on("reply", async (data) => {
      // 답글이 작성된 commentId, 작성자 userId
      const commentId = Number(data.commentId);
      const userId = Number(data.userId);
      let comment = null;
      const targets = [];

      // commentId로 원댓글 조회
      if (commentId) {
        comment = await Comment.findOne({
          where: { id: commentId },
          attributes: [
            "userId",
            "postId",
            [sequelize.literal("Post.userId"), "writerId"],
          ],
          include: [{ model: Post, attributes: [] }],
        }).then((res) => {
          return res ? res["dataValues"] : res;
        });
      }

      if (comment && userId) {
        // 해당 댓글에 답글을 작성한 모든 유저 조회
        const replyList = await ReplyToComment.findAll({
          attributes: [
            [sequelize.fn("DISTINCT", sequelize.col("userId")), "userId"],
          ],
          where: { userId: { [Op.ne]: null }, commentId: commentId },
        }).then((res) => {
          return res;
        });
        replyList.map((user) => {
          targets.push(Number(user["userId"]));
        });

        // 알림 타겟 추가(원댓글 작성자, 게시글 작성자)
        targets.push(Number(comment["writerId"]));
        targets.push(Number(comment["userId"]));

        // 타겟 중복 제거
        const uniqueTargets = [...new Set(targets)];
        const replyTargets = [];
        const commentTargets = [];

        // 타겟 분류
        for (const target of uniqueTargets) {
          if (target === Number(comment["writerId"])) {
            // 게시글 작성자일 경우
            if (target === Number(comment["userId"])) {
              // 댓글 작성자 && !해당 답글 작성자 (답글 알림)
              replyTargets.push(target);
            } else {
              // !댓글 작성자 && !답글 작성자 (댓글 알림)
              commentTargets.push(target);
            }
          } else {
            if (target !== userId) {
              // !해당 답글 작성자 (답글 알림)
              replyTargets.push(target);
            }
          }
        }

        // notification 전달 내용
        const commentNotify = {
          target: comment["writerId"],
          postId: comment["postId"],
        };
        const replyNotify = {
          target: comment["userId"],
          postId: comment["postId"],
          commentId: commentId,
        };

        // 알림 전송 및 데이터 저장
        // 1. 답글
        for (const target of replyTargets) {
          // 데이터 저장
          await Notification.create({
            category: "reply",
            userId: target,
            postId: comment["postId"],
            commentId: commentId,
          });

          // socket id 조회
          const id = await redisCli.get(`${target}socket`);

          // 알림 전송
          io.to(id).emit("reply", replyNotify);
        }
        // 2. 댓글
        for (const target of commentTargets) {
          // 데이터 저장
          await Notification.create({
            category: "comment",
            userId: target,
            postId: comment["postId"],
            commentId: commentId,
          });

          // socket id 조회
          const id = await redisCli.get(`${target}socket`);

          // 알림 전송
          io.to(id).emit("comment", commentNotify);
        }
      } else {
        const message =
          !data.userId || !data.commentId
            ? "[ Transmission Failed ] Value Required."
            : "[ Transmission Failed ] Invalid Value.";

        // 알림 전송
        io.to(socket.id).emit("reply", message);
      }
    });

    // 연결 종료
    socket.on("disconnect", async (data) => {
      const userId = data;
      // redis 내 id 삭제
      await redisCli.del(`${userId}socket`).then(() => {
        console.log(`[Redis] User ${userId} : Socket Id Removed Successfully.`);
        console.log("Socket disconnected.");
      });
    });

    // socket error
    socket.on("error", (error) => {
      console.error(error);
      io.to(socket.id).emit("error", error);
    });
  });
};

export default socket;
