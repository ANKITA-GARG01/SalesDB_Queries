CREATE TABLE Students(
     student_id int,
     student_name varchar(30)
     )
CREATE TABLE Subjects( 
     subject_name varchar(30)
     )
CREATE TABLE Examinations(
    student_id int,
    subject_name varchar(30)
)

INSERT INTO Students(student_id , student_name) 
VALUES (1,'Alice'),
(2,'Bob'),
(13,'John'),
(6,'Alex')

INSERT INTO Subjects(subject_name)
VALUES ('Maths'),
  ('Physics'),
  ('Programming')

  INSERT INTO Examinations(student_id, subject_name)
  VALUES(1,'Maths'),
  (1,'Physics'),
  (1,'Programming'),
  (2,'Programming'),
  (1,'Physics'),
  (1,'Maths'),
  (13,'Maths'),
  (13,'Physics'),
  (13,'Programming'),
  (2,'Maths'),
  (1,'Maths')

  SELECT 
  st.student_id,
  su.subject_name,
  COUNT(ex.student_id)
  FROM Students st
  CROSS JOIN Subjects su
  LEFT JOIN Examinations ex
  ON st.student_id=ex.student_id
     AND su.subject_name = ex.subject_name
GROUP BY 
    st.student_id,
    su.subject_name
ORDER BY 
    st.student_id,
    su.subject_name;