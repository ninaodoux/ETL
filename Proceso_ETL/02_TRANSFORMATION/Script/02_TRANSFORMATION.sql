-----------------------------
-- DATA QUALITY CHECK PS4  -------
------------------------------


-- creacion de una tabla que agrupara las metricas :

CREATE TABLE Data_Quality_PS4 (
    Metric TEXT,          
    Description TEXT,     
    Value DECIMAL(10, 2),         
    Observations TEXT);



-- update de los valores missing como NULL
   
UPDATE PS4_GamesSales
SET "Game" = NULL
WHERE "Game" = '' OR "Game" = ' ';

UPDATE PS4_GamesSales
SET "Year" = NULL
WHERE "Year" = '' OR "Year" = ' ';

UPDATE PS4_GamesSales
SET "Genre" = NULL
WHERE "Genre" = '' OR "Genre" = ' ';

UPDATE PS4_GamesSales
SET "Publisher" = NULL
WHERE "Publisher" = '' OR "Publisher" = ' ';

UPDATE PS4_GamesSales
SET "North America" = NULL
WHERE "North America" = '' OR "North America" = ' ';

UPDATE PS4_GamesSales
SET "Europe" = NULL
WHERE "Europe" = '' OR "Europe" = ' ';

UPDATE PS4_GamesSales
SET "Japan" = NULL
WHERE "Japan" = '' OR "Japan" = ' ';

UPDATE PS4_GamesSales
SET "Rest of World" = NULL
WHERE "Rest of World" = '' OR "Rest of World" = ' ';

UPDATE PS4_GamesSales
SET "Global" = NULL
WHERE "Global" = '' OR "Global" = ' ';



-- inspeccion para la columna 'year'

SELECT "Year", COUNT(*) AS Occurrences
FROM PS4_GamesSales
GROUP BY "Year"
ORDER BY Occurrences DESC;


-- UPDATE DE N/A COMO NULL

UPDATE PS4_GamesSales
SET "Year" = NULL
WHERE "Year" = 'N/A';




                      -- COMPLETITUD--
SELECT 
    'Game' AS Column_Name,
    (100.0 - (SUM(CASE WHEN "Game" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
FROM PS4_GamesSales
UNION ALL
SELECT 
    'Year' AS Column_Name,
    (100.0 - (SUM(CASE WHEN "Year" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
FROM PS4_GamesSales
UNION ALL
SELECT 
    'Genre' AS Column_Name,
    (100.0 - (SUM(CASE WHEN "Genre" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
FROM PS4_GamesSales
UNION ALL
SELECT 
    'Publisher' AS Column_Name,
    (100.0 - (SUM(CASE WHEN "Publisher" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
FROM PS4_GamesSales
UNION ALL
SELECT 
    'North America' AS Column_Name,
    (100.0 - (SUM(CASE WHEN "North America" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
FROM PS4_GamesSales
UNION ALL
SELECT 
    'Europe' AS Column_Name,
    (100.0 - (SUM(CASE WHEN "Europe" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
FROM PS4_GamesSales
UNION ALL
SELECT 
    'Japan' AS Column_Name,
    (100.0 - (SUM(CASE WHEN "Japan" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
FROM PS4_GamesSales
UNION ALL
SELECT 
    'Rest of World' AS Column_Name,
    (100.0 - (SUM(CASE WHEN "Rest of World" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
FROM PS4_GamesSales
UNION ALL
SELECT 
    'Global' AS Column_Name,
    (100.0 - (SUM(CASE WHEN "Global" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
FROM PS4_GamesSales;


INSERT INTO Data_Quality_PS4 (Metric, Description, Value)
VALUES 
    ('Completitud','Media del porcentaje de datos no nulos para todas las columnas.',
        (
            SELECT AVG(Completeness_Percentage)
            FROM (
                SELECT 
                    (100.0 - (SUM(CASE WHEN "Game" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
                FROM PS4_GamesSales
                UNION ALL
                SELECT 
                    (100.0 - (SUM(CASE WHEN "Year" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
                FROM PS4_GamesSales
                UNION ALL
                SELECT 
                    (100.0 - (SUM(CASE WHEN "Genre" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
                FROM PS4_GamesSales
                UNION ALL
                SELECT 
                    (100.0 - (SUM(CASE WHEN "Publisher" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
                FROM PS4_GamesSales
                UNION ALL
                SELECT 
                    (100.0 - (SUM(CASE WHEN "North America" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
                FROM PS4_GamesSales
                UNION ALL
                SELECT 
                    (100.0 - (SUM(CASE WHEN "Europe" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
                FROM PS4_GamesSales
                UNION ALL
                SELECT 
                    (100.0 - (SUM(CASE WHEN "Japan" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
                FROM PS4_GamesSales
                UNION ALL
                SELECT 
                    (100.0 - (SUM(CASE WHEN "Rest of World" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
                FROM PS4_GamesSales
                UNION ALL
                SELECT 
                    (100.0 - (SUM(CASE WHEN "Global" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
                FROM PS4_GamesSales)));


   
   
                                   -- ACCURACY--  
   
WITH AccuracyCalculations AS (
    SELECT 
        (SUM(CASE WHEN "Year" BETWEEN 1950 AND strftime('%Y', 'now') THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Accuracy_Percentage
    FROM PS4_GamesSales
    UNION ALL
    SELECT 
        (SUM(CASE WHEN "Global" = ("North America" + "Europe" + "Japan" + "Rest of World") THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Accuracy_Percentage
    FROM PS4_GamesSales)

INSERT INTO Data_Quality_PS4 (Metric, Description, Value, Observations)
VALUES ('Accuracy','Media del porcentaje de valores correctos para las métricas de Year y Global Sales(las unicas que podemo sverificar).',
    (SELECT AVG(Accuracy_Percentage) FROM AccuracyCalculations),'Incluye la precisión de Year y Global Sales.');



                               -- LINAJE -- 

-- Para esta metrica ponemos un 100% ( se explicara en el reporte las razones )

INSERT INTO Data_Quality_PS4 (Metric, Description, Value, Observations)
VALUES 
    ('Linaje','Porcentaje de rastreabilidad fiable en la tabla.',
        100,'El linaje es completo gracias a la columna Game, que permite rastrear valores faltantes con fuentes externas.');

   
                            -- SEMANTICA --
       
       
INSERT INTO Data_Quality_PS4 (Metric, Description, Value, Observations)
VALUES 
    (
        'Semantica ',
        'Porcentaje de filas con datos validos semánticamente (ventas no negativas, Publisher válido y Year dentro del rango logico).',
        (
            WITH SemanticChecks AS (
                SELECT 
                    COUNT(*) AS Total_Rows,
                    SUM(
                        CASE 
                            WHEN "North America" >= 0 
                              AND "Europe" >= 0 
                              AND "Japan" >= 0 
                              AND "Rest of World" >= 0 
                              AND "Publisher" IS NOT NULL 
                              AND LENGTH("Publisher") > 0 
                              AND "Year" BETWEEN 1950 AND strftime('%Y', 'now') THEN 1 
                            ELSE 0 
                        END
                    ) AS Total_Valid_Rows
                FROM PS4_GamesSales
            )
            SELECT 
                (Total_Valid_Rows * 100.0 / Total_Rows) 
            FROM SemanticChecks
        ),
        'Incluye verificaciones para ventas no negativas, Publisher válido y Year dentro del rango lógico (de 1950: decade de creacion del primer videojuego, hasta ahora).');

   
   
   
                                -- ESTRUCTURA --
   
   
WITH Metrics AS (
    SELECT 
        COUNT(*) AS Total_Rows,

        --  que  'Year': Tipo DATE y rango valido
        SUM(
            CASE 
                WHEN typeof("Year") = 'date' AND "Year" BETWEEN '1950-01-01' AND date('now') THEN 1 
                ELSE 0 
            END
        ) * 100.0 / COUNT(*) AS Year_Validity_Percentage,
        
        -- que  'Publisher': mayuscula o numero inicial
        SUM(
            CASE 
                WHEN "Publisher" GLOB '[A-Z]*' OR "Publisher" GLOB '[0-9]*' THEN 1 
                ELSE 0 
            END
        ) * 100.0 / COUNT(*) AS Publisher_Validity_Percentage,

        -- que de 'Genre': Comienza con una letra mayuscula
        SUM(
            CASE 
                WHEN "Genre" GLOB '[A-Z]*' THEN 1 
                ELSE 0 
            END
        ) * 100.0 / COUNT(*) AS Genre_Validity_Percentage
    FROM PS4_GamesSales
),
AverageMetric AS (
    SELECT 
        (Year_Validity_Percentage + Publisher_Validity_Percentage + Genre_Validity_Percentage) / 3 AS Structural_Validity_Average
    FROM Metrics
)


INSERT INTO Data_Quality_PS4 (Metric, Description, Value, Observations)
SELECT 
    'Estructura',
    'Promedio de validez estructural basado en columnas Year, Publisher y Genre.',
    Structural_Validity_Average,
    'Incluye validación de Year con un tipo DATE, Publisher con mayúscula o número inicial, y Genre comenzando con una mayúscula, los numerico ya estan todos en decimales (.2) con las normativas de la tabla.'
FROM AverageMetric;


                             -- CONSISTENCIA --

WITH SalesConsistency AS (
    SELECT 
        SUM(
            CASE 
                WHEN "Global" = ("North America" + "Europe" + "Japan" + "Rest of World") THEN 1 
                ELSE 0 
            END
        ) * 100.0 / COUNT(*) AS Regional_Sales_Consistency_Percentage
    FROM PS4_GamesSales
)



INSERT INTO Data_Quality_PS4 (Metric, Description, Value, Observations)
SELECT 
    'Consistencia',
    'Porcentaje de filas donde la suma de ventas regionales coincide con las ventas globales.',
    Regional_Sales_Consistency_Percentage,
    'Verifica que las ventas en North America, Europe, Japan y Rest of World sumen correctamente a Global para que sea un total justo.'
FROM SalesConsistency;


                                  -- MONEDA --

-- dado que no tenemos datos adecuados para medir esta metrica ponemos un NULL

INSERT INTO Data_Quality_PS4 (Metric, Description, Value, Observations)
VALUES 
    (
        'Moneda',
        'Esta métrica no aplica aqui porque los valores no representan datos monetarios ni cuya medida puede cambiar a lo largo del tiempo ',
        NULL,
        'No es relevante calcular esta métrica para los datos actuales.'
    );


   
                                  -- PUNTUALIDAD --
   
   -- no hay No hay una expectativa específica de "actualización o entrega" en este dataset
   -- las fechas indican el ano de lanzamiento 
   
SELECT DISTINCT "Year" 
FROM PS4_GamesSales
ORDER BY "Year";

-- rellenamos con NULL


INSERT INTO Data_Quality_PS4 (Metric, Description, Value, Observations)
VALUES 
    ('Puntualidad','Esta métrica no aplica aqui el dataset no trata de actualizaciones obligatorias o rangos temporales precisos de ventas',
        NULL,
        'No es relevante calcular esta métrica para los datos actuales.');

   
                               -- IDENTIFICABILIDAD --
   -- consideremos duplicados si el nombre del juego es igual que otro, pero con fechas de lanzamiento iguales
   -- si tienen fechas de lanzamiento distintas, no son duplicados 
   -- ya que pueden ser updates de videojuegos, o nueva version etc...
   
   
SELECT "Game", "Year", COUNT(*) AS Duplicate_Count
FROM PS4_GamesSales
GROUP BY "Game", "Year"
HAVING COUNT(*) > 1;


WITH TotalRows AS (
    SELECT COUNT(*) AS Total
    FROM PS4_GamesSales
),
UniqueRows AS (
    SELECT COUNT(*) AS Unique_Count
    FROM (
        SELECT "Game", "Year"
        FROM PS4_GamesSales
        GROUP BY "Game", "Year"
    )
),
IdentifiabilityMetric AS (
    SELECT 
        (Unique_Count * 100.0 / Total) AS Identifiability_Percentage
    FROM TotalRows, UniqueRows
)


INSERT INTO Data_Quality_PS4 (Metric, Description, Value, Observations)
SELECT 
    'Identificabilidad',
    'Porcentaje de filas únicas en funcion de Game y Year como indicatores.',
    Identifiability_Percentage,
    'Identifica duplicados considerando juegos con el mismo nombre y la misma fecha de lanzamiento.'
FROM IdentifiabilityMetric;



                            -- RAZONABILIDAD --

INSERT INTO Data_Quality_PS4 (Metric, Description, Value, Observations)
VALUES ('Razonabilidad','Promedio de razonabilidad basado en consistencia de ventas y rangos razonables (0-50 millones).',
    (
        SELECT 
            (SUM(
                CASE 
                    WHEN "Global" >= ("North America" + "Europe" + "Japan" + "Rest of World")
                         AND "North America" BETWEEN 0 AND 50 
                         AND "Europe" BETWEEN 0 AND 50 
                         AND "Japan" BETWEEN 0 AND 50 
                         AND "Rest of World" BETWEEN 0 AND 50 
                         AND "Global" BETWEEN 0 AND 50 THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*))
        FROM PS4_GamesSales
    ),
    'Los valores fuera del rango 0-50 millones serán revisados durante el proceso de limpieza.');





---------------------------------------------
-- RESULTADOS DATA QUALITY CHECK PS4  -------
---------------------------------------------



SELECT * FROM Data_Quality_PS4 


                                     -- TOTAL --

INSERT INTO Data_Quality_PS4 (Metric, Description, Value)
SELECT
     'TOTAL',
     'PROMEDIO DE CALIDAD GLOBAL BASADO EN VALORES DE METRICAS OBTENIDAS',
     AVG(Value)
FROM Data_Quality_PS4 
WHERE Value IS NOT NULL;










-----------------------------
-- DATA QUALITY CHECK XBOX ---
------------------------------


-- creacion de la tabla de calidad de datos --

CREATE TABLE Data_Quality_Xbox (
    Metric TEXT,          
    Description TEXT,     
    Value DECIMAL(10, 2),          
    Observation TEXT
);



-- update de missing ' ' o NA como NULL


UPDATE XboxOne_GameSales
SET "Game" = NULL
WHERE "Game" = '' OR "Game" = ' ' OR "Game" LIKE 'N/A';

UPDATE XboxOne_GameSales
SET "Year" = NULL
WHERE "Year" = '' OR "Year" = ' ' OR "Year" LIKE 'N/A';

UPDATE XboxOne_GameSales
SET "Genre" = NULL
WHERE "Genre" = '' OR "Genre" = ' ' OR "Genre" LIKE 'N/A';

UPDATE XboxOne_GameSales
SET "Publisher" = NULL
WHERE "Publisher" = '' OR "Publisher" = ' ' OR "Publisher" LIKE 'N/A';

UPDATE XboxOne_GameSales
SET "North America" = NULL
WHERE "North America" = '' OR "North America" = ' ' OR "North America" LIKE 'N/A';

UPDATE XboxOne_GameSales
SET "Europe" = NULL
WHERE "Europe" = '' OR "Europe" = ' ' OR "Europe" LIKE 'N/A';

UPDATE XboxOne_GameSales
SET "Japan" = NULL
WHERE "Japan" = '' OR "Japan" = ' ' OR "Japan" LIKE 'N/A';

UPDATE XboxOne_GameSales
SET "Rest of World" = NULL
WHERE "Rest of World" = '' OR "Rest of World" = ' ' OR "Rest of World" LIKE 'N/A';

UPDATE XboxOne_GameSales
SET "Global" = NULL
WHERE "Global" = '' OR "Global" = ' ' OR "Global" LIKE 'N/A';






                            -- COMPLETITUD --

INSERT INTO Data_Quality_Xbox (Metric, Description, Value, Observation)
VALUES ('Completitud','Promedio de completitud para cada variable',
    (
        SELECT AVG(Completeness_Percentage)
        FROM (
            SELECT 
                100.0 - (SUM(CASE WHEN "Pos" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Completeness_Percentage
            FROM XboxOne_GameSales
            UNION ALL
            SELECT 
                100.0 - (SUM(CASE WHEN "Game" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Completeness_Percentage
            FROM XboxOne_GameSales
            UNION ALL
            SELECT 
                100.0 - (SUM(CASE WHEN "Year" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Completeness_Percentage
            FROM XboxOne_GameSales
            UNION ALL
            SELECT 
                100.0 - (SUM(CASE WHEN "Publisher" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Completeness_Percentage
            FROM XboxOne_GameSales
            UNION ALL
            SELECT 
                100.0 - (SUM(CASE WHEN "Genre" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Completeness_Percentage
            FROM XboxOne_GameSales
            UNION ALL
            SELECT 
                100.0 - (SUM(CASE WHEN "North America" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Completeness_Percentage
            FROM XboxOne_GameSales
            UNION ALL
            SELECT 
                100.0 - (SUM(CASE WHEN "Europe" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Completeness_Percentage
            FROM XboxOne_GameSales
            UNION ALL
            SELECT 
                100.0 - (SUM(CASE WHEN "Japan" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Completeness_Percentage
            FROM XboxOne_GameSales
            UNION ALL
            SELECT 
                100.0 - (SUM(CASE WHEN "Rest of World" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Completeness_Percentage
            FROM XboxOne_GameSales
            UNION ALL
            SELECT 
                100.0 - (SUM(CASE WHEN "Global" IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Completeness_Percentage
            FROM XboxOne_GameSales
        ) AS CompletenessMetrics
    ),'');



                                     -- ACCURACY --



SELECT 
    'Accuracy' AS Metric, 
    (SUM(CASE WHEN "Year" BETWEEN 1950 AND strftime('%Y', 'now') THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Percentage,
    'si el ano es en el rango de precision' AS Description
FROM XboxOne_GameSales;


SELECT DISTINCT "Year"
FROM XboxOne_GameSales
ORDER BY "Year";




INSERT INTO Data_Quality_Xbox (Metric, Description, Value, Observation)
VALUES ('Accuracy','Promedio de precision de la variable Year.',
    (
        SELECT 
            (SUM(CASE WHEN "Year" BETWEEN 1950 AND strftime('%Y', 'now') THEN 1 ELSE 0 END) * 100.0 / COUNT(*))
        FROM XboxOne_GameSales
    ),'Incluye valores dentro del rango, es la unica metrica que podemos verificar con los recursos que tenemos');



                                             -- LINAJE --


-- Para esta metrica ponemos un 100% ( se explicara en el reporte las razones )


INSERT INTO Data_Quality_Xbox (Metric, Description, Value, Observation)
VALUES 
    ('Linaje','Porcentaje de rastreabilidad fiable en la tabla.',
        100,
        'El linaje es completo gracias a la columna Game, que permite rastrear valores faltantes con fuentes externas.');



                                             -- SEMANTICA --
       
       
INSERT INTO Data_Quality_Xbox (Metric, Description, Value, Observation)
VALUES ('Semantica', 'Porcentaje de filas con datos validos semánticamente (ventas no negativas,y Publisher valido).',
    (SELECT (SUM(CASE WHEN 
                        "North America" >= 0 AND 
                        "Europe" >= 0 AND 
                        "Japan" >= 0 AND 
                        "Rest of World" >= 0 AND 
                        "Global" >= 0 AND
                        "Publisher" IS NOT NULL AND LENGTH("Publisher") > 0
                    THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*))
        FROM XboxOne_GameSales
    ),'Verificaciones de ventas no negativas y Publisher válido.');

   
                                                                           -- Estructura --
WITH Metrics AS (SELECT 
        COUNT(*) AS Total_Rows,

        --  tipo de year
        SUM(CASE 
                WHEN typeof("Year") = 'date' THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*) AS Year_Validity_Percentage,
        
        -- Estructura de datos formato TEXT/Varchar
        SUM(CASE 
                WHEN SUBSTR("Publisher", 1, 1) GLOB '[A-Z]' OR SUBSTR("Publisher", 1, 1) GLOB '[0-9]' THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*) AS Publisher_Validity_Percentage,

        --  'Genre'  con una letra mayúscula
        SUM(CASE 
                WHEN SUBSTR("Genre", 1, 1) GLOB '[A-Z]' THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*) AS Genre_Validity_Percentage,

        --'Game': Mayúscula o número inicial
        SUM( CASE 
                WHEN SUBSTR("Game", 1, 1) GLOB '[A-Z]' OR SUBSTR("Game", 1, 1) GLOB '[0-9]' THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*) AS Game_Validity_Percentage
    FROM XboxOne_GameSales
),
AverageMetric AS (
    SELECT 
        (Year_Validity_Percentage + Publisher_Validity_Percentage + Genre_Validity_Percentage + Game_Validity_Percentage) / 4 AS Structural_Validity_Average
    FROM Metrics
)


INSERT INTO Data_Quality_Xbox (Metric, Description, Value, Observation)
SELECT 
    'Estructura',
    'Promedio de validez estructural basado en las normas establecidas.',
    Structural_Validity_Average,
    'Validación de Year con tipo DATE, variables textuales con primer caracter en mayúscula o número inicial.'
FROM AverageMetric;



                                         -- CONSISTENCIA --


INSERT INTO Data_Quality_Xbox (Metric, Description, Value, Observation)
VALUES ('Consistencia','Porcentaje de filas donde las ventas Global coinciden con la suma de las ventas para cada region.',
    (SELECT(SUM(CASE 
                    WHEN "Global" = ("North America" + "Europe" + "Japan" + "Rest of World") THEN 1
                    ELSE 0
                END) * 100.0 / COUNT(*))
FROM XboxOne_GameSales
    ),'Verificación realizada sobre ventas globales y regionales para asegurar la coherencia de datos.');
   
   

                                                -- MONEDA --
   
   -- dado que no tenemos datos adecuados para medir esta metrica ponemos un NULL

INSERT INTO Data_Quality_Xbox (Metric, Description, Value, Observation)
VALUES 
    ('Moneda','Esta métrica no aplica aqui porque los valores no representan datos monetarios ni cuya medida puede cambiar a lo largo del tiempo ',
    NULL,'No es relevante calcular esta métrica para los datos actuales.');


   
                             -- PUNTUALIDAD --
                             --esta métrica puede omitirse porque no hay actualizaciones, el unico campo temporal aqui son fechas fijas de fecha de lanzamiento/publicacion del
                             -- videojuego                                              
   
INSERT INTO Data_Quality_Xbox (Metric, Description, Value, Observation)
VALUES ('Puntualidad','Esta métrica no aplica aqui el dataset no trata de actualizaciones obligatorias o rangos temporales precisos de ventas',
        NULL,
        'No es relevante calcular esta métrica para los datos actuales.');

                                          -- INDETIFICABILIDAD --
   
INSERT INTO Data_Quality_Xbox (Metric, Description, Value, Observation)
VALUES ('Identificabilidad','Porcentaje de registros unicos basados en Game y si Year es distinto.',
    (WITH DuplicateCheck AS (SELECT 
                "Game", 
                "Year", 
                COUNT(*) AS Duplicate_Count
            FROM XboxOne_GameSales
            GROUP BY "Game", "Year"
            HAVING COUNT(*) > 1),
        TotalDuplicates AS (SELECT SUM(Duplicate_Count - 1) AS Total_Duplicates FROM DuplicateCheck),
        TotalRows AS (SELECT COUNT(*) AS Total_Rows FROM XboxOne_GameSales)
        SELECT 100.0 - (COALESCE((SELECT Total_Duplicates FROM TotalDuplicates), 0) * 100.0 / (SELECT Total_Rows FROM TotalRows))),
    'Se considera duplicado si Game y Year son iguales en varias filas.');
   
                                        -- RAZONABILIDAD --
   
INSERT INTO Data_Quality_Xbox (Metric, Description, Value, Observation)
VALUES ('Razonabilidad','Promedio de razonabilidad basado en consistencia de ventas y rangos razonables (0-50 millones).',
    (
        SELECT 
            (SUM(
                CASE 
                    WHEN "Global" >= ("North America" + "Europe" + "Japan" + "Rest of World")
                         AND "North America" BETWEEN 0 AND 50 
                         AND "Europe" BETWEEN 0 AND 50 
                         AND "Japan" BETWEEN 0 AND 50 
                         AND "Rest of World" BETWEEN 0 AND 50 
                         AND "Global" BETWEEN 0 AND 50 THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*))
        FROM XboxOne_GameSales
    ),'Los valores fuera del rango 0-50 millones serán revisados durante el proceso de limpieza.');

   
   
   
   
   
   ---------------------------------------------
-- RESULTADOS DATA QUALITY CHECK XBOX  -------
---------------------------------------------

   
-- TOTAL-- 

INSERT INTO Data_Quality_Xbox (Metric, Description, Value)
SELECT 
    'TOTAL' AS Metric,
    'PROMEDIO DE CALIDAD GLOBAL BASADO EN VALORES DE METRICAS OBTENIDAS' AS Description,
    AVG(Value) AS Value
FROM Data_Quality_Xbox
WHERE Value IS NOT NULL;

SELECT * FROM Data_Quality_Xbox; 












   ---------------------------------------------
-- DATA QUALITY CHECK SALES 22 DICIEMBRE 2016   -------
------------------------------------------------------



SELECT * FROM Video_Games_Sales_as_at_22_Dec_2016  

-- update de espacios vacios, N/A, Nan como NULL 
-- en cada columna 



UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Name" = NULL
WHERE "Name" = '' OR "Name" = ' ' OR "Name" LIKE 'N/A' OR "Name" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Platform" = NULL
WHERE "Platform" = '' OR "Platform" = ' ' OR "Platform" LIKE 'N/A' OR "Platform" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Year_of_Release" = NULL
WHERE "Year_of_Release" = '' OR "Year_of_Release" = ' ' OR "Year_of_Release" LIKE 'N/A' OR "Year_of_Release" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Genre" = NULL
WHERE "Genre" = '' OR "Genre" = ' ' OR "Genre" LIKE 'N/A' OR "Genre" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Publisher" = NULL
WHERE "Publisher" = '' OR "Publisher" = ' ' OR "Publisher" LIKE 'N/A' OR "Publisher" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "NA_Sales" = NULL
WHERE "NA_Sales" = '' OR "NA_Sales" = ' ' OR "NA_Sales" LIKE 'N/A' OR "NA_Sales" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "EU_Sales" = NULL
WHERE "EU_Sales" = '' OR "EU_Sales" = ' ' OR "EU_Sales" LIKE 'N/A' OR "EU_Sales" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "JP_Sales" = NULL
WHERE "JP_Sales" = '' OR "JP_Sales" = ' ' OR "JP_Sales" LIKE 'N/A' OR "JP_Sales" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Other_Sales" = NULL
WHERE "Other_Sales" = '' OR "Other_Sales" = ' ' OR "Other_Sales" LIKE 'N/A' OR "Other_Sales" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Global_Sales" = NULL
WHERE "Global_Sales" = '' OR "Global_Sales" = ' ' OR "Global_Sales" LIKE 'N/A' OR "Global_Sales" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Critic_Score" = NULL
WHERE "Critic_Score" = '' OR "Critic_Score" = ' ' OR "Critic_Score" LIKE 'N/A' OR "Critic_Score" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Critic_Count" = NULL
WHERE "Critic_Count" = '' OR "Critic_Count" = ' ' OR "Critic_Count" LIKE 'N/A' OR "Critic_Count" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "User_Score" = NULL
WHERE "User_Score" = '' OR "User_Score" = ' ' OR "User_Score" LIKE 'N/A' OR "User_Score" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "User_Count" = NULL
WHERE "User_Count" = '' OR "User_Count" = ' ' OR "User_Count" LIKE 'N/A' OR "User_Count" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Developer" = NULL
WHERE "Developer" = '' OR "Developer" = ' ' OR "Developer" LIKE 'N/A' OR "Developer" LIKE 'NaN';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Rating" = NULL
WHERE "Rating" = '' OR "Rating" = ' ' OR "Rating" LIKE 'N/A' OR "Rating" LIKE 'NaN';



-- creacion de la tabla de calidad de datos 


CREATE TABLE Data_Quality_22Dec2016 (
    Metric VARCHAR(100),          
    Description VARCHAR(100),            
    Value DECIMAL(10, 2),        
    Observation VARCHAR(100)             
);


                    -- COMPLETITUD --


INSERT INTO Data_Quality_22Dec2016 (Metric, Description, Value, Observation)
VALUES (
    'Completitud','Porcentaje promedio de datos no faltantes en todas las columnas.',
    (SELECT AVG(Completeness_Percentage)
        FROM (SELECT 
                (100.0 - (SUM(CASE WHEN "Name" IS NULL OR "Name" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS Completeness_Percentage
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "Platform" IS NULL OR "Platform" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "Year_of_Release" IS NULL OR "Year_of_Release" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "Genre" IS NULL OR "Genre" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "Publisher" IS NULL OR "Publisher" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "NA_Sales" IS NULL OR "NA_Sales" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "EU_Sales" IS NULL OR "EU_Sales" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "JP_Sales" IS NULL OR "JP_Sales" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "Other_Sales" IS NULL OR "Other_Sales" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "Global_Sales" IS NULL OR "Global_Sales" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "Critic_Score" IS NULL OR "Critic_Score" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "Critic_Count" IS NULL OR "Critic_Count" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "User_Score" IS NULL OR "User_Score" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "User_Count" IS NULL OR "User_Count" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "Developer" IS NULL OR "Developer" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016
            UNION ALL
            SELECT 
                (100.0 - (SUM(CASE WHEN "Rating" IS NULL OR "Rating" = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)))
            FROM Video_Games_Sales_as_at_22_Dec_2016)),
    'Se verifica la completitud general del dataset con el promedio de regirstros de cada variable.');




                        -- ACCURACY --
   
   WITH AccuracyChecks AS (SELECT COUNT(*) AS Total_Rows,
         -- conteos no sean negativas
        SUM(CASE WHEN "Critic_Count" >= 0 OR "Critic_Count" IS NULL THEN 1 ELSE 0 
        END) * 100.0 / COUNT(*) AS Critic_Count_Accuracy,
        SUM(CASE WHEN "User_Count" >= 0 OR "User_Count" IS NULL THEN 1 ELSE 0 
        END) * 100.0 / COUNT(*) AS User_Count_Accuracy,
        --  que Global_Sales = suma de ventas regionales
        SUM(CASE WHEN "Global_Sales" = ("NA_Sales" + "EU_Sales" + "JP_Sales" + "Other_Sales") THEN 1 ELSE 0 
        END) * 100.0 / COUNT(*) AS Global_Sales_Accuracy,
        --  que Year_of_Release este en el rango lógico
        SUM(CASE WHEN "Year_of_Release" BETWEEN 1950 AND strftime('%Y', 'now') THEN 1  ELSE 0 
        END) * 100.0 / COUNT(*) AS Year_Accuracy
    FROM Video_Games_Sales_as_at_22_Dec_2016),
AverageAccuracy AS (SELECT (Critic_Count_Accuracy + User_Count_Accuracy + Global_Sales_Accuracy + Year_Accuracy) / 4 AS Overall_Accuracy
    FROM AccuracyChecks)
    
INSERT INTO Data_Quality_22Dec2016 (Metric, Description, Value, Observation)
SELECT'Accuracy' AS Metric,'Promedio de accuracy basado en ventas no negativas y precisas y rango lógico del año de lanzamiento.' AS Description,
    Overall_Accuracy AS Value,
    'Se verifica la precision de los datos de ventas y de Year.' AS Observation
FROM AverageAccuracy;

   
                                        -- LINAJE --
   
   -- Para esta metrica ponemos un 100% 


INSERT INTO Data_Quality_22Dec2016 (Metric, Description, Value, Observation)
VALUES 
    ('Linaje','Porcentaje de rastreabilidad fiable en la tabla.',
        100,
        'El linaje es completo gracias a la columna Name, que permite rastrear valores faltantes con fuentes externas.');

   
       
       
                                    -- SEMANTICA --
   
INSERT INTO Data_Quality_22Dec2016 (Metric, Description, Value, Observation)
VALUES ('Semantica','Promedio de validez basado en ventas no negativas, scorings en el rango y valores validos que existen en Rating.',
    (WITH SemanticMetrics AS (SELECT 
                (SUM(CASE 
                        WHEN "NA_Sales" >= 0 AND "EU_Sales" >= 0 AND "JP_Sales" >= 0 AND "Other_Sales" >= 0 AND "Global_Sales" >= 0 THEN 1
                        ELSE 0
                    END) * 100.0 / COUNT(*)) AS Sales_Validity,
                (SUM(CASE 
                        WHEN "Critic_Score" BETWEEN 0 AND 100 OR "Critic_Score" IS NULL THEN 1
                        ELSE 0
                    END) * 100.0 / COUNT(*)) AS Critic_Score_Validity,
                (SUM(CASE 
                        WHEN "User_Score" BETWEEN 0 AND 10 OR "User_Score" IS NULL THEN 1
                        ELSE 0
                    END) * 100.0 / COUNT(*)) AS User_Score_Validity,
                (SUM(CASE 
                        WHEN "Rating" IN ('E', 'T', 'M', 'AO', 'EC', 'RP', 'E+10', 'AO+18') OR "Rating" IS NULL THEN 1
                        ELSE 0
                    END) * 100.0 / COUNT(*)) AS Rating_Validity
            FROM Video_Games_Sales_as_at_22_Dec_2016)
        SELECT 
            --promedio de todas las métricas semánticas
            (Sales_Validity + Critic_Score_Validity + User_Score_Validity + Rating_Validity) / 4
        FROM SemanticMetrics
    ),'Verificacion del sentido de las variables, de sus rangos, de acuerdo con el data catalog y la logica.');

   
                                   -- ESTRUCTURA --
   
   
INSERT INTO Data_Quality_22Dec2016 (Metric, Description, Value, Observation)
VALUES ('Estructura','Promedio de validez basado en tipo de datos y formato de columnas, ignorando valores NULL.',
    (
        WITH StructuralMetrics AS (
            SELECT 
                --  estructuta de tipo para Year_of_Release (solo cuenta si no es NULL)
                (SUM(
                    CASE 
                        WHEN typeof("Year_of_Release") = 'date' THEN 1
                        WHEN "Year_of_Release" IS NULL THEN 1 -- Ignorar valores NULL
                        ELSE 0
                    END
                ) * 100.0 / COUNT(*)) AS Year_Validity,
                (SUM(
                    CASE 
                        WHEN ("NA_Sales" IS NULL OR typeof("NA_Sales") IN ('integer', 'real')) AND 
                             ("EU_Sales" IS NULL OR typeof("EU_Sales") IN ('integer', 'real')) AND 
                             ("JP_Sales" IS NULL OR typeof("JP_Sales") IN ('integer', 'real')) AND 
                             ("Global_Sales" IS NULL OR typeof("Global_Sales") IN ('integer', 'real')) AND
                             ("Critic_Score" IS NULL OR typeof("Critic_Score") IN ('integer', 'real')) AND 
                             ("User_Score" IS NULL OR typeof("User_Score") IN ('integer', 'real')) THEN 1
                        ELSE 0
                    END
                ) * 100.0 / COUNT(*)) AS Sales_Scores_Validity,
                
                --  de formato para columnas de texto (solo cuenta si no son NULL)
                (SUM(
                    CASE 
                        WHEN ("Name" IS NULL OR "Name" GLOB '[A-Z0-9]*') AND
                             ("Platform" IS NULL OR "Platform" GLOB '[A-Z0-9]*') AND
                             ("Publisher" IS NULL OR "Publisher" GLOB '[A-Z0-9]*') AND
                             ("Rating" IS NULL OR "Rating" GLOB '[A-Z0-9]*') THEN 1
                        ELSE 0
                    END
                ) * 100.0 / COUNT(*)) AS Text_Columns_Validity
            FROM Video_Games_Sales_as_at_22_Dec_2016
        )
        SELECT 
            -- promedio de las métricas
            (Year_Validity + Sales_Scores_Validity + Text_Columns_Validity) / 3
        FROM StructuralMetrics
    ),'Los valores que no cumplen serán normalizados en el proceso de limpieza.');



   
   

                                   -- MONEDA --
INSERT INTO Data_Quality_22Dec2016 (Metric, Description, Value, Observation)
VALUES ('Moneda','No aplica porque no existen valores monetarios en este dataset.',
    NULL,'Esta métrica no es relevante para este análisis.');

   
   

                                  -- PUNTUALIDAD --
INSERT INTO Data_Quality_22Dec2016 (Metric, Description, Value, Observation)
VALUES ('Puntualidad','No aplica en este caso, ya que no hay campos que requieran actualizacion.',
    NULL,
    'El dataset contiene datos de fecha de lanzamiento y no requiere evaluacion de puntualidad.');

   
   
                                 -- CONSISTENCIA--
   
INSERT INTO Data_Quality_22Dec2016 (Metric, Description, Value, Observation)
VALUES ('Consistencia','Porcentaje de registros donde las ventas globales coinciden con la suma de las ventas regionales.',
    (
        SELECT 
            (SUM(
                CASE 
                    WHEN "Global_Sales" = ("NA_Sales" + "EU_Sales" + "JP_Sales" + "Other_Sales") THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*))
        FROM Video_Games_Sales_as_at_22_Dec_2016
    ), 'Nos da insights sobre la consistencia de los datos de ventas, sobre el total global.');
   
   
                               -- IDENTIFICABILIDAD --
-- contamos como duplicados los registros que tengan Name, Year of Release, y Platform iguales
-- porque sino son solamente variantes del videojuego (no duplicados)   
   
SELECT "Name", 
    "Year_of_Release", 
    "Platform",
    COUNT(*) AS Duplicate_Count
FROM Video_Games_Sales_as_at_22_Dec_2016
WHERE "Name" IS NOT NULL AND "Year_of_Release" IS NOT NULL AND "Platform" IS NOT NULL
GROUP BY "Name", "Year_of_Release", "Platform"
HAVING COUNT(*) > 1;






INSERT INTO Data_Quality_22Dec2016 (Metric, Description, Value, Observation)
VALUES ('Identificabilidad','Porcentaje de registros unicos basados en Name, Year_of_Release y Platform cuando todas las columnas están completas.',
    (SELECT 
            (COUNT(*) - SUM(CASE WHEN Duplicate_Count > 1 THEN Duplicate_Count - 1 ELSE 0 END)) * 100.0 / COUNT(*)
        FROM (
            SELECT 
                "Name", 
                "Year_of_Release", 
                "Platform",
                COUNT(*) AS Duplicate_Count
            FROM Video_Games_Sales_as_at_22_Dec_2016
            WHERE "Name" IS NOT NULL AND "Year_of_Release" IS NOT NULL AND "Platform" IS NOT NULL
            GROUP BY "Name", "Year_of_Release", "Platform"
        )),'La identificabilidad se asegura si los registros únicos basados en Name, Year_of_Release y Platform superan el 95%.');

   
                             -- RAZONABILIDAD--

INSERT INTO Data_Quality_22Dec2016 (Metric, Description, Value, Observation)
VALUES ('Razonabilidad',
    'Promedio de razonabilidad basado en consistencia de ventas y puntajes en un rango establecido.',
    (
        WITH ReasonabilityMetrics AS (
            SELECT 
                -- Consistencia de ventas regionales y globales
                (SUM(
                    CASE 
                        WHEN "Global_Sales" >= ("NA_Sales" + "EU_Sales" + "JP_Sales" + "Other_Sales") THEN 1
                        ELSE 0
                    END
                ) * 100.0 / COUNT(*)) AS Global_Sales_Reasonability,
                
                -- Razonabilidad de Critic Score
                (SUM(
                    CASE 
                        WHEN "Critic_Score" BETWEEN 0 AND 100 OR "Critic_Score" IS NULL THEN 1
                        ELSE 0
                    END
                ) * 100.0 / COUNT(*)) AS Critic_Score_Reasonability,
                
                -- Razonabilidad de User Score
                (SUM(
                    CASE 
                        WHEN "User_Score" BETWEEN 0 AND 10 OR "User_Score" IS NULL THEN 1
                        ELSE 0
                    END
                ) * 100.0 / COUNT(*)) AS User_Score_Reasonability,

                -- Razonabilidad de la fecha de lanzamiento
                (SUM(
                    CASE
                        WHEN "Year_of_Release" BETWEEN 1950 AND 2016 OR "Year_of_Release" IS NULL THEN 1
                        ELSE 0
                    END
                ) * 100.0 / COUNT(*)) AS Year_Reasonability
            FROM Video_Games_Sales_as_at_22_Dec_2016
        )
        SELECT 
            -- Promedio de todas las métricas de razonabilidad
            (Global_Sales_Reasonability + Critic_Score_Reasonability + User_Score_Reasonability + Year_Reasonability) / 4
        FROM ReasonabilityMetrics
    ),
    '');

   
   ---------------------------------------------
-- RESULTS DATA QUALITY CHECK SALES 22 DICIEMBRE 2016   -------
------------------------------------------------------

   
   
INSERT INTO Data_Quality_22Dec2016 (Metric, Description, Value, Observation)
VALUES ('TOTAL',
    'Promedio de todas las metricas de calidad.',
    (SELECT AVG(Value)
        FROM Data_Quality_22Dec2016
        WHERE Value IS NOT NULL
    ),'');


   
   
   
   
   
------------------
-- LIMPIEZA   ----
------------------

   
   
   
-- SOLVAR la consistencia de SALES 22 DEC 2016
   
UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Global_Sales" = COALESCE("NA_Sales", 0) + COALESCE("EU_Sales", 0) + COALESCE("JP_Sales", 0) + COALESCE("Other_Sales", 0)
WHERE "Global_Sales" != (COALESCE("NA_Sales", 0) + COALESCE("EU_Sales", 0) + COALESCE("JP_Sales", 0) + COALESCE("Other_Sales", 0))
   OR "Global_Sales" IS NULL;

  
  UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Global_Sales" = COALESCE("NA_Sales", 0) + COALESCE("EU_Sales", 0) + COALESCE("JP_Sales", 0) + COALESCE("Other_Sales", 0);

   

-- poner la estructura de primer caracter en mayuscula 

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Name" = UPPER(SUBSTR("Name", 1, 1)) || SUBSTR("Name", 2)
WHERE "Name" GLOB '[a-z]*';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Platform" = UPPER(SUBSTR("Platform", 1, 1)) || SUBSTR("Platform", 2)
WHERE "Platform" GLOB '[a-z]*';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Genre" = UPPER(SUBSTR("Genre", 1, 1)) || SUBSTR("Genre", 2)
WHERE "Genre" GLOB '[a-z]*';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Publisher" = UPPER(SUBSTR("Publisher", 1, 1)) || SUBSTR("Publisher", 2)
WHERE "Publisher" GLOB '[a-z]*';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Rating" = UPPER(SUBSTR("Rating", 1, 1)) || SUBSTR("Rating", 2)
WHERE "Rating" GLOB '[a-z]*';

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Developer" = UPPER(SUBSTR("Developer", 1, 1)) || SUBSTR("Developer", 2)
WHERE "Developer" GLOB '[a-z]*';



UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Rating" = NULL
WHERE "Rating" IN ('', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET 
    "Critic_Score" = NULL
WHERE "Critic_Score" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET 
    "Developer" = NULL
WHERE "Developer" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET 
    "Rating" = NULL
WHERE "Rating" IN ('', ' ', 'N/A', 'NaN');




-- solvar el problema de tipo de columna Year of Release 


ALTER TABLE Video_Games_Sales_as_at_22_Dec_2016 ADD COLUMN "Year" DATE;

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Year" = DATE("Year_of_Release" || '-01-01')
WHERE "Year_of_Release" IS NOT NULL AND "Year_of_Release" BETWEEN 1950 AND strftime('%Y', 'now');







CREATE TABLE Video_Games_Sales_as_at_22_Dec_2016_N AS
SELECT 
    "Name",
    "Platform",
    "Year", -- la nueva columna que reemplaza la antigua 
    "Genre",
    "Publisher",
    "NA_Sales",
    "EU_Sales",
    "JP_Sales",
    "Other_Sales",
    "Global_Sales",
    "Critic_Score",
    "Critic_Count",
    "User_Score",
    "User_Count",
    "Developer",
    "Rating"
FROM Video_Games_Sales_as_at_22_Dec_2016;



-- datos irazonables --
-- removamos los datos fuera del rango logico 


SELECT *
FROM Video_Games_Sales_as_at_22_Dec_2016_N
WHERE "Year" > '2016-12-31';

DELETE FROM Video_Games_Sales_as_at_22_Dec_2016_N
WHERE "Year" > '2016-12-31';

-- verificar

SELECT DISTINCT "Year"
FROM Video_Games_Sales_as_at_22_Dec_2016_N
ORDER BY "Year";



-- solvar los problemas XBOX 


ALTER TABLE XboxOne_GameSales ADD COLUMN "Year Release" DATE;

UPDATE XboxOne_GameSales
SET "Year Release" = DATE("Year" || '-01-01')
WHERE "Year" IS NOT NULL AND "Year" BETWEEN 1950 AND strftime('%Y', 'now');


CREATE TABLE XboxOne_GameSales_N AS
SELECT 
    "Pos",
    "Game",
    "Genre",
    "Publisher",
    "North America",
    "Europe",
    "Japan",
    "Rest of World",
    "Global",
    DATE("Year" || '-01-01') AS "Year Release"
FROM XboxOne_GameSales
WHERE "Year" IS NOT NULL AND "Year" BETWEEN 1950 AND strftime('%Y', 'now');

DROP TABLE XboxOne_GameSales 


-- normalizacion de valores textuales --


ALTER TABLE XboxOne_GameSales_N RENAME TO XboxOne_GameSales;

UPDATE XboxOne_GameSales
SET "Game" = UPPER(SUBSTR("Game", 1, 1)) || SUBSTR("Game", 2)
WHERE "Game" GLOB '[a-z]*';

UPDATE XboxOne_GameSales
SET "Genre" = UPPER(SUBSTR("Genre", 1, 1)) || SUBSTR("Genre", 2)
WHERE "Genre" GLOB '[a-z]*';

UPDATE XboxOne_GameSales
SET "Publisher" = UPPER(SUBSTR("Publisher", 1, 1)) || SUBSTR("Publisher", 2)
WHERE "Publisher" GLOB '[a-z]*';


-- duplicados check--

SELECT "Game", "Year Release", "Genre", "Publisher", COUNT(*) AS Duplicate_Count
FROM XboxOne_GameSales
GROUP BY "Game", "Year Release", "Genre", "Publisher"
HAVING COUNT(*) > 1;

-- Rellenar valores nulos en ventas regionales con 0 -- 

UPDATE XboxOne_GameSales
SET "North America" = 0
WHERE "North America" IS NULL;

UPDATE XboxOne_GameSales
SET "Europe" = 0
WHERE "Europe" IS NULL;

UPDATE XboxOne_GameSales
SET "Japan" = 0
WHERE "Japan" IS NULL;

UPDATE XboxOne_GameSales
SET "Rest of World" = 0
WHERE "Rest of World" IS NULL;



ALTER TABLE Video_Games_Sales_as_at_22_Dec_2016_N RENAME TO Video_Games_Sales_as_at_22_Dec_2016;



-- PS4


-- date -- 

ALTER TABLE PS4_GamesSales ADD COLUMN "Year Release" DATE;

UPDATE PS4_GamesSales 
SET "Year Release" = DATE("Year" || '-01-01')
WHERE "Year" IS NOT NULL 
  AND "Year" BETWEEN 1950 AND strftime('%Y', 'now');

CREATE TABLE PS4_GamesSales_Y AS
SELECT 
    "Game",
    DATE("Year" || '-01-01') AS "Year Release",
    "Genre",
    "Publisher",
    "North America",
    "Europe",
    "Japan",
    "Rest of World",
    "Global"
FROM PS4_GamesSales
WHERE "Year" IS NOT NULL AND "Year" BETWEEN 1950 AND strftime('%Y', 'now');


DROP TABLE PS4_GamesSales

ALTER TABLE PS4_GamesSales_Y RENAME TO PS4_GamesSales;




-- Normalizar textuales

UPDATE PS4_GamesSales
SET "Game" = UPPER(SUBSTR("Game", 1, 1)) || SUBSTR("Game", 2),
    "Genre" = UPPER(SUBSTR("Genre", 1, 1)) || SUBSTR("Genre", 2),
    "Publisher" = UPPER(SUBSTR("Publisher", 1, 1)) || SUBSTR("Publisher", 2)
WHERE "Game" GLOB '[a-z]*' OR "Genre" GLOB '[a-z]*' OR "Publisher" GLOB '[a-z]*';



-- duplicados

SELECT "Game", "Year_as_Date", "Genre", "Publisher", COUNT(*) AS Duplicate_Count
FROM PS4_GamesSales
GROUP BY "Game", "Year_as_Date", "Genre", "Publisher"
HAVING COUNT(*) > 1;



DELETE FROM PS4_GamesSales
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM PS4_GamesSales
    GROUP BY "Game", "Year_as_Date", "Genre", "Publisher");




   
   
   -- rellenar de NULL si hay faltantes o 0 para numericas 
   
UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Name" = NULL
WHERE "Name" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Platform" = NULL
WHERE "Platform" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Genre" = NULL
WHERE "Genre" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Publisher" = NULL
WHERE "Publisher" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Critic_Score" = NULL
WHERE "Critic_Score" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Critic_Count" = NULL
WHERE "Critic_Count" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "User_Score" = NULL
WHERE "User_Score" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "User_Count" = NULL
WHERE "User_Count" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Developer" = NULL
WHERE "Developer" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Rating" = NULL
WHERE "Rating" IN ('', ' ', 'N/A', 'NaN');



UPDATE PS4_GamesSales
SET "Game" = NULL
WHERE "Game" IN ('', ' ', 'N/A', 'NaN');

UPDATE PS4_GamesSales
SET "Genre" = NULL
WHERE "Genre" IN ('', ' ', 'N/A', 'NaN');

UPDATE PS4_GamesSales
SET "Publisher" = NULL
WHERE "Publisher" IN ('', ' ', 'N/A', 'NaN');




UPDATE XboxOne_GameSales
SET "Game" = NULL
WHERE "Game" IN ('', ' ', 'N/A', 'NaN');

UPDATE XboxOne_GameSales
SET "Genre" = NULL
WHERE "Genre" IN ('', ' ', 'N/A', 'NaN');

UPDATE XboxOne_GameSales
SET "Publisher" = NULL
WHERE "Publisher" IN ('', ' ', 'N/A', 'NaN');



UPDATE PS4_GamesSales
SET "North America" = 0
WHERE "North America" IN ('', ' ', 'N/A', 'NaN');

UPDATE PS4_GamesSales
SET "Europe" = 0
WHERE "Europe" IN ('', ' ', 'N/A', 'NaN');

UPDATE PS4_GamesSales
SET "Japan" = 0
WHERE "Japan" IN ('', ' ', 'N/A', 'NaN');

UPDATE PS4_GamesSales
SET "Rest of World" = 0
WHERE "Rest of World" IN ('', ' ', 'N/A', 'NaN');

UPDATE PS4_GamesSales
SET "Global" = 0
WHERE "Global" IN ('', ' ', 'N/A', 'NaN');


UPDATE XboxOne_GameSales
SET "North America" = 0
WHERE "North America" IN ('', ' ', 'N/A', 'NaN');

UPDATE XboxOne_GameSales
SET "Europe" = 0
WHERE "Europe" IN ('', ' ', 'N/A', 'NaN');

UPDATE XboxOne_GameSales
SET "Japan" = 0
WHERE "Japan" IN ('', ' ', 'N/A', 'NaN');

UPDATE XboxOne_GameSales
SET "Rest of World" = 0
WHERE "Rest of World" IN ('', ' ', 'N/A', 'NaN');

UPDATE XboxOne_GameSales
SET "Global" = 0
WHERE "Global" IN ('', ' ', 'N/A', 'NaN');



UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "NA_Sales" = 0
WHERE "NA_Sales" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "EU_Sales" = 0
WHERE "EU_Sales" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "JP_Sales" = 0
WHERE "JP_Sales" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Other_Sales" = 0
WHERE "Other_Sales" IN ('', ' ', 'N/A', 'NaN');

UPDATE Video_Games_Sales_as_at_22_Dec_2016
SET "Global_Sales" = 0
WHERE "Global_Sales" IN ('', ' ', 'N/A', 'NaN');








