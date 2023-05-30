import express from "express";
import searchController from "../controllers/searchController.js";
import validateAccessToken from "../middlewares/validateAccessToken.js";

const router = express.Router();

router.get("/course/:type", validateAccessToken, searchController.findCourse);
router.get("/post", validateAccessToken, searchController.findPost);

export default router;
