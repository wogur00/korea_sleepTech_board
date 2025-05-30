CREATE DATABASE IF NOT EXISTS `high_school_banking_system_webpage`
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE `high_school_banking_system_webpage`;

-- 학교
CREATE TABLE `school` (
    school_id INT PRIMARY KEY AUTO_INCREMENT,
	school_name VARCHAR(30) NOT NULL,
    address VARCHAR(255) NOT NULL,
    contact_number VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 관리자 (로그인 포함)
CREATE TABLE `admin` (
    admin_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL,
    user_name VARCHAR(50) UNIQUE NOT NULL,
    admin_password VARCHAR(255) NOT NULL,
    admin_name VARCHAR(30) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES school(school_id)
);

-- 교사 (로그인 포함)
CREATE TABLE `teacher` (
    teacher_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL,
    user_name VARCHAR(50) UNIQUE NOT NULL,
    teacher_password VARCHAR(255) NOT NULL,
    teacher_name VARCHAR(30) NOT NULL,
    gender ENUM('MALE','FEMALE'),
	email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    subject VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES school(school_id)
);

-- 학생 (로그인 포함)
CREATE TABLE `student` (
    student_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL,
    user_name VARCHAR(50) UNIQUE NOT NULL,
    student_password VARCHAR(255) NOT NULL,
    student_number VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(20) NOT NULL,
    grade ENUM('1', '2', '3') NOT NULL,
    gender ENUM('MALE','FEMALE') NOT NULL,    
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    affiliation ENUM('LIBERAL_ARTS', 'NATURAL_SCIENCES') NOT NULL,
    status ENUM('ENROLLED', 'GRADUATED') NOT NULL,
    admission_year YEAR NOT NULL,
    profile_image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES school(school_id)
);

-- 과목: 강의 개설용 정보 (수업 개요)
CREATE TABLE `subject` (
    subject_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL,
    subject_name VARCHAR(50) NOT NULL,
    grade ENUM('1', '2', '3') NOT NULL,
    semester ENUM('1', '2') NOT NULL,
    affiliation ENUM('LIBERAL_ARTS', 'NATURAL_SCIENCES') NOT NULL,
    -- completion_classification ENUM('COMPLETED', 'NOT_SELECTED') NOT NULL,
    main_category ENUM('KOREAN', 'MATHEMATICS', 'ENGLISH', 'KOREAN_HISTORY') NOT NULL,
    choice_category ENUM ('SOCIAL_STUDIES', 'SCIENCE', 'SECOND_FOREIGN_LANGUAGE', 
    'ARTS_AND_PHYSICAL_EDUCATION', 'OTHERS') NOT NULL,
    max_enrollment INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES school(school_id)
);

-- 교실
CREATE TABLE `classroom` (
    classroom_id INT PRIMARY KEY AUTO_INCREMENT,
    class_number VARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    location VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 강의: 시간표 포함, 과목 실제 운영
CREATE TABLE `lecture` (
    lecture_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id VARCHAR(30) NOT NULL,
    teacher_id VARCHAR(30) NOT NULL,
    admin_id VARCHAR(30) NOT NULL,
    classroom_id INT NOT NULL,
    day_of_week ENUM('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY') NOT NULL,
    period INT NOT NULL,
    lecture_content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id),
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id),
    FOREIGN KEY (classroom_id) REFERENCES classroom(classroom_id)
);

-- 수강 제한
CREATE TABLE `course_restriction` (
    restriction_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id VARCHAR(30) NOT NULL,
    allowed_grade ENUM('1', '2', '3') NOT NULL,
    is_repeat_allowed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE(subject_id, allowed_grade),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id)
);

-- 수강 신청
CREATE TABLE `course_registration` (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(30) NOT NULL,
    lecture_id INT NOT NULL,
    academic_year YEAR NOT NULL,
    semester ENUM('1','2') NOT NULL,
    registration_status ENUM('REGISTERED','CANCELLED') DEFAULT 'REGISTERED',
    approval_status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    approval_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (lecture_id) REFERENCES lecture(lecture_id)
);

-- 수강 이력
CREATE TABLE `course_history` (
    course_history_id VARCHAR(30) PRIMARY KEY,
    student_id VARCHAR(30),
    lecture_id INT,
    academic_year YEAR NOT NULL,
    semester ENUM('1', '2') NOT NULL,
    grade ENUM('1', '2', '3'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- PRIMARY KEY (student_id, lecture_id, academic_year, semester),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (lecture_id) REFERENCES lecture(lecture_id)
);

-- 시간표
CREATE TABLE `schedule` (
   schedule_id VARCHAR(500) PRIMARY KEY,
    student_id VARCHAR(30),
    lecture_id INT,
    -- PRIMARY KEY (student_id, lecture_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (lecture_id) REFERENCES lecture(lecture_id)
);

-- 공지사항
CREATE TABLE `notice` (
    notice_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id VARCHAR(30) NOT NULL,
    title VARCHAR(255) NOT NULL,
    notice_content TEXT NOT NULL,
    target_audience ENUM('ALL', 'STUDENT', 'TEACHER') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);

-- 커뮤니티
CREATE TABLE `community` (
  id VARCHAR(30) PRIMARY KEY,
  category ENUM('SCHOOL', 'COURSE', 'ENTRANCE_EXAMINATION') NOT NULL,
  title VARCHAR(255) NOT NULL,
  community_content TEXT NOT NULL,
  author_id VARCHAR(30) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (author_id) REFERENCES student(student_id)
);
