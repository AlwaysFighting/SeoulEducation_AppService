import models from "../../models/index.js";

const Course = models.Course;
const Dept = models.Dept;

const matchDept = async () => {
  const depts = await Dept.findAll().then((res) => {
    return res;
  });

  for (const item of depts) {
    await Course.update(
      {
        deptId: item["id"],
      },
      { where: { deptName: item["name"] } }
    );
  }
};

export default matchDept;
