import models from "../../models/index.js";

const Dept = models.Dept;

const checkDuplicate = async (data) => {
  const res = await Dept.findOne({
    where: {
      name: data["name"],
    },
  }).then((res) => {
    return res;
  });

  if (res && res["tel"] === data["tel"]) {
    return true;
  }

  return false;
};

export default checkDuplicate;
