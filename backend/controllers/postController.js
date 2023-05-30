import models from "../models/index.js";
import findNickname from "../utils/findNickname.js";
import commentCount from "../utils/commentCount.js";

const Post = models.Post;
const postController = {};

// 게시글 목록 조회
postController.readList = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    // 제목, 내용, 작성자, 작성일시, 댓글 수
    const list = await Post.findAll({
      attributes: [
        "id",
        "title",
        "content",
        "userId",
        "publishDate",
        "viewCount",
      ],
    }).then((res) => {
      return res;
    });

    // 목록이 없을 경우
    if (!list.length) {
      res.status(200).send({
        status: 200,
        message: "No Result.",
        data: null,
      });

      return;
    }

    const result = [];
    for (const post of list) {
      const postData = {};

      postData.postId = post["id"];
      postData.title = post["title"];
      postData.content = post["content"];
      postData.userId = post["userId"];
      postData.userNickname = await findNickname(post["userId"]);
      postData.publishDate = post["publishDate"];
      postData.viewCount = post["viewCount"];
      postData.commentCount = await commentCount(post["id"]);

      result.push(postData);
    }

    res.status(200).send({
      status: 200,
      message: "Successfully Loaded.",
      data: result,
    });
  } catch (err) {
    console.error(err);
    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 게시글 세부 조회
postController.readDetail = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const postId = req.params.postId;

    // 게시글 데이터 조회
    const post = await Post.findOne({
      attributes: [
        "id",
        "title",
        "content",
        "userId",
        "publishDate",
        "viewCount",
      ],
      where: {
        id: postId,
      },
    }).then((res) => {
      return res;
    });

    // 게시글이 없을 경우
    if (!post) {
      throw new Error("Invalid PostId.");
    }

    const result = {};

    result.postId = post["id"];
    result.title = post["title"];
    result.content = post["content"];
    result.userId = post["userId"];
    result.userNickname = await findNickname(post["userId"]);
    result.publishDate = post["publishDate"];
    result.viewCount = post["viewCount"] + 1;
    result.commentCount = await commentCount(post["id"]);

    // 조회 수 증가
    await Post.increment({ viewCount: 1 }, { where: { id: postId } });

    // 응답 전송
    res.status(200).send({
      status: 200,
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

// 게시글 작성
postController.newPost = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const title = req.body.title;
    const content = req.body.content;

    // 값 유효성 검사
    if (!title || !content) {
      throw new Error("Value required.");
    } else if (title.length > 40) {
      throw new Error("Title is too long.");
    } else if (!title.trim()) {
      throw new Error("Title is Empty.");
    } else if (!content.trim()) {
      throw new Error("Content is Empty.");
    }

    // DB 저장
    const postId = await Post.create({
      userId: userId,
      title: title,
      content: content,
    }).then((res) => {
      return res["id"];
    });

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: "Successfully Saved.",
      postId: postId,
    });
  } catch (err) {
    console.error(err);

    if (
      err.message === "Value required." ||
      err.message === "Title is too long." ||
      err.message === "Title is Empty." ||
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

// 게시글 삭제
postController.deletePost = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const postId = Number(req.params.postId);

    // 해당 게시글 작성자 확인
    const writer = await Post.findOne({
      where: {
        id: postId,
      },
    }).then((res) => {
      return res;
    });

    // 해당 게시글이 존재하지 않을 경우
    if (!writer) {
      throw new Error("Invalid PostId.");
    }

    // 요청 사용자가 게시글 작성자가 아닐 경우
    if (writer["userId"] !== userId) {
      throw new Error("Not the Writer.");
    }

    // 데이터 삭제
    await Post.destroy({
      where: {
        id: postId,
      },
    });

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: "Successfully Deleted.",
    });
  } catch (err) {
    console.error(err);

    if (err.message === "Invalid PostId.") {
      message = err.message;
      errCode = 400;
    } else if (err.message === "Not the Writer.") {
      message = err.message;
      errCode = 403;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 게시글 수정
postController.editPost = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const postId = Number(req.params.postId);
    const title = req.body.title;
    const content = req.body.content;

    // 해당 게시글 작성자 확인
    const post = await Post.findOne({
      where: {
        id: postId,
      },
    }).then((res) => {
      return res;
    });

    // 해당 게시글이 존재하지 않을 경우
    if (!post) {
      throw new Error("Invalid PostId.");
    }

    // 요청 사용자가 게시글 작성자가 아닐 경우
    if (post["userId"] !== userId) {
      throw new Error("Not the Writer.");
    }

    // 값 유효성 검사
    if (!title || !content) {
      throw new Error("Value required.");
    } else if (!title.trim()) {
      throw new Error("Title is Empty.");
    } else if (!content.trim()) {
      throw new Error("Content is Empty.");
    } else if (title.length > 40) {
      throw new Error("Title is too long.");
    } else if (title === post["title"] && content === post["content"]) {
      throw new Error("No change detected.");
    }

    // 데이터 수정
    await Post.update(
      {
        title: title,
        content: content,
        isEdited: true,
      },
      {
        where: {
          id: postId,
        },
      }
    );

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: "Successfully Updated.",
    });
  } catch (err) {
    console.error(err);

    if (
      err.message === "Invalid PostId." ||
      err.message === "Value required." ||
      err.message === "Title is Empty." ||
      err.message === "Content is Empty." ||
      err.message === "Title is too long." ||
      err.message === "No change detected."
    ) {
      message = err.message;
      errCode = 400;
    } else if (err.message === "Not the Writer.") {
      message = err.message;
      errCode = 403;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

export default postController;
