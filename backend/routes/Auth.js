import express from "express";
import authController from "../controllers/authController.js";
import validateAccessToken from "../middlewares/validateAccessToken.js";
import validateRefreshToken from "../middlewares/validateRefreshToken.js";

const router = express.Router();

router.post("/login", authController.login);
router.post("/login/kakao", authController.loginKakao);
router.post("/login/kakao/nickname/:userId", authController.setNickname);
router.post("/email", authController.requestEmailCode);
router.post("/email/code", authController.verifyEmailCode);
router.post("/join", authController.joinEmail);
router.get("/refresh", validateRefreshToken, authController.refresh);
router.post("/logout", validateAccessToken, authController.logout);
router.delete("/leave", validateAccessToken, authController.leave);

export default router;
