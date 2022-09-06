SELECT MAX(m.datemsg) AS lastdate, m.ChatRoomId,m.mensaje, m.userid, su.username, su.profile_img,cr.RoomName
FROM mensajes AS m
INNER JOIN siteuser AS su 
ON m.userid=su.userid
INNER JOIN chatroom AS cr
ON cr.idRoom=m.ChatRoomId
WHERE m.ChatRoomId IN (SELECT ChatRoomId FROM mensajes WHERE userid=1)
GROUP BY m.ChatRoomId

SELECT cr.idRoom,cr.RoomName FROM chatroom AS cr 
INNER JOIN userinroom AS uir ON cr.idRoom=uir.idroom 
INNER JOIN siteuser AS su ON uir.iduser=su.userid
WHERE su.userid=1;

SELECT *  FROM mensajes AS m INNER JOIN siteuser AS su ON m.userid=su.userid INNER JOIN chatroom AS cr ON m.ChatRoomId=cr.idRoom WHERE m.ChatRoomId=10 ORDER BY m.idmsg ASC;
SELECT *  FROM mensajes AS m INNER JOIN siteuser AS su ON m.userid=su.userid WHERE m.ChatRoomId=idRoomS ORDER BY m.idmsg ASC;Get_MessagesGet_Messages




SELECT MAX(m.datemsg) AS lastdate, m.ChatRoomId,m.mensaje, m.userid, su.username, su.profile_img,cr.RoomName
		FROM mensajes AS m
		INNER JOIN siteuser AS su 
		ON m.userid=su.userid
		INNER JOIN chatroom AS cr
		ON cr.idRoom=m.ChatRoomId
		WHERE m.ChatRoomId IN (SELECT idroom FROM userinroom WHERE iduser=1)
		GROUP BY m.ChatRoomId;
		
SET @imgprofile='/static/img/no_user.png';
		
SELECT uir.*, 
		(SELECT mensaje FROM mensajes WHERE idmsg=(SELECT MAX(idmsg) FROM mensajes WHERE ChatRoomId=1)) AS 'LastMessage',
		(SELECT datemsg FROM mensajes WHERE idmsg=(SELECT MAX(idmsg) FROM mensajes WHERE ChatRoomId=1)) AS 'LastDateMsg',
		(SELECT username FROM siteuser WHERE userid=(SELECT DISTINCT(userid) FROM mensajes WHERE datemsg=(SELECT MAX(datemsg)FROM mensajes WHERE chatroomid=uir.idroom))) AS 'LastUser',
		@imgprofile AS 'profile_img'
FROM userinroom AS uir
WHERE uir.iduser=1 AND uir.idroom=1
union
SELECT uir.*, 
	(SELECT mensaje FROM mensajes WHERE idmsg=(SELECT MAX(idmsg) FROM mensajes WHERE chatroomid=uir.idroom)) AS 'LastMessage',
	(SELECT datemsg FROM mensajes WHERE idmsg=(SELECT MAX(idmsg) FROM mensajes WHERE chatroomid=uir.idroom)) AS 'LastDateMsg',
	(SELECT username FROM siteuser WHERE userid=(SELECT DISTINCT(userid) FROM mensajes WHERE datemsg=(SELECT MAX(datemsg)FROM mensajes WHERE chatroomid=uir.idroom))) AS 'LastUser',
	(SELECT profile_img FROM siteuser WHERE userid=(SELECT iduser FROM userinroom WHERE idroom=uir.idroom AND iduser!=1)) AS 'profile_img'
FROM userinroom AS uir
WHERE uir.iduser=1 AND uir.idroom!=1 AND (SELECT COUNT(mensaje) FROM mensajes WHERE userid=1 AND ChatRoomId=uir.idroom);




SELECT *, (SELECT lastMsgId FROM userinroom as uir WHERE uir.iduser=1 AND uir.idroom=1) AS'lastMsgId',
InsertarMSGInsertarMSG(SELECT MAX(idmsg) FROM mensajes as msg WHERE msg.ChatRoomId=1) AS'lastMsgOnRoom'
		FROM mensajes AS m 
		INNER JOIN siteuser AS su ON m.userid=su.userid 
		INNER JOIN chatroom AS cr ON m.ChatRoomId=cr.idRoom 
		WHERE m.ChatRoomId=1 ORDER BY m.idmsg ASC
		
SELECT msg.*,su.* 
FROM mensajes AS msg INNER JOIN siteuser AS su ON msg.userid=su.userid
WHERE msg.idmsg=(SELECT MAX(idmsg) FROM mensajes WHERE userid=1 AND ChatRoomId=1)


(SELECT m.*,su.userid,su.username,su.email,su.profile_img,cr.*, (SELECT lastMsgId FROM userinroom as uir WHERE uir.iduser=1 AND uir.idroom=1) AS'lastMsgId',
		(SELECT MAX(idmsg) FROM mensajes as msg WHERE msg.ChatRoomId=1) AS'lastMsgOnRoom'
		FROM mensajes AS m 
		INNER JOIN siteuser AS su ON m.userid=su.userid 
		INNER JOIN chatroom AS cr ON m.ChatRoomId=cr.idRoom 
		WHERE m.ChatRoomId=1 AND m.idmsg<=(SELECT uir.lastMsgId FROM userinroom AS uir WHERE uir.iduser=1 AND uir.idroom=1)
		ORDER BY m.idmsg ASC 
		LIMIT 10);
 
(SELECT *, (SELECT lastMsgId FROM userinroom as uir WHERE uir.iduser=1 AND uir.idroom=1) AS'lastMsgId',
		(SELECT MAX(idmsg) FROM mensajes as msg WHERE msg.ChatRoomId=1) AS'lastMsgOnRoom'
		FROM mensajes AS m 
		INNER JOIN siteuser AS su ON m.userid=su.userid 
		INNER JOIN chatroom AS cr ON m.ChatRoomId=cr.idRoom 
		WHERE m.ChatRoomId=1 AND m.idmsg>(SELECT uir.lastMsgId FROM userinroom AS uir WHERE uir.iduser=1 AND uir.idroom=1)
		ORDER BY m.idmsg ASC 
		LIMIT 10) 


SELECT idmsg FROM mensajes AS m
INNER JOIN userinroom AS uir
ON m.userid=uir.iduser
WHERE m.ChatRoomId =1 AND m.idmsg>=(SELECT lastMsgId FROM userinroom WHERE iduser=1)
ORDER BY m.idmsg


(SELECT *, (SELECT lastMsgId FROM userinroom as uir WHERE uir.iduser=iduserChat AND uir.idroom=idRoomS) AS'lastMsgId',
		(SELECT MAX(idmsg) FROM mensajes as msg WHERE msg.ChatRoomId=idRoomS) AS'lastMsgOnRoom'
		FROM mensajes AS m 
		INNER JOIN siteuser AS su ON m.userid=su.userid 
		INNER JOIN chatroom AS cr ON m.ChatRoomId=cr.idRoom 
		WHERE m.ChatRoomId=idRoomS AND m.idmsg<=(SELECT uir.lastMsgId FROM userinroom AS uir WHERE uir.iduser=iduserChat AND uir.idroom=idRoomS)
		ORDER BY m.idmsg ASC 
		LIMIT 10) 
		UNION 
(SELECT *, (SELECT lastMsgId FROM userinroom as uir WHERE uir.iduser=iduserChat AND uir.idroom=idRoomS) AS'lastMsgId',
		(SELECT MAX(idmsg) FROM mensajes as msg WHERE msg.ChatRoomId=idRoomS) AS'lastMsgOnRoom'
		FROM mensajes AS m 
		INNER JOIN siteuser AS su ON m.userid=su.userid 
		INNER JOIN chatroom AS cr ON m.ChatRoomId=cr.idRoom 
		WHERE m.ChatRoomId=idRoomS AND m.idmsg>(SELECT uir.lastMsgId FROM userinroom AS uir WHERE uir.iduser=iduserChat AND uir.idroom=idRoomS)
		ORDER BY m.idmsg ASC 
		LIMIT 10);userinroom