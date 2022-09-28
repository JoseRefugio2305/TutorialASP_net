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

-- Volcando estructura para tabla mvctutorial.chatroom
CREATE TABLE IF NOT EXISTS `chatroom` (
  `idRoom` int(11) NOT NULL AUTO_INCREMENT,
  `RoomName` varchar(50) NOT NULL DEFAULT '0',
  `fechaInicio` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idRoom`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.chatroom: 4 rows
/*!40000 ALTER TABLE `chatroom` DISABLE KEYS */;
INSERT INTO `chatroom` (`idRoom`, `RoomName`, `fechaInicio`) VALUES
	(1, 'General', '2022-08-16 11:40:24'),
	(2, '0', '2022-08-18 12:07:31'),
	(3, '0', '2022-08-18 13:27:37'),
	(4, '0', '2022-08-19 11:37:53');
/*!40000 ALTER TABLE `chatroom` ENABLE KEYS */;

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

-- Volcando estructura para procedimiento mvctutorial.EditUserProfile
DELIMITER //
CREATE PROCEDURE `EditUserProfile`(
	IN `usernameE` VARCHAR(150),
	IN `useremailE` VARCHAR(150),
	IN `useridE` INT
)
BEGIN
	SET @existsuserE=if(EXISTS(SELECT * FROM siteuser WHERE (username = usernameE OR email=useremailE) AND userid!=useridE),1,0);
	if @existsuserE=0 then
	UPDATE siteuser SET username=usernameE,email=useremailE WHERE userid=useridE;
	SET @existsuserE="No Existe";
	ELSE
	SET @existsuserE="Existe";
	END if;
	
	SELECT @existsuserE AS is_exists;
END//
DELIMITER ;

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

-- Volcando estructura para procedimiento mvctutorial.Get_Messages
DELIMITER //
CREATE PROCEDURE `Get_Messages`(
	IN `iduserChat` INT,
	IN `optionC` INT,
	IN `idRoomS` INT
)
BEGIN
	/*UPDATE siteuser SET lastLoginChat=CURRENT_TIMESTAMP WHERE userid=iduserChat;*/
	if optionC=1 then
		 SELECT *, (SELECT lastMsgId FROM userinroom as uir WHERE uir.iduser=iduserChat AND uir.idroom=idRoomS) AS'lastMsgId',
		(SELECT MAX(idmsg) FROM mensajes as msg WHERE msg.ChatRoomId=idRoomS) AS'lastMsgOnRoom'
		FROM mensajes AS m 
		INNER JOIN siteuser AS su ON m.userid=su.userid 
		INNER JOIN chatroom AS cr ON m.ChatRoomId=cr.idRoom 
		WHERE m.ChatRoomId=idRoomS 
		ORDER BY m.idmsg ASC;
	ELSE 
		SET @imgprofile='/static/img/no_user.png';
		
		SELECT uir.*, 
				(SELECT mensaje FROM mensajes WHERE idmsg=(SELECT MAX(idmsg) FROM mensajes WHERE ChatRoomId=1)) AS 'LastMessage',
				(SELECT message_type FROM mensajes WHERE idmsg=(SELECT MAX(idmsg) FROM mensajes WHERE ChatRoomId=1)) AS 'type',
				(SELECT datemsg FROM mensajes WHERE idmsg=(SELECT MAX(idmsg) FROM mensajes WHERE ChatRoomId=1)) AS 'LastDateMsg',
				(SELECT username FROM siteuser WHERE userid=(SELECT DISTINCT(userid) FROM mensajes WHERE datemsg=(SELECT MAX(datemsg)FROM mensajes WHERE chatroomid=uir.idroom))) AS 'LastUser',
				@imgprofile AS 'profile_img',
				(SELECT COUNT(*) FROM mensajes WHERE ChatRoomId=1 AND idmsg>(SELECT lastMsgId FROM userinroom WHERE iduser=iduserChat AND idroom=1))
		FROM userinroom AS uir
		WHERE uir.iduser=iduserChat AND uir.idroom=1
		union
		SELECT uir.*, 
			(SELECT mensaje FROM mensajes WHERE idmsg=(SELECT MAX(idmsg) FROM mensajes WHERE chatroomid=uir.idroom)) AS 'LastMessage',
			(SELECT message_type FROM mensajes WHERE idmsg=(SELECT MAX(idmsg) FROM mensajes WHERE ChatRoomId=uir.idroom)) AS 'type',
			(SELECT datemsg FROM mensajes WHERE idmsg=(SELECT MAX(idmsg) FROM mensajes WHERE chatroomid=uir.idroom)) AS 'LastDateMsg',
			(SELECT username FROM siteuser WHERE userid=(SELECT DISTINCT(userid) FROM mensajes WHERE datemsg=(SELECT MAX(datemsg)FROM mensajes WHERE chatroomid=uir.idroom))) AS 'LastUser',
			(SELECT profile_img FROM siteuser WHERE userid=(SELECT iduser FROM userinroom WHERE idroom=uir.idroom AND iduser!=iduserChat)) AS 'profile_img',
			(SELECT COUNT(*) FROM mensajes WHERE ChatRoomId=uir.idroom AND idmsg>(SELECT lastMsgId FROM userinroom WHERE iduser=iduserChat AND idroom=uir.idroom))
		FROM userinroom AS uir
		WHERE uir.iduser=iduserChat AND uir.idroom!=1
		ORDER BY LastDateMsg DESC;
		
	END if;
END//
DELIMITER ;

-- Volcando estructura para procedimiento mvctutorial.InsertarMSG
DELIMITER //
CREATE PROCEDURE `InsertarMSG`(
	IN `usernamemsg` VARCHAR(150),
	IN `msgsend` VARCHAR(250),
	IN `idRoomMsg` INT,
	IN `MSGtype` INT
)
BEGIN
	SET @useridmsg=(SELECT su.userid FROM siteuser AS su WHERE username=usernamemsg);
	INSERT INTO mensajes (userid,mensaje,ChatRoomId,message_type) VALUES (@useridmsg,msgsend,idRoomMsg,MSGtype);
	SET @maxidmsg =(SELECT MAX(idmsg) FROM mensajes WHERE userid=@useridmsg AND ChatRoomId=idRoomMsg);
	UPDATE userinroom SET lastMsgId=@maxidmsg WHERE iduser=@useridmsg and idroom=idRoomMsg;
	SELECT msg.*,su.* 
	FROM mensajes AS msg INNER JOIN siteuser AS su ON msg.userid=su.userid
	WHERE msg.idmsg=@maxidmsg;
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
  `userid` int(11) NOT NULL,
  `mensaje` varchar(256) DEFAULT NULL,
  `idmsg` int(11) NOT NULL AUTO_INCREMENT,
  `datemsg` datetime DEFAULT CURRENT_TIMESTAMP,
  `ChatRoomId` int(11) DEFAULT '1',
  `message_type` int(11) DEFAULT '1',
  PRIMARY KEY (`idmsg`),
  KEY `FK_mensajes_siteuser` (`userid`),
  KEY `FK_mensajes_chatroom` (`ChatRoomId`),
  KEY `FK_mensajes_message_type` (`message_type`)
) ENGINE=MyISAM AUTO_INCREMENT=616 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.mensajes: 109 rows
/*!40000 ALTER TABLE `mensajes` DISABLE KEYS */;
INSERT INTO `mensajes` (`userid`, `mensaje`, `idmsg`, `datemsg`, `ChatRoomId`, `message_type`) VALUES
	(1, 'SDASD', 505, '2022-09-21 14:59:45', 1, 1),
	(2, 'ASDA', 506, '2022-09-21 14:59:54', 2, 1),
	(1, '/static/img/stikers/Bv.jpg', 598, '2022-09-22 13:38:40', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 599, '2022-09-22 13:38:40', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 600, '2022-09-22 13:38:40', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 601, '2022-09-22 13:38:40', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 602, '2022-09-22 13:38:40', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 603, '2022-09-22 13:38:40', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 604, '2022-09-22 13:38:40', 1, 2),
	(1, '/static/img/Chats/1/1/cargando.gif', 605, '2022-09-22 15:11:37', 1, 3),
	(1, '/static/img/Chats/1/1/PHPMailer-5.2.11.zip', 606, '2022-09-22 15:11:37', 1, 3),
	(1, '/static/img/Chats/1/1/PHPMailer-5.2.19.zip', 607, '2022-09-22 15:11:37', 1, 3),
	(1, '/static/img/Chats/1/1/REPORTE PRELIMINAR - Rivera Mendoza Roxana Elizab.pdf', 608, '2022-09-22 15:11:37', 1, 3),
	(1, 'dasd', 609, '2022-09-22 15:47:56', 1, 1),
	(1, '/static/img/Chats/1/1/casa-kame-de-dragon-ball_3840x2160_xtrafondos.com.jpg', 610, '2022-09-23 14:01:18', 1, 3),
	(1, '/static/img/Chats/1/1/creeper-de-minecraft_3840x2160_xtrafondos.com.jpg', 611, '2022-09-23 14:01:18', 1, 3),
	(1, '/static/img/Chats/1/1/saitama-one-punch-man_3840x2160_xtrafondos.com.jpg', 612, '2022-09-23 14:01:18', 1, 3),
	(2, '/static/img/stikers/Bv.jpg', 613, '2022-09-23 15:06:44', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 596, '2022-09-22 13:38:39', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 597, '2022-09-22 13:38:39', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 548, '2022-09-22 13:34:08', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 549, '2022-09-22 13:34:09', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 550, '2022-09-22 13:34:09', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 551, '2022-09-22 13:34:09', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 552, '2022-09-22 13:34:09', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 553, '2022-09-22 13:34:09', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 554, '2022-09-22 13:34:09', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 555, '2022-09-22 13:34:10', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 556, '2022-09-22 13:34:10', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 557, '2022-09-22 13:34:10', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 558, '2022-09-22 13:34:10', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 559, '2022-09-22 13:34:10', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 560, '2022-09-22 13:34:10', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 561, '2022-09-22 13:34:11', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 562, '2022-09-22 13:34:11', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 563, '2022-09-22 13:34:11', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 564, '2022-09-22 13:34:11', 1, 2),
	(1, '/static/img/stikers/no_nos_importa.jpg', 565, '2022-09-22 13:34:12', 1, 2),
	(1, '/static/img/stikers/no_nos_importa.jpg', 566, '2022-09-22 13:34:12', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 567, '2022-09-22 13:37:10', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 568, '2022-09-22 13:37:10', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 569, '2022-09-22 13:37:11', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 570, '2022-09-22 13:37:11', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 571, '2022-09-22 13:37:11', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 572, '2022-09-22 13:37:11', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 573, '2022-09-22 13:37:11', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 574, '2022-09-22 13:37:12', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 575, '2022-09-22 13:37:12', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 576, '2022-09-22 13:37:12', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 577, '2022-09-22 13:37:12', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 578, '2022-09-22 13:37:12', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 579, '2022-09-22 13:37:12', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 580, '2022-09-22 13:37:13', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 581, '2022-09-22 13:37:13', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 582, '2022-09-22 13:37:13', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 583, '2022-09-22 13:37:13', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 584, '2022-09-22 13:37:13', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 585, '2022-09-22 13:38:37', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 586, '2022-09-22 13:38:38', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 587, '2022-09-22 13:38:38', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 588, '2022-09-22 13:38:38', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 589, '2022-09-22 13:38:38', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 590, '2022-09-22 13:38:38', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 591, '2022-09-22 13:38:38', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 592, '2022-09-22 13:38:39', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 593, '2022-09-22 13:38:39', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 594, '2022-09-22 13:38:39', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 595, '2022-09-22 13:38:39', 1, 2),
	(2, 'ewedwed', 507, '2022-09-22 12:31:04', 1, 1),
	(2, 'wed', 508, '2022-09-22 12:31:05', 1, 1),
	(2, 'ewd', 509, '2022-09-22 12:31:05', 1, 1),
	(2, 'wed', 510, '2022-09-22 12:31:06', 1, 1),
	(2, 'ed', 511, '2022-09-22 12:31:06', 1, 1),
	(2, 'w', 512, '2022-09-22 12:31:06', 1, 1),
	(2, 'd', 513, '2022-09-22 12:31:06', 1, 1),
	(2, 'd', 514, '2022-09-22 12:31:06', 1, 1),
	(2, 'we', 515, '2022-09-22 12:31:07', 1, 1),
	(2, 'w', 516, '2022-09-22 12:31:07', 1, 1),
	(2, 'd', 517, '2022-09-22 12:31:07', 1, 1),
	(2, 'ewed', 518, '2022-09-22 12:31:11', 1, 1),
	(2, 'wedw', 519, '2022-09-22 12:31:12', 1, 1),
	(2, 'wedwe', 520, '2022-09-22 12:31:13', 1, 1),
	(1, 'erferf', 521, '2022-09-22 12:37:59', 1, 1),
	(1, 'erf', 522, '2022-09-22 12:38:00', 1, 1),
	(1, 'erf', 523, '2022-09-22 12:38:00', 1, 1),
	(1, 'erfe', 524, '2022-09-22 12:38:01', 1, 1),
	(1, 'rfe', 525, '2022-09-22 12:38:01', 1, 1),
	(1, 'rfe', 526, '2022-09-22 12:38:01', 1, 1),
	(1, 'rf', 527, '2022-09-22 12:38:02', 1, 1),
	(1, 'erf', 528, '2022-09-22 12:38:02', 1, 1),
	(1, 'erf', 529, '2022-09-22 12:38:02', 1, 1),
	(1, 'edwedw', 530, '2022-09-22 12:38:07', 1, 1),
	(1, 'wedw', 531, '2022-09-22 12:38:07', 1, 1),
	(1, 'edw', 532, '2022-09-22 12:38:07', 1, 1),
	(1, 'edw', 533, '2022-09-22 12:38:08', 1, 1),
	(1, 'ed', 534, '2022-09-22 12:38:08', 1, 1),
	(1, 'wedwed', 535, '2022-09-22 12:38:09', 1, 1),
	(2, 'fsfdsd', 536, '2022-09-22 13:30:33', 1, 1),
	(2, '/static/img/stikers/Bv.jpg', 537, '2022-09-22 13:30:35', 1, 2),
	(2, '/static/img/stikers/Bv.jpg', 538, '2022-09-22 13:30:35', 1, 2),
	(2, '/static/img/stikers/Bv.jpg', 539, '2022-09-22 13:30:36', 1, 2),
	(2, '/static/img/stikers/Bv.jpg', 540, '2022-09-22 13:30:36', 1, 2),
	(2, '/static/img/stikers/Bv.jpg', 541, '2022-09-22 13:30:36', 1, 2),
	(2, '/static/img/stikers/Bv.jpg', 542, '2022-09-22 13:30:36', 1, 2),
	(2, '/static/img/stikers/Bv.jpg', 543, '2022-09-22 13:30:36', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 544, '2022-09-22 13:34:08', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 545, '2022-09-22 13:34:08', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 546, '2022-09-22 13:34:08', 1, 2),
	(1, '/static/img/stikers/Bv.jpg', 547, '2022-09-22 13:34:08', 1, 2),
	(2, '/static/img/stikers/Bv.jpg', 614, '2022-09-28 14:30:23', 1, 2),
	(2, '/static/img/stikers/like.jpg', 615, '2022-09-28 14:30:24', 1, 2);
/*!40000 ALTER TABLE `mensajes` ENABLE KEYS */;

-- Volcando estructura para tabla mvctutorial.message_type
CREATE TABLE IF NOT EXISTS `message_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.message_type: 4 rows
/*!40000 ALTER TABLE `message_type` DISABLE KEYS */;
INSERT INTO `message_type` (`id`, `name`) VALUES
	(1, 'Texto'),
	(2, 'Stiker'),
	(3, 'Imagen'),
	(4, 'Archivo');
/*!40000 ALTER TABLE `message_type` ENABLE KEYS */;

-- Volcando estructura para procedimiento mvctutorial.RegisterUser
DELIMITER //
CREATE PROCEDURE `RegisterUser`(
	IN `newusername` VARCHAR(150),
	IN `newemail` VARCHAR(150),
	IN `newpass` VARCHAR(150)
)
BEGIN
INSERT INTO siteuser (username,email,password,roleid) VALUES(newusername,newemail,newpass,1);
SET @lastid=(SELECT MAX(userid) FROM siteuser);
INSERT INTO userinroom (iduser,idroom) VALUES(@lastid,1);
END//
DELIMITER ;

-- Volcando estructura para tabla mvctutorial.sites
CREATE TABLE IF NOT EXISTS `sites` (
  `SiteId` int(11) NOT NULL AUTO_INCREMENT,
  `EmployeeId` int(11) DEFAULT NULL,
  `SiteName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`SiteId`),
  KEY `FK__employee` (`EmployeeId`),
  CONSTRAINT `FK__employee` FOREIGN KEY (`EmployeeId`) REFERENCES `employee` (`EmployeeId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.sites: ~0 rows (aproximadamente)
INSERT INTO `sites` (`SiteId`, `EmployeeId`, `SiteName`) VALUES
	(1, 10, 'google.com');

-- Volcando estructura para tabla mvctutorial.siteuser
CREATE TABLE IF NOT EXISTS `siteuser` (
  `userid` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(150) DEFAULT 'Desconocido',
  `email` varchar(150) DEFAULT 'Desconocido',
  `password` varchar(150) DEFAULT '12345',
  `profile_img` varchar(256) DEFAULT '/static/img/no_user.png',
  `roleid` int(11) NOT NULL DEFAULT '1',
  `lastLogin` datetime DEFAULT CURRENT_TIMESTAMP,
  `lastLoginChat` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`userid`),
  KEY `FK_siteuser_userrole` (`roleid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.siteuser: 6 rows
/*!40000 ALTER TABLE `siteuser` DISABLE KEYS */;
INSERT INTO `siteuser` (`userid`, `username`, `email`, `password`, `profile_img`, `roleid`, `lastLogin`, `lastLoginChat`) VALUES
	(1, 'refu23', 'refu@mail.com', '12345', '/static/img/user/1/profile/1-14092022-32.jpg', 1, '2022-09-28 14:25:18', '2022-08-16 11:06:23'),
	(5, 'nuevo', 'new@mail.com', '12345', '/static/img/no_user.png', 1, '2022-08-18 11:17:11', '2022-08-18 11:17:11'),
	(2, 'a', 'refu1@mail.com', '12345', '/static/img/user/2/profile/2-20092022-48.gif', 2, '2022-09-28 14:26:38', '2022-08-16 10:16:23'),
	(3, 'b', 'correo@mail.com', '12345', '/static/img/no_user.png', 3, '2022-08-12 09:39:27', '2022-08-16 09:56:41'),
	(4, 'c', 'jose@mail.com', '12345', '/static/img/no_user.png', 1, '2022-08-19 11:41:24', '2022-08-16 09:56:41'),
	(6, 'refu2312', 'correoopcio121212nal2305@gmail.com', '12345', '/static/img/no_user.png', 1, '2022-09-14 11:32:02', '2022-09-14 11:32:02');
/*!40000 ALTER TABLE `siteuser` ENABLE KEYS */;

-- Volcando estructura para tabla mvctutorial.stikers
CREATE TABLE IF NOT EXISTS `stikers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ruta` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.stikers: 4 rows
/*!40000 ALTER TABLE `stikers` DISABLE KEYS */;
INSERT INTO `stikers` (`id`, `ruta`) VALUES
	(1, 'Bv.jpg'),
	(2, 'like.jpg'),
	(3, 'chale.jpg'),
	(4, 'no_nos_importa.jpg');
/*!40000 ALTER TABLE `stikers` ENABLE KEYS */;

-- Volcando estructura para tabla mvctutorial.userinroom
CREATE TABLE IF NOT EXISTS `userinroom` (
  `iduser` int(11) NOT NULL,
  `idroom` int(11) NOT NULL DEFAULT '1',
  `fechainicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `lastLoginChat` datetime DEFAULT CURRENT_TIMESTAMP,
  `lastMsgId` int(11) DEFAULT '1',
  KEY `FK__siteuser` (`iduser`),
  KEY `FK__chatroom` (`idroom`),
  KEY `FK_userinroom_mensajes` (`lastMsgId`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla mvctutorial.userinroom: 12 rows
/*!40000 ALTER TABLE `userinroom` DISABLE KEYS */;
INSERT INTO `userinroom` (`iduser`, `idroom`, `fechainicio`, `lastLoginChat`, `lastMsgId`) VALUES
	(1, 1, '2022-08-18 11:06:51', '2022-09-28 14:31:10', 613),
	(2, 1, '2022-08-18 11:06:57', '2022-09-28 14:30:11', 615),
	(3, 1, '2022-08-18 11:07:18', '2022-08-19 10:33:14', 1),
	(4, 4, '2022-08-18 11:07:25', '2022-08-19 10:33:14', 1),
	(5, 1, '2022-08-18 11:17:11', '2022-08-19 10:33:14', 1),
	(1, 2, '2022-08-18 12:08:07', '2022-09-28 14:31:22', 506),
	(2, 2, '2022-08-18 12:08:59', '2022-09-28 14:21:33', 506),
	(1, 3, '2022-08-18 13:27:47', '2022-08-24 12:53:13', 1),
	(3, 3, '2022-08-18 13:27:52', '2022-08-19 10:33:14', 1),
	(4, 1, '2022-08-19 11:37:41', '2022-08-19 11:37:41', 1),
	(5, 4, '2022-08-19 11:38:16', '2022-08-19 11:38:16', 1),
	(6, 1, '2022-09-14 11:32:02', '2022-09-14 11:32:02', 1);
/*!40000 ALTER TABLE `userinroom` ENABLE KEYS */;

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
