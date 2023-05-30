import axios from "axios";
import dotenv from "dotenv";

dotenv.config();

const getRecommendation = async (category) => {
  const result = await axios
    .get(`${process.env.FAST_API_BASE_URL}/rec/${category}`)
    .then((res) => {
      return res;
    });

  return result["data"];
};

export default getRecommendation;
