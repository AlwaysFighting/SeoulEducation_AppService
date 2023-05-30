import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import redisCli from "../utils/redisCli.js";
import models from "../models/index.js";

dotenv.config();

const User = models.User;

async function validateRefreshToken(req, res, next) {
  try {
    const token = req.get("Authorization").split("Bearer ")[1];
    const refresh = req.get("Refresh").split("Bearer ")[1];
    let payload = null;

    if (!token || !refresh) {
      return res.status(401).send({
        status: 401,
        message: "Token Required.",
      });
    }

    try {
      payload = jwt.verify(refresh, process.env.JWT_SECRET);
    } catch (err) {
      // refresh token 미인증 시
      return res.status(401).send({
        status: 401,
        message: "Invalid Refresh Token.",
      });
    }

    try {
      const verifiedToken = jwt.verify(token, process.env.JWT_SECRET);

      if (verifiedToken) {
        // access token & refresh token 모두 만료되지 않은 경우
        return res.status(200).send({
          status: 200,
          message: "Access Token still valid.",
        });
      }
    } catch (err) {
      // access token만 만료 시
      //console.log(payload);
      const userId = payload["userId"];

      // DB 내 회원정보 조회
      const user = await User.findOne({
        where: {
          id: userId,
        },
      }).then((res) => {
        return res;
      });

      // 존재하지 않는 회원일 경우
      if (!user) {
        return res.status(401).send({
          status: 401,
          message: "User Not Found.",
        });
      }

      // Redis 내 user 정보 조회
      const redisToken = await redisCli.get(`${userId}refresh`);
      if (redisToken !== refresh) {
        return res.status(401).send({
          status: 401,
          message: "Invalid Refresh Token.",
        });
      }

      // payload 저장
      req.userId = userId;
      req.email = payload["email"];
      req.isSocial = payload["isSocial"];

      next();
    }
  } catch (err) {
    console.error(err);
    return res.status(401).send({
      status: 401,
      message: "Invalid Token.",
    });
  }
}

export default validateRefreshToken;
