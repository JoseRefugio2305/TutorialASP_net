-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         5.7.36 - MySQL Community Server (GPL)
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.0.0.6468
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para mvctutorial
CREATE DATABASE IF NOT EXISTS `mvctutorial` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `mvctutorial`;

-- Volcando estructura para procedimiento mvctutorial.add_employee
DELIMITER //
CREATE PROCEDURE `add_employee`(
	IN nombre VARCHAR(50),
	IN deptid INT,
	IN address VARCHAR(50))
begin
	INSERT INTO employee (DepartmentId,Name,Address) Values (deptid,nombre,address);
END//
DELIMITER ;

-- Volcando estructura para tabla mvctutorial.department
CREATE TABLE IF NOT EXISTS `department` (
  `DepartmentId` int(11) NOT NULL AUTO_INCREMENT,
  `DeptName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`DepartmentId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.department: ~4 rows (aproximadamente)
INSERT INTO `department` (`DepartmentId`, `DeptName`) VALUES
	(1, 'IT'),
	(2, 'QA'),
	(3, 'Development'),
	(4, 'Marketing');

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
INSERT INTO `employee` (`EmployeeId`, `DepartmentId`, `Name`, `Address`, `IsDeleted`) VALUES
	(1, 1, 'Jose Refugio', 'Mexico', 0),
	(4, 3, 'Ashis', 'India', 0),
	(10, 1, 'Aniceto', 'Peru', 1);

-- Volcando estructura para procedimiento mvctutorial.ExistsUser
DELIMITER //
CREATE PROCEDURE `ExistsUser`(
	IN `usernameTest` VARCHAR(150),
	IN `useremailTest` VARCHAR(150)
)
BEGIN
	SET @isuser=if(EXISTS(SELECT * FROM siteuser WHERE username = usernameTest),'Existe','No Existe');
	SET @isuseremail=if(EXISTS(SELECT * FROM siteuser WHERE email = useremailTest),'Existe','No Existe');
	SELECT @isuser AS is_Username, @isuseremail AS is_Useremail;
END//
DELIMITER ;

-- Volcando estructura para procedimiento mvctutorial.InsertarMSG
DELIMITER //
CREATE PROCEDURE `InsertarMSG`(
	IN `usernamemsg` VARCHAR(150),
	IN `msgsend` VARCHAR(250)
)
BEGIN
	SET @useridmsg=(SELECT su.userid FROM siteuser AS su WHERE username=usernamemsg);
	INSERT INTO mensajes (userid,mensaje) VALUES (@useridmsg,msgsend);
END//
DELIMITER ;

-- Volcando estructura para procedimiento mvctutorial.LoginUser
DELIMITER //
CREATE PROCEDURE `LoginUser`(
	IN `emaillogin` VARCHAR(150),
	IN `passlogin` VARCHAR(150)
)
BEGIN
	SET @isuser=if(EXISTS(SELECT * FROM siteuser WHERE email=emaillogin AND password=passlogin),1,0);
	if @isuser=1 then
	UPDATE siteuser SET lastLogin=CURRENT_TIMESTAMP WHERE email=emaillogin;
	END IF;
	SELECT * FROM siteuser WHERE email=emaillogin AND password=passlogin;
END//
DELIMITER ;

-- Volcando estructura para tabla mvctutorial.mensajes
CREATE TABLE IF NOT EXISTS `mensajes` (
  `userid` int(11) DEFAULT NULL,
  `mensaje` varchar(256) DEFAULT NULL,
  `idmsg` int(11) NOT NULL AUTO_INCREMENT,
  `datemsg` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idmsg`),
  KEY `FK_mensajes_siteuser` (`userid`)
) ENGINE=MyISAM AUTO_INCREMENT=65 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.mensajes: 15 rows
/*!40000 ALTER TABLE `mensajes` DISABLE KEYS */;
INSERT INTO `mensajes` (`userid`, `mensaje`, `idmsg`, `datemsg`) VALUES
	(1, 'asd', 1, '2022-08-11 12:09:49'),
	(1, 'Este es un mensaje', 2, '2022-08-11 12:09:49'),
	(2, 'Este es otro usuario', 3, '2022-08-11 12:09:49'),
	(3, 'sd', 64, '2022-08-12 09:03:43'),
	(2, 'we', 63, '2022-08-12 09:03:37'),
	(1, 'wefwef', 62, '2022-08-11 13:56:55'),
	(1, 'a', 61, '2022-08-11 13:56:16'),
	(2, 'a', 60, '2022-08-11 13:56:12'),
	(1, 'edwedwedwedwedwed', 59, '2022-08-11 13:55:31'),
	(1, 'https://www.youtube.com/?gl=ES', 58, '2022-08-11 13:54:30'),
	(2, '1', 57, '2022-08-11 13:47:39'),
	(1, '1', 56, '2022-08-11 13:47:25'),
	(1, 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Explicabo dolor accusamus velit aperiam cupiditate soluta odio voluptates quod? Amet porro corrupti totam quis eum perspiciatis harum delectus maxime ea ad?dnskdnskdjfnskfjnskfjnsfksjfnskjfnssk', 53, '2022-08-11 13:41:09'),
	(1, 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Explicabo dolor accusamus velit aperiam cupiditate soluta odio voluptates quod? Amet porro corrupti totam quis eum perspiciatis harum delectus maxime ea ad?dnskdnskdLorem ipsum dolor sit amet c', 54, '2022-08-11 13:41:36'),
	(1, 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Explicabo dolor accusamus velit aperiam cupiditate soluta odio voluptates quod? Amet porro corrupti totam quis eum perspiciatis harum delectus maxime ea ad?dnskdnskdjfnsLorem ipsum dolor sit am', 55, '2022-08-11 13:41:57');
/*!40000 ALTER TABLE `mensajes` ENABLE KEYS */;

-- Volcando estructura para tabla mvctutorial.sites
CREATE TABLE IF NOT EXISTS `sites` (
  `SiteId` int(11) NOT NULL AUTO_INCREMENT,
  `EmployeeId` int(11) DEFAULT NULL,
  `SiteName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`SiteId`),
  KEY `FK__employee` (`EmployeeId`),
  CONSTRAINT `FK__employee` FOREIGN KEY (`EmployeeId`) REFERENCES `employee` (`EmployeeId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.sites: ~1 rows (aproximadamente)
INSERT INTO `sites` (`SiteId`, `EmployeeId`, `SiteName`) VALUES
	(1, 10, 'google.com');

-- Volcando estructura para tabla mvctutorial.siteuser
CREATE TABLE IF NOT EXISTS `siteuser` (
  `userid` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(150) DEFAULT 'Desconocido',
  `email` varchar(150) DEFAULT 'Desconocido',
  `password` varchar(150) DEFAULT '12345',
  `profile_img` varchar(100) DEFAULT '/static/img/no_user.png',
  `roleid` int(11) NOT NULL DEFAULT '1',
  `lastLogin` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`userid`),
  KEY `FK_siteuser_userrole` (`roleid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.siteuser: 4 rows
/*!40000 ALTER TABLE `siteuser` DISABLE KEYS */;
INSERT INTO `siteuser` (`userid`, `username`, `email`, `password`, `profile_img`, `roleid`, `lastLogin`) VALUES
	(1, 'refu', 'refu@mail.com', '12345', '/static/img/no_user.png', 1, '2022-08-12 09:35:37'),
	(2, 'refu2', 'joserefugioriveramendoza@gmail.com', '12345', '/static/img/no_user.png', 1, '2022-08-12 09:13:54'),
	(3, 'usuario3', 'mail3@mail.com', '12345', '/static/img/no_user.png', 3, '2022-08-12 09:39:27'),
	(4, 'Desconocido', 'Desconocido', '12345', '/static/img/no_user.png', 1, '2022-08-12 09:21:35');
/*!40000 ALTER TABLE `siteuser` ENABLE KEYS */;

-- Volcando estructura para tabla mvctutorial.userrole
CREATE TABLE IF NOT EXISTS `userrole` (
  `roleid` int(11) NOT NULL AUTO_INCREMENT,
  `rolename` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`roleid`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.userrole: 3 rows
/*!40000 ALTER TABLE `userrole` DISABLE KEYS */;
INSERT INTO `userrole` (`roleid`, `rolename`) VALUES
	(1, 'Ususario'),
	(2, 'Administrador'),
	(3, 'Super Administrador');
/*!40000 ALTER TABLE `userrole` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
