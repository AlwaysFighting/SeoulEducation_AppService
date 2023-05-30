import models from "../models/index.js";
import { Sequelize } from "sequelize";
import findNickname from "../utils/findNickname.js";
import commentCount from "../utils/commentCount.js";

const Course = models.Course;
const Post = models.Post;
const Wishlist = models.Wishlist;
const Op = Sequelize.Op;
const searchController = {};

// 강좌 검색
searchController.findCourse = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const type = req.params.type;
    const query = req.query.query;

    // type 유효성 검사
    if (type !== "off" && type !== "on") {
      throw new Error("Invalid type.");
    }

    // query 유효성 검사
    if (!query) {
      throw new Error("Query Required.");
    } else if (!query.trim()) {
      throw new Error("Query is Empty.");
    }

    // 데이터 검색 - 강좌명, 기관명, 기관구
    const result = await Course.findAll({
      where: {
        type: type,
        [Op.or]: [
          {
            title: {
              [Op.like]: `%${query}%`,
            },
          },
          {
            deptName: {
              [Op.like]: `%${query}%`,
            },
          },
          {
            deptGu: {
              [Op.like]: `%${query}%`,
            },
          },
        ],
      },
      attributes: [
        "type",
        "id",
        "title",
        "applyStartDate",
        "applyEndDate",
        "isFree",
        "category",
        "capacity",
      ],
      order: [["id", "DESC"]],
    }).then((res) => {
      return res;
    });

    for (const item of result) {
      const wish = await Wishlist.findOne({
        where: { userId: userId, courseId: item.id },
      });
      item["dataValues"].isLiked = wish ? true : false;
    }

    // 응답 메세지 설정
    const resMessage =
      result.length === 0 ? "No Result." : "Successfully Loaded.";

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: resMessage,
      data: result.length === 0 ? null : result,
    });
  } catch (err) {
    console.error(err);

    if (
      err.message === "Invalid type." ||
      err.message === "Query Required." ||
      err.message === "Query is Empty."
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

// 게시글 검색
searchController.findPost = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const query = req.query.query;

    // query 유효성 검사
    if (!query) {
      throw new Error("Query Required.");
    } else if (!query.trim()) {
      throw new Error("Query is Empty.");
    }

    // 데이터 검색 - 제목, 내용
    const list = await Post.findAll({
      where: {
        [Op.or]: [
          {
            title: {
              [Op.like]: `%${query}%`,
            },
          },
          {
            content: {
              [Op.like]: `%${query}%`,
            },
          },
        ],
      },
      attributes: [
        "id",
        "title",
        "content",
        "userId",
        "publishDate",
        "viewCount",
      ],
      order: [["publishDate", "DESC"]],
    }).then((res) => {
      return res;
    });

    // 데이터 저장
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

    // 응답 메세지 설정
    const resMessage =
      result.length === 0 ? "No Result." : "Successfully Loaded.";

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: resMessage,
      data: result.length === 0 ? null : result,
    });
  } catch (err) {
    console.error(err);

    if (
      err.message === "Query Required." ||
      err.message === "Query is Empty."
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

export default searchController;
