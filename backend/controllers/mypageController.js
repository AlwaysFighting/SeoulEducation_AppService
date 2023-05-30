import models from "../models/index.js";
import { createHashedPassword, verifyPassword } from "../utils/hash.js";
import commentCount from "../utils/commentCount.js";
import findNickname from "../utils/findNickname.js";
import {
  nicknameValidation,
  passwordValidation,
} from "../utils/strValidation.js";

const sequelize = models.sequelize;
const User = models.User;
const Wishlist = models.Wishlist;
const Course = models.Course;
const Post = models.Post;
const mypageController = {};

// 관심 강좌 목록 조회
mypageController.readLike = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const type = req.params.type;

    // type 값이 올바르지 않은 경우
    if (type !== "off" && type !== "on") {
      throw new Error("Invalid type.");
    }

    // 관심 강좌 조회
    const list = await Wishlist.findAll({
      where: { userId: userId, "$Course.type$": type },
      attributes: [
        "wishDate",
        [sequelize.literal("Course.id"), "courseId"],
        [sequelize.literal("Course.type"), "type"],
        [sequelize.literal("Course.title"), "title"],
        [sequelize.literal("Course.applyStartDate"), "applyStartDate"],
        [sequelize.literal("Course.applyEndDate"), "applyEndDate"],
        [sequelize.literal("Course.isFree"), "isFree"],
        [sequelize.literal("Course.category"), "category"],
        [sequelize.literal("Course.capacity"), "capacity"],
      ],
      include: [
        {
          model: Course,
          required: true,
          attributes: [],
        },
      ],
      order: [["wishDate", "DESC"]],
    }).then((res) => {
      return res;
    });

    // 응답 메세지 설정
    const resMessage =
      list.length === 0 ? "No Result." : "Successfully Loaded.";

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: resMessage,
      data: list.length === 0 ? null : list,
    });
  } catch (err) {
    console.error(err);

    if (err.message === "Invalid type.") {
      message = err.message;
      errCode = 400;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 작성 게시글 목록 조회
mypageController.readPost = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;

    const list = await Post.findAll({
      attributes: [
        "id",
        "title",
        "content",
        "userId",
        "publishDate",
        "viewCount",
      ],
      where: { userId: userId },
      order: [["publishDate", "DESC"]],
    }).then((res) => {
      return res;
    });

    for (const item of list) {
      item["dataValues"].commentCount = await commentCount(item["id"]);
      item["dataValues"].userNickname = await findNickname(item["userId"]);
    }

    // 응답 메세지 설정
    const resMessage =
      list.length === 0 ? "No Result." : "Successfully Loaded.";

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: resMessage,
      data: list.length === 0 ? null : list,
    });
  } catch (err) {
    console.error(err);

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 닉네임 변경
mypageController.setNickname = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const nickname = req.body.nickname;

    // 유저 조회
    const user = await User.findOne({ where: { id: userId } }).then((res) => {
      return res;
    });

    // 닉네임 변화가 없는 경우
    if (user["nickname"] === nickname) {
      throw new Error("Nickname unchanged.");
    }

    // nickname 유효성 확인 (공백, 길이)
    if (!nicknameValidation(nickname)) {
      throw new Error("Invalid Nickname.");
    }

    // DB 수정
    await User.update(
      {
        nickname: nickname,
      },
      { where: { id: userId } }
    );

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: "Updated Successfully.",
    });
  } catch (err) {
    console.error(err);

    if (
      err.message === "Nickname unchanged." ||
      err.message === "Invalid Nickname."
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

// 비밀번호 변경
mypageController.setPassword = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const password = req.body.password;
    const newPassword = req.body.newPassword;

    // 회원 조회
    const user = await User.findOne({
      where: {
        id: userId,
      },
    }).then((res) => {
      return res;
    });

    if (user["isSocial"]) {
      throw new Error("Social login user.");
    }

    // 현재 비밀번호 일치 여부 검사
    const userPassword = user.password;
    const userSalt = user.salt;

    // 비밀번호 불일치
    if (!(await verifyPassword(password, userSalt, userPassword))) {
      throw new Error("Incorrect Password.");
    }

    // password 유효성 확인 (공백, 길이)
    if (!passwordValidation(newPassword)) {
      throw new Error("Invalid Password.");
    }

    // password hashing
    const { hashedPassword, salt } = await createHashedPassword(newPassword);

    // DB 수정
    await User.update(
      {
        password: hashedPassword,
        salt: salt,
      },
      {
        where: {
          id: userId,
        },
      }
    );

    // 응답 전송
    res.status(200).send({
      status: 200,
      message: "Updated Successfully.",
    });
  } catch (err) {
    console.error(err);

    if (
      err.message === "Social login user." ||
      err.message === "Incorrect Password."
    ) {
      message = err.message;
      errCode = 403;
    } else if (err.message === "Invalid Password.") {
      message = err.message;
      errCode = 400;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

// 회원정보 조회
mypageController.getUserInfo = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  try {
    const userId = req.user;
    const data = {};

    // user 조회
    const user = await User.findOne({ where: { id: userId } }).then((res) => {
      return res;
    });

    // 해당 user가 존재하지 않을 경우
    if (!user) {
      throw new Error("Invalid UserId.");
    }

    // 데이터 저장
    data.email = user["email"];
    data.nickname = user["nickname"];

    // 응답 전송
    res.status(200).send({
      status: 200,
      data: data,
    });
  } catch (err) {
    console.error(err);

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

export default mypageController;
