import dotenv from "dotenv";
import redis from "redis";

dotenv.config();

// Connect Redis
const redisClient = redis.createClient({
  url: `redis://${process.env.REDIS_HOST}:${process.env.REDIS_PORT}`,
  legacyMode: true,
});

redisClient.on("connect", () => {
  console.info("Redis connected.");
});

redisClient.on("error", (err) => {
  console.error("Redis Client Error", err);
});

const connectClient = async () => {
  await redisClient.connect();
};

connectClient();

// Connect redis v4
const redisClientV4 = redisClient.v4;

export default redisClientV4;
