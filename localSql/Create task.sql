-- Database: Tasks

-- Creación de tabla.
CREATE TABLE TASK (
	id 				INT GENERATED ALWAYS AS IDENTITY,
	title 			VARCHAR(70),
	description 	VARCHAR(500),
	completed 		BOOLEAN DEFAULT FALSE,
	deadline 		TIMESTAMP,
	CONSTRAINT TASK_PRIMARY_KEY PRIMARY KEY(id)
)
-- DROP TABLE task

-- Insertando valores en la tabla.
INSERT INTO TASK (title, description, deadline)
	VALUES('Test POSTGRES', 'This is just a test of Postgres', '2020-05-12')

-- Query basica de prueba.
SELECT *
  FROM TASK
