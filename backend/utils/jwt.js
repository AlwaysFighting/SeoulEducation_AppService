import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

export const getJWT = (payload) => {
  const { userId, email, isSocial } = payload;

  const token = jwt.sign(
    {
      userId: userId,
      email: email,
      isSocial: isSocial,
    },
    process.env.JWT_SECRET,
    { expiresIn: 60 * 60 } // 1 시간 후 만료
  );

  return token;
};

export const getRefresh = (payload) => {
  const { userId, email, isSocial } = payload;
  const str = "refresh_token";

  const token = jwt.sign(
    {
      userId: userId,
      email: email,
      isSocial: isSocial,
      string: str,
    },
    process.env.JWT_SECRET,
    { expiresIn: 60 * 60 * 24 * 14 } // 2 주 후 만료
  );

  return token;
};
