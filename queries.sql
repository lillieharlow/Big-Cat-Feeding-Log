/* Query 1: What are the names and id numbers for the zoo keepers?*/
SELECT keeper_id, full_name
    FROM zoo_keeper;

-- Query 2: What ID number is linked to what species?
SELECT * FROM species;

-- Query 3: What are the cats names and id numbers?
SELECT cat_id, name FROM big_cat;

-- Query 4: What species is species_id 2?
SELECT common_name AS "Species with species_id 2"
FROM species
WHERE species_id = 2;

-- Query 5: Whose ID badge will expire first?
SELECT zk.full_name AS "Keeper with Earliest ID Badge Expiry"
FROM zoo_keeper zk
JOIN id_badge ib ON zk.keeper_id = ib.keeper_id -- join on PK,FK relationship
GROUP BY zk.full_name, ib.expiry_date -- grouping by both because HAVING clause for aggregate function
HAVING expiry_date = (SELECT MIN(expiry_date) FROM id_badge); -- subquery to find minimum date in id_badge.expiry_date

/* Query 6: Zee needs to record the big cats he fed on the 8th of August.
 Zee is quite forgetful and only knows the cats names. During his shift he fed
 Zuri and Chaka horse meat. Zuri was given 12.98kg and Chaka was given 10.25kg. */
INSERT INTO feeding_log (keeper_id, cat_id, date, meat_type, qty_kg)
SELECT zk.keeper_id, bc.cat_id, '2025-08-08', 'Horse', fl.qty_kg
FROM (VALUES
    ('Zee McGee', 'Zuri', 12.98),
    ('Zee McGee', 'Chaka', 10.25)
) AS fl (full_name, cat_name, qty_kg)
JOIN zoo_keeper zk ON zk.full_name = fl.full_name
JOIN big_cat bc ON bc.name = fl.cat_name;

-- Show updated feeding log:
SELECT * FROM feeding_log;

/* Query 7: Millie dropped her phone whilst feeding Indrah and he crushed it
with his big paws. Her new number is 0234555333. */
UPDATE zoo_keeper
SET contact_number = '0234555333'
WHERE full_name = 'Millie Thomas';

/* Query 8: Arnold got a new job! The zoo no longer needs to keep his info on file.
The zoo manager needs to delete all records for Arnold but he can't remember his last name.
It starts with a B and has an M in there too. */
DELETE FROM zoo_keeper
WHERE full_name LIKE 'Arnold B%M%';

-- Show updated tables:
SELECT * FROM zoo_keeper;
SELECT * FROM id_badge;
SELECT * FROM feeding_log; -- default zoo_keeper profile set at table creation to avoid loss of data

-- Query 9: Who eats more than 25kg of meat per week? List their names, gender and species.
Select bc.name AS "Name", bc.gender AS "Gender", s.common_name AS "Species", SUM(fl.qty_kg) AS "Total kg of meat/per week"
FROM big_cat bc
LEFT JOIN feeding_log fl ON bc.cat_id = fl.cat_id
LEFT JOIN species s ON bc.species_id = s.species_id
WHERE fl.date BETWEEN '2025-08-01' AND '2025-08-07'
GROUP BY bc.name, bc.gender, s.common_name
HAVING SUM(fl.qty_kg) > 25;

-- Query 10: On average how much of each 'meat type' does Rojo eat per week?
SELECT fl.meat_type AS "Rojo eats", ROUND(AVG(fl.qty_kg), 2) AS "Avg kg/per week"
FROM big_cat bc
JOIN feeding_log fl ON bc.cat_id = fl.cat_id
WHERE bc.name = 'Rojo' AND fl.date BETWEEN '2025-08-01' AND '2025-08-07'
GROUP BY bc.name, fl.meat_type;

-- Query 11: What feeding record has the highest qty of meat per one feeding?
SELECT * FROM feeding_log
WHERE qty_kg = (SELECT MAX(qty_kg) FROM feeding_log);

-- Query 12: What is the average amount of meat per feeding, per species and gender?
SELECT s.common_name AS "Species", bc.gender, ROUND(AVG(fl.qty_kg), 2) AS "Avg qty of meat per feeding (kg)"
FROM species s
JOIN big_cat bc ON s.species_id = bc.species_id
JOIN feeding_log fl ON bc.cat_id = fl.cat_id
GROUP BY s.common_name, bc.gender
ORDER BY AVG(fl.qty_kg) DESC;

-- Query 13: What meat type is most frequently fed to each species? What is the total quantity?