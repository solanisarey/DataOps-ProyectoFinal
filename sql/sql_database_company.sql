create database CompanyDB;
use CompanyDB;
--Creacion de tablas - DDL
create table Departaments(
	DepartamentID nvarchar(50) primary key,
	DepartamenteName nvarchar(50),
);

create table Projects(
	ProjectID nvarchar(50) primary Key,
	ProjectName nvarchar(50),
	StarDate date,
	EndDate date
);

create table Employees(
	EmployeeID nvarchar(50) primary key,
	FirstName nvarchar(30),
	LastName nvarchar(30),
	DepartamentID nvarchar(50) foreign key references Departaments(DepartamentID),
	Hiredate date,
	Salary decimal(10,2),
);

create table EmployeeProjects(
	EmployeeId nvarchar(50) foreign key references Employees(EmployeeID),
	ProjectId nvarchar(50) foreign key references Projects(ProjectID)
);

---insertar valores - DML

insert into Departaments(DepartamentID,DepartamenteName) values
(1,'IT'),
(2,'HR'),
(3,'Finance');

insert into Projects(ProjectID,ProjectName,StarDate,EndDate) values
(1,'Website Revamp','2022-01-01','2022/06/30'),
(2,'New Hire Training','2021-09-01',GETDATE()),
(3,'Financial Audit','2022-03-01','2022-09-30');

select * from Projects;
select 
	FORMAT(EndDate,'dd-MM-yyyy') as EndDate 
from Projects ;

insert into Employees(EmployeeID,FirstName,LastName,DepartamentID,HireDate,Salary) values
(1,'John','Doe',1,'2020-01-15',60000.00),
(2,'Jane','Smith',2,'2019-03-10',55000.00),
(3,'Bob','Johnson',1,'2021-07-22',70000.00),
(4,'Alice','Davis',3,'2018-11-30',75000.00),
(5,'Michael','Wilson',2,'2020-05-14',50000.00);

insert into EmployeeProjects(EmployeeId,ProjectId) values
(1,1),
(2,2),
(3,1),
(4,3),
(5,2);

-- Modificacion de tablas - DDL

-- Agregar columna
select * from Employees;
alter table Employees ADD Email varchar(100);
select * from Employees;

-- Alterar limites de una columna
exec sp_help Employees;
alter table Employees alter column salary Decimal(12,2);
exec sp_help Employees;

-- Eliminar una columna
select * from Employees;
alter table Employees drop column email;
select * from Employees;

-- Eliminar una tabla con llave foranea
SELECT 
    OBJECT_NAME(f.parent_object_id) AS TableName,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName,
    OBJECT_NAME(f.referenced_object_id) AS ReferencedTableName,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferencedColumnName,
    f.name AS ForeignKeyName
FROM 
    sys.foreign_keys AS f
INNER JOIN 
    sys.foreign_key_columns AS fc 
        ON f.object_id = fc.constraint_object_id
WHERE 
    OBJECT_NAME(f.parent_object_id) = 'EmployeeProjects';
-- Eliminar la restricciones
ALTER TABLE EmployeeProjects DROP CONSTRAINT FK__EmployeeP__Emplo__5AEE82B9;
-- Eliminar la tabla
DROP TABLE Employees;

-- Eliminar datos
select * from EmployeeProjects;
TRUNCATE TABLE EmployeeProjects;
select * from EmployeeProjects;

-- Mi comentario esta 
-- en varias lineas
-- como lo ha pongo en una sola
/*
	Este es un comentario
	de multiples lineas
*/

-- Renombrar tablas/entidades
select * from EmployeeProjects;
EXEC sp_rename 'EmployeeProjects','EmpleadoProyecto';
select * from EmpleadoProyecto;


/*
	Reiniciaremos toda la data
*/
-- Desactivar las restricciones de integridad referencial
ALTER TABLE EmpleadoProyecto NOCHECK CONSTRAINT ALL;

-- Eliminar todas las tablas en el orden correcto para evitar problemas de dependencias
DROP TABLE EmpleadoProyecto;
DROP TABLE Employees;
DROP TABLE Projects;
DROP TABLE Departaments;


-- DATA MANIPULATION LANGUAGE (todo apunta una tabla)
select * from Employees;
update Employees set Salary=45000 where FirstName='Jane';
select * from Employees;

select * from Projects;
delete from Projects where ProjectName='New hire training';

select * from Departaments;
INSERT INTO Departaments (DepartamentID, DepartamenteName) VALUES (4, 'Marketing');
delete from Departaments where DepartamentID=4;
select * from Departaments;

select * from Projects;
select --sin * representa parte de la info
	ProjectID,
	ProjectName,
	FORMAT(StarDate,'dd-MM-yyyy') as StarDate,
	FORMAT(EndDate,'dd-MM-yyyy') as EndDate
from Projects;

--LENGUAJE DE CONTROL DE DATOS
/*
	1. Base de datos -> propiedades
	2. Seguridad
	3. Sql server and windows authetincator
	4. Base de datos -> restart
*/
-- Creates a database user for the login created above.  
CREATE USER AH FOR LOGIN AH;  
GO

-- Creates the login AH with password '123456'.  
CREATE LOGIN AH   
    WITH PASSWORD = '123456';  
GO  

GRANT SELECT ON Employees TO AH;
REVOKE SELECT ON Employees TO AH;

-- Control de transacciones
-- Ejemplo 1: Uso de COMMIT
BEGIN TRANSACTION;
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartamentID, HireDate, Salary)
VALUES (6, 'David', 'Brown', 'IT', '2023-06-01', 68000);
-- Verificar los cambios
SELECT * FROM Employees WHERE EmployeeID = 6;
-- Confirmar la transacción
COMMIT;

-- Verificar los cambios después del COMMIT
SELECT * FROM Employees WHERE EmployeeID = 6;


-- Ejemplo 2: Uso de ROLLBACK
BEGIN TRANSACTION;

UPDATE Employees SET Salary = 70000 WHERE EmployeeID = 1;
-- Verificar los cambios
SELECT * FROM Employees ;
-- Revertir la transacción
ROLLBACK;

-- Verificar los cambios después del ROLLBACK
SELECT * FROM Employees;


-- Desactivar las restricciones de integridad referencial
ALTER TABLE EmployeeProjects NOCHECK CONSTRAINT ALL;

-- Eliminar todas las tablas en el orden correcto para evitar problemas de dependencias
DROP TABLE EmployeeProjects;
DROP TABLE Employees;
DROP TABLE Projects;
DROP TABLE Departaments;