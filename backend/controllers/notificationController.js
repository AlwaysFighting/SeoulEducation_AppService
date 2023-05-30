import models from "../models/index.js";

const sequelize = models.sequelize;
const Notification = models.Notification;
const Course = models.Course;
const notificationController = {};

// 알림 목록 조회
notificationController.readAll = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const category = req.query.category;
    let list = null;

    // category가 올바르지 않은 경우
    if (
      category &&
      category !== "new" &&
      category !== "last" &&
      category !== "comment" &&
      category !== "reply"
    ) {
      throw new Error("Invalid category.");
    }

    if (category) {
      // 카테고리를 설정한 경우 (new / last / comment / reply)
      let attributes;
      switch (category) {
        case "new":
          attributes = [
            ["id", "notifyId"],
            "category",
            "isChecked",
            "publishDate",
            "userId",
          ];
          break;
        case "last":
          attributes = [
            ["id", "notifyId"],
            "category",
            [sequelize.literal("Course.type"), "type"],
            "isChecked",
            "publishDate",
            "userId",
            "courseId",
          ];
          break;
        case "comment":
          attributes = [
            ["id", "notifyId"],
            "category",
            "isChecked",
            "publishDate",
            "userId",
            "postId",
          ];
          break;
        case "reply":
          attributes = [
            ["id", "notifyId"],
            "category",
            "isChecked",
            "publishDate",
            "userId",
            "postId",
            "commentId",
          ];
          break;
      }

      list = await Notification.findAll({
        attributes: attributes,
        include: [{ model: Course, required: false, attributes: [] }],
        where: { userId: userId, category: category },
        order: [["publishDate", "DESC"]],
      }).then((res) => {
        return res;
      });
    } else {
      list = await Notification.findAll({
        attributes: [
          ["id", "notifyId"],
          "category",
          [sequelize.literal("Course.type"), "type"],
          "isChecked",
          "publishDate",
          "courseId",
          "postId",
          "commentId",
        ],
        include: [{ model: Course, required: false, attributes: [] }],
        where: { userId: userId },
        order: [["publishDate", "DESC"]],
      }).then((res) => {
        return res;
      });
    }

    list = list.length === 0 ? null : list;
    const resMessage = list ? "Successfully Loaded." : "No Result.";

    // 응답 전달
    res.status(200).send({
      status: 200,
      message: resMessage,
      data: list,
    });
  } catch (err) {
    console.error(err);

    if (err.message === "Invalid category.") {
      message = err.message;
      errCode = 400;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 알림 읽음 처리
notificationController.setChecked = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const notifyId = Number(req.params.notifyId);

    // notifyId가 올바르지 않을 경우
    if (!notifyId) {
      throw new Error("Invalid NotifyId.");
    }

    // notifyId 유효성 검사
    const notif = await Notification.findOne({
      where: { id: notifyId, userId: userId },
    }).then((res) => {
      return res;
    });

    // 해당 알림이 존재하지 않을 경우
    if (!notif) {
      throw new Error("Invalid NotifyId.");
    }

    // 데이터 업데이트
    await Notification.update(
      {
        isChecked: true,
      },
      { where: { id: notifyId } }
    );

    // 응답 전달
    res.status(200).send({
      status: 200,
      message: "Updated Successfuly.",
    });
  } catch (err) {
    console.error(err);

    if (err.message === "Invalid NotifyId.") {
      message = err.message;
      errCode = 400;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 모든 알림 조회 여부
notificationController.isAllChecked = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;

    // 데이터 조회
    const list = await Notification.findAll({
      where: { userId: userId, isChecked: false },
    }).then((res) => {
      return res;
    });

    // 조회 여부
    const isAllChecked = list.length === 0 ? true : false;

    // 응답 전달
    res.status(200).send({
      status: 200,
      isAllChecked: isAllChecked,
    });
  } catch (err) {
    console.error(err);

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

export default notificationController;
