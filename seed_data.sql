-- species seed data
INSERT INTO species (common_name)
VALUES
    ('African Lion'),
    ('Sumatran Tiger'),
    ('Snow Leopard');

-- zoo_keeper seed data
INSERT INTO zoo_keeper (full_name, contact_number)
VALUES
    ('Millie Thomas', '0234556778'),
    ('Zee McGee', '0234990889'),
    ('Arnold Barney-Matthews', '0234112334');

/* See Query 1 in queries.sql
 Select zoo_keeper.keeper_id and zoo_keeper.full_name
 before inserting data into id_badge table
 keeper_id is a PK,FK in id_badge */

-- id_badge seed data
INSERT INTO id_badge (keeper_id, issue_date, expiry_date)
VALUES
    (1, '2025-01-15', '2026-01-14'),
    (2, '2025-03-20', '2026-03-19'),
    (3, '2025-06-05', '2026-06-04');

/* See Query 2 in queries.sql
 Show species.species_id before inserting data,
 big_cat.species_id is a FK in big_cat table */

-- big_cat seed data
INSERT INTO big_cat (name, gender, species_id)
VALUES
    ('Zuri', 'M', 1),
    ('Chaka', 'F', 1),
    ('Indrah', 'M', 2),
    ('Rojo', 'F', 3);

/* See Query 3 in queries.sql
 Show big_cat.cat_id, big_cat.name before inserting feeding_log seed data
 zoo_keeper.keeper_id (query 1) and big_cat.cat_id are FK in feeding_log table */

-- feeding_log seed data
INSERT INTO feeding_log (keeper_id, cat_id, date, meat_type, qty_kg)
VALUES
    (1, 1, '2025-08-01', 'Beef', 12.61),
    (1, 2, '2025-08-01', 'Beef', 9.83),
    (2, 4, '2025-08-01', 'Chicken', 1.62),
    (3, 3, '2025-08-02', 'Goat', 10.31),
    (3, 4, '2025-08-02', 'Rabbit', 1.44),
    (3, 4, '2025-08-04', 'Rabbit', 1.70),
    (2, 1, '2025-08-05', 'Horse', 13.22),
    (2, 2, '2025-08-05', 'Horse', 11.20),
    (1, 3, '2025-08-05', 'Beef', 13.21),
    (3, 4, '2025-08-06', 'Chicken', 1.17),
    (1, 4, '2025-08-07', 'Chicken', 1.36),
    (1, 3, '2025-08-07', 'Beef', 11.91);