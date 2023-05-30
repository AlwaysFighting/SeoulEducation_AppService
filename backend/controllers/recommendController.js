import getRecommendation from "../utils/getRecommendation.js";
import models from "../models/index.js";

const Course = models.Course;
const Wishlist = models.Wishlist;
const recommendController = {};

recommendController.getRecommend = async (req, res) => {
  let message = "Server Error.";
  let errCode = 500;
  let errCategory;
  try {
    const userId = req.user;
    const category = req.body.category;
    const result = [];

    for (const value of category) {
      const data = await getRecommendation(value);

      if (data.length === 0) {
        errCategory = value;
        throw new Error("Invalid Category.");
      }

      for (const item of data) {
        const course = await Course.findOne({
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
          where: { courseCode: item },
        }).then((res) => {
          return res;
        });

        if (course) {
          const courseData = course["dataValues"];
          result.push(courseData);
        }
      }
    }

    // isLiked
    for (const item of result) {
      const wish = await Wishlist.findOne({
        where: { userId: userId, courseId: item.id },
      });
      item.isLiked = wish ? true : false;
    }

    // 응답 전송
    res.status(200).send({
      status: 200,
      data: result,
    });
  } catch (err) {
    console.error(err);

    if (err.message === "Invalid Category.") {
      message = `Invalid Category '${errCategory}'.`;
      errCode = 400;
    }

    res.status(errCode).send({
      status: errCode,
      message: message,
    });
  }
};

export default recommendController;
