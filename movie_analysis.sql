-- MOVIE DATABASE ANALYSIS PROJECT

-- DROP TABLES IF THEY EXIST
DROP TABLE IF EXISTS Movie_Actors;
DROP TABLE IF EXISTS BoxOffice;
DROP TABLE IF EXISTS Actors;
DROP TABLE IF EXISTS Movies;

-- 1. Create Movies Table
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(255),
    release_year INT,
    genre VARCHAR(50),
    rating FLOAT
);

-- 2. Create Actors Table
CREATE TABLE Actors (
    actor_id INT PRIMARY KEY,
    name VARCHAR(255),
    birth_year INT
);

-- 3. Create Movie_Actors Table (Many-to-Many)
CREATE TABLE Movie_Actors (
    movie_id INT,
    actor_id INT,
    PRIMARY KEY (movie_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (actor_id) REFERENCES Actors(actor_id)
);

-- 4. Create BoxOffice Table
CREATE TABLE BoxOffice (
    movie_id INT PRIMARY KEY,
    budget BIGINT,
    revenue BIGINT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

-- -----------------------------------------
-- INSERT SAMPLE DATA

-- Movies
INSERT INTO Movies VALUES 
(1, 'Inception', 2010, 'Sci-Fi', 8.8),
(2, 'The Dark Knight', 2008, 'Action', 9.0),
(3, 'Interstellar', 2014, 'Sci-Fi', 8.6),
(4, 'The Matrix', 1999, 'Action', 8.7),
(5, 'The Godfather', 1972, 'Crime', 9.2);

-- Actors
INSERT INTO Actors VALUES 
(1, 'Leonardo DiCaprio', 1974),
(2, 'Christian Bale', 1974),
(3, 'Keanu Reeves', 1964),
(4, 'Marlon Brando', 1924),
(5, 'Matthew McConaughey', 1969);

-- Movie_Actors
INSERT INTO Movie_Actors VALUES 
(1, 1), -- Inception - Leonardo
(2, 2), -- Dark Knight - Bale
(3, 5), -- Interstellar - Matthew
(4, 3), -- Matrix - Keanu
(5, 4); -- Godfather - Brando

-- BoxOffice
INSERT INTO BoxOffice VALUES 
(1, 160000000, 829895144),
(2, 185000000, 1004558444),
(3, 165000000, 677471339),
(4, 63000000, 465300000),
(5, 6000000, 250000000);

-- -----------------------------------------
-- ANALYSIS QUERIES

-- 1. Top 3 Highest Grossing Movies
SELECT M.title, B.revenue
FROM Movies M
JOIN BoxOffice B ON M.movie_id = B.movie_id
ORDER BY B.revenue DESC
LIMIT 3;

-- 2. Average Rating per Genre
SELECT genre, AVG(rating) AS avg_rating
FROM Movies
GROUP BY genre;

-- 3. Actor with Most Movies
SELECT A.name, COUNT(*) AS movie_count
FROM Actors A
JOIN Movie_Actors MA ON A.actor_id = MA.actor_id
GROUP BY A.name
ORDER BY movie_count DESC
LIMIT 1;

-- 4. Movies with Profit > $100M
SELECT M.title, (B.revenue - B.budget) AS profit
FROM Movies M
JOIN BoxOffice B ON M.movie_id = B.movie_id
WHERE (B.revenue - B.budget) > 100000000;

-- 5. Total Budget and Revenue by Genre
SELECT M.genre, SUM(B.budget) AS total_budget, SUM(B.revenue) AS total_revenue
FROM Movies M
JOIN BoxOffice B ON M.movie_id = B.movie_id
GROUP BY M.genre;
