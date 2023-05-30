export const emailValidation = (email) => {
  const pattern =
    /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
  return pattern.test(email);
};

export const passwordValidation = (password) => {
  const maxLength = 20;
  const minLength = 10;

  if (password.length < minLength || password.length > maxLength) {
    return false;
  }

  const blank_pattern = /[\s]/g;
  if (blank_pattern.test(password)) {
    return false;
  }

  return true;
};

export const nicknameValidation = (nickname) => {
  const maxLength = 10;
  const minLength = 3;

  if (nickname.length < minLength || nickname.length > maxLength) {
    return false;
  }

  const blank_pattern = /[\s]/g;
  if (blank_pattern.test(nickname)) {
    return false;
  }

  return true;
};
