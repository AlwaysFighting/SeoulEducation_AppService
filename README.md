# 에듀서울 

## 목차
[1. 프로젝트 소개](#프로젝트-소개)

[2. 피그마 디자인 링크](#피그마-디자인-링크)

[3. 프로젝트 구조도](#프로젝트-구조도)

[4. 프로젝트 설치 및 실행 방법](#프로젝트-설치-및-실행-방법)

[5. 프로젝트 사용 방법](#프로젝트-사용-방법)

[6. Contributors](#contributors)



## 프로젝트 소개



## 피그마 디자인 링크
<img width="1000" src=""/>

[![Video Label](https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/7b26a45c-746a-483d-b67b-ea799e800f84)](https://www.figma.com/file/Nncev6ZyYveAEih4HQxcVd/%EC%97%B4%EB%A6%B0%EB%8D%B0%EC%9D%B4%ED%84%B0-%EA%B3%B5%EB%AA%A8%EC%A0%84?type=design&node-id=1-2)


## 프로젝트 구조도



## 프로젝트 설치 및 실행 방법

[Server]

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



## Contributors

|Name|김지원|송승희|목정아|최유선|김수민|
|------|---|---|---|---|---|
|Role|UXUI 디자이너|Frontend Dev|Frontend Dev|Backend Dev|AI / ML Dev|
|Profile|<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/68b770ed-45cc-417a-bf11-5f0901e616e7"/>|<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/da8a09d9-c6b7-45ad-87b5-e4bab17e9249"/>|<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/5a52883e-1cc9-4f91-a88e-e16c9828d9d5"/>|<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/3ad8548d-bae9-47ed-b1ac-fd32f806aa15"/>|<img width="200" src="https://github.com/AlwaysFighting/SeoulEducation_AppService/assets/87655596/e6626890-3d95-41e7-aa09-2a1ae4d20adc"/>|

