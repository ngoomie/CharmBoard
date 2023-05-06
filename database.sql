--
-- File generated with SQLiteStudio v3.4.4 on Sat. May 6 00:01:26 2023
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: categories
DROP TABLE IF EXISTS categories;
CREATE TABLE IF NOT EXISTS categories (cat_id INTEGER NOT NULL UNIQUE, cat_name TEXT, PRIMARY KEY (cat_id AUTOINCREMENT));

-- Table: posts
DROP TABLE IF EXISTS posts;
CREATE TABLE IF NOT EXISTS "posts" (
	"post_id"	INTEGER NOT NULL UNIQUE,
	"user_id"	INTEGER NOT NULL,
	"thread_id"	INTEGER NOT NULL,
	"post_date"	INTEGER NOT NULL,
	PRIMARY KEY("post_id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "users"("user_id"),
	FOREIGN KEY("thread_id") REFERENCES "threads"("thread_id")
);

-- Table: session
DROP TABLE IF EXISTS session;
CREATE TABLE IF NOT EXISTS "session" (
	"user_id"	INTEGER NOT NULL UNIQUE,
	"session_id"	TEXT NOT NULL,
	"session_expiry"	INTEGER,
	PRIMARY KEY("user_id")
);

-- Table: subforums
DROP TABLE IF EXISTS subforums;
CREATE TABLE IF NOT EXISTS subforums (subf_id INTEGER PRIMARY KEY UNIQUE NOT NULL, subf_cat INTEGER REFERENCES categories (cat_id) UNIQUE NOT NULL, subf_name TEXT NOT NULL, subf_desc);

-- Table: threads
DROP TABLE IF EXISTS threads;
CREATE TABLE IF NOT EXISTS threads (thread_id INTEGER NOT NULL, thread_title TEXT NOT NULL, thread_subf INTEGER REFERENCES categories (cat_id), PRIMARY KEY (thread_id AUTOINCREMENT));

-- Table: users
DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users (user_id INTEGER NOT NULL UNIQUE, username TEXT NOT NULL UNIQUE ON CONFLICT ABORT, email TEXT UNIQUE NOT NULL, password INTEGER NOT NULL, salt TEXT NOT NULL, signup_date INTEGER NOT NULL, PRIMARY KEY (user_id AUTOINCREMENT) ON CONFLICT FAIL);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
