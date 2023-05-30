import models from "../../models/index.js";

const Course = models.Course;
const Dept = models.Dept;

const addDB = async (data, type) => {
  switch (type) {
    case "off":
      await Course.create({
        courseCode: data["courseCode"],
        type: data["type"],
        title: data["title"],
        url: data["url"],
        applyStartDate: data["applyStartDate"],
        applyEndDate: data["applyEndDate"],
        startDate: data["startDate"],
        endDate: data["endDate"],
        deptName: data["deptName"],
        deptGu: data["deptGu"],
        deptLat: data["deptLat"],
        deptLng: data["deptLng"],
        insertDate: data["insertDate"],
        capacity: data["capacity"],
      });
      break;
    case "on":
      await Course.create({
        courseCode: data["courseCode"],
        type: data["type"],
        title: data["title"],
        url: data["url"],
        applyStartDate: data["applyStartDate"],
        applyEndDate: data["applyEndDate"],
        startDate: data["startDate"],
        deptName: data["deptName"],
        deptGu: data["deptGu"],
        deptLat: data["deptLat"],
        deptLng: data["deptLng"],
        insertDate: data["insertDate"],
        imagePath: data["imagePath"],
        isAvailable: data["isAvailable"],
        isFree: data["isFree"],
      });
      break;
    case "dept":
      await Dept.create({
        name: data["name"],
        tel: data["tel"],
        addr: data["addr"],
        url: data["url"],
        lat: data["lat"],
        lng: data["lng"],
      });
      break;
  }
};

export default addDB;
