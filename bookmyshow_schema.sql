-- ============================================================
-- BookMyShow Database Schema
-- Platform: MySQL
-- Normalization: 1NF, 2NF, 3NF, BCNF
-- ============================================================

CREATE DATABASE IF NOT EXISTS bookmyshow;
USE bookmyshow;

-- ============================================================
-- P1: Entity Definitions, Table Structures & Sample Data
-- ============================================================

-- ------------------------------------------------------------
-- 1. City
-- ------------------------------------------------------------
-- Attributes:
--   city_id   (PK, INT, AUTO_INCREMENT)
--   city_name (VARCHAR, NOT NULL)
--   state     (VARCHAR, NOT NULL)
-- ------------------------------------------------------------
CREATE TABLE city (
    city_id   INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state     VARCHAR(100) NOT NULL
);

INSERT INTO city (city_id, city_name, state) VALUES
(1, 'Chennai',   'Tamil Nadu'),
(2, 'Mumbai',    'Maharashtra'),
(3, 'Bangalore', 'Karnataka');

-- ------------------------------------------------------------
-- 2. Theatre
-- ------------------------------------------------------------
-- Attributes:
--   theatre_id   (PK, INT, AUTO_INCREMENT)
--   theatre_name (VARCHAR, NOT NULL)
--   address      (VARCHAR, NOT NULL)
--   city_id      (FK -> city.city_id)
-- ------------------------------------------------------------
CREATE TABLE theatre (
    theatre_id   INT AUTO_INCREMENT PRIMARY KEY,
    theatre_name VARCHAR(150) NOT NULL,
    address      VARCHAR(255) NOT NULL,
    city_id      INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

INSERT INTO theatre (theatre_id, theatre_name, address, city_id) VALUES
(1, 'PVR: Velachery',       'Phoenix Mall, Velachery, Chennai',    1),
(2, 'INOX: Brookefields',   'Brookefields Mall, Kundalahalli, Bangalore', 3),
(3, 'Sathyam Cinemas',      'Royapettah, Chennai',                1);

-- ------------------------------------------------------------
-- 3. Screen
-- ------------------------------------------------------------
-- Attributes:
--   screen_id   (PK, INT, AUTO_INCREMENT)
--   screen_name (VARCHAR, NOT NULL)
--   capacity    (INT, NOT NULL)
--   theatre_id  (FK -> theatre.theatre_id)
-- ------------------------------------------------------------
CREATE TABLE screen (
    screen_id   INT AUTO_INCREMENT PRIMARY KEY,
    screen_name VARCHAR(50) NOT NULL,
    capacity    INT NOT NULL,
    theatre_id  INT NOT NULL,
    FOREIGN KEY (theatre_id) REFERENCES theatre(theatre_id)
);

INSERT INTO screen (screen_id, screen_name, capacity, theatre_id) VALUES
(1, 'Screen 1', 150, 1),
(2, 'Screen 2', 200, 1),
(3, 'Screen 3', 120, 1),
(4, 'Screen 1', 180, 2),
(5, 'Screen 2', 160, 2),
(6, 'Sathyam Main', 250, 3),
(7, 'Sathyam S2',   180, 3);

-- ------------------------------------------------------------
-- 4. Movie
-- ------------------------------------------------------------
-- Attributes:
--   movie_id         (PK, INT, AUTO_INCREMENT)
--   title            (VARCHAR, NOT NULL)
--   language         (VARCHAR, NOT NULL)
--   genre            (VARCHAR, NOT NULL)
--   duration_minutes (INT, NOT NULL)
--   rating           (VARCHAR) – e.g. U, UA, A
-- ------------------------------------------------------------
CREATE TABLE movie (
    movie_id         INT AUTO_INCREMENT PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    language         VARCHAR(50)  NOT NULL,
    genre            VARCHAR(100) NOT NULL,
    duration_minutes INT          NOT NULL,
    rating           VARCHAR(10)
);

INSERT INTO movie (movie_id, title, language, genre, duration_minutes, rating) VALUES
(1, 'Vikram',               'Tamil',   'Action/Thriller', 174, 'UA'),
(2, 'RRR',                  'Telugu',  'Action/Drama',    187, 'UA'),
(3, 'The Batman',           'English', 'Action/Crime',    176, 'UA'),
(4, 'KGF Chapter 2',        'Kannada', 'Action',          168, 'UA'),
(5, 'Ponniyin Selvan - 2',  'Tamil',   'Historical/Drama',167, 'U');

-- ------------------------------------------------------------
-- 5. Show
-- ------------------------------------------------------------
-- Attributes:
--   show_id    (PK, INT, AUTO_INCREMENT)
--   movie_id   (FK -> movie.movie_id)
--   screen_id  (FK -> screen.screen_id)
--   show_date  (DATE, NOT NULL)
--   start_time (TIME, NOT NULL)
--   price      (DECIMAL, NOT NULL)
-- ------------------------------------------------------------
CREATE TABLE `show` (
    show_id    INT AUTO_INCREMENT PRIMARY KEY,
    movie_id   INT           NOT NULL,
    screen_id  INT           NOT NULL,
    show_date  DATE          NOT NULL,
    start_time TIME          NOT NULL,
    price      DECIMAL(8, 2) NOT NULL,
    FOREIGN KEY (movie_id)  REFERENCES movie(movie_id),
    FOREIGN KEY (screen_id) REFERENCES screen(screen_id)
);

INSERT INTO `show` (show_id, movie_id, screen_id, show_date, start_time, price) VALUES
-- PVR Velachery (theatre 1) — 2026-02-26
(1,  1, 1, '2026-02-26', '10:00:00', 180.00),
(2,  1, 1, '2026-02-26', '14:30:00', 180.00),
(3,  3, 2, '2026-02-26', '11:00:00', 200.00),
(4,  3, 2, '2026-02-26', '18:00:00', 220.00),
(5,  5, 3, '2026-02-26', '09:30:00', 150.00),
(6,  5, 3, '2026-02-26', '16:00:00', 150.00),
-- PVR Velachery (theatre 1) — 2026-02-27
(7,  1, 1, '2026-02-27', '10:00:00', 180.00),
(8,  2, 2, '2026-02-27', '13:00:00', 200.00),
(9,  5, 3, '2026-02-27', '17:00:00', 150.00),
-- INOX Brookefields (theatre 2) — 2026-02-26
(10, 4, 4, '2026-02-26', '10:30:00', 220.00),
(11, 4, 4, '2026-02-26', '15:00:00', 220.00),
(12, 2, 5, '2026-02-26', '11:00:00', 200.00),
(13, 2, 5, '2026-02-26', '19:00:00', 250.00),
-- Sathyam Cinemas (theatre 3) — 2026-02-26
(14, 1, 6, '2026-02-26', '10:00:00', 200.00),
(15, 1, 6, '2026-02-26', '14:00:00', 200.00),
(16, 1, 6, '2026-02-26', '21:00:00', 250.00),
(17, 3, 7, '2026-02-26', '11:30:00', 220.00),
(18, 3, 7, '2026-02-26', '18:30:00', 220.00);


-- ============================================================
-- P2: List all shows on a given date at a given theatre
--     along with their respective show timings
-- ============================================================

-- Parameters (replace as needed):
--   Theatre : 'PVR: Velachery'
--   Date    : '2026-02-26'

SELECT
    m.title            AS movie_title,
    m.language,
    m.genre,
    m.duration_minutes,
    s.screen_name,
    sh.start_time,
    sh.price
FROM `show` sh
JOIN movie   m ON m.movie_id  = sh.movie_id
JOIN screen  s ON s.screen_id = sh.screen_id
JOIN theatre t ON t.theatre_id = s.theatre_id
WHERE t.theatre_name = 'PVR: Velachery'
  AND sh.show_date   = '2026-02-26'
ORDER BY m.title, sh.start_time;

-- ============================================================
-- Expected Output for the above query:
-- +-------------------------+----------+------------------+------------------+-----------+------------+--------+
-- | movie_title             | language | genre            | duration_minutes | screen_name| start_time | price  |
-- +-------------------------+----------+------------------+------------------+-----------+------------+--------+
-- | Ponniyin Selvan - 2     | Tamil    | Historical/Drama | 167              | Screen 3  | 09:30:00   | 150.00 |
-- | Ponniyin Selvan - 2     | Tamil    | Historical/Drama | 167              | Screen 3  | 16:00:00   | 150.00 |
-- | The Batman              | English  | Action/Crime     | 176              | Screen 2  | 11:00:00   | 200.00 |
-- | The Batman              | English  | Action/Crime     | 176              | Screen 2  | 18:00:00   | 220.00 |
-- | Vikram                  | Tamil    | Action/Thriller  | 174              | Screen 1  | 10:00:00   | 180.00 |
-- | Vikram                  | Tamil    | Action/Thriller  | 174              | Screen 1  | 14:30:00   | 180.00 |
-- +-------------------------+----------+------------------+------------------+-----------+------------+--------+
-- ============================================================
