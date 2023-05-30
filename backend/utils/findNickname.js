import models from "../models/index.js";

const User = models.User;

const findNickname = async (userId) => {
  const nickname = await User.findOne({
    attributes: ["nickname"],
    where: {
      id: userId,
    },
  }).then((res) => {
    return res;
  });

  const result = nickname ? nickname["dataValues"]["nickname"] : null;

  return result;
};

export default findNickname;
