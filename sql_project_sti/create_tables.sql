-- ChatGPT ha scritto le colonne
-- io ho deciso i dtypes

CREATE TABLE IF NOT EXISTS country_data (
    country_name VARCHAR(100) PRIMARY KEY,
    density_per_sq_km TEXT, --NEED CLEANING COMMA
    abbreviation CHAR(2),
    agricultural_land_percent TEXT, --NEED CLEANING %
    land_area_sq_km TEXT, --NEED CLEANING COMMA
    armed_forces_size TEXT, --NEED CLEANING COMMA
    birth_rate NUMERIC(10,3),
    calling_code INT,
    capital_major_city VARCHAR(100),
    co2_emissions TEXT, --NEED CLEANING COMMA
    cpi TEXT, --NEED CLEANING COMMA
    cpi_change_percent TEXT, --NEED CLEANING %
    currency_code VARCHAR(5),
    fertility_rate NUMERIC(10,3),
    forested_area_percent TEXT, --NEED CLEANING %
    gasoline_price TEXT, --NEED CLEANING %
    gdp TEXT, --NEED CLEANING $ AND COMMA
    gross_primary_education_enrollment_percent TEXT, --NEED CLEANING %
    gross_tertiary_education_enrollment_percent TEXT, --NEED CLEANING %
    infant_mortality NUMERIC(10,3),
    largest_city VARCHAR(100),
    life_expectancy NUMERIC(10,3),
    maternal_mortality_ratio NUMERIC(10,3),
    minimum_wage TEXT, --NEED CLEANING $
    official_language VARCHAR(100),
    out_of_pocket_health_expenditure TEXT, --NEED CLEANING %
    physicians_per_thousand NUMERIC(10,3),
    population TEXT, --NEED CLEANING COMMA
    labor_force_percent TEXT, --NEED CLEANING %
    tax_revenue_percent TEXT, --NEED CLEANING %
    total_tax_rate TEXT, --NEED CLEANING %
    unemployment_rate TEXT, --NEED CLEANING %
    urban_population TEXT, --NEED CLEANING COMMA
    latitude NUMERIC,
    longitude NUMERIC
);

CREATE TABLE IF NOT EXISTS energy_data (
    country_name VARCHAR(100),
    year INTEGER,
    access_to_electricity NUMERIC,
    access_to_clean_fuels NUMERIC(10,3),
    renew_e_generating_capacity NUMERIC(10,3),
    financial_flows BIGINT,
    renewable_energy_share NUMERIC(10,3),
    electricity_from_fossil_fuels NUMERIC(10,3),
    electricity_from_nuclear NUMERIC(10,3),
    electricity_from_renewables NUMERIC(10,3),
    low_carbon_electricity NUMERIC,
    primary_e_consumption_pc NUMERIC,
    energy_intensity NUMERIC(10,3),
    co2_emissions_kt NUMERIC,
    renewables_share NUMERIC,
    gdp_growth NUMERIC,
    gdp_per_capita NUMERIC,
    density TEXT, --NEED CLEANING COMMA
    land_area NUMERIC,
    latitude NUMERIC,
    longitude NUMERIC,
	PRIMARY KEY (country_name, year)
);