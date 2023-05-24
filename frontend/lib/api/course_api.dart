const localhost = "172.18.15.148";
const API_AUTH_URL = "http://$localhost:8080/auth";
const API_COURSES_URL = "http://$localhost:8080/course";
const API_COURSES_SEARCH_URL = "http://$localhost:8080/search/course";
const API_ALARM_URL = "http://$localhost:8080/notif";
const API_COMMUNITY = "http://$localhost:8080/post";
const String API_DETAIL_COMMUNITY = "http://$localhost:8080/post/";
const API_DELETE_COMMUNITY = "http://$localhost:8080/post";
const API_REPLY_COMMUNITY = "http://$localhost:8080/comment";
const String API_WRITING_REPLY = "http://$localhost:8080/comment";
const API_COMMUNITY_EDIT = "http://$localhost:8080/post";
const String API_COMMUNITY_SEARCH = "http://$localhost:8080/search/post?query=";
const API_COMMUNITY_WRITING = "http://$localhost:8080/post";
const String API_COMMUNITY_REREPLY = "http://$localhost:8080/comment/reply";
const API_MYPAGE_NICKCHANGE = "http://$localhost:8080/mypage/nickname";
const API_MYPAGE_PASSWORD_CHANGE = "http://$localhost:8080/mypage/password";
const String API_MYPAGE_LIKEDLECTURE="http://$localhost:8080/mypage/like";
const API_MYPAGE_WRITED="http://$localhost:8080/mypage/post";
const API_LOGOUT = "http://$localhost:8080/auth/logout";
const API_MYPAGE_LIKED = "http://$localhost:8080/mypage/like/";
const API_MYPAGE_CANCELLIKED = "http://$localhost:8080/course/";

// API_AUTH_URL - 회원가입
const EMAIL_LOGIN_API = "$API_AUTH_URL/login";
// const KAKAO_LOGIN__API = "$API_URL/login";
const LOGOUT_API = "$API_AUTH_URL/logout";
const EMAIL_CODE_REQUEST_API = "$API_AUTH_URL/email";
const EMAIL_CODE_CONFIRM_API = "$API_AUTH_URL/email/code";
const REGISTER_API = "$API_AUTH_URL/join";

// API_COURSES_URL - 강의 URL
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

  // 4. 강좌 검색 (온/오프/all)
  String searchCourses(String type, String query) {
    return "$API_COURSES_SEARCH_URL/$type?query=$query";
  }

  // 5. 강좌 찜 POST
  String starCourses(int id) {
    return "$API_COURSES_URL/$id";
  }
}

// API_ALARM_URL - 알림
class AlarmAPI {
  // 알림 목록 조회
  // 1-1. 카테고리 미선택 시 (모든 알림)
  String alarmList(int id) {
    return "$API_ALARM_URL/$id";
  }

  // 1-2. 카테고리 선택 시
  String alarmCatList(int id, String category) {
    return "$API_ALARM_URL/$id?category=$category";
  }
}
