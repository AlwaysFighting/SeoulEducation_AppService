import dotenv from "dotenv";
import models from "../../models/index.js";
import checkRecentLog from "./checkRecentLog.js";
import renewalCourseData from "./renewalCourseData.js";
import renewalDeptData from "./renewalDeptData.js";
import matchDept from "./matchDept.js";

const System = models.System;
dotenv.config();

const renewalData = async () => {
  let recentLog, now;
  const error = { off: false, on: false, dept: false, matchDept: false };
  const newLength = { off: 0, on: 0, dept: 0 };

  // Dept
  try {
    now = new Date();
    recentLog = await checkRecentLog("dept");

    if (recentLog.needUpdate) {
      await renewalDeptData(recentLog).then((res) => {
        newLength.dept = res;
      });
    }
  } catch (err) {
    console.error(err);
    if (recentLog.needUpdate) {
      await System.destroy({
        where: { id: recentLog.newLogId },
      });
    }
    error.dept = true;
  } finally {
    console.log(`[ Data Update ] #--- Dept Data Update Completed.`);
  }

  // Offline Course
  try {
    now = new Date();
    // 최근 로그 검사 및 새로운 로그 등록
    recentLog = await checkRecentLog("off");

    // 데이터 등록
    if (recentLog.needUpdate) {
      await renewalCourseData(true, recentLog).then((res) => {
        newLength.off = res;
      });
    }
  } catch (err) {
    console.error(err);
    if (recentLog.needUpdate) {
      await System.destroy({
        where: { id: recentLog.newLogId },
      });
    }
    error.off = true;
  } finally {
    console.log(`[ Data Update ] ##-- Offline Course Data Update Completed.`);
  }

  // Online Course
  try {
    now = new Date();
    recentLog = await checkRecentLog("on");

    if (recentLog.needUpdate) {
      await renewalCourseData(false, recentLog).then((res) => {
        newLength.on = res;
      });
    }
  } catch (err) {
    console.error(err);
    if (recentLog.needUpdate) {
      await System.destroy({
        where: { id: recentLog.newLogId },
      });
    }
    error.on = true;
  } finally {
    console.log(`[ Data Update ] ###- Online Course Data Update Completed.`);
  }

  // dept 데이터 결합 (새로운 데이터가 있는 경우에만)
  try {
    if (newLength.dept || newLength.off || newLength.on) {
      await matchDept(newLength);
      error.matchDept = true;
    }
  } catch (err) {
    console.error(err);
  } finally {
    console.log(`[ Data Update ] #### Data Matching Completed.`);
  }

  const updateResult = {};
  updateResult.off = error.off ? "failed" : "success";
  updateResult.on = error.on ? "failed" : "success";
  updateResult.dept = error.dept ? "failed" : "success";
  updateResult.matchDept = error.matchDept ? "failed" : "success";

  return { updateResult, newLength };
};

export default renewalData;
