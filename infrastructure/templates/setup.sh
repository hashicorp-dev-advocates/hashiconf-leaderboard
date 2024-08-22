#!/bin/bash

sudo apt install -y wget

sudo sh -c 'echo "deb https://apt.PostgreSQL.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.PostgreSQL.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo apt update

sudo apt install -y postgresql-16

mkdir -p /opt/database

cat > /opt/database/connection.env <<- EOF
export PGDATABASE=${DATABASE}
export PGHOST=${ADDRESS}
export PGUSER=${USER}
export PGPASSWORD='${PASSWORD}'
EOF

cat > /opt/database/setup.sql <<- EOF
set time zone 'UTC';
create extension pgcrypto;

CREATE TABLE IF NOT EXISTS teams (
    id serial PRIMARY KEY,
    name VARCHAR (255) NOT NULL,
    activation VARCHAR (255) NOT NULL,
    time DECIMAL NOT NULL,
    created_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    id serial PRIMARY KEY,
    username VARCHAR (255) NOT NULL,
    password VARCHAR (255) NOT NULL
);

CREATE TABLE IF NOT EXISTS tokens (
    id serial PRIMARY KEY,
    user_id int references users(id),
    created_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP
);

%{ for user, password in LEADERBOARD_USER_LIST }
INSERT INTO users (username, password) VALUES ('${user}', '${password}') ON CONFLICT UPDATE;
%{ endfor }
EOF

source /opt/database/connection.env

psql -a -f /opt/database/setup.sql