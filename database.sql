--
-- File generated with SQLiteStudio v3.4.4 on Fri. Aug. 23 23:32:02 2024
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: categories
CREATE TABLE IF NOT EXISTS categories (
    cat_id   INTEGER NOT NULL ON CONFLICT ROLLBACK
                     UNIQUE ON CONFLICT ROLLBACK,
    cat_rank INTEGER NOT NULL,
    cat_name TEXT,
    PRIMARY KEY (
        cat_id
    )
);


-- Table: posts
CREATE TABLE IF NOT EXISTS posts (
    post_id   INTEGER NOT NULL ON CONFLICT ROLLBACK
                      UNIQUE ON CONFLICT ROLLBACK,
    user_id   INTEGER NOT NULL ON CONFLICT ROLLBACK,
    thread_id INTEGER NOT NULL ON CONFLICT ROLLBACK,
    post_date INTEGER NOT NULL ON CONFLICT ROLLBACK,
    post_body TEXT    NOT NULL,
    PRIMARY KEY (
        post_id AUTOINCREMENT
    ),
    FOREIGN KEY (
        user_id
    )
    REFERENCES users (user_id),
    FOREIGN KEY (
        thread_id
    )
    REFERENCES threads (thread_id) 
);


-- Table: sessions
CREATE TABLE IF NOT EXISTS sessions (
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
CREATE TABLE IF NOT EXISTS subforums (
    subf_id   INTEGER,
    subf_cat  INTEGER,
    subf_rank INTEGER,
    subf_name TEXT,
    subf_desc TEXT,
    PRIMARY KEY (
        subf_id AUTOINCREMENT
    )
);


-- Table: threads
CREATE TABLE IF NOT EXISTS threads (
    thread_id    INTEGER NOT NULL ON CONFLICT ROLLBACK,
    thread_title TEXT    NOT NULL ON CONFLICT ROLLBACK,
    thread_subf  INTEGER NOT NULL
                         REFERENCES categories (cat_id),
    PRIMARY KEY (
        thread_id AUTOINCREMENT
    )
);


-- Table: users
CREATE TABLE IF NOT EXISTS users (
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
