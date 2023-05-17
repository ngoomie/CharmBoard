--
-- File generated with SQLiteStudio v3.4.4 on Tue. May 16 22:16:54 2023
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: categories
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (cat_id INTEGER NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, cat_rank INTEGER NOT NULL, cat_name TEXT, PRIMARY KEY (cat_id AUTOINCREMENT));

-- Table: posts
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (post_id INTEGER NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, user_id INTEGER NOT NULL ON CONFLICT ROLLBACK, thread_id INTEGER NOT NULL ON CONFLICT ROLLBACK, post_date INTEGER NOT NULL ON CONFLICT ROLLBACK, post_body TEXT NOT NULL, PRIMARY KEY (post_id AUTOINCREMENT), FOREIGN KEY (user_id) REFERENCES users (user_id), FOREIGN KEY (thread_id) REFERENCES threads (thread_id));

-- Table: sessions
DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
    session_key    TEXT           NOT NULL
                                  UNIQUE
                                  PRIMARY KEY,
    user_id        INTEGER        REFERENCES users (user_id) 
                                  NOT NULL,
    session_expiry NUMERIC        NOT NULL,
    is_ip_bound    INTEGER (1, 1) NOT NULL
                                  DEFAULT (0),
    bound_ip       TEXT
);

-- Table: subforums
DROP TABLE IF EXISTS subforums;
CREATE TABLE subforums (subf_id INTEGER PRIMARY KEY UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, subf_cat INTEGER REFERENCES categories (cat_id) NOT NULL, subf_rank INTEGER NOT NULL, subf_name TEXT NOT NULL ON CONFLICT ROLLBACK, subf_desc TEXT);

-- Table: threads
DROP TABLE IF EXISTS threads;
CREATE TABLE threads (
    thread_id    INTEGER NOT NULL ON CONFLICT ROLLBACK,
    thread_title TEXT    NOT NULL ON CONFLICT ROLLBACK,
    thread_subf  INTEGER REFERENCES categories (cat_id),
    PRIMARY KEY (
        thread_id AUTOINCREMENT
    )
);

-- Table: users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id     INTEGER NOT NULL ON CONFLICT ROLLBACK
                        UNIQUE ON CONFLICT ROLLBACK,
    username    TEXT    NOT NULL ON CONFLICT ROLLBACK
                        UNIQUE ON CONFLICT ROLLBACK,
    email       TEXT    UNIQUE ON CONFLICT ROLLBACK
                        NOT NULL ON CONFLICT ROLLBACK,
    password    TEXT    NOT NULL ON CONFLICT ROLLBACK,
    salt        TEXT    NOT NULL ON CONFLICT ROLLBACK,
    signup_date INTEGER NOT NULL,
    PRIMARY KEY (
        user_id AUTOINCREMENT
    )
    ON CONFLICT ABORT
);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
