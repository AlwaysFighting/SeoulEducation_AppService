import models from "../../models/index.js";

const System = models.System;

const checkRecentUpdate = (date, now) => {
  // 최근 갱신 날짜보다 24시간 지난 시점이라면 true
  return date.setDate(date.getDate() + 1) <= now;
};

const checkRecentLog = async (category) => {
  const now = new Date();
  const result = {};
  // 1. 최근 갱신 날짜 확인
  const log = await System.findAll({
    where: {
      category: category,
    },
    order: [["renewalDate", "DESC"]],
    limit: 1,
  }).then((res) => {
    return res[0] ? res[0]["dataValues"] : null;
  });

  const recentUpdate = log ? log.renewalDate : null;
  const needUpdate = recentUpdate ? checkRecentUpdate(recentUpdate, now) : true;

  result.now = now;
  result.log = log;
  result.needUpdate = needUpdate;
  result.recentUpdate = recentUpdate;

  if (!needUpdate) {
    return result;
  }

  // 2. log 등록
  const logId = await System.create({
    category: category,
    renewalDate: models.sequelize.literal("CURRENT_TIMESTAMP"),
  }).then((res) => {
    return res["dataValues"].id;
  });

  result.newLogId = logId;

  return result;
};

export default checkRecentLog;
