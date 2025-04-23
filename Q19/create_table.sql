/* ========= 1. 学校 =========== */
CREATE TABLE
    university (
        university_id INT PRIMARY KEY,
        name VARCHAR(120) NOT NULL,
        address VARCHAR(255),
        phone VARCHAR(30),
        fax VARCHAR(30),
        website VARCHAR(255)
    );

/* ========= 2. 系（院、部门） =========== */
CREATE TABLE
    department (
        department_id INT PRIMARY KEY,
        university_id INT NOT NULL,
        name VARCHAR(120) NOT NULL,
        head_name VARCHAR(120),
        head_email VARCHAR(120),
        FOREIGN KEY (university_id) REFERENCES university (university_id)
    );

/* ========= 3. 项目 / 专业 =========== */
CREATE TABLE
    program (
        program_id INT PRIMARY KEY,
        department_id INT NOT NULL,
        program_name VARCHAR(150) NOT NULL,
        degree VARCHAR(30),
        duration_years DECIMAL(3, 1),
        FOREIGN KEY (department_id) REFERENCES department (department_id)
    );

/* ========= 4. 课程 =========== */
CREATE TABLE
    course (
        course_code VARCHAR(10) PRIMARY KEY,
        course_name VARCHAR(150) NOT NULL,
        credits DECIMAL(3, 1) NOT NULL
    );

/* ========= 5. 教师 =========== */
CREATE TABLE
    instructor (
        instructor_id INT PRIMARY KEY,
        name VARCHAR(120) NOT NULL,
        title VARCHAR(120),
        email VARCHAR(120)
    );

/* ========= 6. 关系表（多对多） =========== */
CREATE TABLE
    program_course (
        program_id INT,
        course_code VARCHAR(10),
        PRIMARY KEY (program_id, course_code),
        FOREIGN KEY (program_id) REFERENCES program (program_id),
        FOREIGN KEY (course_code) REFERENCES course (course_code)
    );

CREATE TABLE
    course_instructor (
        course_code VARCHAR(10),
        instructor_id INT,
        PRIMARY KEY (course_code, instructor_id),
        FOREIGN KEY (course_code) REFERENCES course (course_code),
        FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id)
    );