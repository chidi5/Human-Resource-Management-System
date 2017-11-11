-- MySQL dump 10.13  Distrib 5.7.19, for osx10.12 (x86_64)
--
-- Host: localhost    Database: HRMS
-- ------------------------------------------------------
-- Server version	5.7.19

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Charge_Sheet`
--

DROP TABLE IF EXISTS `Charge_Sheet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Charge_Sheet` (
  `IID` int(11) NOT NULL AUTO_INCREMENT,
  `Decision` varchar(100) DEFAULT NULL,
  `Appeal` varchar(100) DEFAULT NULL,
  `Charges` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`IID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Charge_Sheet`
--

LOCK TABLES `Charge_Sheet` WRITE;
/*!40000 ALTER TABLE `Charge_Sheet` DISABLE KEYS */;
INSERT INTO `Charge_Sheet` VALUES (1,'Vindicated','I was framed for the wrong doing.','Taking things away from office.'),(2,'Found Guilty','I was framed for wrong doing.','Murder'),(3,'Found Guilty','I was framed for wrong doing.','Murder'),(4,'Found Guilty','I had no control over myself','Indecent Exposure');
/*!40000 ALTER TABLE `Charge_Sheet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Contract_Based`
--

DROP TABLE IF EXISTS `Contract_Based`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Contract_Based` (
  `EID` int(11) NOT NULL,
  `CID` int(11) NOT NULL,
  PRIMARY KEY (`EID`,`CID`),
  KEY `CID` (`CID`),
  CONSTRAINT `contract_based_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contract_based_ibfk_2` FOREIGN KEY (`CID`) REFERENCES `Contracts` (`CID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Contract_Based`
--

LOCK TABLES `Contract_Based` WRITE;
/*!40000 ALTER TABLE `Contract_Based` DISABLE KEYS */;
INSERT INTO `Contract_Based` VALUES (8,1),(9,2);
/*!40000 ALTER TABLE `Contract_Based` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Demotion`
--

DROP TABLE IF EXISTS `Demotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Demotion` (
  `IID` int(11) NOT NULL,
  `Higher_PID` int(11) NOT NULL,
  `Higher_UID` int(11) NOT NULL,
  `Lower_PID` int(11) NOT NULL,
  `Lower_UID` int(11) NOT NULL,
  `Relieving_Date` date DEFAULT NULL,
  `Joining_Date` date DEFAULT NULL,
  PRIMARY KEY (`IID`,`Higher_PID`,`Higher_UID`,`Lower_PID`,`Lower_UID`),
  KEY `Lower_PID` (`Lower_PID`,`Lower_UID`),
  KEY `Higher_PID` (`Higher_PID`,`Higher_UID`),
  CONSTRAINT `demotion_ibfk_1` FOREIGN KEY (`IID`) REFERENCES `Charge_Sheet` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `demotion_ibfk_2` FOREIGN KEY (`Lower_PID`, `Lower_UID`) REFERENCES `Post` (`PID`, `UID`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `demotion_ibfk_3` FOREIGN KEY (`Higher_PID`, `Higher_UID`) REFERENCES `Post` (`PID`, `UID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Demotion`
--

LOCK TABLES `Demotion` WRITE;
/*!40000 ALTER TABLE `Demotion` DISABLE KEYS */;
INSERT INTO `Demotion` VALUES (2,1,3,7,3,'2017-11-10','2017-11-13'),(3,1,2,8,2,'2017-11-10','2017-11-12'),(3,6,1,7,1,'2017-11-10','2017-11-11');
/*!40000 ALTER TABLE `Demotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Dependents`
--

DROP TABLE IF EXISTS `Dependents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Dependents` (
  `Aadhar` char(12) NOT NULL,
  `EID` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Address` varchar(50) NOT NULL,
  `Age` int(11) NOT NULL,
  `Gender` char(1) NOT NULL,
  `Relation` varchar(10) NOT NULL,
  PRIMARY KEY (`Aadhar`),
  KEY `EID` (`EID`),
  CONSTRAINT `dependents_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Dependents`
--

LOCK TABLES `Dependents` WRITE;
/*!40000 ALTER TABLE `Dependents` DISABLE KEYS */;
INSERT INTO `Dependents` VALUES ('328592384923',4,'Bipin B Choudhary','40/9J, Pocket 3, Faridabad',65,'M','Father'),('382342829023',1,'Ashok Rathee','1010-B, Sector-1, Rohtak',57,'M','Father'),('384593845938',7,'Rahul Kumar','Room 123, DG Hostel, IIT BHU',8,'M','Cousin'),('435345345345',7,'Satish Kumar','36/9J Patna, Bihar',57,'M','Father');
/*!40000 ALTER TABLE `Dependents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee`
--

DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Employee` (
  `EID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  `Address` varchar(50) NOT NULL,
  `Age` int(11) NOT NULL,
  `Gender` char(1) NOT NULL,
  `Aadhar` char(12) DEFAULT NULL,
  PRIMARY KEY (`EID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee`
--

LOCK TABLES `Employee` WRITE;
/*!40000 ALTER TABLE `Employee` DISABLE KEYS */;
INSERT INTO `Employee` VALUES (1,'Deevashwer','Room 124, Dhanraj Giri Hostel, IIT BHU',20,'M','123456789012'),(4,'Ketan','Room 124, Dhanraj Giri Hostel, IIT BHU',21,'M','325987239583'),(5,'Chaitanya','Room 137, Dhanraj Giri Hostel, IIT BHU',21,'M','238942934829'),(6,'Dhawal','Room 151, Dhanraj Giri Hostel, IIT BHU',20,'M','238942934829'),(7,'Mayank','Room 149, Dhanraj Giri Hostel, IIT BHU',22,'M','982343141928'),(8,'Karan','Room 145, Dhanraj Giri Hostel, IIT BHU',20,'M','832948294823'),(9,'Aakash','Room 171, DG, IIT BHU',25,'M','932284923482'),(12,'Adit Agarwal','Room 156, DG Hostel, IIT BHU',26,'M','893245829358'),(14,'Rahul Prasad','Room 153, DG Hostel, IIT BHU',25,'M','823948928294');
/*!40000 ALTER TABLE `Employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee_Account`
--

DROP TABLE IF EXISTS `Employee_Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Employee_Account` (
  `EID` int(11) NOT NULL,
  `Account_No` varchar(11) NOT NULL,
  `IFSC` char(11) NOT NULL,
  PRIMARY KEY (`Account_No`,`IFSC`),
  KEY `EID` (`EID`),
  CONSTRAINT `employee_account_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee_Account`
--

LOCK TABLES `Employee_Account` WRITE;
/*!40000 ALTER TABLE `Employee_Account` DISABLE KEYS */;
INSERT INTO `Employee_Account` VALUES (1,'23892810482','SBI00000832'),(4,'23892812183','SBI00000661'),(5,'23892811923','SBI00000912'),(6,'89352834928','SBI00000134'),(7,'28727237372','SBI00000588'),(8,'28727237372','SBI00000360'),(9,'23423425252','SBI00000324'),(12,'38294823948','SBI00002343'),(14,'32859423849','ICICI000023');
/*!40000 ALTER TABLE `Employee_Account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee_Charges`
--

DROP TABLE IF EXISTS `Employee_Charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Employee_Charges` (
  `EID` int(11) NOT NULL,
  `IID` int(11) NOT NULL,
  PRIMARY KEY (`EID`,`IID`),
  KEY `IID` (`IID`),
  CONSTRAINT `employee_charges_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employee_charges_ibfk_2` FOREIGN KEY (`IID`) REFERENCES `Charge_Sheet` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee_Charges`
--

LOCK TABLES `Employee_Charges` WRITE;
/*!40000 ALTER TABLE `Employee_Charges` DISABLE KEYS */;
INSERT INTO `Employee_Charges` VALUES (7,1),(5,2),(7,3),(4,4);
/*!40000 ALTER TABLE `Employee_Charges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee_Loan`
--

DROP TABLE IF EXISTS `Employee_Loan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Employee_Loan` (
  `EID` int(11) NOT NULL,
  `LID` int(11) NOT NULL,
  PRIMARY KEY (`EID`,`LID`),
  KEY `LID` (`LID`),
  CONSTRAINT `employee_loan_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employee_loan_ibfk_2` FOREIGN KEY (`LID`) REFERENCES `Loan` (`LID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee_Loan`
--

LOCK TABLES `Employee_Loan` WRITE;
/*!40000 ALTER TABLE `Employee_Loan` DISABLE KEYS */;
INSERT INTO `Employee_Loan` VALUES (4,2),(1,4),(1,8),(5,9),(7,12),(7,13);
/*!40000 ALTER TABLE `Employee_Loan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee_Login`
--

DROP TABLE IF EXISTS `Employee_Login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Employee_Login` (
  `EID` int(11) NOT NULL,
  `User` int(11) NOT NULL,
  PRIMARY KEY (`EID`,`User`),
  KEY `User` (`User`),
  CONSTRAINT `employee_login_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employee_login_ibfk_2` FOREIGN KEY (`User`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee_Login`
--

LOCK TABLES `Employee_Login` WRITE;
/*!40000 ALTER TABLE `Employee_Login` DISABLE KEYS */;
INSERT INTO `Employee_Login` VALUES (1,1),(4,3),(5,4),(6,5),(7,6),(8,7),(9,8),(12,11),(14,13);
/*!40000 ALTER TABLE `Employee_Login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee_Phone`
--

DROP TABLE IF EXISTS `Employee_Phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Employee_Phone` (
  `EID` int(11) NOT NULL,
  `Phone` char(10) NOT NULL,
  PRIMARY KEY (`EID`,`Phone`),
  CONSTRAINT `employee_phone_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee_Phone`
--

LOCK TABLES `Employee_Phone` WRITE;
/*!40000 ALTER TABLE `Employee_Phone` DISABLE KEYS */;
INSERT INTO `Employee_Phone` VALUES (1,'1262273651'),(1,'9466010005'),(4,'3490683503'),(5,'9882342342'),(6,'9882342342'),(7,'9777723413'),(8,'7234242342'),(9,'9888982348'),(12,'9898329472'),(14,'9892938492');
/*!40000 ALTER TABLE `Employee_Phone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee_Post`
--

DROP TABLE IF EXISTS `Employee_Post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Employee_Post` (
  `EID` int(11) NOT NULL,
  `PID` int(11) NOT NULL,
  `UID` int(11) NOT NULL,
  PRIMARY KEY (`EID`,`PID`,`UID`),
  KEY `PID` (`PID`,`UID`),
  CONSTRAINT `employee_post_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employee_post_ibfk_2` FOREIGN KEY (`PID`, `UID`) REFERENCES `Post` (`PID`, `UID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee_Post`
--

LOCK TABLES `Employee_Post` WRITE;
/*!40000 ALTER TABLE `Employee_Post` DISABLE KEYS */;
INSERT INTO `Employee_Post` VALUES (4,1,1),(5,1,2),(12,6,1),(6,6,2),(7,7,1),(1,7,2),(14,8,1);
/*!40000 ALTER TABLE `Employee_Post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Initial_Pay_Scale`
--

DROP TABLE IF EXISTS `Initial_Pay_Scale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Initial_Pay_Scale` (
  `PID` int(11) NOT NULL,
  `UID` int(11) NOT NULL,
  `SID` int(11) NOT NULL,
  PRIMARY KEY (`PID`,`UID`,`SID`),
  KEY `SID` (`SID`),
  CONSTRAINT `initial_pay_scale_ibfk_1` FOREIGN KEY (`PID`, `UID`) REFERENCES `Post` (`PID`, `UID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `initial_pay_scale_ibfk_2` FOREIGN KEY (`SID`) REFERENCES `Salary` (`SID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Initial_Pay_Scale`
--

LOCK TABLES `Initial_Pay_Scale` WRITE;
/*!40000 ALTER TABLE `Initial_Pay_Scale` DISABLE KEYS */;
INSERT INTO `Initial_Pay_Scale` VALUES (1,1,1),(1,2,2),(1,3,2),(2,1,3),(2,2,4),(2,3,4),(3,1,5),(4,1,5),(5,1,5),(3,2,6),(3,3,6),(4,2,6),(4,3,6),(5,2,6),(5,3,6),(6,1,7),(7,1,7),(8,1,7),(6,2,8),(6,3,8),(7,2,8),(7,3,8),(8,2,8),(8,3,8),(9,1,9),(9,2,10),(9,3,10),(10,1,11),(10,2,12),(10,3,12);
/*!40000 ALTER TABLE `Initial_Pay_Scale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Leave_Record`
--

DROP TABLE IF EXISTS `Leave_Record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Leave_Record` (
  `EID` int(11) NOT NULL,
  `Date` date NOT NULL,
  `Type` varchar(10) DEFAULT NULL,
  `Approved` char(1) DEFAULT 'N',
  PRIMARY KEY (`EID`,`Date`),
  CONSTRAINT `leave_record_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Leave_Record`
--

LOCK TABLES `Leave_Record` WRITE;
/*!40000 ALTER TABLE `Leave_Record` DISABLE KEYS */;
INSERT INTO `Leave_Record` VALUES (1,'2017-11-14','Earned','Y'),(1,'2017-11-15','Medical','Y'),(1,'2017-11-16','Medical','C'),(1,'2017-11-18','Medical','C'),(4,'2016-07-20','Medical','N'),(4,'2017-11-14','Medical','N'),(5,'2017-11-07','Earned','Y'),(5,'2017-11-09','Casual','C'),(5,'2017-11-11','Earned','N'),(8,'2017-11-13','Medical','C'),(8,'2017-11-15','Medical','Y');
/*!40000 ALTER TABLE `Leave_Record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Orders_Placed`
--

DROP TABLE IF EXISTS `Orders_Placed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Orders_Placed` (
  `EID` int(11) NOT NULL,
  `OID` int(11) NOT NULL,
  PRIMARY KEY (`EID`,`OID`),
  KEY `OID` (`OID`),
  CONSTRAINT `orders_placed_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `orders_placed_ibfk_2` FOREIGN KEY (`OID`) REFERENCES `Orders` (`OID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Orders_Placed`
--

LOCK TABLES `Orders_Placed` WRITE;
/*!40000 ALTER TABLE `Orders_Placed` DISABLE KEYS */;
INSERT INTO `Orders_Placed` VALUES (1,1),(8,2),(9,4),(5,5),(5,6),(4,7);
/*!40000 ALTER TABLE `Orders_Placed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pay_Scale`
--

DROP TABLE IF EXISTS `Pay_Scale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Pay_Scale` (
  `EID` int(11) NOT NULL,
  `SID` int(11) NOT NULL,
  PRIMARY KEY (`EID`,`SID`),
  KEY `SID` (`SID`),
  CONSTRAINT `pay_scale_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pay_scale_ibfk_2` FOREIGN KEY (`SID`) REFERENCES `Salary` (`SID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pay_Scale`
--

LOCK TABLES `Pay_Scale` WRITE;
/*!40000 ALTER TABLE `Pay_Scale` DISABLE KEYS */;
INSERT INTO `Pay_Scale` VALUES (4,2),(7,2),(5,6),(6,6),(12,7),(14,7),(1,8);
/*!40000 ALTER TABLE `Pay_Scale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Payment`
--

DROP TABLE IF EXISTS `Payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Payment` (
  `Account_No` varchar(11) NOT NULL,
  `IFSC` char(11) NOT NULL,
  `SID` int(11) NOT NULL,
  `Date` date NOT NULL,
  `Deductions` int(11) DEFAULT '0',
  PRIMARY KEY (`Account_No`,`IFSC`,`Date`),
  KEY `SID` (`SID`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`Account_No`, `IFSC`) REFERENCES `Employee_Account` (`Account_No`, `IFSC`) ON UPDATE CASCADE,
  CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`SID`) REFERENCES `Salary` (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payment`
--

LOCK TABLES `Payment` WRITE;
/*!40000 ALTER TABLE `Payment` DISABLE KEYS */;
INSERT INTO `Payment` VALUES ('23892810482','SBI00000832',8,'2017-10-14',500),('23892810482','SBI00000832',8,'2017-11-05',16),('23892810482','SBI00000832',8,'2017-11-10',16),('23892811923','SBI00000912',6,'2017-11-05',475),('23892811923','SBI00000912',6,'2017-11-10',91),('23892812183','SBI00000661',2,'2017-11-10',27),('28727237372','SBI00000588',2,'2017-11-05',0),('28727237372','SBI00000588',2,'2017-11-10',90),('32859423849','ICICI000023',7,'2017-11-10',90),('38294823948','SBI00002343',7,'2017-11-10',90),('89352834928','SBI00000134',6,'2017-11-05',75);
/*!40000 ALTER TABLE `Payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Payment_Loan`
--

DROP TABLE IF EXISTS `Payment_Loan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Payment_Loan` (
  `Account_No` varchar(11) NOT NULL,
  `IFSC` char(11) NOT NULL,
  `Date` date NOT NULL,
  `LID` int(11) NOT NULL,
  PRIMARY KEY (`Account_No`,`IFSC`,`Date`,`LID`),
  KEY `LID` (`LID`),
  CONSTRAINT `payment_loan_ibfk_1` FOREIGN KEY (`Account_No`, `IFSC`, `Date`) REFERENCES `Payment` (`Account_No`, `IFSC`, `Date`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `payment_loan_ibfk_2` FOREIGN KEY (`LID`) REFERENCES `Loan` (`LID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payment_Loan`
--

LOCK TABLES `Payment_Loan` WRITE;
/*!40000 ALTER TABLE `Payment_Loan` DISABLE KEYS */;
INSERT INTO `Payment_Loan` VALUES ('23892812183','SBI00000661','2017-11-10',2),('23892810482','SBI00000832','2017-11-05',4),('23892810482','SBI00000832','2017-11-10',4),('23892810482','SBI00000832','2017-11-05',8),('23892810482','SBI00000832','2017-11-10',8),('23892811923','SBI00000912','2017-11-05',9),('23892811923','SBI00000912','2017-11-10',9);
/*!40000 ALTER TABLE `Payment_Loan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Promotion`
--

DROP TABLE IF EXISTS `Promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Promotion` (
  `EID` int(11) NOT NULL,
  `Lower_PID` int(11) NOT NULL,
  `Lower_UID` int(11) NOT NULL,
  `Higher_PID` int(11) NOT NULL,
  `Higher_UID` int(11) NOT NULL,
  `Relieving_Date` date DEFAULT NULL,
  `Joining_Date` date DEFAULT NULL,
  PRIMARY KEY (`EID`,`Lower_PID`,`Lower_UID`,`Higher_PID`,`Higher_UID`),
  KEY `Lower_PID` (`Lower_PID`,`Lower_UID`),
  KEY `Higher_PID` (`Higher_PID`,`Higher_UID`),
  CONSTRAINT `promotion_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `promotion_ibfk_2` FOREIGN KEY (`Lower_PID`, `Lower_UID`) REFERENCES `Post` (`PID`, `UID`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `promotion_ibfk_3` FOREIGN KEY (`Higher_PID`, `Higher_UID`) REFERENCES `Post` (`PID`, `UID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Promotion`
--

LOCK TABLES `Promotion` WRITE;
/*!40000 ALTER TABLE `Promotion` DISABLE KEYS */;
INSERT INTO `Promotion` VALUES (5,3,2,1,3,'2017-11-09','2017-11-10'),(5,7,3,1,2,'2017-11-10','2017-11-11'),(7,8,2,6,1,'2017-11-10','2017-11-11');
/*!40000 ALTER TABLE `Promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Rates`
--

DROP TABLE IF EXISTS `Rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Rates` (
  `Date` date NOT NULL,
  `DA_Rate` int(11) NOT NULL,
  `A_HRA` int(11) NOT NULL,
  `B_HRA` int(11) NOT NULL,
  `C_HRA` int(11) NOT NULL,
  `MA` int(11) NOT NULL,
  `Income_Tax` varchar(100) NOT NULL,
  `Interest_Rate` int(11) NOT NULL,
  `Provident_Fund` int(11) NOT NULL,
  `GIS` int(11) NOT NULL,
  PRIMARY KEY (`Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Rates`
--

LOCK TABLES `Rates` WRITE;
/*!40000 ALTER TABLE `Rates` DISABLE KEYS */;
INSERT INTO `Rates` VALUES ('0001-01-01',5,30,20,10,500,'0:0+0:250000;250000:0+5:500000;500000:25000+20:1000000;1000000:125000+30:-1',9,10,10);
/*!40000 ALTER TABLE `Rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Regularisation`
--

DROP TABLE IF EXISTS `Regularisation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Regularisation` (
  `EID` int(11) NOT NULL,
  `Date` date NOT NULL,
  `PID` int(11) NOT NULL,
  `UID` int(11) NOT NULL,
  PRIMARY KEY (`EID`,`Date`,`PID`,`UID`),
  KEY `PID` (`PID`,`UID`),
  CONSTRAINT `regularisation_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `regularisation_ibfk_2` FOREIGN KEY (`PID`, `UID`) REFERENCES `Post` (`PID`, `UID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Regularisation`
--

LOCK TABLES `Regularisation` WRITE;
/*!40000 ALTER TABLE `Regularisation` DISABLE KEYS */;
INSERT INTO `Regularisation` VALUES (4,'2017-11-01',1,2),(7,'2017-11-02',1,2),(5,'2017-11-02',3,2),(6,'2017-11-02',4,2),(12,'2017-11-10',6,1),(14,'2017-11-10',8,1);
/*!40000 ALTER TABLE `Regularisation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Resignation`
--

DROP TABLE IF EXISTS `Resignation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Resignation` (
  `EID` int(11) NOT NULL,
  `Date` date NOT NULL,
  `Reason` varchar(100) DEFAULT 'NIL',
  `w_e_f` date DEFAULT NULL,
  PRIMARY KEY (`EID`,`Date`),
  CONSTRAINT `resignation_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Resignation`
--

LOCK TABLES `Resignation` WRITE;
/*!40000 ALTER TABLE `Resignation` DISABLE KEYS */;
/*!40000 ALTER TABLE `Resignation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Retirement`
--

DROP TABLE IF EXISTS `Retirement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Retirement` (
  `EID` int(11) NOT NULL,
  `Date` date DEFAULT NULL,
  `Pension` int(11) DEFAULT NULL,
  PRIMARY KEY (`EID`),
  CONSTRAINT `retirement_ibfk_1` FOREIGN KEY (`EID`) REFERENCES `Employee` (`EID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Retirement`
--

LOCK TABLES `Retirement` WRITE;
/*!40000 ALTER TABLE `Retirement` DISABLE KEYS */;
/*!40000 ALTER TABLE `Retirement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Salary`
--

DROP TABLE IF EXISTS `Salary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Salary` (
  `SID` int(11) NOT NULL AUTO_INCREMENT,
  `Basic_Pay` int(11) NOT NULL,
  `Grade_Pay` int(11) NOT NULL,
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Salary`
--

LOCK TABLES `Salary` WRITE;
/*!40000 ALTER TABLE `Salary` DISABLE KEYS */;
INSERT INTO `Salary` VALUES (1,39100,5400),(2,15600,5400),(3,34800,5400),(4,9300,5400),(5,34800,4600),(6,9300,4600),(7,34800,4200),(8,9300,4200),(9,20200,1800),(10,5200,1800),(11,7440,1300),(12,4440,1300);
/*!40000 ALTER TABLE `Salary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (3,'Employee_Contract_Based'),(1,'Employee_Regularised'),(4,'Head_of_Head'),(6,'ULB_Accountant'),(5,'ULB_admin'),(2,'ULB_Head');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (1,4,1),(2,4,2),(3,4,3),(4,4,4),(5,4,5),(6,4,6),(7,4,7),(8,4,8),(9,4,9),(10,4,10),(11,4,11),(12,4,12),(13,4,13),(14,4,14),(15,4,15),(16,4,16),(17,4,17),(18,4,18);
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can add permission',2,'add_permission'),(5,'Can change permission',2,'change_permission'),(6,'Can delete permission',2,'delete_permission'),(7,'Can add group',3,'add_group'),(8,'Can change group',3,'change_group'),(9,'Can delete group',3,'delete_group'),(10,'Can add user',4,'add_user'),(11,'Can change user',4,'change_user'),(12,'Can delete user',4,'delete_user'),(13,'Can add content type',5,'add_contenttype'),(14,'Can change content type',5,'change_contenttype'),(15,'Can delete content type',5,'delete_contenttype'),(16,'Can add session',6,'add_session'),(17,'Can change session',6,'change_session'),(18,'Can delete session',6,'delete_session');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$36000$QawHBFl9Fxtu$auQwN3BWYmwQLcc1ShBmmSqiWdzt4W2UougqpAwHJXw=','2017-11-10 19:11:58.691842',1,'Deevashwer','','','deevashwerrathee10@gmail.com',1,1,'2017-10-28 01:10:30.000000'),(3,'pbkdf2_sha256$36000$eI6cGgl0Fp5n$gkIUdT2xgY9mBXsRefMPqIEQ2GAnzgZ989FaUxwYAcg=','2017-11-10 17:29:10.228974',0,'Ketan-4','','','',0,1,'2017-11-01 22:55:24.691377'),(4,'pbkdf2_sha256$36000$LeB9SspR9E0d$6QzghfJthaloDFZ1GJPbPJpdkfzozbShPx/xn7A4VRI=','2017-11-10 16:11:17.109512',0,'Chaitanya-5','','','',0,1,'2017-11-02 00:25:05.809205'),(5,'pbkdf2_sha256$36000$yswGBjFMCRnM$KJg5H9qVOR3m1khuEybweZC1TqgBn1ZpMSRoAWl5nZ4=','2017-11-10 18:55:54.927976',0,'Dhawal-6','','','',0,1,'2017-11-02 08:00:36.887046'),(6,'pbkdf2_sha256$36000$jH1bVT6zkutI$OrtLr6qUXHn/WaNNjyilMCTxAJLmg+zxBOMnazPzfFE=','2017-11-10 16:12:12.408174',0,'Mayank-7','','','',0,1,'2017-11-02 21:04:42.767032'),(7,'pbkdf2_sha256$36000$1qHSvcVAfrhW$VaA8h3pSIWJAgux1QZmIeg+g2bR2679hz61+3zlzKsY=','2017-11-10 06:34:37.059424',0,'Karan-8','','','',0,1,'2017-11-03 00:59:43.741817'),(8,'pbkdf2_sha256$36000$PTwJ4WyAtCB6$AZMSPsqK5DjZF4kBCmnRAp+9i8cD7ESmizsHvNZffAo=','2017-11-10 06:58:08.797061',0,'Aakash-9','','','',0,1,'2017-11-08 21:49:46.957658'),(11,'pbkdf2_sha256$36000$D9HsnF55IP7r$D+eyy4pVOhnP/KbmbqBD0strcrqsAVsflorollZQ9NE=','2017-11-10 15:32:34.530646',0,'Adit-12','','','',0,1,'2017-11-10 15:25:25.509485'),(13,'pbkdf2_sha256$36000$QRTM9ErZEQwF$OFdjBp8WneW9RD+PclXkn9hcXUhElCw17FsnR9wVsVo=','2017-11-10 16:11:50.970749',0,'Rahul-14','','','',0,1,'2017-11-10 15:32:13.003891');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (9,1,5),(8,3,4),(10,4,2),(11,5,6),(12,6,5),(13,7,3),(14,8,3),(17,11,6),(19,13,1);
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_payment`
--

DROP TABLE IF EXISTS `contract_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_payment` (
  `Account_No` varchar(11) NOT NULL,
  `IFSC` char(11) NOT NULL,
  `Date` date NOT NULL,
  `CID` int(11) NOT NULL,
  `Deductions` int(11) DEFAULT '0',
  PRIMARY KEY (`Account_No`,`IFSC`,`Date`,`CID`),
  KEY `CID` (`CID`),
  CONSTRAINT `contract_payment_ibfk_1` FOREIGN KEY (`Account_No`, `IFSC`) REFERENCES `Employee_Account` (`Account_No`, `IFSC`),
  CONSTRAINT `contract_payment_ibfk_2` FOREIGN KEY (`CID`) REFERENCES `Contracts` (`CID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_payment`
--

LOCK TABLES `contract_payment` WRITE;
/*!40000 ALTER TABLE `contract_payment` DISABLE KEYS */;
INSERT INTO `contract_payment` VALUES ('23423425252','SBI00000324','2017-11-10',2,0),('28727237372','SBI00000360','2017-11-05',1,500),('28727237372','SBI00000360','2017-11-10',1,0);
/*!40000 ALTER TABLE `contract_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contracts`
--

DROP TABLE IF EXISTS `contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contracts` (
  `CID` int(11) NOT NULL AUTO_INCREMENT,
  `Contract` varchar(100) NOT NULL,
  `Salary` int(11) NOT NULL,
  `Date_Started` date DEFAULT NULL,
  `End_Date` date DEFAULT NULL,
  `uid` int(11) NOT NULL,
  PRIMARY KEY (`CID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contracts`
--

LOCK TABLES `contracts` WRITE;
/*!40000 ALTER TABLE `contracts` DISABLE KEYS */;
INSERT INTO `contracts` VALUES (1,'Improve road condition to prevent sliding during rainy season.',15000,'2017-11-07','2017-12-07',2),(2,'Fix network lines',20000,'2017-11-08','2018-01-08',1),(3,'Fixing LAN Ports',1000,'2017-11-10','2017-11-12',1);
/*!40000 ALTER TABLE `contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2017-10-28 01:11:13.000622','1','Employee',1,'[{\"added\": {}}]',3,1),(2,'2017-10-28 01:11:25.174447','2','ULB_Head',1,'[{\"added\": {}}]',3,1),(3,'2017-10-28 01:11:35.988770','1','Employee_Regularised',2,'[{\"changed\": {\"fields\": [\"name\"]}}]',3,1),(4,'2017-10-28 01:11:58.934737','3','Employee_Contract_Based',1,'[{\"added\": {}}]',3,1),(5,'2017-10-28 01:16:26.264843','4','Head_of_Head',1,'[{\"added\": {}}]',3,1),(6,'2017-10-31 22:56:09.415258','1','Deevashwer',2,'[{\"changed\": {\"fields\": [\"groups\"]}}]',4,1),(7,'2017-11-01 15:52:01.038546','5','ULB_admin',1,'[{\"added\": {}}]',3,1),(8,'2017-11-01 16:28:53.387344','1','Deevashwer',2,'[{\"changed\": {\"fields\": [\"groups\"]}}]',4,1),(9,'2017-11-01 18:47:41.137066','1','Deevashwer',2,'[{\"changed\": {\"fields\": [\"groups\"]}}]',4,1),(10,'2017-11-01 18:48:51.295052','1','Deevashwer',2,'[{\"changed\": {\"fields\": [\"groups\"]}}]',4,1),(11,'2017-11-01 19:52:30.982032','1','Deevashwer',2,'[{\"changed\": {\"fields\": [\"groups\"]}}]',4,1),(12,'2017-11-01 19:53:15.619920','1','Deevashwer',2,'[{\"changed\": {\"fields\": [\"groups\"]}}]',4,1),(13,'2017-11-01 22:31:38.407478','2','2',3,'',4,1),(14,'2017-11-01 23:05:12.325887','3','Ketan-4',2,'[{\"changed\": {\"fields\": [\"password\"]}}]',4,1),(15,'2017-11-01 23:16:36.937124','1','Deevashwer',2,'[{\"changed\": {\"fields\": [\"groups\"]}}]',4,1),(16,'2017-11-01 23:27:48.470904','1','Deevashwer',2,'[{\"changed\": {\"fields\": [\"password\"]}}]',4,1),(17,'2017-11-01 23:32:33.772656','1','Deevashwer',2,'[{\"changed\": {\"fields\": [\"groups\"]}}]',4,1),(18,'2017-11-04 13:29:20.708892','6','ULB_Accountant',1,'[{\"added\": {}}]',3,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2017-10-28 01:09:51.614559'),(2,'auth','0001_initial','2017-10-28 01:09:52.029077'),(3,'admin','0001_initial','2017-10-28 01:09:52.091279'),(4,'admin','0002_logentry_remove_auto_add','2017-10-28 01:09:52.121005'),(5,'contenttypes','0002_remove_content_type_name','2017-10-28 01:09:52.189829'),(6,'auth','0002_alter_permission_name_max_length','2017-10-28 01:09:52.215794'),(7,'auth','0003_alter_user_email_max_length','2017-10-28 01:09:52.243664'),(8,'auth','0004_alter_user_username_opts','2017-10-28 01:09:52.256270'),(9,'auth','0005_alter_user_last_login_null','2017-10-28 01:09:52.283471'),(10,'auth','0006_require_contenttypes_0002','2017-10-28 01:09:52.285583'),(11,'auth','0007_alter_validators_add_error_messages','2017-10-28 01:09:52.300979'),(12,'auth','0008_alter_user_username_max_length','2017-10-28 01:09:52.328507'),(13,'sessions','0001_initial','2017-10-28 01:09:52.359937');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('3xk0nytwv3246l9g9exib94yts8i98r8','NzI3NDgyMGYyN2VlM2VkM2Q5ZGMwNTQ2NWRlZjQyYzVhYWViNjUzMTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJkNGRjNTdjZDk0NjcwYTFjMTEzMGUwYWZiOTQ2ZTIxYmRjMmVkYmRjIn0=','2017-11-24 19:11:58.694689'),('6slceprddl7vsshlk4ry9fg77ygqzahl','YWQ2MmZmZDM5MjVlNmFjZGQ4ODg4MTNiYWY4NWY3ODA1NmE1NTdhODp7Il9hdXRoX3VzZXJfaWQiOiI2IiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2Mjk5ZDNiYjRkZTA3Y2NlNDdkNDU4OWZjMDZhNzNjYjk1MmI3MGQwIn0=','2017-11-24 08:55:02.909563'),('9vgt2bo9a4xke8ai32y7bscxmkalyxsg','NGJlMTNhMzM2ODRkZDY2NTExYjY4NzQ5MTMyZTIzZjE3ZjM1M2UyNTp7Il9hdXRoX3VzZXJfaWQiOiIzIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJkYmI1NWQyOTE5YTRhZTRjMTVmODQyNDgwZDc3OTFkMGI3NDNjNTAzIn0=','2017-11-24 08:19:45.210172'),('bu35j0q6sfz65tdqgictjqas9vnb1qf1','NWQ3Mjc4ZWM4MTNlMjBiN2E2ZGVmMGIzNGI0YzMxYTJmMTAyYjQ1Yzp7fQ==','2017-11-15 22:57:56.281403'),('gflh6qecsop3ed8bcn2v7vgvhal9s7lg','NWQ3Mjc4ZWM4MTNlMjBiN2E2ZGVmMGIzNGI0YzMxYTJmMTAyYjQ1Yzp7fQ==','2017-11-15 22:25:39.646426'),('h17ahv7yy7eguy4sd4o3qlfbve2t1hie','NzI3NDgyMGYyN2VlM2VkM2Q5ZGMwNTQ2NWRlZjQyYzVhYWViNjUzMTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJkNGRjNTdjZDk0NjcwYTFjMTEzMGUwYWZiOTQ2ZTIxYmRjMmVkYmRjIn0=','2017-11-17 02:20:29.914176'),('ii67xgtuhctvd8fxpdptkh4zfwr1bbyh','NWQ3Mjc4ZWM4MTNlMjBiN2E2ZGVmMGIzNGI0YzMxYTJmMTAyYjQ1Yzp7fQ==','2017-11-15 23:06:09.355475'),('jc8stxnceucrixi3urz209wx0m5rifse','YjI2OTc2MTMxOTJmZDlkYThjYWJkYmQ0YjdiMWFhMTE4YjQ1NGFhYzp7Il9hdXRoX3VzZXJfaWQiOiI1IiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJhYjA2NTcyZGY5ZWNjYTMzOTMwYTYyYWJkNzFjM2JiYTk0N2NjZDljIn0=','2017-11-17 13:56:21.395019'),('mr95gr8k8xr8hcb1gdy690m79lih2k4h','YWQ2MmZmZDM5MjVlNmFjZGQ4ODg4MTNiYWY4NWY3ODA1NmE1NTdhODp7Il9hdXRoX3VzZXJfaWQiOiI2IiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2Mjk5ZDNiYjRkZTA3Y2NlNDdkNDU4OWZjMDZhNzNjYjk1MmI3MGQwIn0=','2017-11-24 06:16:06.289118'),('oqb52giszobhgx2288ip65z2nzd2pcpg','NWQ3Mjc4ZWM4MTNlMjBiN2E2ZGVmMGIzNGI0YzMxYTJmMTAyYjQ1Yzp7fQ==','2017-11-15 22:56:37.631910'),('s670zifuk5gclqe3w5xfpm3omgdgl5j9','NWQ3Mjc4ZWM4MTNlMjBiN2E2ZGVmMGIzNGI0YzMxYTJmMTAyYjQ1Yzp7fQ==','2017-11-15 23:28:24.521919'),('y04wh4ijhkjrv6sh3io5c2ipljjkapxl','MzgxNWU3Y2YwMjc3OGZhNDVkZWEzZjRhZmY2Yjg2MDBmZDM1YTZjZjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5Nzg1YmUwOTQ3YzI2M2VhYWExODBkOGZkZGQzMDFlNjc4YzJjNjQ2In0=','2017-11-15 23:25:10.379371');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan`
--

DROP TABLE IF EXISTS `loan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loan` (
  `LID` int(11) NOT NULL AUTO_INCREMENT,
  `Amount` int(11) NOT NULL,
  `Date` date NOT NULL,
  `Duration` int(11) NOT NULL,
  `Type` varchar(10) DEFAULT NULL,
  `Status` char(1) DEFAULT 'N',
  `Paid` int(11) DEFAULT '0',
  `months` int(11) DEFAULT '0',
  PRIMARY KEY (`LID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan`
--

LOCK TABLES `loan` WRITE;
/*!40000 ALTER TABLE `loan` DISABLE KEYS */;
INSERT INTO `loan` VALUES (2,15000,'2017-10-18',1,'Medical','Y',1362,1),(4,13000,'2017-11-02',2,'Festival','Y',590,2),(8,40000,'2017-11-05',4,'House','Y',908,2),(9,100000,'2017-11-05',1,'Marriage','Y',9083,2),(10,14000,'2017-11-05',1,'Festival','N',0,0),(12,20000,'2017-11-10',2,'Marriage','C',0,0),(13,25000,'2017-11-10',1,'Festival','Y',0,0);
/*!40000 ALTER TABLE `loan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `OID` int(11) NOT NULL AUTO_INCREMENT,
  `Quantity` int(11) NOT NULL,
  `Item` varchar(20) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `Approved` char(1) DEFAULT 'N',
  PRIMARY KEY (`OID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,2,'Tube','2017-11-04','Y'),(2,2,'Cement','2017-11-04','C'),(3,2,'Tube','2017-11-05','N'),(4,500,'Optical Fibre Cables','2017-11-08','Y'),(5,10,'LAN cables','2017-11-10','Y'),(6,10,'LAN Ports','2017-11-10','Y'),(7,6,'Tubes','2017-11-10','Y');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post` (
  `PID` int(11) NOT NULL,
  `UID` int(11) NOT NULL,
  `post_name` varchar(30) DEFAULT NULL,
  `Class` char(7) DEFAULT NULL,
  `number` int(11) NOT NULL,
  PRIMARY KEY (`PID`,`UID`),
  KEY `UID` (`UID`),
  CONSTRAINT `post_ibfk_1` FOREIGN KEY (`UID`) REFERENCES `ULB` (`UID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES (1,1,'Executive Officer','Class A',0),(1,2,'Executive Officer','Class A',0),(1,3,'Executive Officer','Class A',1),(2,1,'Municipal Engineer','Class B',1),(2,2,'Municipal Engineer','Class B',1),(2,3,'Municipal Engineer','Class B',1),(3,1,'Secretary','Class C',1),(3,2,'Secretary','Class C',1),(3,3,'Secretary','Class C',1),(4,1,'Junior Engineer','Class C',1),(4,2,'Junior Engineer','Class C',0),(4,3,'Junior Engineer','Class C',1),(5,1,'Sanitary Inspector','Class C',1),(5,2,'Sanitary Inspector','Class C',1),(5,3,'Sanitary Inspector','Class C',1),(6,1,'Accountant','Class D',0),(6,2,'Accountant','Class D',0),(6,3,'Accountant','Class D',1),(7,1,'Superintendent','Class D',2),(7,2,'Superintendent','Class D',2),(7,3,'Superintendent','Class D',3),(8,1,'Assistant','Class D',3),(8,2,'Assistant','Class D',4),(8,3,'Assistant','Class D',4),(9,1,'Clerk','Class E',6),(9,2,'Clerk','Class E',6),(9,3,'Clerk','Class E',6),(10,1,'Peon','Class F',10),(10,2,'Peon','Class F',10),(10,3,'Peon','Class F',10);
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ulb`
--

DROP TABLE IF EXISTS `ulb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ulb` (
  `UID` int(11) NOT NULL AUTO_INCREMENT,
  `ulb_name` varchar(40) DEFAULT NULL,
  `ULB_Type` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`UID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ulb`
--

LOCK TABLES `ulb` WRITE;
/*!40000 ALTER TABLE `ulb` DISABLE KEYS */;
INSERT INTO `ulb` VALUES (1,'Municipal Corporation, Gurgaon','Corporation'),(2,'Municipal Council, Rohtak','Council'),(3,'Municipal Committee, Sampla','Committee');
/*!40000 ALTER TABLE `ulb` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-11-11 13:26:41
