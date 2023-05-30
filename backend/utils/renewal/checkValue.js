const getIsoString = (str) => {
  const date = new Date(str);

  return date.toISOString().substring(0, 10);
};

export const checkNull = (value) => {
  return value === "" ? null : value;
};

export const checkLatLng = (latData, lngData) => {
  // lat, lng 값이 반대로 저장된 데이터일 경우 두 값 바꿔주기
  // lat, lng 값이 잘못 입력된 경우 null로 변경
  let lat = Number(latData);
  let lng = Number(lngData);

  if (lat === NaN || lng === NaN) {
    lat = null;
    lng = null;
  } else if (lat > 100 && lng > 100) {
    lat = null;
  } else if (lat < 100 && lng < 100) {
    lng = null;
  } else if (lat > 100 && lng < 100) {
    const temp = lat;
    lat = lng;
    lng = temp;
  }

  lat = lat === 0 ? null : lat;
  lng = lng === 0 ? null : lng;

  return { lat, lng };
};

export const parseDate = (str, isStr) => {
  if (str === "" || !str) {
    return null;
  }

  if (str === "상시") {
    return "always";
  }

  const str2 = str.includes("E") ? Number(str).toString() : str;

  try {
    let year, month, day;

    if (str2.includes(".")) {
      year = Number(str2.split(".")[0]);
      month = Number(str2.split(".")[1]) - 1;
      day = Number(str2.split(".")[2]);
    } else if (str2.includes("-")) {
      year = Number(str2.split("-")[0]);
      month = Number(str2.split("-")[1]) - 1;
      day = Number(str2.split("-")[2]);
    } else {
      year = Number(str2.substring(0, 4));
      month = Number(str2.substring(4, 6)) - 1;
      day = Number(str2.substring(6, 8));
    }

    year = year === NaN ? 0 : year;
    month = month === NaN ? 0 : month;
    day = day === NaN ? 1 : day;

    const result = new Date(year, month, day);

    return isStr ? result.toISOString().substring(0, 10) : result;
  } catch (err) {
    console.error(err);
    console.log(str);
  }
};

export const parseOnlineApplyDate = (str) => {
  if (str === "" || !str) {
    return null;
  }
  const applyStart = getIsoString(str.split("~")[0]);
  const applyEnd = getIsoString(str.split("~")[1]);

  return { applyStart, applyEnd };
};
