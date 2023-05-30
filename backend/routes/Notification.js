import express from "express";
import validateAccessToken from "../middlewares/validateAccessToken.js";
import notificationController from "../controllers/notificationController.js";

const router = express.Router();

router.get("/", validateAccessToken, notificationController.readAll);
router.patch(
  "/:notifyId",
  validateAccessToken,
  notificationController.setChecked
);
router.get("/check", validateAccessToken, notificationController.isAllChecked);

export default router;
