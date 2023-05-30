import express from "express";
import mypageController from "../controllers/mypageController.js";
import validateAccessToken from "../middlewares/validateAccessToken.js";

const router = express.Router();

router.get("/like/:type", validateAccessToken, mypageController.readLike);
router.get("/post", validateAccessToken, mypageController.readPost);
router.patch("/nickname", validateAccessToken, mypageController.setNickname);
router.patch("/password", validateAccessToken, mypageController.setPassword);
router.get("/info", validateAccessToken, mypageController.getUserInfo);

export default router;
