-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: lib
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `books_issued`
--

DROP TABLE IF EXISTS `books_issued`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books_issued` (
  `id` int NOT NULL AUTO_INCREMENT,
  `member_name` varchar(100) DEFAULT NULL,
  `book_name` varchar(100) DEFAULT NULL,
  `author_name` varchar(100) DEFAULT NULL,
  `borrowed_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books_issued`
--

LOCK TABLES `books_issued` WRITE;
/*!40000 ALTER TABLE `books_issued` DISABLE KEYS */;
INSERT INTO `books_issued` VALUES (1,'Alice','The Great Gatsby','F. Scott Fitzgerald','2025-04-01','2025-04-15','2025-04-30'),(2,'Bob','1984','George Orwell','2025-04-05','2025-04-20','2025-05-05'),(3,'Charlie','To Kill a Mockingbird','Harper Lee','2025-04-10','2025-04-25','2025-05-10'),(4,'David','Pride and Prejudice','Jane Austen','2025-04-12','2025-04-27','2025-05-08'),(5,'Eva','Moby Dick','Herman Melville','2025-04-15','2025-04-30','2025-05-20'),(6,'Frank','War and Peace','Leo Tolstoy','2025-04-18','2025-05-03','2025-05-15'),(7,'Grace','The Odyssey','Homer','2025-04-20','2025-05-05','2025-05-07');
/*!40000 ALTER TABLE `books_issued` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-26 15:21:14
