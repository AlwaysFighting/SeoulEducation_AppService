# 배움나래 - 에듀서울 📚

## 목차
[1. 프로젝트 소개](#프로젝트-소개)

[2. 피그마 디자인 링크](#피그마-디자인-링크)

[3. 프로젝트 구조도](#프로젝트-구조도)

[4. 프로젝트 설치 및 실행 방법](#프로젝트-설치-및-실행-방법)

[5. 프로젝트 사용 방법](#프로젝트-사용-방법)

[6. Contributors](#contributors)



## 프로젝트 소개
에듀서울은 서울시의 평생교육강좌 데이터를 활용해 서울 시민의 평생교육 강좌를 보다 편리하게 이용할 수 있도록 개발한 어플입니다. 
저희 어플의 주요기능은 크게 3가지가 있습니다.

첫 번째, 온라인, 오프라인, 추천강좌로 나누어서 전체 강좌들을 총 3가지방식으로 보여주고 있습니다. 추천강좌는 평생교육 강좌 공공데이터를 카테고리화하여 보여주어 사용자들이 자신에게 적합한 강좌를 찾을 수 있도록 하기위해 제작하였습니다.

두 번째, 에듀서울을 이용하여 평생학습 강좌를 수강하는 사용자들간의 정보공유와 다른 사용자와의 소통을 하기위해서 게시판 기능을 제작하였습니다. 이 게시판을 통해 사용자들은 유용한 정보들을 획득하고 다른 사용자들과 소통할 수 있습니다.

세 번째, 평생학습 관련 공지사항을 에듀서울에서 받을 수 있도록 제작하여 사용자들이 유용한 정보를 빠르게 받을 수 있도록 제작하였습니다.

네 번째, 사용자가 스크랩한 강좌의 신청 마감기한을 알람으로 안내하여 신청 마감기한을 놓치지 않을 수 있도록 제작하였습니다.


## 피그마 디자인 링크

https://www.figma.com/file/Nncev6ZyYveAEih4HQxcVd/%EC%97%B4%EB%A6%B0%EB%8D%B0%EC%9D%B4%ED%84%B0-%EA%B3%B5%EB%AA%A8%EC%A0%84?type=design&node-id=1-2 


## IA
<img width="800" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/7163e924-af66-4e8a-bfad-c726ca1aae89"/>



## 프로젝트 구조도
<img width="800" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/43cef5a5-3ce9-4aaf-aec6-3898dd06324c"/>



## 프로젝트 설치 및 실행 방법

### 1) Server

### 1. MySQL, Redis 프로그램 설치
데이터베이스 구축을 위해 MySQL, Redis 프로그램을 미리 설치합니다.

### 2. 백엔드 폴더로 이동
터미널을 실행하여 백엔드 폴더로 이동합니다.

```bash
cd backend
```

### 3. `.env` 파일 생성
프로그램 실행을 위해 환경변수를 작성합니다.

```env
# 서버 PORT
SERVER_PORT=8080
DATABASE_SERVER_PORT=8081

# DB 설정 관련 값
DB_USERNAME={MySQL 사용자 이름}
DB_NAME={MySQL 데이터베이스 이름}
DB_PASSWORD={MySQL 비밀번호}
DB_HOST="127.0.0.1"

# Redis 관련 값
REDIS_HOST="127.0.0.1"
REDIS_PORT="6379"

# JWT 발행 관련 값
JWT_SECRET={JWT 발행을 위한 비밀키}

# 해싱을 위한 값
HASH_ITERATION_COUNT=100149
HASH_ALGORITHM="sha512"

# nodemailer 설정 값 (이메일 인증 코드 전송을 위해)
SMTP_SERVICE="gmail"
SMTP_USER={발송자 이메일 주소}
SMTP_PASSWORD={발송자 이메일 비밀번호}

# Kakao OAuth
KAKAO_OAUTH_TOKEN_API_URL="https://kauth.kakao.com/oauth/token"
KAKAO_GRANT_TYPE="authorization_code"
KAKAO_CLIENT_ID={카카오 로그인 API의 REST API 키}
KAKAO_REDIRECT_URI="http://localhost:3000"
KAKAO_API_URL="https://kapi.kakao.com"
KAKAO_PROFILE_URL="https://kapi.kakao.com/v2/user/me"
KAKAO_APP_ADMIN_KEY={카카오 로그인 API의 Admin 키}

# Open API 요청을 위한 값
OPEN_API_BASE_URL="http://openAPI.seoul.go.kr:8088"
OPEN_API_KEY={서울 열린데이터 OpenAPI KEY}
OPEN_API_SERVICE_NAME_OFFLINE="OfflineCourse"
OPEN_API_SERVICE_NAME_ONLINE="OnlineCoures"
OPEN_API_SERVICE_NAME_DEPT="LifetimeEduOrgan"
SLL_URL="https://sll.seoul.go.kr"

# Fast API
FAST_API_BASE_URL="http://localhost:8000"
```

### 4. 패키지 설치
프로그램 실행에 필요한 패키지들을 설치합니다.

```bash
npm install
```

### 5. 서버 실행
서버를 실행합니다.

```bash
node app
```

<br>

[Frontend]



## 프로젝트 사용 방법


### 1.회원가입


<img width="300" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/d00a4a17-0351-476d-addd-32e369413ef6"/><img width="300" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/e2d3509f-cfad-462f-8c4b-38dcd37442bf"/>


사용자는 이메일 인증을 통해 회원가입을 진행할 수 있습니다.


### 2.로그인


<img width="250" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/a0add984-35a0-4bb6-8f5f-0c6aee4f0872"/><img width="250" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/6e915963-1c37-49cd-a5b5-46b9ec3fb304"/>


회원가입시 인증받았던 이메일로 로그인이 가능하며 카카오 소셜계정을 통해서도 로그인이 가능합니다.


### 3.홈화면


<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/62fe9e35-5423-4665-b294-ce3adf5534ce"/>
<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/0e926cb7-6f33-4026-ae29-b79447ce8c6c"/>
<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/db59e402-1885-4a21-a17b-2717acb673fb"/>



로그인을 완료한 회원은 홈화면으로 가게됩니다. 홈화면에서는 온라인, 오프라인, 추천강좌 항목들을 통해 평생교육 강좌들을 조회할 수 있습니다. 찾고 싶은 특정 강좌가 있을 경우 검색기능을 사용하여 강좌를 찾을 수 있습니다. 평생교육 관련 공지사항들도 홈화면에서 확인할 수 있습니다.
사용자가 스크랩한 강좌의 수강 신청기간이 임박했을 때 알람을 통해 해당 사실을 안내 받을 수 있습니다. 알람은 홈화면과 마이페이지에서도 조회할 수 있습니다. 


### 4.강좌조회

<img width="150" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/60ecd257-fe85-4134-a39a-ea2621e8af6b"/><img width="150" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/61156aac-82c6-4a80-bc14-3df9e14013f5"/><img width="150" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/10fa8433-e4bb-4f12-81fb-e1e4a35ee658"/><img width="150" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/8a114429-2669-4312-8519-ee5cd78db8db"/>



사용자는 온라인, 오프라인, 추천강좌 탭에서 다양한 강좌를 조회할 수 있습니다. 마감임박순과 관심설정순으로 강좌를 정렬할 수 있습니다. 또한 사용자는 자신이 원하는 강좌를 스크랩해서 마이페이지에서 볼 수 있습니다.


### 5.게시판


<img width="150" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/6dba2093-a57c-4077-8e7b-67a872ef3ecf"/><img width="150" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/6503e175-2dcb-4dd9-991c-6b5e9df6f866"/><img width="150" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/c84688db-6c55-4367-9d8a-0d4a96dcdfbd"/><img width="150" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/70aa2800-af63-4586-8c91-b3ecd359ce7f"/>



사용자들 사이의 의견교환과 정보공유를 위한 게시판 기능입니다. 
게시판에서는 사용자들끼리 궁금한 것이나 자신의 의견, 유용한 정보를 나눌 수 있습니다. 게시판에 글을 작성하고 댓글과 대댓글을 달 수 있으며 사용자가 보고 싶은 게시글이 있다면 검색기능을 통해 찾을 수 있습니다.


### 6.마이페이지


<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/14398217-0b63-4aa4-ae16-6eb91dde3da1"/><img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/a8cb459e-f5cc-483f-9a1a-e42d93b04980"/><img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/80136506/d046f8fb-f532-40eb-ae2e-4c2f234f2f2d"/>



사용자가 개인정보를 편리하게 관리하도록 하게하기 위해서 마이페이지입니다.
마이페이지에서는 사용자가 스크랩한 강좌, 사용자가 게시판에 작성한 글, 최근 본 강좌의 목록을 조회할 수 있습니다. 또한 이름과 비밀번호를 수정할 수 있고 로그아웃과 탈퇴의 기능이 있어 에듀서울을 보다 편리하게 사용할 수 있도록 하였습니다.



## Contributors

|Name|김지원|송승희|목정아|최유선|김수민|
|------|---|---|---|---|---|
|Role|UXUI 디자이너|Frontend Dev|Frontend Dev|Backend Dev|AI / ML Dev|
|Profile|<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/78d80a96-4e38-4d29-84bc-96bed3fadb75"/>|<img width="140" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/3effd961-c190-4013-b46b-3429eb5a8f82"/>|<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/541c41c9-479a-4680-93e2-6e3dc34607bb"/>|<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/acfcae46-584c-4153-9c8e-a215cae7e7a0"/>|<img width="210" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/54fe5dec-9943-408b-90b6-4359f46cf194"/>|

