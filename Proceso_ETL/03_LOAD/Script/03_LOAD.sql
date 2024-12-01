--------------------
----- CARGA --------
--------------------





-- Creacion de las tablas segun el modelo 


CREATE TABLE Game_Dimension (
    Game_ID INT PRIMARY KEY,
    Game_Name VARCHAR(100),
    Genre VARCHAR(50));


CREATE TABLE Data_Update_Dimension (
    Update_Date_ID INT PRIMARY KEY,
    Update_Year DATE);

CREATE TABLE Publisher_Dimension (
    Publisher_ID INT PRIMARY KEY,
    Publisher_Name VARCHAR(100));

CREATE TABLE Date_Dimension (
    Release_Date_ID INT PRIMARY KEY,
    Release_Year INT);

CREATE TABLE Platform_Dimension (
    Platform_ID INT PRIMARY KEY, 
    Platform_Name VARCHAR(50));

CREATE TABLE Region_Sales_Dimension (
    Region_ID INT PRIMARY KEY,
    Region_Name VARCHAR(50),
    Sales_Amount DECIMAL(18,2));

--  fact table
PRAGMA foreign_keys = ON;

CREATE TABLE Fact_Table (
    Sales_ID INTEGER PRIMARY KEY,
    Game_ID INTEGER,
    Platform_ID INTEGER,
    Release_Date_ID INTEGER,
    Update_Date_ID INTEGER,
    Publisher_ID INTEGER,
    Region_ID INTEGER,
    Units_Sold INTEGER,
    Global_Sales DECIMAL(18,2),
    FOREIGN KEY (Game_ID) REFERENCES Game_Dimension(Game_ID),
    FOREIGN KEY (Platform_ID) REFERENCES Platform_Dimension(Platform_ID),
    FOREIGN KEY (Release_Date_ID) REFERENCES Date_Dimension(Release_Date_ID),
    FOREIGN KEY (Update_Date_ID) REFERENCES Data_Update_Dimension(Update_Date_ID),
    FOREIGN KEY (Publisher_ID) REFERENCES Publisher_Dimension(Publisher_ID),
    FOREIGN KEY (Region_ID) REFERENCES Region_Sales_Dimension(Region_ID));





-- tabla de GAME 

-- con los datos de las 3 tablas
-- en orden alfabetico los nombres de juegos 
   
   
CREATE TEMP TABLE Temp_Game_Data AS
SELECT DISTINCT
    "Game" AS Game_Name,
    CASE 
        WHEN "Genre" IS NULL OR "Genre" = '' THEN 'Unknown' 
        ELSE "Genre"
    END AS Genre
FROM PS4_GamesSales
WHERE "Game" IS NOT NULL AND "Game" != '' 
UNION
SELECT DISTINCT
    "Game" AS Game_Name,
    CASE 
        WHEN "Genre" IS NULL OR "Genre" = '' THEN 'Unknown'
        ELSE "Genre"
    END AS Genre
FROM XboxOne_GameSales
WHERE "Game" IS NOT NULL AND "Game" != '' 
UNION
SELECT DISTINCT
    "Name" AS Game_Name,
    CASE 
        WHEN "Genre" IS NULL OR "Genre" = '' THEN 'Unknown'
        ELSE "Genre"
    END AS Genre
FROM Video_Games_Sales_as_at_22_Dec_2016
WHERE "Name" IS NOT NULL AND "Name" != ''; 


INSERT INTO Game_Dimension (Game_ID, Game_Name, Genre)
SELECT
    ROW_NUMBER() OVER (ORDER BY Game_Name) AS Game_ID, 
    Game_Name,
    Genre
FROM Temp_Game_Data
ORDER BY Game_Name; 


SELECT * FROM Temp_Game_Data

-- insertar con ID unico

INSERT INTO Game_Dimension (Game_ID, Game_Name, Genre)
SELECT
    ROWID AS Game_ID, 
    Game_Name,
    Genre
FROM Temp_Game_Data;

-- tabla temporal

DROP TABLE Temp_Game_Data;



-- plataforma dimension


CREATE TEMP TABLE Temp_Platform_Data AS
SELECT DISTINCT
    "Platform" AS Platform_Name
FROM Video_Games_Sales_as_at_22_Dec_2016
WHERE "Platform" IS NOT NULL AND "Platform" != '' -- Exclure les valeurs NULL ou vides
UNION
SELECT DISTINCT
    'PS4' AS Platform_Name
FROM PS4_GamesSales
UNION
SELECT DISTINCT
    'Xbox One' AS Platform_Name
FROM XboxOne_GameSales;



SELECT * FROM Temp_Platform_Data



INSERT INTO Platform_Dimension (Platform_ID, Platform_Name)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Platform_Name) AS Platform_ID, -- Générer les IDs séquentiels
    Platform_Name
FROM Temp_Platform_Data
ORDER BY Platform_Name;


DROP TABLE Temp_Platform_Data;

-- publisher




CREATE TEMP TABLE Temp_Publisher_Data AS
SELECT DISTINCT
    "Publisher" AS Publisher_Name
FROM PS4_GamesSales
WHERE "Publisher" IS NOT NULL AND "Publisher" != '' 
UNION
SELECT DISTINCT
    "Publisher" AS Publisher_Name
FROM XboxOne_GameSales
WHERE "Publisher" IS NOT NULL AND "Publisher" != '' 
SELECT DISTINCT
    "Publisher" AS Publisher_Name
FROM Video_Games_Sales_as_at_22_Dec_2016
WHERE "Publisher" IS NOT NULL AND "Publisher" != ''; 




SELECT * FROM Temp_Publisher_Data


INSERT INTO Publisher_Dimension (Publisher_ID, Publisher_Name)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Publisher_Name) AS Publisher_ID, 
    Publisher_Name
FROM Temp_Publisher_Data
ORDER BY Publisher_Name;

DROP TABLE Temp_Publisher_Data;



-- dimension date release


CREATE TEMP TABLE Temp_Year_Data AS
SELECT DISTINCT
    "Year Release" AS Release_Year
FROM PS4_GamesSales
WHERE "Year Release" IS NOT NULL
UNION
SELECT DISTINCT
    "Year Release" AS Release_Year
FROM XboxOne_GameSales
WHERE "Year Release" IS NOT NULL
UNION
SELECT DISTINCT
    "Year" AS Release_Year
FROM Video_Games_Sales_as_at_22_Dec_2016
WHERE "Year" IS NOT NULL;


SELECT * FROM Temp_Year_Data


INSERT INTO Date_Dimension (Release_Date_ID, Release_Year)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Release_Year) AS Release_Date_ID, -- Générer des IDs uniques
    Release_Year
FROM Temp_Year_Data
ORDER BY Release_Year;

DROP TABLE Temp_Year_Data;





-- region sales dimension 



INSERT INTO Region_Sales_Dimension (Region_ID, Region_Name, Sales_Amount)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Region_Name) AS Region_ID, 
    Region_Name,
    SUM(Sales_Amount) AS Sales_Amount
FROM (
    -- PS4_GamesSales
    SELECT 'North America' AS Region_Name, SUM(COALESCE("North America", 0)) AS Sales_Amount
    FROM PS4_GamesSales
    UNION ALL
    SELECT 'Europe' AS Region_Name, SUM(COALESCE("Europe", 0)) AS Sales_Amount
    FROM PS4_GamesSales
    UNION ALL
    SELECT 'Japan' AS Region_Name, SUM(COALESCE("Japan", 0)) AS Sales_Amount
    FROM PS4_GamesSales
    UNION ALL
    SELECT 'Rest of World' AS Region_Name, SUM(COALESCE("Rest of World", 0)) AS Sales_Amount
    FROM PS4_GamesSales
    --  de XboxOne_GameSales
    UNION ALL
    SELECT 'North America' AS Region_Name, SUM(COALESCE("North America", 0)) AS Sales_Amount
    FROM XboxOne_GameSales
    UNION ALL
    SELECT 'Europe' AS Region_Name, SUM(COALESCE("Europe", 0)) AS Sales_Amount
    FROM XboxOne_GameSales
    UNION ALL
    SELECT 'Japan' AS Region_Name, SUM(COALESCE("Japan", 0)) AS Sales_Amount
    FROM XboxOne_GameSales
    UNION ALL
    SELECT 'Rest of World' AS Region_Name, SUM(COALESCE("Rest of World", 0)) AS Sales_Amount
    FROM XboxOne_GameSales
    --  de Video_Games_Sales_as_at_22_Dec_2016
    UNION ALL
    SELECT 'North America' AS Region_Name, SUM(COALESCE("NA_Sales", 0)) AS Sales_Amount
    FROM Video_Games_Sales_as_at_22_Dec_2016
    UNION ALL
    SELECT 'Europe' AS Region_Name, SUM(COALESCE("EU_Sales", 0)) AS Sales_Amount
    FROM Video_Games_Sales_as_at_22_Dec_2016
    UNION ALL
    SELECT 'Japan' AS Region_Name, SUM(COALESCE("JP_Sales", 0)) AS Sales_Amount
    FROM Video_Games_Sales_as_at_22_Dec_2016
    UNION ALL
    SELECT 'Rest of World' AS Region_Name, SUM(COALESCE("Other_Sales", 0)) AS Sales_Amount
    FROM Video_Games_Sales_as_at_22_Dec_2016
) Regions
GROUP BY Region_Name
ORDER BY Region_Name;



-- data update 


INSERT INTO Data_Update_Dimension (Update_Date_ID, Update_Year)
VALUES
    (1, 2020), -- Données PS4 actualisées en 2020
    (2, 2020), -- Données Xbox actualisées en 2020
    (3, 2016); -- Données Video Games Sales au 22 décembre 2016
    
    
    
    -- anadir fuente de los datos para que se pueda usar 
    
    
ALTER TABLE Data_Update_Dimension ADD COLUMN Source VARCHAR(100);

ALTER TABLE Data_Update_Dimension 
ADD FOREIGN KEY (Source_ID) REFERENCES Source_Dimension(Source_ID);


UPDATE Data_Update_Dimension
SET Source = 'PS4_GamesSales'
WHERE Update_Date_ID = 1;

UPDATE Data_Update_Dimension
SET Source = 'XboxOne_GameSales'
WHERE Update_Date_ID = 2;

UPDATE Data_Update_Dimension
SET Source = 'Video_Games_Sales_as_at_22_Dec_2016'
WHERE Update_Date_ID = 3;



SELECT * FROM Data_Update_Dimension 



-- fact table 


INSERT INTO Fact_Table (
    Game_ID, Platform_ID, Release_Date_ID, Update_Date_ID, Publisher_ID, Region_ID, Units_Sold, Global_Sales
)
SELECT
    G.Game_ID,
    P.Platform_ID,
    D.Release_Date_ID,
    DU.Update_Date_ID,
    Pub.Publisher_ID,
    R.Region_ID,
    S.Sales_Amount AS Units_Sold,
    S.Global_Sales  
FROM (
    SELECT
        S."Game",
        S."Year Release" AS Release_Year,
        S."Publisher",
        'North America' AS Region_Name,
        COALESCE(S."North America", 0) AS Sales_Amount,
        --  Global_Sales para  cada game
        COALESCE(S."North America", 0) + COALESCE(S."Europe", 0) + COALESCE(S."Japan", 0) + COALESCE(S."Rest of World", 0) AS Global_Sales
    FROM PS4_GamesSales AS S
    UNION ALL
    SELECT
        S."Game",
        S."Year Release",
        S."Publisher",
        'Europe' AS Region_Name,
        COALESCE(S."Europe", 0) AS Sales_Amount,
        COALESCE(S."North America", 0) + COALESCE(S."Europe", 0) + COALESCE(S."Japan", 0) + COALESCE(S."Rest of World", 0) AS Global_Sales
    FROM PS4_GamesSales AS S
    UNION ALL
    SELECT
        S."Game",
        S."Year Release",
        S."Publisher",
        'Japan' AS Region_Name,
        COALESCE(S."Japan", 0) AS Sales_Amount,
        COALESCE(S."North America", 0) + COALESCE(S."Europe", 0) + COALESCE(S."Japan", 0) + COALESCE(S."Rest of World", 0) AS Global_Sales
    FROM PS4_GamesSales AS S
    UNION ALL
    SELECT
        S."Game",
        S."Year Release",
        S."Publisher",
        'Rest of World' AS Region_Name,
        COALESCE(S."Rest of World", 0) AS Sales_Amount,
        COALESCE(S."North America", 0) + COALESCE(S."Europe", 0) + COALESCE(S."Japan", 0) + COALESCE(S."Rest of World", 0) AS Global_Sales
    FROM PS4_GamesSales AS S
) AS S
JOIN Game_Dimension AS G ON G.Game_Name = S."Game"
JOIN Platform_Dimension AS P ON P.Platform_Name = 'PS4'
JOIN Date_Dimension AS D ON D.Release_Year = S.Release_Year
JOIN Data_Update_Dimension AS DU ON DU.Update_Date_ID = 1
JOIN Publisher_Dimension AS Pub ON Pub.Publisher_Name = S."Publisher"
JOIN Region_Sales_Dimension AS R ON R.Region_Name = S.Region_Name;



-- de XboxOne_GameSales con Global_Sales
INSERT INTO Fact_Table (
    Game_ID, Platform_ID, Release_Date_ID, Update_Date_ID, Publisher_ID, Region_ID, Units_Sold, Global_Sales
)
SELECT
    G.Game_ID,
    P.Platform_ID,
    D.Release_Date_ID,
    DU.Update_Date_ID,
    Pub.Publisher_ID,
    R.Region_ID,
    S.Sales_Amount AS Units_Sold,
    S.Global_Sales
FROM (
    SELECT
        S."Game",
        S."Year Release" AS Release_Year,
        S."Publisher",
        'North America' AS Region_Name,
        COALESCE(S."North America", 0) AS Sales_Amount,
        COALESCE(S."North America", 0) + COALESCE(S."Europe", 0) + COALESCE(S."Japan", 0) + COALESCE(S."Rest of World", 0) AS Global_Sales
    FROM XboxOne_GameSales AS S
    UNION ALL
    SELECT
        S."Game",
        S."Year Release",
        S."Publisher",
        'Europe' AS Region_Name,
        COALESCE(S."Europe", 0) AS Sales_Amount,
        COALESCE(S."North America", 0) + COALESCE(S."Europe", 0) + COALESCE(S."Japan", 0) + COALESCE(S."Rest of World", 0) AS Global_Sales
    FROM XboxOne_GameSales AS S
    UNION ALL
    SELECT
        S."Game",
        S."Year Release",
        S."Publisher",
        'Japan' AS Region_Name,
        COALESCE(S."Japan", 0) AS Sales_Amount,
        COALESCE(S."North America", 0) + COALESCE(S."Europe", 0) + COALESCE(S."Japan", 0) + COALESCE(S."Rest of World", 0) AS Global_Sales
    FROM XboxOne_GameSales AS S
    UNION ALL
    SELECT
        S."Game",
        S."Year Release",
        S."Publisher",
        'Rest of World' AS Region_Name,
        COALESCE(S."Rest of World", 0) AS Sales_Amount,
        COALESCE(S."North America", 0) + COALESCE(S."Europe", 0) + COALESCE(S."Japan", 0) + COALESCE(S."Rest of World", 0) AS Global_Sales
    FROM XboxOne_GameSales AS S
) AS S
JOIN Game_Dimension AS G ON G.Game_Name = S."Game"
JOIN Platform_Dimension AS P ON P.Platform_Name = 'Xbox One'
JOIN Date_Dimension AS D ON D.Release_Year = S.Release_Year
JOIN Data_Update_Dimension AS DU ON DU.Update_Date_ID = 2
JOIN Publisher_Dimension AS Pub ON Pub.Publisher_Name = S."Publisher"
JOIN Region_Sales_Dimension AS R ON R.Region_Name = S.Region_Name;


-- de Video_Games_Sales_as_at_22_Dec_2016 con Global_Sales
INSERT INTO Fact_Table (
    Game_ID, Platform_ID, Release_Date_ID, Update_Date_ID, Publisher_ID, Region_ID, Units_Sold, Global_Sales
)
SELECT
    G.Game_ID,
    P.Platform_ID,
    D.Release_Date_ID,
    DU.Update_Date_ID,
    Pub.Publisher_ID,
    R.Region_ID,
    S.Sales_Amount AS Units_Sold,
    S."Global_Sales"
FROM (
    SELECT
        S."Name" AS Game_Name,
        S."Platform",
        S."Year" AS Release_Year,
        S."Publisher",
        'North America' AS Region_Name,
        COALESCE(S."NA_Sales", 0) AS Sales_Amount,
        S."Global_Sales"
    FROM Video_Games_Sales_as_at_22_Dec_2016 AS S
    UNION ALL
    SELECT
        S."Name",
        S."Platform",
        S."Year",
        S."Publisher",
        'Europe' AS Region_Name,
        COALESCE(S."EU_Sales", 0) AS Sales_Amount,
        S."Global_Sales"
    FROM Video_Games_Sales_as_at_22_Dec_2016 AS S
    UNION ALL
    SELECT
        S."Name",
        S."Platform",
        S."Year",
        S."Publisher",
        'Japan' AS Region_Name,
        COALESCE(S."JP_Sales", 0) AS Sales_Amount,
        S."Global_Sales"
    FROM Video_Games_Sales_as_at_22_Dec_2016 AS S
    UNION ALL
    SELECT
        S."Name",
        S."Platform",
        S."Year",
        S."Publisher",
        'Rest of World' AS Region_Name,
        COALESCE(S."Other_Sales", 0) AS Sales_Amount,
        S."Global_Sales"
    FROM Video_Games_Sales_as_at_22_Dec_2016 AS S
) AS S
JOIN Game_Dimension AS G ON G.Game_Name = S.Game_Name
JOIN Platform_Dimension AS P ON P.Platform_Name = S."Platform"
JOIN Date_Dimension AS D ON D.Release_Year = S.Release_Year
JOIN Data_Update_Dimension AS DU ON DU.Update_Date_ID = 3
JOIN Publisher_Dimension AS Pub ON Pub.Publisher_Name = S."Publisher"
JOIN Region_Sales_Dimension AS R ON R.Region_Name = S.Region_Name;





----------
-- IMPORTANTE EJEMPLO


-- esta consulta nos permitira ordenar los datos de ventas segun su fuente en funcion de
-- lo que representa la fuente y su fecha de Update 

SELECT
    R.Region_Name,
    DU.Source,
    SUM(FT.Units_Sold) AS Total_Units_Sold,
    SUM(FT.Global_Sales) AS Total_Global_Sales
FROM
    Fact_Table FT
JOIN
    Region_Sales_Dimension R ON FT.Region_ID = R.Region_ID
JOIN
    Data_Update_Dimension DU ON FT.Update_Date_ID = DU.Update_Date_ID
GROUP BY
    R.Region_Name,
    DU.Source
ORDER BY
    R.Region_Name, DU.Source;
   
   




