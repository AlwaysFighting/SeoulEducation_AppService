import models from "../models/index.js";

const Course = models.Course;
const Wishlist = models.Wishlist;
const Dept = models.Dept;
const sequelize = models.sequelize;
const courseController = {};

const setFilter = (filter, item) => {
  if (!filter) {
    return;
  }

  const now = new Date();
  now.setHours(9);
  now.setMinutes(0);
  now.setSeconds(0);

  switch (filter) {
    case "모두":
      return true;
    case "신청예정":
      return new Date(item["applyStartDate"]) > now;
    case "신청중":
      return (
        new Date(item["applyStartDate"]) <= now &&
        new Date(item["applyEndDate"]) >= now
      );
    case "신청마감":
      return new Date(item["applyEndDate"]) < now;
    case "마감임박":
      return new Date(item["applyEndDate"]) >= now;
  }
};

// 강좌 목록 조회
courseController.readList = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;

  let type, order, filter;
  try {
    const userId = req.user;
    type = req.params.type; // 모두 / 오프라인 / 온라인
    order = req.query.order; // 최신순 / 관심설정순 / 마감임박순
    filter = req.query.filter;
    const types = ["모두", "오프라인", "온라인"];
    const orders = ["최신순", "관심설정순", "마감임박순"];
    const filters = ["모두", "신청예정", "신청중", "신청마감"];
    let orderOption = null;
    let isValidType = false;
    let isValidOrder = false;
    let isValidFilter = false;
    let data = null;
    const filteredCourseList = [];

    // type 옵션 값 유효성 검사
    types.map((item) => {
      if (item === type) {
        isValidType = true;
      }
    });

    // type 값이 올바르지 않은 경우
    if (!isValidType) {
      throw new Error("Invalid type.");
    }

    // order 옵션 값 유효성 검사
    orders.map((item) => {
      if (item === order) {
        isValidOrder = true;
      }
    });

    // order 값이 올바르지 않은 경우
    if (!isValidOrder) {
      throw new Error("Invalid order.");
    }

    // filter 옵션 값 유효성 검사
    filters.map((item) => {
      if (item === filter) {
        isValidFilter = true;
      }
    });

    // filter 값이 올바르지 않을 경우
    if (!isValidFilter) {
      throw new Error("Invalid filter.");
    }

    // order option
    switch (order) {
      case "최신순":
        orderOption = [
          ["insertDate", "DESC"],
          ["applyStartDate", "DESC"],
        ];
        break;
      case "관심설정순":
        orderOption = [
          ["likeCount", "DESC"],
          ["insertDate", "DESC"],
        ];
        break;
      case "마감임박순":
        orderOption = [["applyEndDate", "ASC"]];
        break;
    }

    // 강좌 데이터 리스트 조회
    if (type === "모두") {
      data = await Course.findAll({
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
        order: orderOption,
      }).then((res) => {
        return res;
      });
    } else {
      // off / on 개별 조회
      const typeValue = type === "오프라인" ? "off" : "on";
      data = await Course.findAll({
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
        where: {
          type: typeValue,
        },
        order: orderOption,
      }).then((res) => {
        return res;
      });
    }

    if (!data) {
      throw new Error("Database connection error.");
    }

    // '마감임박순' 필터링 (신청마감 제외)
    if (order === "마감임박순") {
      const filteredListTemp = [];
      data.map((item) => {
        if (setFilter("마감임박", item)) {
          filteredListTemp.push(item);
        }
      });

      data = filteredListTemp;
    }

    // filter & isLiked
    for (const item of data) {
      if (setFilter(filter, item)) {
        const wish = await Wishlist.findOne({
          where: { userId: userId, courseId: item.id },
        });
        item["dataValues"].isLiked = wish ? true : false;

        filteredCourseList.push(item);
      }
    }

    const resMessage =
      filteredCourseList.length === 0 ? "No Result" : "Successfully Loaded.";

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: resMessage,
      data: filteredCourseList,
    });
  } catch (err) {
    console.error(err);

    if (err.message === `Invalid type.`) {
      message = `Invalid type '${type}'.`;
      errCode = 400;
    } else if (err.message === `Invalid order.`) {
      message = `Invalid order '${order}'.`;
      errCode = 400;
    } else if (err.message === `Invalid filter.`) {
      message = `Invalid filter '${filter}'.`;
      errCode = 400;
    } else if (err.message === "Database connection error.") {
      message = err.message;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 강좌 세부 조회
courseController.readDetail = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const courseId = req.params.courseId;

    if (!courseId) {
      throw new Error("CourseId Required.");
    }

    // 데이터 조회
    const data = await Course.findOne({
      where: {
        id: courseId,
      },
      attributes: [
        ["id", "courseId"],
        "type",
        "title",
        "category",
        "url",
        "applyStartDate",
        "applyEndDate",
        "startDate",
        "endDate",
        "insertDate",
        "deptName",
        [sequelize.literal("Dept.tel"), "deptTel"],
        "deptGu",
        [sequelize.literal("Dept.addr"), "deptAddr"],
        [sequelize.literal("Dept.url"), "deptUrl"],
        "deptLat",
        "deptLng",
        "likeCount",
        [
          sequelize.fn(
            "concat",
            process.env.SLL_URL,
            sequelize.col("imagePath")
          ),
          "imagePath",
        ],
        "isAvailable",
        "isFree",
        "capacity",
      ],
      include: [
        {
          model: Dept,
          attributes: [],
        },
      ],
    }).then((res) => {
      return res;
    });

    if (!data) {
      throw new Error("Invalid CourseId.");
    }

    if (data["dataValues"]["imagePath"] === process.env.SLL_URL) {
      data["dataValues"]["imagePath"] = null;
    }

    const wish = await Wishlist.findOne({
      where: { userId: userId, courseId: courseId },
    });
    data["dataValues"].isLiked = wish ? true : false;

    res.status(200).send({
      status: 200,
      data: data,
    });
  } catch (err) {
    console.error(err);

    if (err.message === "CourseId Required.") {
      message = err.message;
      errCode = 400;
    } else if (err.message === "Invalid CourseId.") {
      message = err.message;
      errCode = 400;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 찜 추가 및 삭제
courseController.addLike = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const courseId = req.params.courseId;
    let isLiked = false;

    if (!courseId) {
      throw new Error("CourseId Required.");
    }

    // 찜 여부 검사
    const data = await Wishlist.findOne({
      where: {
        userId: userId,
        courseId: courseId,
      },
    }).then((res) => {
      return res;
    });

    if (!data) {
      // 찜 등록
      await Wishlist.create({
        userId: userId,
        courseId: courseId,
      });
      isLiked = true;

      // 강좌 관심 설정 수 증가
      await Course.increment({ likeCount: 1 }, { where: { id: courseId } });
    } else {
      // 찜 해제
      await Wishlist.destroy({
        where: {
          userId: userId,
          courseId: courseId,
        },
      });

      // 강좌 관심 설정 수 감소
      await Course.increment({ likeCount: -1 }, { where: { id: courseId } });
    }

    res.status(200).send({
      status: 200,
      message: "Successfully Updated.",
      result: isLiked,
    });
  } catch (err) {
    console.error(err);

    if (
      err.name === "SequelizeDatabaseError" ||
      err.name === "SequelizeForeignKeyConstraintError"
    ) {
      message = "Invalid CourseId.";
      errCode = 400;
    } else if (err.message === "CourseId Required.") {
      message = err.message;
      errCode = 400;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 최신 강좌 목록 조회
courseController.readNew = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const type = req.params.type;

    if (type !== "off" && type !== "on") {
      throw new Error("Invalid type.");
    }

    // 데이터 조회
    const course = await Course.findAll({
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
      limit: 5,
      where: {
        type: type,
      },
      order: [
        ["insertDate", "DESC"],
        ["applyStartDate", "DESC"],
      ],
    }).then((res) => {
      return res;
    });

    for (const item of course) {
      const wish = await Wishlist.findOne({
        where: { userId: userId, courseId: item.id },
      });
      item["dataValues"].isLiked = wish ? true : false;
    }

    // 응답 전송
    res.status(200).send({
      status: 200,
      data: course,
    });
  } catch (err) {
    console.error(err);
    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

export default courseController;
