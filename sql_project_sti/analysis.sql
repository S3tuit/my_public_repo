-- -- Che impatto ha il salario minimo
-- -- sull'economia dei paesi

-- SELECT
-- 	CASE
-- 		WHEN minimum_wage IS NULL THEN 'min_wage'
-- 		ELSE 'no_min_wage'
-- 		END AS has_min_wage,
-- 	ROUND(AVG(gdp/1e9)) AS average_gdp_bilio,
-- 	ROUND(AVG(unemployment_rate), 2) AS unempl_rate,
-- 	COUNT(*) AS n_countries
-- FROM country_data
-- GROUP BY minimum_wage IS NULL;


-- -- Come la sanità pubblica impatta
-- -- l'aspettativa di vita

-- SELECT
-- 	COUNT(*) AS n_countries,
-- 	(WIDTH_BUCKET(out_of_pocket_health_expenditure,0,100,10)-1)*10 || '%-' ||
-- 		WIDTH_BUCKET(out_of_pocket_health_expenditure,0,100,10)*10 || '%' AS bin,
-- 	ROUND(AVG(life_expectancy),2) AS avg_life_expect,
-- 	ROUND(AVG(maternal_mortality_ratio),2) AS avg_mat_death_1e6,
-- 	ROUND(AVG(infant_mortality),2) AS avg_infant_mort_1e3
-- FROM country_data
-- WHERE out_of_pocket_health_expenditure IS NOT NULL
-- GROUP BY WIDTH_BUCKET(out_of_pocket_health_expenditure,0,100,10)
-- ORDER BY WIDTH_BUCKET(out_of_pocket_health_expenditure,0,100,10) ASC;


-- -- Impatto degli investimenti militari sulla porzione
-- -- di energia rinnovabile di quel paese

-- SELECT 
-- 	c_data.country_name,
-- 	ROUND(AVG((armed_forces_size*100)::NUMERIC/c_data.population::NUMERIC),2) AS armed_force_perc,
-- 	ROUND(AVG(renewable_energy_share),2) AS avg_renewable_energy_share
-- FROM country_data AS c_data
-- JOIN energy_data AS e_data
-- 	ON c_data.country_name = e_data.country_name
-- WHERE (armed_forces_size*100)::NUMERIC/c_data.population::NUMERIC > 0.01
-- GROUP BY c_data.country_name
-- ORDER BY armed_force_perc ASC;

-- -- Vusto che le rows sono molte, ho usato i grafici
-- -- di pdAdim 4 per create una visualizzazione veloce


-- -- Distribuzione di uso energia elettrica
-- -- a bassa produzione di CO2

-- WITH energy_shares
-- AS(
-- 	SELECT
-- 		country_name,
-- 		CASE
-- 			WHEN low_carbon_electricity >= 0.75 THEN 'over_3/4_renew'
-- 			WHEN low_carbon_electricity >= 0.5 THEN 'over_1/2_renew'
-- 			WHEN low_carbon_electricity >= 0.25 THEN 'over_1/4_renew'
-- 			WHEN low_carbon_electricity < 0.25 THEN 'under_1/4_renew'
-- 			ELSE NULL END AS renew_e_share,
-- 		co2_emissions_kt AS co2_per_capita,
-- 		gdp_per_capita AS gdp
-- 	FROM energy_data
-- 	WHERE year = 2019
-- )

-- SELECT
-- 	renew_e_share,
-- 	COUNT(*) AS n_countries,
-- 	ROUND(AVG(co2_per_capita),2) AS avg_co2_per_capita,
-- 	ROUND(AVG(gdp),2) AS avg_gdp
-- FROM energy_shares
-- WHERE renew_e_share IS NOT NULL
-- GROUP BY renew_e_share


-- -- Distribuzione delle principali
-- -- fonti di energia elettrica

-- WITH major_sources
-- AS(
-- 	SELECT
-- 		country_name,
-- 		CASE
-- 			WHEN electricity_from_fossil_fuels > electricity_from_nuclear
-- 				AND electricity_from_fossil_fuels > electricity_from_renewables
-- 				THEN 'fossil_fuel'
-- 			WHEN electricity_from_nuclear > electricity_from_fossil_fuels
-- 				AND electricity_from_nuclear > electricity_from_renewables
-- 				THEN 'nuclear'
-- 			WHEN electricity_from_renewables > electricity_from_fossil_fuels
-- 				AND electricity_from_renewables > electricity_from_nuclear
-- 				THEN 'renewables'
-- 			ELSE NULL
-- 			END AS major_elect_energy_source
-- 	FROM energy_data
-- 	WHERE year = 2019
-- )

-- SELECT
-- 	major_elect_energy_source,
-- 	COUNT(*) AS n_countries
-- FROM major_sources
-- WHERE major_elect_energy_source IS NOT NULL
-- GROUP BY major_elect_energy_source;