set time zone 'UTC';
create extension pgcrypto;

CREATE TABLE teams (
    id serial PRIMARY KEY,
    name VARCHAR (255) NOT NULL,
    activation VARCHAR (255) NOT NULL,
    time DECIMAL NOT NULL,
    created_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP
);

CREATE TABLE users (
    id serial PRIMARY KEY,
    username VARCHAR (255) NOT NULL,
    password VARCHAR (255) NOT NULL
);

CREATE TABLE tokens (
    id serial PRIMARY KEY,
    user_id int references users(id),
    created_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP
);

INSERT INTO users (username, password) VALUES ('admin', 'dGVzdDEyMw==');