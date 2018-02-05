-- Copied from here: https://raw.githubusercontent.com/marceloverdijk/swapi-labs/master/swapi-labs-data/src/main/resources/schema.sql
-- LICENSE: https://github.com/marceloverdijk/swapi-labs/blob/master/LICENSE
CREATE TABLE planet
  ( id BIGINT NOT NULL
  , name VARCHAR(100) NOT NULL
  , rotation_period INT DEFAULT NULL
  , orbital_period INT DEFAULT NULL
  , diameter INT DEFAULT NULL
  , climate VARCHAR(40) DEFAULT NULL
  , gravity VARCHAR(40) DEFAULT NULL
  , terrain VARCHAR(40) DEFAULT NULL
  , surface_water INT DEFAULT NULL
  , population BIGINT DEFAULT NULL
  , created DATETIME NOT NULL
  , edited DATETIME NOT NULL
  , CONSTRAINT planet_pk PRIMARY KEY (id)
  );
CREATE INDEX planet_name_index ON planet (name);

CREATE TABLE person
  ( id BIGINT NOT NULL
  , name VARCHAR(100) NOT NULL
  , height INT DEFAULT NULL
  , mass DOUBLE DEFAULT NULL
  , hair_color VARCHAR(20) DEFAULT NULL
  , skin_color VARCHAR(20) DEFAULT NULL
  , eye_color VARCHAR(20) DEFAULT NULL
  , birth_year VARCHAR(10) DEFAULT NULL
  , gender VARCHAR(40) DEFAULT NULL
  , homeworld BIGINT DEFAULT NULL
  , created DATETIME NOT NULL
  , edited DATETIME NOT NULL
  , CONSTRAINT person_pk PRIMARY KEY (id)
  , CONSTRAINT person_homeworld_fk FOREIGN KEY (homeworld) REFERENCES planet (id)
  );
CREATE INDEX person_name_index ON person (name);

CREATE TABLE species
  ( id BIGINT NOT NULL
  , name VARCHAR(40) NOT NULL
  , classification VARCHAR(40) DEFAULT NULL
  , designation VARCHAR(40) DEFAULT NULL
  , average_height INT DEFAULT NULL
  , skin_colors VARCHAR(200) DEFAULT NULL
  , hair_colors VARCHAR(200) DEFAULT NULL
  , eye_colors VARCHAR(200) DEFAULT NULL
  , average_lifespan INT DEFAULT NULL
  , homeworld BIGINT DEFAULT NULL
  , language VARCHAR(40) DEFAULT NULL
  , created DATETIME NOT NULL
  , edited DATETIME NOT NULL
  , CONSTRAINT species_pk PRIMARY KEY (id)
  , CONSTRAINT species_homeworld_fk FOREIGN KEY (homeworld) REFERENCES planet (id)
  );
CREATE INDEX species_name_index ON species (name);

CREATE TABLE species_person
  ( species_id BIGINT NOT NULL
  , person_id BIGINT NOT NULL
  , CONSTRAINT species_person_pk PRIMARY KEY (species_id, person_id)
  , CONSTRAINT species_person_species_id_fk FOREIGN KEY (species_id) REFERENCES species (id)
  , CONSTRAINT species_person_person_id_fk FOREIGN KEY (person_id) REFERENCES person (id)
  );

CREATE TABLE vehicle
  ( id BIGINT NOT NULL
  , name VARCHAR(40) NOT NULL
  , model VARCHAR(40) DEFAULT NULL
  , manufacturer VARCHAR(80) DEFAULT NULL
  , cost_in_credits BIGINT DEFAULT NULL
  , length INT DEFAULT NULL
  , max_atmosphering_speed INT DEFAULT NULL
  , crew INT DEFAULT NULL
  , passengers INT DEFAULT NULL
  , cargo_capacity BIGINT DEFAULT NULL
  , consumables VARCHAR(40) DEFAULT NULL
  , vehicle_class VARCHAR(40) DEFAULT NULL
  , created DATETIME NOT NULL
  , edited DATETIME NOT NULL
  , CONSTRAINT vehicle_pk PRIMARY KEY (id)
  );
CREATE INDEX vehicle_name_index ON vehicle (name);

CREATE TABLE vehicle_pilot
  ( vehicle_id BIGINT NOT NULL
  , person_id BIGINT NOT NULL
  , CONSTRAINT vehicle_pilot_pk PRIMARY KEY (vehicle_id, person_id)
  , CONSTRAINT vehicle_pilot_vehicle_id_fk FOREIGN KEY (vehicle_id) REFERENCES vehicle (id)
  , CONSTRAINT vehicle_pilot_person_id_fk FOREIGN KEY (person_id) REFERENCES person (id)
  );

CREATE TABLE starship
  ( id BIGINT NOT NULL
  , name VARCHAR(40) NOT NULL
  , model VARCHAR(40) DEFAULT NULL
  , manufacturer VARCHAR(80) DEFAULT NULL
  , cost_in_credits BIGINT DEFAULT NULL
  , length INT DEFAULT NULL
  , max_atmosphering_speed INT DEFAULT NULL
  , crew INT DEFAULT NULL
  , passengers INT DEFAULT NULL
  , cargo_capacity BIGINT DEFAULT NULL
  , consumables VARCHAR(40) DEFAULT NULL
  , hyperdrive_rating DOUBLE DEFAULT NULL
  , mglt INT DEFAULT NULL
  , starship_class VARCHAR(40) DEFAULT NULL
  , created DATETIME NOT NULL
  , edited DATETIME NOT NULL
  , CONSTRAINT starship_pk PRIMARY KEY (id)
  );
CREATE INDEX starship_name_index ON starship (name);

CREATE TABLE starship_pilot
  ( starship_id BIGINT NOT NULL
  , person_id BIGINT NOT NULL
  , CONSTRAINT starship_pilot_pk PRIMARY KEY (starship_id, person_id)
  , CONSTRAINT starship_pilot_starship_id_fk FOREIGN KEY (starship_id) REFERENCES starship (id)
  , CONSTRAINT starship_pilot_person_id_fk FOREIGN KEY (person_id) REFERENCES person (id)
  );

CREATE TABLE film
  ( id BIGINT NOT NULL
  , title VARCHAR(100) NOT NULL
  , episode_id INT NOT NULL
  , opening_crawl VARCHAR(1000) DEFAULT NULL
  , director VARCHAR(100) DEFAULT NULL
  , producer VARCHAR(100) DEFAULT NULL
  , release_date DATE DEFAULT NULL
  , created DATETIME NOT NULL
  , edited DATETIME NOT NULL
  , CONSTRAINT film_pk PRIMARY KEY (id)
  );
CREATE INDEX film_title_index ON film (title);

CREATE TABLE film_character
  ( film_id BIGINT NOT NULL
  , person_id BIGINT NOT NULL
  , CONSTRAINT film_character_pk PRIMARY KEY (film_id, person_id)
  , CONSTRAINT film_character_film_id_fk FOREIGN KEY (film_id) REFERENCES film (id)
  , CONSTRAINT film_character_person_id_fk FOREIGN KEY (person_id) REFERENCES person (id)
  );

CREATE TABLE film_planet
  ( film_id BIGINT NOT NULL
  , planet_id BIGINT NOT NULL
  , CONSTRAINT film_planet_pk PRIMARY KEY (film_id, planet_id)
  , CONSTRAINT film_planet_film_id_fk FOREIGN KEY (film_id) REFERENCES film (id)
  , CONSTRAINT film_planet_planet_id_fk FOREIGN KEY (planet_id) REFERENCES planet (id)
  );

CREATE TABLE film_starship
  ( film_id BIGINT NOT NULL
  , starship_id BIGINT NOT NULL
  , CONSTRAINT film_starship_pk PRIMARY KEY (film_id, starship_id)
  , CONSTRAINT film_starship_film_id_fk FOREIGN KEY (film_id) REFERENCES film (id)
  , CONSTRAINT film_starship_starship_id_fk FOREIGN KEY (starship_id) REFERENCES starship (id)
  );

CREATE TABLE film_vehicle
  ( film_id BIGINT NOT NULL
  , vehicle_id BIGINT NOT NULL
  , CONSTRAINT film_vehicle_pk PRIMARY KEY (film_id, vehicle_id)
  , CONSTRAINT film_vehicle_film_id_fk FOREIGN KEY (film_id) REFERENCES film (id)
  , CONSTRAINT film_vehicle_vehicle_id_fk FOREIGN KEY (vehicle_id) REFERENCES vehicle (id)
  );

CREATE TABLE film_species
  ( film_id BIGINT NOT NULL
  , species_id BIGINT NOT NULL
  , CONSTRAINT film_species_pk PRIMARY KEY (film_id, species_id)
  , CONSTRAINT film_species_film_id_fk FOREIGN KEY (film_id) REFERENCES film (id)
  , CONSTRAINT film_species_species_id_fk FOREIGN KEY (species_id) REFERENCES species (id)
  );
