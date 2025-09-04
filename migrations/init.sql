-- SQL script for creating the database schema for the Project Tracker System

-- Drop tables if they exist to ensure a clean slate
DROP TABLE IF EXISTS project_assignments;
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS consultations;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS users;

-- Create a user role type for easy role management
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
        CREATE TYPE user_role AS ENUM ('student', 'supervisor', 'panel_member', 'admin');
    END IF;
END$$;

-- Users table to store information about all users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(128) NOT NULL, -- Store hashed passwords, not plain text
    email VARCHAR(254) NOT NULL UNIQUE,
    first_name VARCHAR(30),
    last_name VARCHAR(150),
    role user_role NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    date_joined TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Projects table to store project details
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    student_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    supervisor_id INTEGER REFERENCES users(id) ON DELETE SET NULL, -- Can be null initially
    status VARCHAR(50) DEFAULT 'pending', -- e.g., pending, approved, in_progress, completed
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Consultations table for scheduling meetings
CREATE TABLE consultations (
    id SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    student_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    supervisor_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    scheduled_time TIMESTAMP WITH TIME ZONE NOT NULL,
    status VARCHAR(50) DEFAULT 'pending', -- e.g., pending, confirmed, completed, canceled
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Feedback table for supervisors and panel members to leave comments
CREATE TABLE feedback (
    id SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE, -- Supervisor or Panel Member
    feedback_text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Project Assignments table to link panel members to specific projects
CREATE TABLE project_assignments (
    id SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    panel_member_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(project_id, panel_member_id) -- Ensure a panel member is assigned to a project only once
);

-- Insert some sample data for demonstration

-- Sample Users
INSERT INTO users (username, password, email, first_name, last_name, role) VALUES
('student1', 'hashed_password', 'student1@example.com', 'Alice', 'Smith', 'student'),
('supervisor1', 'hashed_password', 'supervisor1@example.com', 'Bob', 'Jones', 'supervisor'),
('panel1', 'hashed_password', 'panel1@example.com', 'Charlie', 'Brown', 'panel_member'),
('admin1', 'hashed_password', 'admin1@example.com', 'David', 'Williams', 'admin');

-- Sample Project
INSERT INTO projects (title, description, student_id, supervisor_id, status) VALUES
('AI-Powered Chatbot', 'A chatbot for customer service using machine learning.', 1, 2, 'in_progress');

-- Sample Consultation
INSERT INTO consultations (project_id, student_id, supervisor_id, scheduled_time, status) VALUES
(1, 1, 2, '2025-10-15 10:00:00+00', 'confirmed');

-- Sample Feedback
INSERT INTO feedback (project_id, user_id, feedback_text) VALUES
(1, 2, 'Good progress on the initial prototype. Focus on the NLU model next.');

-- Sample Panel Assignment
INSERT INTO project_assignments (project_id, panel_member_id) VALUES
(1, 3);


/*
--------------------------------------------------------------------------------
-- How to Run This SQL File from Your Terminal --
--------------------------------------------------------------------------------

First, make sure you have a database system installed (like PostgreSQL or MySQL).

-----------------------------
-- For PostgreSQL (psql): --
-----------------------------

1. **Open your terminal.**

2. **Connect to your PostgreSQL server and create a new database.**
   You might be prompted for your password.

   psql -U your_postgres_username -c "CREATE DATABASE final_year_project_db;"

3. **Run this SQL file to create the tables in the new database.**
   Replace 'your_postgres_username' with your actual PostgreSQL username.

   psql -U your_postgres_username -d final_year_project_db -f database.sql


-------------------------
-- For MySQL (mysql): --
-------------------------

Note: This script is written for PostgreSQL and uses some PostgreSQL-specific syntax
(like SERIAL, ENUM types via DO block, TIMESTAMP WITH TIME ZONE). You would need to
make minor adjustments for it to be fully compatible with MySQL.

Here are the general steps if you were to adapt it:
- Replace SERIAL with INT AUTO_INCREMENT PRIMARY KEY.
- Replace TIMESTAMP WITH TIME ZONE with DATETIME or TIMESTAMP.
- MySQL has ENUM type, but the creation syntax is different.

1. **Open your terminal.**

2. **Log in to your MySQL server.**
   You will be prompted for your password.

   mysql -u your_mysql_username -p

3. **Create a new database from the MySQL prompt.**

   CREATE DATABASE final_year_project_db;
   USE final_year_project_db;

4. **Exit the MySQL prompt.**

   exit

5. **Run this SQL file to populate the database.**
   (Assuming you have an adapted `database_mysql.sql` file)

   mysql -u your_mysql_username -p final_year_project_db < database_mysql.sql

*/