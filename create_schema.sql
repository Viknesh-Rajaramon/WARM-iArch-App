CREATE TABLE IF NOT EXISTS projects (
  id TEXT NOT NULL,
  location_name VARCHAR(100) NOT NULL,
  token VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  SHARD KEY (id)
);

CREATE TABLE IF NOT EXISTS users (
  uuid TEXT NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  password VARCHAR(100) NOT NULL,
  salt VARCHAR(100) NOT NULL,
  project_id TEXT NOT NULL,
  SHARD KEY (email),
  UNIQUE KEY (email) USING HASH
);

CREATE TABLE IF NOT EXISTS monitors (
  serial_no VARCHAR(13) NOT NULL,
  location_id BIGINT NOT NULL,
  name VARCHAR(50) NOT NULL,
  plantower_serial VARCHAR(100) DEFAULT NULL,
  project_id TEXT DEFAULT NULL,
  PRIMARY KEY (serial_no)
);
