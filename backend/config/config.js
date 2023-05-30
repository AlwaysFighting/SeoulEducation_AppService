import dotenv from "dotenv";

// env
dotenv.config();

const development = {
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: "database_seoul01",
  host: process.env.DB_HOST,
  dialect: "mysql",
  dialectOptions: { decimalNumbers: true },
  timezone: "+09:00",
  logging: false,
};

export default { development };
