/* =========================================================
1)  OFFICES
---------------------------------------------------------
• oID          – primary key
• capacity     – just a column
• Each office may be referenced at most once from
– Department.mainOffice   (1 : 1 Operates_from)
– Employee.office         (1 : 1 Hosted_in)
========================================================= */
CREATE TABLE
    Office (oID CHAR(4) PRIMARY KEY, capacity INT NOT NULL);

/* =========================================================
2)  DEPARTMENTS
---------------------------------------------------------
• Every department MUST have exactly one main office
(total participation 1 : 1).
• An office can be mainOffice for **only one** department
(UNIQUE constraint).
========================================================= */
CREATE TABLE
    Department (
        deptID CHAR(4) PRIMARY KEY,
        name VARCHAR(40) NOT NULL,
        location VARCHAR(40),
        mainOffice CHAR(4) NOT NULL UNIQUE,
        CONSTRAINT fk_dept_mainOffice FOREIGN KEY (mainOffice) REFERENCES Office (oID)
    );

/* =========================================================
3)  EMPLOYEES
---------------------------------------------------------
• Each employee MUST belong to one department
(total participation in Works_for → NOT NULL FK).
• Each employee is hosted in exactly one office,
and each office hosts at most one employee
(1 : 1 Hosted_in → UNIQUE on office column).
========================================================= */
CREATE TABLE
    Employee (
        empID CHAR(4) PRIMARY KEY,
        fullName VARCHAR(40) NOT NULL,
        salary INT,
        office CHAR(4) NOT NULL UNIQUE,
        dept CHAR(4) NOT NULL,
        CONSTRAINT fk_emp_office FOREIGN KEY (office) REFERENCES Office (oID),
        CONSTRAINT fk_emp_dept FOREIGN KEY (dept) REFERENCES Department (deptID)
    );

/* =========================================================
4)  TASKS  (multi-valued attribute of Employee)
---------------------------------------------------------
• An employee may hold zero, one, or many tasks.
• Composite PK (empID, task) avoids duplicates.
========================================================= */
CREATE TABLE
    Task (
        empID CHAR(4) NOT NULL,
        task VARCHAR(40) NOT NULL,
        PRIMARY KEY (empID, task),
        CONSTRAINT fk_task_emp FOREIGN KEY (empID) REFERENCES Employee (empID)
    );

/* =========================================================
INSERT SAMPLE DATA
========================================================= */
/* ---- Offices ------------------------------------------------ */
INSERT INTO
    Office (oID, capacity)
VALUES
    ('BL01', 100),
    ('BL02', 150),
    ('BL03', 200),
    ('BL04', 120),
    ('BL05', 180),
    ('BL06', 160),
    ('BL07', 140),
    ('BL08', 130),
    ('BL09', 100),
    ('BL10', 170);

/* ---- Departments (must reference existing offices) ---------- */
INSERT INTO
    Department (deptID, name, location, mainOffice)
VALUES
    ('D001', 'Research', 'St. George', 'BL01'),
    ('D002', 'Finance', 'King St.', 'BL02'),
    ('D003', 'Sales', 'Harbor St.', 'BL03');

/* ---- Employees (office UNIQUE & NOT NULL, dept NOT NULL) ---- */
INSERT INTO
    Employee (empID, fullName, salary, office, dept)
VALUES
    ('E001', 'Amanda Wang', 50000, 'BL04', 'D001'),
    ('E002', 'Nada Almasri', 60000, 'BL05', 'D001'),
    ('E003', 'Arthur Ho', 55000, 'BL06', 'D002'),
    ('E004', 'Ramesh Narayan', 65000, 'BL07', 'D002'),
    ('E005', 'Jane Doe', 70000, 'BL08', 'D003'),
    ('E006', 'Li Wei', 75000, 'BL09', 'D003');

/* ---- Tasks (multi-valued attribute) ------------------------- */
INSERT INTO
    Task (empID, task)
VALUES
    ('E001', 'Data Analysis'),
    ('E002', 'Budget Planning'),
    ('E003', 'Code Testing'),
    ('E004', 'Market Research'),
    ('E005', 'Customer Relations');