import dotenv from "dotenv";
import nodemailer from "nodemailer";
import ejs from "ejs";
import path from "path";
import fs from "fs";
import randomString from "./randomString.js";
import redisCli from "../utils/redisCli.js";

dotenv.config();

const imagePath = "./public/eduSeoulLogo.png";
const image = fs.readFileSync(imagePath);
const base64Image = image.toString("base64");

const smtpTransport = nodemailer.createTransport({
  service: process.env.SMTP_SERVICE,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASSWORD,
  },
  tls: {
    rejectUnauthorized: false,
  },
});

const sendEmailCode = async (email) => {
  const code = randomString(6);
  const __dirname = path.resolve();
  let emailTemplete;
  ejs.renderFile(
    __dirname + "/emailTemplete.ejs",
    { code: code, base64Image: base64Image },
    (err, data) => {
      if (err) {
        console.error("ejs.renderFile Error");
        console.error(err);
      }
      emailTemplete = data;
    }
  );

  const mailOptions = {
    from: process.env.SMTP_USER,
    to: email,
    subject: "[평생학습 포털 모바일] 이메일 인증 코드 입력 안내",
    html: emailTemplete,
  };

  smtpTransport.sendMail(mailOptions, async (err, res) => {
    if (err) {
      console.error(err);
      throw new Error("Failed to Send Email.");
    } else {
      console.log(`${email}: Email Sent Successfully.`);

      // redis 내 인증코드 저장
      await redisCli.set(email, code, {
        EX: 60 * 5, // 5m
      });
    }

    smtpTransport.close();
  });
};

export default sendEmailCode;
