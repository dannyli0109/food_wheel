CREATE TABLE users(
  id SERIAL4 PRIMARY KEY,
  email VARCHAR(400) UNIQUE NOT NULL,
  password_digest TEXT NOT NULL
);

CREATE TABLE places(
  id SERIAL4 PRIMARY KEY,
  place_id TEXT NOT NULL,
  vicinity TEXT,
  name VARCHAR(400),
  place_lat FLOAT,
  place_lon FLOAT
);

CREATE TABLE visits(
  id SERIAL4 PRIMARY KEY,
  place_id INTEGER,
  user_id INTEGER,
  visit_date VARCHAR(400)
);

pg_dump -Fc --no-acl --no-owner -h localhost -U xiaohaoli wheel_db > db.dump
https://github.com/dannyli0109/food_wheel/raw/master/db.dump
heroku pg:backups:restore 'https://github.com/dannyli0109/food_wheel/raw/master/db.dump' DATABASE_URL
