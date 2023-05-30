import express from "express";
import recommendController from "../controllers/recommendController.js";
import validateAccessToken from "../middlewares/validateAccessToken.js";

const router = express.Router();

router.get("/", validateAccessToken, recommendController.getRecommend);

export default router;
