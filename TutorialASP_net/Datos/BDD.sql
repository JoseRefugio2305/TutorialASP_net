-- --------------------------------------------------------
-- Host:                         localhost
-- Versión del servidor:         5.7.24 - MySQL Community Server (GPL)
-- SO del servidor:              Win64
-- HeidiSQL Versión:             10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Volcando estructura de base de datos para mvctutorial
CREATE DATABASE IF NOT EXISTS `mvctutorial` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `mvctutorial`;

-- Volcando estructura para tabla mvctutorial.department
CREATE TABLE IF NOT EXISTS `department` (
  `DepartmentId` int(11) NOT NULL AUTO_INCREMENT,
  `DeptName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`DepartmentId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.department: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` (`DepartmentId`, `DeptName`) VALUES
	(1, 'IT'),
	(2, 'QA'),
	(3, 'Development'),
	(4, 'Marketing');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;

-- Volcando estructura para tabla mvctutorial.employee
CREATE TABLE IF NOT EXISTS `employee` (
  `EmployeeId` int(11) NOT NULL AUTO_INCREMENT,
  `DepartmentId` int(11) NOT NULL DEFAULT '1',
  `Name` varchar(50) DEFAULT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `IsDeleted` int(11) DEFAULT '0',
  PRIMARY KEY (`EmployeeId`),
  KEY `FK_employee_department` (`DepartmentId`),
  CONSTRAINT `FK_employee_department` FOREIGN KEY (`DepartmentId`) REFERENCES `department` (`DepartmentId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.employee: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` (`EmployeeId`, `DepartmentId`, `Name`, `Address`, `IsDeleted`) VALUES
	(1, 1, 'Jose Refugio', 'Mexico', 0),
	(4, 3, 'Ashis', 'India', 0),
	(10, 1, 'Aniceto', 'Peru', 0);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;

-- Volcando estructura para tabla mvctutorial.sites
CREATE TABLE IF NOT EXISTS `sites` (
  `SiteId` int(11) NOT NULL AUTO_INCREMENT,
  `EmployeeId` int(11) DEFAULT NULL,
  `SiteName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`SiteId`),
  KEY `FK__employee` (`EmployeeId`),
  CONSTRAINT `FK__employee` FOREIGN KEY (`EmployeeId`) REFERENCES `employee` (`EmployeeId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.sites: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` (`SiteId`, `EmployeeId`, `SiteName`) VALUES
	(1, 10, 'google.com');
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;

-- Volcando estructura para procedimiento mvctutorial.add_employee
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_employee`(
	IN `nombre` VARCHAR(50),
	IN `deptid` INT,
	IN `address` VARCHAR(50)

)
BEGIN
	INSERT INTO employee (DepartmentId,Name,Address) Values (deptid,nombre,address);
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
