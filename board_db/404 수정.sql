CREATE DATABASE IF NOT EXISTS `high_school_banking_system_webpage`
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE `high_school_banking_system_webpage`;

-- DROP DATABASE `high_school_banking_system_webpage`;

-- 교실 (전체 수정 필요!)
-- CREATE TABLE IF NOT EXISTS `classroom` (
--     classroom_id INT PRIMARY KEY AUTO_INCREMENT, -- 교실 아이디, -- 테이블 내에서 교실을 나타내는 식별 키
--     class_number VARCHAR(10) NOT NULL, -- 반 번호
--     capacity INT NOT NULL, -- 인원 수 제한
--     is_available BOOLEAN NOT NULL DEFAULT TRUE, -- 사용 가능 유무
--     location VARCHAR(50) NOT NULL, -- 교실 위치
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성시간, -- 레코드가 처음 생성된 시각
--     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 수정시간, -- 레코드가 마지막으로 수정된 시각
-- );


-- 학교
CREATE TABLE IF NOT EXISTS `school` (
    school_id INT PRIMARY KEY AUTO_INCREMENT, -- 학교 아이디, -- 테이블 내에서 학교정보를 나타내는 식별 키
    name VARCHAR(30) NOT NULL, -- 학교 이름
    address VARCHAR(255) NOT NULL, -- 학교 주소
    contact_number VARCHAR(20) NOT NULL, -- 학교 전화번호
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성시간, -- 레코드가 처음 생성된 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 수정시간, -- 레코드가 마지막으로 수정된 시각
);

-- 관리자
CREATE TABLE IF NOT EXISTS `admin` (
    admin_id INT PRIMARY KEY AUTO_INCREMENT, -- 관리자 아이디, -- 테이블 내에서 관리자를 나타내는 식별 키 
    school_id INT NOT NULL, -- 학교 아이디
    name VARCHAR(30) NOT NULL, -- 관리자 이름
    email VARCHAR(30) UNIQUE NOT NULL, -- 관리자 이메일
    phone_number VARCHAR(20) NOT NULL, -- 관리자 전화번호
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성시간, -- 레코드가 처음 생성된 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정시간, -- 레코드가 마지막으로 수정된 시각
    FOREIGN KEY (school_id) REFERENCES school(school_id) -- 관리자가 학교정보를 가지고 오기 위해, school테이블에서 school_id를 가져오려고 외래키로 설정
);

-- 교사
CREATE TABLE IF NOT EXISTS `teacher` (
    teacher_id VARCHAR(30) PRIMARY KEY, -- 교사 아이디, -- 테이블 내에서 선생님을 나타내는 식별 키
    school_id INT NOT NULL, -- 학교 아이디
    name VARCHAR(30) NOT NULL, -- 교사 이름
    email VARCHAR(50) UNIQUE NOT NULL, -- 교사 이메일
    phone_number VARCHAR(20) NOT NULL, -- 교사 전화번호
    subject VARCHAR(50) NOT NULL, -- 담당 과목, 정규화 필요 (1대 다)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성시간, -- 레코드가 처음 생성된 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정시간, -- 레코드가 마지막으로 수정된 시각
    FOREIGN KEY (school_id) REFERENCES school(school_id) -- 선생님이 학교정보를 가지고 오기 위해, school테이블에서 school_id를 가져오려고 외래키로 설정
);

-- 학생
CREATE TABLE IF NOT EXISTS `student` ( 
    student_id VARCHAR(30) PRIMARY KEY, -- 학생 아이디, -- 테이블 내에서 학생을 나타내는 식별 키
    school_id INT NOT NULL, -- 학교 아이디
    username VARCHAR(255) NOT NULL, -- 학생 (로그인) 아이디 -- UNIQUE 지정?
    password VARCHAR(255) NOT NULL, -- 학생 비밀번호
    student_number VARCHAR(30) UNIQUE, -- 학번
    name VARCHAR(20) NOT NULL, 학생 이름
    grade VARCHAR(10) NOT NULL, -- 학년 정보
    email VARCHAR(50) UNIQUE NOT NULL, -- 이메일
    phone_number VARCHAR(20) NOT NULL, -- 휴대전화
    birth_date DATE NOT NULL, 생년월일
    affiliation ENUM('humanities', 'natural_sciences') NOT NULL, -- 계열(문과, 이과)
    
    status ENUM('enrolled', 'graduated') NOT NULL, -- 상태: 재학, 졸업 
    admission_year DATE NOT NULL, -- 입학 년도
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 생성시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정시간
    FOREIGN KEY (school_id) REFERENCES school(school_id) -- 학생이 학교정보를 가지고 오기 위해, school테이블에서 school_id를 가져오려고 외래키로 설정
);

-- 과목
CREATE TABLE IF NOT EXISTS subject (
    subject_id VARCHAR(30) PRIMARY KEY, -- 과목 고유 ID
    school_id INT NOT NULL, -- 과목을 개설한 학교 ID
    teacher_id VARCHAR(30), -- 담당 교사 ID (teacher 테이블 참조)
    subject_name VARCHAR(30) NOT NULL, -- 과목명
    grade VARCHAR(10) NOT NULL, -- 대상 학년 (예: 1, 2, 3학년)
    semester VARCHAR(10) NOT NULL, -- 개설 학기 (예: 1학기, 2학기)
    category ENUM('completed', 'not_selected') NOT NULL, -- 과목 분류 (기이수/미선택 등)
    affiliation ENUM('humanities', 'natural_sciences') NOT NULL, -- 계열 구분 (이과/문과 등)
    max_enrollment INT NOT NULL, -- 수강 정원

    -- 아래는 lecture 테이블에서 가져온 강의 정보
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') NOT NULL, -- 수업 요일
    period INT NOT NULL, -- 수업 교시
    classroom_name VARCHAR(50), -- 강의실 이름 (예: 2층 201호)
    -- 결과 발표일: 신청 마감 이후 자동 처리 기준
    result_announcement_date DATE NOT NULL, -- 수강 결과 발표일
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시각
    FOREIGN KEY (school_id) REFERENCES school(school_id),
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);


-- 수강 제한
CREATE TABLE IF NOT EXISTS `course_restriction` (
    restriction_id INT PRIMARY KEY AUTO_INCREMENT, -- 수강 제한 아이디, -- 테이블 내에서 수강 제한을 나타내는 식별 키
    subject_id VARCHAR(30) NOT NULL, -- 과목 아이디
    allowed_grade VARCHAR(10) NOT NULL, -- 허용 학년
    max_enrollment INT NOT NULL, -- 제한 인원
    is_repeat_allowed BOOLEAN DEFAULT FALSE, -- 중복신청허용여부
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성시간 
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정시간
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id) -- 과목을 가지고 와서 수강 제한하기 위해, subject테이블에서 subject_id을 가져오려고 외래키로 설정
);

-- 수강 관리
CREATE TABLE IF NOT EXISTS `course_registration` (
    registration_id INT PRIMARY KEY AUTO_INCREMENT, -- 수강 관리 아이디, -- 테이블 내에서 수강 관리를 나타내는 식별 키
    student_id VARCHAR(30) NOT NULL, -- 학생 아이디
    subject_id VARCHAR(30) NOT NULL, -- 과목 아이디
    academic_year YEAR NOT NULL, -- 수강 신청 년도
    semester VARCHAR(10) NOT NULL, -- 학기
    registration_status ENUM('registered','cancelled') DEFAULT 'registered', -- 수강 관리 상태(등록, 취소) = DEFAULT 등록
    approval_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending', -- 승인 상태(대기, 허용, 거부) = DEFAULT 대기
    approval_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 승인 처리 날짜
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정시간
    FOREIGN KEY (student_id) REFERENCES student(student_id), -- 수강 관리를 위해 학생정보를 가지고 오기 위해, student테이블에서 student_id 외래키로 설정
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id) -- 수강 관리를 위해 과목을 가지고 오기 위해, subject테이블에서 subject_id 외래키로 설정
);

-- 수강 이력
CREATE TABLE IF NOT EXISTS `course_history` (
    student_id VARCHAR(30), -- 학생 아이디
    subject_id VARCHAR(30), -- 과목 아이디
    teacher_id VARCHAR(30), -- 선생님 아이디
    academic_year YEAR NOT NULL, -- 수강 신청 연도
    semester VARCHAR(10) NOT NULL, -- 수강 신청 학기
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성시간 
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정시간
    PRIMARY KEY (student_id, subject_id, academic_year, semester), -- 테이블 내에서 수강 이력을 나타내는 식별 키
    FOREIGN KEY (student_id) REFERENCES student(student_id), -- 수강 이력 확인을 위해, student테이블에서 student_id 외래키로 설정
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id), -- 수강 이력 확인을 위해, subject테이블에서 subject_id 외래키로 설정
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id) -- 수강 이력 확인을 위해, teacher테이블에서 teacher_id 외래키로 설정
);

-- 시간표
CREATE TABLE IF NOT EXISTS `schedule` (
    student_id VARCHAR(30), -- 학생 아이디
    subject_id VARCHAR(30),  -- 과목 아이디
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') NOT NULL, -- 요일
    period INT NOT NULL, -- (1~8)교시
    classroom_id INT, -- 교실 아이디
    teacher_id VARCHAR(30), -- 선생님 아이디
    PRIMARY KEY (student_id, subject_id, day_of_week, period), -- 테이블 내에서 시간표를 나타내는 식별 키
    FOREIGN KEY (student_id) REFERENCES student(student_id), -- 시간표 확인을 위해, student테이블에서 student_id 외래키로 설정
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id), -- 시간표 확인을 위해, subject테이블에서 subject_id 외래키로 설정
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id), -- 시간표 확인을 위해, teacher테이블에서 teacher_id 외래키로 설정
    FOREIGN KEY (classroom_id) REFERENCES classroom(classroom_id) -- 수강 이력 확인을 위해, classroom테이블에서 classroom_id 외래키로 설정
);

-- 공지사항
CREATE TABLE IF NOT EXISTS `notice` (
    notice_id INT PRIMARY KEY AUTO_INCREMENT, -- 공지사항 아이디, -- 테이블 내에서 강의를 나타내는 식별 키
    admin_id INT NOT NULL, -- 관리자 아이디
    title VARCHAR(255) NOT NULL, -- 제목
    content TEXT NOT NULL, -- 내용
    target_audience ENUM('all', 'student', 'teacher') NOT NULL, -- 대상('전체','학생','선생님)
    
    -- 필드 설명: 
    start_date DATE NOT NULL, -- 시작 날짜
    end_date DATE NOT NULL, -- 마지막 날짜
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정시간
    
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id) -- 공지사항 확인을 위해, admin테이블에서 admin_id 외래키로 설정
);

-- INSERT INTO 테이블명 (열1, 열2, 열3, ...)
-- VALUES (값1, 값2, 값3, ...);
