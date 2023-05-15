const API_AUTH_URL = "http://localhost:8080/auth";
const API_COURSES_URL = "http://localhost:8080/course";
const API_COURSES_SEARCH_URL = "http://localhost:8080/search/course";
const API_COURSES_MYPAGE_URL = "http://localhost:8080/mypage/like";

// API_AUTH_URL - 회원가입
const EMAIL_LOGIN_API = "$API_AUTH_URL/login";
// const KAKAO_LOGIN__API = "$API_URL/login";
const LOGOUT_API = "$API_AUTH_URL/logout";
const EMAIL_CODE_REQUEST_API = "$API_AUTH_URL/email";
const EMAIL_CODE_CONFIRM_API = "$API_AUTH_URL/email/code";
const REGISTER_API = "$API_AUTH_URL/join";

// API_COURSES_URL - 강의
class CoursesAPI {

  // 1. 강의 세부 목록 조회
  // 1-1. filter 미선택 시
  String coursesList(String type, String order) {
    return "$API_COURSES_URL/$type?order=$order";
  }
  // 1-2. filter 선택 시
  String coursesFilterList(String type, String order, String filter ) {
    return "$API_COURSES_URL/$type?order=$order?filter=$filter";
  }

  // 2. 관심 강좌 설정 및 취소
  String bookmarkCourse(String id) {
    return "$API_COURSES_URL/$id";
  }

  // 강좌 세부 조회
  String detailCourse(int id) {
    return "$API_COURSES_URL/detail/$id";
  }

  // 3. 최신 강좌 목록 조회
  String latestCourses(String type) {
    return "$API_COURSES_URL/course/new/$type";
  }

  // 4. 강좌 검색 (온/오프)
  String searchCourses(String type, String query) {
    return "$API_COURSES_SEARCH_URL/$type?query=$query";
  }

  // 5. 강좌 찜 POST
  String starCourses(int id) {
    return "$API_COURSES_URL/$id";
  }

  // 5. 강좌 찜 GET
  String isStarCourses(String type) {
    return "$API_COURSES_MYPAGE_URL/$type";
  }
}

