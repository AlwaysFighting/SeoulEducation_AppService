import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import redisCli from "./redisCli.js";

dotenv.config();

async function validateAccessTokenForSocket(token) {
  let status = false;
  let message = "Invalid Token.";
  let userId = null;
  let decoded;

  if (!token) {
    message = "Token Required.";

    return { status, message, userId };
  }

  try {
    decoded = jwt.verify(token, process.env.JWT_SECRET);
  } catch (err) {
    console.error(err);

    // token이 만료된 경우
    if (err.name === "TokenExpiredError") {
      message = "Token Expired.";
    }

    return { status, message, userId };
  }

  // Redis 내 user 정보 조회
  const userIdData = await redisCli.get(token);

  if (Number(userIdData) === Number(decoded["userId"])) {
    // Redis 내 토큰 존재
    status = true;
    message = "Validated.";
    userId = Number(userIdData);
  } else {
    // Redis 내 토큰 미존재
    message = "Invalid User.";
  }

  return { status, message, userId };
}

export default validateAccessTokenForSocket;
