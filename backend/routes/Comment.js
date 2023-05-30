import express from "express";
import commentController from "../controllers/commentController.js";
import validateAccessToken from "../middlewares/validateAccessToken.js";

const router = express.Router();

router.get("/:postId", validateAccessToken, commentController.readComment);
router.post("/:postId", validateAccessToken, commentController.addComment);
router.post(
  "/reply/:commentId",
  validateAccessToken,
  commentController.addReplyComment
);

export default router;
