
USE Kaggle
GO

---EN CASO NO EXISTE LA TABLA

IF NOT EXISTS (SELECT * FROM sys.tables WHERE object_id = OBJECT_ID(N'dbo.olympics') AND type='U')

	CREATE TABLE dbo.olympics(

		NOC VARCHAR(10),

		Gold INT,

		Silver INT,

		Bronze INT,

		Total INT

	)



GO



---SI YA EXISTE LA TABLA

TRUNCATE TABLE dbo.olympics;

GO



---IMPORTAR DATA DESDE ARCHIVO

BULK INSERT dbo.olympics

FROM 'C:\Users\ASUS\CERTUS\proyecto_parcial\python\dataset\Athens 2004 Olympics Nations Medals.csv'

WITH
(

	FIRSTROW = 2, --empieza en la 2da fila, ya que la 1era es la cabecera
	FIELDTERMINATOR = ',', --indicamos separador de columnas
	ROWTERMINATOR = '0X0a' --hace referencia a un salto de linea

)
GO
