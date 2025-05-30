CREATE DATABASE IF NOT EXISTS `high_school_banking_system_webpage`
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE `high_school_banking_system_webpage`;

-- 학교: 각 학교의 기본 정보 저장
CREATE TABLE IF NOT EXISTS `school` (
    school_id INT PRIMARY KEY AUTO_INCREMENT, -- 학교 고유 ID
    name VARCHAR(30) NOT NULL, -- 학교 이름
    address VARCHAR(255) NOT NULL, -- 학교 주소
    contact_number VARCHAR(20) NOT NULL, -- 학교 연락처
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 수정 시각
);

-- 관리자: 각 학교의 관리자 정보 저장
CREATE TABLE IF NOT EXISTS `admin` (
    admin_id INT PRIMARY KEY AUTO_INCREMENT, -- 관리자 고유 ID
    school_id INT NOT NULL, -- 소속 학교 ID
    name VARCHAR(30) NOT NULL, -- 이름
    email VARCHAR(30) UNIQUE NOT NULL, -- 이메일 (로그인용)
    phone_number VARCHAR(20) NOT NULL, -- 전화번호
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시각
    FOREIGN KEY (school_id) REFERENCES school(school_id) -- 소속 학교 참조
);

-- 교사: 교사 정보 저장
CREATE TABLE IF NOT EXISTS `teacher` (
    teacher_id VARCHAR(30) PRIMARY KEY, -- 교사 고유 ID
    school_id INT NOT NULL, -- 소속 학교 ID
    name VARCHAR(30) NOT NULL, -- 이름
    email VARCHAR(50) UNIQUE NOT NULL, -- 이메일
    phone_number VARCHAR(20) NOT NULL, -- 전화번호
    subject VARCHAR(50) NOT NULL, -- 담당 과목 (단일 문자열, 정규화 가능)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시각
    FOREIGN KEY (school_id) REFERENCES school(school_id) -- 소속 학교 참조
);

-- 학생: 학생 정보 저장
CREATE TABLE IF NOT EXISTS `student` ( 
    student_id VARCHAR(30) PRIMARY KEY, -- 학생 고유 ID
    school_id INT NOT NULL, -- 소속 학교 ID
    username VARCHAR(255) NOT NULL, -- 로그인용 사용자명
    password VARCHAR(255) NOT NULL, -- 로그인용 비밀번호
    student_number VARCHAR(30) UNIQUE, -- 학번
    name VARCHAR(20) NOT NULL, -- 이름
    grade VARCHAR(10) NOT NULL, -- 학년
    email VARCHAR(50) UNIQUE NOT NULL, -- 이메일
    phone_number VARCHAR(20) NOT NULL, -- 전화번호
    birth_date DATE NOT NULL, -- 생년월일
    affiliation ENUM('humanities', 'natural_sciences') NOT NULL, -- 계열
    status ENUM('enrolled', 'graduated') NOT NULL, -- 재학 상태
    admission_year DATE NOT NULL, -- 입학 연도
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시각
    FOREIGN KEY (school_id) REFERENCES school(school_id) -- 소속 학교 참조
);

-- 과목: 과목 및 강의 정보 통합 저장
CREATE TABLE IF NOT EXISTS subject (
    subject_id VARCHAR(30) PRIMARY KEY, -- 과목 고유 ID
    school_id INT NOT NULL, -- 소속 학교 ID
    teacher_id VARCHAR(30), -- 담당 교사 ID
    subject_name VARCHAR(30) NOT NULL, -- 과목명
    grade VARCHAR(10) NOT NULL, -- 대상 학년
    semester VARCHAR(10) NOT NULL, -- 학기
    category ENUM('completed', 'not_selected') NOT NULL, -- 과목 분류
    affiliation ENUM('humanities', 'natural_sciences') NOT NULL, -- 계열
    max_enrollment INT NOT NULL, -- 최대 수강 인원
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') NOT NULL, -- 수업 요일
    period INT NOT NULL, -- 교시
    classroom_name VARCHAR(50), -- 강의실 이름
    result_announcement_date DATE NOT NULL, -- 결과 발표일
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시각
    FOREIGN KEY (school_id) REFERENCES school(school_id),
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

-- 수강 제한: 과목별 수강 조건 설정
CREATE TABLE IF NOT EXISTS `course_restriction` (
    restriction_id INT PRIMARY KEY AUTO_INCREMENT, -- 수강 제한 고유 ID
    subject_id VARCHAR(30) NOT NULL, -- 관련 과목 ID
    allowed_grade VARCHAR(10) NOT NULL, -- 수강 허용 학년
    max_enrollment INT NOT NULL, -- 수강 정원
    is_repeat_allowed BOOLEAN DEFAULT FALSE, -- 재수강 허용 여부
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시각
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id) -- 과목 참조
);

-- 수강 신청
CREATE TABLE IF NOT EXISTS `course_registration` (
    registration_id INT PRIMARY KEY AUTO_INCREMENT, -- 수강 신청 고유 ID
    student_id VARCHAR(30) NOT NULL, -- 신청 학생 ID
    subject_id VARCHAR(30) NOT NULL, -- 신청 과목 ID
    academic_year YEAR NOT NULL, -- 수강 신청 연도
    semester VARCHAR(10) NOT NULL, -- 학기
    registration_status ENUM('registered','cancelled') DEFAULT 'registered', -- 등록/취소 상태
    approval_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending', -- 승인 상태
    approval_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 상태 변경 시각
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시각
    FOREIGN KEY (student_id) REFERENCES student(student_id), -- 학생 참조
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id) -- 과목 참조
);

-- 수강 이력
CREATE TABLE IF NOT EXISTS `course_history` (
    student_id VARCHAR(30), -- 학생 ID
    subject_id VARCHAR(30), -- 과목 ID
    teacher_id VARCHAR(30), -- 교사 ID
    academic_year YEAR NOT NULL, -- 수강 연도
    semester VARCHAR(10) NOT NULL, -- 학기
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시각
    PRIMARY KEY (student_id, subject_id, academic_year, semester), -- 복합 기본 키
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

-- 시간표
CREATE TABLE IF NOT EXISTS `schedule` (
    student_id VARCHAR(30), -- 학생 ID
    subject_id VARCHAR(30), -- 과목 ID
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') NOT NULL, -- 요일
    period INT NOT NULL, -- 교시
    classroom_name VARCHAR(50), -- 강의실 이름
    teacher_id VARCHAR(30), -- 교사 ID
    PRIMARY KEY (student_id, subject_id, day_of_week, period),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

-- 공지사항
CREATE TABLE IF NOT EXISTS `notice` (
    notice_id INT PRIMARY KEY AUTO_INCREMENT, -- 공지사항 고유 ID
    admin_id INT NOT NULL, -- 작성 관리자 ID
    title VARCHAR(255) NOT NULL, -- 제목
    content TEXT NOT NULL, -- 내용
    target_audience ENUM('all', 'student', 'teacher') NOT NULL, -- 대상 구분
    start_date DATE NOT NULL, -- 공지 시작일
    end_date DATE NOT NULL, -- 공지 종료일
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시각
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시각
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);
