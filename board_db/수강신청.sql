CREATE DATABASE IF NOT EXISTS `school_management`;
USE `school_management`;

-- 학교 정보
CREATE TABLE `school` (
    school_id INT PRIMARY KEY AUTO_INCREMENT,
    school_name VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 관리자 정보
CREATE TABLE `admin` (
    admin_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES School(school_id)
);

-- 관리자 로그인 정보
CREATE TABLE `admin_login` (
    admin_id VARCHAR(30) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    last_login TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

-- 교사 정보
CREATE TABLE `teacher` (
    teacher_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    subject VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES School(school_id)
);

-- 학생 정보
CREATE TABLE `student` (
    student_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL,
    name VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    status ENUM('재학', '졸업') DEFAULT '재학',
    grade VARCHAR(10) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES School(school_id)
);

-- 학생 로그인 정보
CREATE TABLE `student_login` (
    student_id VARCHAR(30) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    last_login TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

-- 과목 정보
CREATE TABLE `subject` (
    subject_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL,
    subject_name VARCHAR(50) NOT NULL,
    teacher_id VARCHAR(30) NOT NULL,
    grade VARCHAR(10) NOT NULL,
    semester VARCHAR(10) NOT NULL,
    max_enrollment INT DEFAULT 30,
    category ENUM('수강완료', '수강 미선택') DEFAULT '수강 미선택',
    affiliation ENUM('이과', '문과') NOT NULL,
    time_schedule VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES School(school_id),
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

-- 강의실 정보
CREATE TABLE `classroom` (
    classroom_id INT PRIMARY KEY AUTO_INCREMENT,
    class_number VARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    location VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 강의 정보
CREATE TABLE `lecture` (
    lecture_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id VARCHAR(30) NOT NULL,
    teacher_id VARCHAR(30) NOT NULL,
    classroom_id INT NOT NULL,
    day_of_week ENUM('월요일', '화요일', '수요일', '목요일', '금요일') NOT NULL,
    period INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id),
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id)
);

-- 수강 신청 정보
CREATE TABLE `course_registration` (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(30),
    subject_id VARCHAR(30),
    semester VARCHAR(10),
    year YEAR,
    registration_status ENUM('수강완료', '수강 미선택') DEFAULT '수강 미선택',
    approval_status ENUM('대기', '승인', '취소', '마감') DEFAULT '대기',
    approval_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

-- 학생 변경 내역
CREATE TABLE `student_history` (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(30),
    change_type ENUM('등록', '수정', '삭제') NOT NULL,
    changed_data TEXT NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

-- 공지사항
CREATE TABLE `notice` (
    notice_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id VARCHAR(30),
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    author VARCHAR(30) NOT NULL,
    target_audience ENUM('전체', '학생', '교사') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);