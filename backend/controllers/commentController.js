import models from "../models/index.js";
import findNickname from "../utils/findNickname.js";

const Post = models.Post;
const Comment = models.Comment;
const ReplyToComment = models.ReplyToComment;
const commentController = {};

// 댓글 목록 조회
commentController.readComment = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const postId = Number(req.params.postId);

    // postId 유효성 검사
    const post = await Post.findOne({
      where: {
        id: postId,
      },
    }).then((res) => {
      return res;
    });

    // 해당 게시글 존재하지 않을 경우
    if (!post) {
      throw new Error("Invalid PostId.");
    }

    // 댓글 조회
    const commentData = await Comment.findAll({
      where: {
        postId: postId,
      },
      order: [["publishDate", "ASC"]],
    }).then((res) => {
      return res;
    });

    if (!commentData.length) {
      res.status(200).send({
        status: 200,
        message: "No Comment.",
        data: null,
      });

      return;
    }

    // 데이터 저장
    const result = [];

    for (const item of commentData) {
      const data = {};
      data.commentId = item["id"];
      data.userId = item["userId"];
      data.userNickname = await findNickname(item["userId"]);
      data.publishDate = item["publishDate"];
      data.content = item["content"];
      result.push(data);
    }

    // 댓글에 대한 답글 조회
    for (const item of result) {
      const replyData = await ReplyToComment.findAll({
        where: {
          commentId: item["commentId"],
        },
        order: [["publishDate", "ASC"]],
      }).then((res) => {
        return res;
      });

      const replyArr = [];
      if (!replyData.length) {
        item.reply = null;
      } else {
        for (const reply of replyData) {
          const data = {};
          data.replyId = reply["id"];
          data.userId = reply["userId"];
          data.userNickname = await findNickname(reply["userId"]);
          data.publishDate = reply["publishDate"];
          data.content = reply["content"];
          replyArr.push(data);
        }

        item.reply = replyArr;
      }
    }

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: "Successfully Loaded.",
      data: result,
    });
  } catch (err) {
    console.error(err);

    if (err.message === "Invalid PostId.") {
      message = err.message;
      errCode = 400;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 댓글 작성
commentController.addComment = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const postId = req.params.postId;
    const content = req.body.content;

    // PostId 유효성 검사
    const post = await Post.findOne({
      where: {
        id: postId,
      },
    }).then((res) => {
      return res;
    });

    // 해당 게시글 존재하지 않을 경우
    if (!post) {
      throw new Error("Invalid PostId.");
    }

    // content 값 유효성 검사
    if (!content) {
      throw new Error("Value required.");
    } else if (!content.trim()) {
      throw new Error("Content is Empty.");
    }

    // 데이터 저장
    const commentId = await Comment.create({
      userId: userId,
      postId: postId,
      content: content,
    }).then((res) => {
      return res["id"];
    });

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: "Successfully Saved.",
      commentId: commentId,
    });
  } catch (err) {
    console.error(err);

    if (
      err.message === "Invalid PostId." ||
      err.message === "Value required." ||
      err.message === "Content is Empty."
    ) {
      message = err.message;
      errCode = 400;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 댓글-답글 작성
commentController.addReplyComment = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const commentId = req.params.commentId;
    const content = req.body.content;

    // commentId 유효성 검사
    const comment = await Comment.findOne({
      where: {
        id: commentId,
      },
    }).then((res) => {
      return res;
    });

    // 해당 원댓글 존재하지 않을 경우
    if (!comment) {
      throw new Error("Invalid CommentId.");
    }

    // content 값 유효성 검사
    if (!content) {
      throw new Error("Value required.");
    } else if (!content.trim()) {
      throw new Error("Content is Empty.");
    }

    // 데이터 저장
    const replyId = await ReplyToComment.create({
      userId: userId,
      commentId: commentId,
      content: content,
    }).then((res) => {
      return res["id"];
    });

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: "Successfully Saved.",
      replyId: replyId,
    });
  } catch (err) {
    console.error(err);

    if (
      err.message === "Invalid CommentId." ||
      err.message === "Value required." ||
      err.message === "Content is Empty."
    ) {
      message = err.message;
      errCode = 400;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

export default commentController;
