import crypto from "crypto";

const randomString = (length) => {
  const randomString = crypto
    .randomBytes(length)
    .toString("hex")
    .substring(0, length);

  return randomString;
};

export default randomString;
