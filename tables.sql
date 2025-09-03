-- drop all existing tables
DROP TABLE IF EXISTS species CASCADE;
DROP TABLE IF EXISTS zoo_keeper CASCADE;
DROP TABLE IF EXISTS id_badge;
DROP TABLE IF EXISTS big_cat CASCADE;
DROP TABLE IF EXISTS feeding_log;

 -- table 1: species
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(30) NOT NULL UNIQUE -- no duplicates, every species has a unique name
);

 -- table 2: zoo_keeper
CREATE TABLE zoo_keeper (
    keeper_id SERIAL PRIMARY KEY,
    full_name VARCHAR(40) NOT NULL,
    contact_number CHAR(10) NOT NULL UNIQUE -- no duplicates, every keeper has a unique contact number
);

/* default value for table 2: zoo_keeper
 When a keeper leaves, the default value replaces keeper data in table 5: feeding_log
 Important! Ensures feeding log entries are not deleted when a keeper is deleted. */
INSERT INTO zoo_keeper(keeper_id, full_name, contact_number)
VALUES (0, 'Past Keeper', '0000000000');

-- table 3: id_badge
CREATE TABLE id_badge (
    keeper_id INTEGER PRIMARY KEY,
    issue_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    FOREIGN KEY (keeper_id) REFERENCES zoo_keeper(keeper_id) ON DELETE CASCADE
);

CREATE TYPE gender AS ENUM ('M', 'F'); -- gender for table 4: big_cat

-- table 4: big_cat
CREATE TABLE big_cat (
    cat_id SERIAL PRIMARY KEY,
    name VARCHAR(10) NOT NULL UNIQUE, -- no duplicates, zoo's never use the same name for living animals within the zoo.
    gender gender NOT NULL,
    species_id INTEGER NOT NULL,
    FOREIGN KEY (species_id) REFERENCES species(species_id) ON DELETE CASCADE
);

-- table 5: feeding_log
CREATE TABLE feeding_log (
    feeding_log_id SERIAL PRIMARY KEY,
    keeper_id INTEGER DEFAULT 0,
    cat_id INTEGER NOT NULL,
    date DATE NOT NULL,
    meat_type VARCHAR(10) NOT NULL,
    qty_kg DECIMAL(4, 2),
    FOREIGN KEY (keeper_id) REFERENCES zoo_keeper(keeper_id) ON DELETE SET DEFAULT,
    FOREIGN KEY (cat_id) REFERENCES big_cat(cat_id) ON DELETE CASCADE,
    UNIQUE (cat_id, date)
);