CREATE TYPE facility_type AS ENUM ('supermarket', 'warehouse');

CREATE TABLE facilities (
                          facility_id   SERIAL PRIMARY KEY,
                          type          facility_type NOT NULL,
                          name          TEXT NOT NULL UNIQUE,
                          address_line1 TEXT NOT NULL,
                          address_line2 TEXT,
                          city          TEXT NOT NULL,
                          region        TEXT,
                          postal_code   TEXT NOT NULL,
                          country_code  CHAR(2) NOT NULL,
                          latitude      DOUBLE PRECISION CHECK (latitude BETWEEN -90 AND 90),
                          longitude     DOUBLE PRECISION CHECK (longitude BETWEEN -180 AND 180)
);

CREATE INDEX facility_type_idx ON facilities(type);
CREATE INDEX facility_city_idx ON facilities(city);

CREATE INDEX facility_earth_gist_idx
    ON facilities
        USING GIST (ll_to_earth(latitude, longitude));

CREATE TABLE facility_inventory (
                                    facility_id INTEGER NOT NULL REFERENCES facilities(facility_id) ON DELETE CASCADE,
                                    product_id  INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
                                    qty_units   INTEGER NOT NULL DEFAULT 0 CHECK (qty_units >= 0),
                                    PRIMARY KEY (facility_id, product_id)
);

CREATE INDEX facility_inventory_product_idx ON facility_inventory(product_id);

