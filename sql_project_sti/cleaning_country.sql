-- Così nel caso faccio qualche errore posso sempre
-- usare ROLLBACK;
START TRANSACTION;

-- Aiutato da ChatGPT che ha fatto il lavoro ripetitivo
ALTER TABLE country_data 
    ALTER COLUMN density_per_sq_km TYPE INT
		USING REPLACE(density_per_sq_km, ',', '')::INT,
    ALTER COLUMN agricultural_land_percent TYPE NUMERIC
		USING REPLACE(agricultural_land_percent, '%', '')::NUMERIC,
    ALTER COLUMN land_area_sq_km TYPE INT
		USING REPLACE(land_area_sq_km, ',', '')::INT,
    ALTER COLUMN armed_forces_size TYPE INT
		USING REPLACE(armed_forces_size, ',', '')::INT,
    ALTER COLUMN cpi TYPE NUMERIC 
		USING REPLACE(cpi, ',', '')::NUMERIC,
    ALTER COLUMN cpi_change_percent TYPE NUMERIC 
		USING REPLACE(cpi_change_percent, '%', '')::NUMERIC,
    ALTER COLUMN forested_area_percent TYPE NUMERIC 
		USING REPLACE(forested_area_percent, '%', '')::NUMERIC,
    ALTER COLUMN gasoline_price TYPE NUMERIC 
		USING REPLACE(REPLACE(gasoline_price, ',', ''), '$', '')::NUMERIC,
    ALTER COLUMN urban_population TYPE INT 
		USING REPLACE(urban_population, ',', '')::INT,
    ALTER COLUMN population TYPE INT 
		USING REPLACE(population, ',', '')::INT,
    ALTER COLUMN gdp TYPE NUMERIC 
		USING REPLACE(REPLACE(gdp, ',', ''), '$', '')::NUMERIC,
    ALTER COLUMN gross_primary_education_enrollment_percent TYPE NUMERIC 
		USING REPLACE(gross_primary_education_enrollment_percent, '%', '')::NUMERIC,
    ALTER COLUMN gross_tertiary_education_enrollment_percent TYPE NUMERIC 
		USING REPLACE(gross_tertiary_education_enrollment_percent, '%', '')::NUMERIC,
    ALTER COLUMN minimum_wage TYPE NUMERIC 
		USING REPLACE(minimum_wage, '$', '')::NUMERIC,
    ALTER COLUMN out_of_pocket_health_expenditure TYPE NUMERIC 
		USING REPLACE(out_of_pocket_health_expenditure, '%', '')::NUMERIC,
    ALTER COLUMN tax_revenue_percent TYPE NUMERIC 
		USING REPLACE(tax_revenue_percent, '%', '')::NUMERIC,
    ALTER COLUMN total_tax_rate TYPE NUMERIC 
		USING REPLACE(total_tax_rate, '%', '')::NUMERIC,
    ALTER COLUMN unemployment_rate TYPE NUMERIC 
		USING REPLACE(unemployment_rate, '%', '')::NUMERIC;

-- Per essere sicuro che tutto sia andato bene
SELECT * FROM country_data LIMIT 10;

-- Tutto è andato bene :)
COMMIT;