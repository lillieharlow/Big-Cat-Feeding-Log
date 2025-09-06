/* Query 1: What are the names and id numbers of the zoo keepers?*/
SELECT keeper_id, full_name FROM zoo_keeper;

-- Query 2: What ID number is linked to what species?
SELECT * FROM species;

-- Query 3: What are the big cat names and id numbers?
SELECT cat_id, name FROM big_cat;

-- Query 4: What species is species_id 2?
SELECT common_name AS "Species_id 2"
FROM species
WHERE species_id = 2;

-- Query 5: Whose ID badge will expire first?
SELECT zk.full_name AS "Earliest id badge expiry"
FROM zoo_keeper zk
JOIN id_badge ib
    ON zk.keeper_id = ib.keeper_id -- join on keeper_id
GROUP BY zk.full_name, ib.expiry_date -- grouping by both because HAVING clause for agg function
HAVING expiry_date = ( -- subquery to find minimum date in id_badge.expiry_date
    SELECT MIN(expiry_date)
    FROM id_badge
);

/* Query 6: Zee needs to record the big cats he fed on the 8th of August.
 Zee is quite forgetful and only knows the cats names. During his shift he fed
 Zuri and Chaka horse meat. Zuri was given 12.98kg and Chaka was given 10.25kg. */
INSERT INTO feeding_log (
    keeper_id,
    cat_id,
    date,
    meat_type,
    qty_kg
)
SELECT
    zk.keeper_id,
    bc.cat_id,
    '2025-08-08',
    'Horse',
    fl.qty_kg
FROM (VALUES
    ('Zee McGee', 'Zuri', 12.98),
    ('Zee McGee', 'Chaka', 10.25)
) AS fl (full_name, cat_name, qty_kg)
JOIN zoo_keeper zk
    ON zk.full_name = fl.full_name -- join zoo_keeper with feeding_log on full_name
JOIN big_cat bc
    ON bc.name = fl.cat_name; -- join big_cat with feeding_log on cat_name

-- Show updated feeding log:
SELECT * FROM feeding_log;

/* Query 7: Millie dropped her phone whilst feeding Indrah and he crushed it
with his big paws. Her new number is 0234555333. */
UPDATE zoo_keeper
SET contact_number = '0234555333'
WHERE full_name = 'Millie Thomas';

/* Query 8: Arnold got a new job! The zoo manager needs to delete all records
 for Arnold but he can't remember his last name. It starts with a B and has an M in there too. */
DELETE FROM zoo_keeper
WHERE full_name LIKE 'Arnold B%M%';

-- Show updated tables:
SELECT * FROM zoo_keeper;
SELECT * FROM id_badge;
SELECT * FROM feeding_log; -- default zoo_keeper profile set at table creation to avoid loss of data

-- Query 9: Who eats more than 25kg of meat per week? List their name, gender and species.
SELECT
    bc.name AS "Cat name",
    bc.gender AS "Cat gender",
    s.common_name AS "Cat species",
    SUM(fl.qty_kg) AS "Total kg of meat/per week"
FROM big_cat bc
LEFT JOIN feeding_log fl -- left joins to return all rows from big_cat regardless of matches
    ON bc.cat_id = fl.cat_id -- join big_cat with feeding_log on cat_id
LEFT JOIN species s
    ON bc.species_id = s.species_id -- join big_cat with species on species_id
WHERE fl.date
    BETWEEN '2025-08-01' AND '2025-08-07'
GROUP BY
    bc.name,
    bc.gender,
    s.common_name
HAVING SUM(fl.qty_kg) > 25;

-- Query 10: On average how much of each 'meat type' does Rojo eat per week?
SELECT
    fl.meat_type AS "Rojo's meats",
    ROUND(AVG(fl.qty_kg), 2) AS "Avg kg/per week"
FROM big_cat bc
JOIN feeding_log fl
    ON bc.cat_id = fl.cat_id
WHERE bc.name = 'Rojo'
    AND fl.date BETWEEN '2025-08-01' AND '2025-08-07'
GROUP BY bc.name, fl.meat_type;

-- Query 11: What feeding record has the highest qty of meat per one feeding?
SELECT * FROM feeding_log
WHERE qty_kg = (
    SELECT MAX(qty_kg)
    FROM feeding_log
);

/* Query 12: There's a new cat in town! She's a Snow Leopard named Muri.
 Enter her details into the big cat database. Run Query 2 again to check her species_id. */

INSERT INTO big_cat (
    name,
    gender,
    species_id
)
VALUES ('Muri', 'F', 3);

/* Query 13: What is the average amount of meat eaten per species and gender in one feeding,
 and how many total feedings have been recorded?*/
SELECT
    s.common_name AS "Cat species",
    bc.gender AS "Cat gender",
    ROUND(AVG(fl.qty_kg), 2) AS "Avg qty of meat per feeding (kg)",
    (
        SELECT COUNT(*) -- count total feedings subquery
        FROM feeding_log fl2 -- use diff aliases ('2') to outer query, says what instance belongs to what query
        JOIN big_cat bc2
            ON fl2.cat_id = bc2.cat_id
        WHERE bc2.species_id = s.species_id
            AND bc2.gender = bc.gender
    ) AS "Total feedings"
FROM species s
JOIN big_cat bc -- join species with big_cat on species_id
    ON s.species_id = bc.species_id
JOIN feeding_log fl -- join big_cat with feeding_log on cat_id
    ON bc.cat_id = fl.cat_id
GROUP BY
    s.common_name,
    bc.gender,
    s.species_id -- has to be part of the GROUP BY or you get an error
ORDER BY AVG(fl.qty_kg) DESC;

/* Add extra seed data to feeding_log to show query 14 output. You will have
 to adjust seed data dates if it doesn't reflect past week when assessing. */
INSERT INTO feeding_log (keeper_id, cat_id, date, meat_type, qty_kg)
VALUES
    (1, 1, '2025-09-01', 'Beef', 12.5),
    (1, 2, '2025-09-01', 'Beef', 9.8),
    (2, 4, '2025-09-01', 'Chicken', 1.6),
    (2, 1, '2025-09-04', 'Horse', 13.2),
    (2, 2, '2025-09-04', 'Horse', 11.2),
    (1, 3, '2025-09-04', 'Beef', 13.2),
    (1, 4, '2025-09-06', 'Chicken', 1.4),
    (1, 3, '2025-09-06', 'Beef', 11.9);

-- Query 14: List all meat types fed to each species last week (from today). Order by total weight.
SELECT
    s.common_name AS "Cat species",
    fl.meat_type AS "Meat type",
    SUM(fl.qty_kg) AS "Total weight (kg)"
FROM species s
JOIN big_cat bc -- comes first to join species with species on species_id
    ON s.species_id = bc.species_id
JOIN (
    SELECT *
    FROM feeding_log
    WHERE date >= CURRENT_DATE - INTERVAL '7 days' -- Last 7 days from today
) fl ON bc.cat_id = fl.cat_id
GROUP BY
    s.common_name,
    fl.meat_type
ORDER BY
    SUM(fl.qty_kg) DESC;
