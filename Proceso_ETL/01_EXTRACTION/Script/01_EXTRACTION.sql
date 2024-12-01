
-- CREACION DE LAS 3 TABLAS, CON LOS PARAMETROS DE ENTRADA DE TIPO ESPECIFICOS A CADA CSV:

CREATE TABLE PS4_GamesSales (
    "Game" VARCHAR(255),
    "Year" DECIMAL(4,0),
    "Genre" VARCHAR(100),
    "Publisher" VARCHAR(255),
    "North America" DECIMAL(10,2),
    "Europe" DECIMAL(10,2),
    "Japan" DECIMAL(10,2),
    "Rest of World" DECIMAL(10,2),
    "Global" DECIMAL(10,2)
);



CREATE TABLE Video_Games_Sales_as_at_22_Dec_2016 (
    Name VARCHAR(200),
    Platform VARCHAR(200),
    Year_of_Release DECIMAL(10,2),
    Genre VARCHAR(200),
    Publisher VARCHAR(200),
    NA_Sales DECIMAL(10,2),
    EU_Sales DECIMAL(10,2),
    JP_Sales DECIMAL(10,2),
    Other_Sales DECIMAL(10,2),
    Global_Sales DECIMAL(10,2),
    Critic_Score DECIMAL(10,2),
    Critic_Count DECIMAL(10,2),
    User_Score DECIMAL(10,2),
    User_Count DECIMAL(10,2),
    Developer VARCHAR(200),
    Rating VARCHAR(200)
);




CREATE TABLE "XboxOne_GameSales" (
    "Pos" INTEGER,
    "Game" VARCHAR(200),
    "Year" DECIMAL(10,2),
    "Genre" VARCHAR(200),
    "Publisher" VARCHAR(200),
    "North America" DECIMAL(10,2),
    "Europe" DECIMAL(10,2),
    "Japan" DECIMAL(10,2),
    "Rest of World" DECIMAL(10,2),
    "Global" DECIMAL(10,2)
);



-- USO DE LA CONSULTA IMPORT DATA 
-- ADAPTACION AL ENCODING 'latin1'
-- VERIFICANDO LOS PARAMETROS DE ESTRUCTURA 


-- VERIFICACION DEL CONTENIDO DE LAS TABLAS 

SELECT * FROM PS4_GamesSales
SELECT * FROM Video_Games_Sales_as_at_22_Dec_2016  
SELECT * FROM XboxOne_GameSales 



