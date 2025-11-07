CREATE TABLE AppUser (
    user_id SERIAL,
    username VARCHAR(30) NOT NULL,
    email VARCHAR(50),
    phone VARCHAR(15),
    PRIMARY KEY (user_id)
);

CREATE TABLE Sleep (
    sleep_id SERIAL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    duration_min INT CHECK (duration_min > 0),
    user_id INT NOT NULL,
    PRIMARY KEY (sleep_id),
    FOREIGN KEY (user_id) REFERENCES AppUser(user_id)
);

CREATE TABLE SleepStat (
    stat_id SERIAL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    avg_duration_min INT CHECK (avg_duration_min >= 0),
    avg_quality REAL CHECK (avg_quality BETWEEN 0 AND 100),
    user_id INT NOT NULL,
    PRIMARY KEY (stat_id),
    FOREIGN KEY (user_id) REFERENCES AppUser(user_id)
);

CREATE TABLE Recommendation (
    rec_id SERIAL,
    text VARCHAR(500),
    created_date DATE,
    stat_id INT NOT NULL,
    PRIMARY KEY (rec_id),
    FOREIGN KEY (stat_id) REFERENCES SleepStat(stat_id)
);

CREATE TABLE SearchParams (
    params_id SERIAL,
    district VARCHAR(50),
    house_type VARCHAR(30),
    min_rooms INT,
    min_area_m2 FLOAT,
    max_price NUMERIC(10,2),
    user_id INT NOT NULL,
    PRIMARY KEY (params_id),
    FOREIGN KEY (user_id) REFERENCES AppUser(user_id),

    CONSTRAINT district_pattern
        CHECK (district IS NULL OR district ~ '^[[:alpha:]][[:alpha:][:space:]-]{1,49}$'),

    CONSTRAINT house_type_pattern
        CHECK (house_type IS NULL OR house_type ~ '^[[:alpha:]][[:alpha:]-]{1,29}$')
);

CREATE TABLE DataSource (
    source_id SERIAL,
    name VARCHAR(40) NOT NULL,
    region VARCHAR(30),
    type VARCHAR(15) CHECK (type IN ('DB','API','Service')),
    PRIMARY KEY (source_id)
);

CREATE TABLE PropertyInfo (
    property_id SERIAL,
    district VARCHAR(40),
    house_type VARCHAR(20),
    rooms SMALLINT CHECK (rooms >= 0),
    area_m2 FLOAT CHECK (area_m2 > 0),
    rent_price NUMERIC(10,2) CHECK (rent_price > 0),
    source_id INT NOT NULL,
    PRIMARY KEY (property_id),
    FOREIGN KEY (source_id) REFERENCES DataSource(source_id)
);
