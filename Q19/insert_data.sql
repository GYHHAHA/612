/* ------ university ------ */
INSERT INTO
    university (university_id, name, address, phone, fax, website)
VALUES
    (
        1,
        'Wilfrid Laurier University',
        '75 University Avenue West, Waterloo, Ontario, N2L 3C5',
        '+1 519-884-0710',
        '+1 519-884-8828',
        'https://students.wlu.ca/programs/science/computer-science/index.html'
    );

/* ------ department ------ */
INSERT INTO
    department (
        department_id,
        university_id,
        name,
        head_name,
        head_email
    )
VALUES
    (
        1,
        1,
        'Department of Computer Science',
        'Dr. Christopher Power',
        'cpower@wlu.ca'
    );

/* ------ program ------ */
INSERT INTO
    program (
        program_id,
        department_id,
        program_name,
        degree,
        duration_years
    )
VALUES
    (
        1,
        1,
        'Bachelor of Science in Computer Science',
        'BSc',
        4.0
    ),
    (2, 1, 'Master of Applied Computing', 'MAC', 2.0);

/* ------ course ------ */
INSERT INTO
    course (course_code, course_name, credits)
VALUES
    ('CP104', 'Introduction to Programming', 0.5),
    ('CP164', 'Data Structure II', 0.5),
    (
        'CP213',
        'Introduction to Object-Oriented Programming',
        0.5
    ),
    ('CP600', 'Practical Algorithm Design', 0.5),
    ('CP612', 'Data Management & Analysis', 0.5),
    ('CP640', 'Data Analytics', 0.5);

/* ------ instructor ------ */
INSERT INTO
    instructor (instructor_id, name, title, email)
VALUES
    (
        1,
        'Dr. Kaiyu Li',
        'Assistant Professor',
        'kli@wlu.ca'
    ),
    (
        2,
        'Prof. David Brown',
        'Assistant Professor (Teaching Stream)',
        'davidb@wlu.ca'
    ),
    (
        3,
        'Dr. Sarah Ahmed',
        'Associate Professor',
        'sahmed@wlu.ca'
    ),
    (4, 'Dr. Yifan Li', 'Lecturer', 'yifli@wlu.ca');

/* ------ program_course (多对多) ------ */
/* — BSc — */
INSERT INTO
    program_course (program_id, course_code)
VALUES
    (1, 'CP104'),
    (1, 'CP164'),
    (1, 'CP213');

/* — MAC — */
INSERT INTO
    program_course (program_id, course_code)
VALUES
    (2, 'CP600'),
    (2, 'CP640'),
    (2, 'CP612');

/* ------ course_instructor (多对多) ------ */
INSERT INTO
    course_instructor (course_code, instructor_id)
VALUES
    ('CP104', 1), -- Dr. Kaiyu Li
    ('CP164', 2), -- Prof. David Brown
    ('CP213', 3), -- Dr. Sarah Ahmed
    ('CP600', 1), -- Dr. Kaiyu Li
    ('CP612', 1), -- Dr. Kaiyu Li
    ('CP640', 4);

-- Dr. Yifan Li