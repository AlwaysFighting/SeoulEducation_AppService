import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import redisCli from "../utils/redisCli.js";

dotenv.config();

function validateAccessToken(req, res, next) {
  if (!req.get("Authorization")) {
    return res.status(401).json({
      status: 401,
      message: "Token Required.",
    });
  }

  const token = req.get("Authorization").split("Bearer ")[1];

  // accessToken 검사 (redis 내 존재 여부)
  try {
    jwt.verify(token, process.env.JWT_SECRET, async (err, user) => {
      // jwt 검증 과정에서 error 발생한 경우
      if (err) {
        // token이 만료된 경우
        if (err.name === "TokenExpiredError") {
          return res.status(401).json({
            status: 401,
            message: "Token Expired.",
          });
        }

        // token이 올바르지 않을 경우
        return res.status(401).json({
          status: 401,
          message: "Invalid Token.",
        });
      }

      // Redis 내 user 정보 조회
      const userId = await redisCli.get(token);

      if (Number(userId) === Number(user.userId)) {
        // Redis 내 토큰 존재
        req.user = Number(userId);
        req.token = token;

        next();
      } else {
        // Redis 내 토큰 미존재
        return res.status(403).json({
          status: 403,
          message: "Invalid User.",
        });
      }
    });
  } catch (err) {
    console.error(err);
    return res.status(403).json({
      status: 403,
      message: "Invalid User.",
    });
  }
}

export default validateAccessToken;
