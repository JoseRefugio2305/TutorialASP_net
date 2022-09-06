using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TutorialASP_net.Datos;
using TutorialASP_net.Filters;
using TutorialASP_net.Models;

namespace TutorialASP_net.Controllers
{
    
    public class ChatController : Controller
    {
        // GET: Chat
        //public static Dictionary<int, string> Rooms = new Dictionary<int, string>() { { 1, "Programacion" },{ 2, "Negocios" }  };
        [AuthorizationUser(role: "123")]
        public ActionResult Index()
        {
            Conexion bdd = new Conexion();
            List<ChatInbox> inboxList = new List<ChatInbox>();
            try
            {
                bdd.con.Open();
                MySqlCommand command = new MySqlCommand("CALL `Get_Messages`("+Session["userid"]+", 2, 0)", bdd.con);
                MySqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    inboxList.Add(new ChatInbox
                    {
                        idroom = (int)reader["idroom"],
                        roomname = (int)reader["idroom"]==1?"General": (string)reader["LastUser"],
                        lastMsgDate = (DateTime)reader["LastDateMsg"],
                        lastMsg=(string)reader["LastMessage"],
                        photoChat=(string)reader["profile_img"],
                        usernameLastMsg=(string)reader["LastUser"] == (string)Session["username"]?"Tú": (string)reader["LastUser"]
                    });

                }
                reader.Close();
                bdd.con.Close();
                if (inboxList.Count() == 0)
                {
                    inboxList = null;
                }
            }
            catch (Exception e)
            {
                string message = "Ocurrio un error al intentar el registro de usuario" + e;
            }
            return View(inboxList);
        }
        [AuthorizationUser(role: "123")]
        public ActionResult ChatRoom(int idroom)
        {
            Conexion bdd = new Conexion();
            List<MensajesChat> messageList = new List<MensajesChat>();
            try
            {


                bdd.con.Open();
                MySqlCommand command = new MySqlCommand("CALL `Get_Messages`("+Session["userid"]+", 1, "+idroom+")", bdd.con);
                MySqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    ViewBag.lastMsgId = (int)reader["lastMsgId"];
                    ViewBag.lastMsgOnRoom= (int)reader["lastMsgOnRoom"];
                    messageList.Add(new MensajesChat
                    {
                        userid = (int)reader["userid"],
                        msgid= (int)reader["idmsg"],
                        lastMsgId=(int)reader["lastMsgId"],
                        mensaje = (string)reader["mensaje"],
                        fechamsg = (DateTime)reader["datemsg"],
                        username = (string)reader["username"],
                        photoprofile = (string)reader["profile_img"],
                        roleuser = (int)reader["roleid"],
                        lastLogChat = (DateTime)reader["lastLoginChat"],
                        chatName=idroom==1? (string)reader["RoomName"]:""
                    });

                }
                command= new MySqlCommand("CALL `Get_Messages`(" + Session["userid"] + ", 1, " + idroom + ")", bdd.con);
                reader.Close();
                bdd.con.Close();
                ViewBag.idroom = idroom;
                if (messageList.Count() == 0)
                {
                    messageList = null;
                }
            }
            catch (Exception e)
            {
                string message = "Ocurrio un error al intentar el registro de usuario"+e;
            }
            return View(messageList);
        }


        public ActionResult _TempView()
        {
            Conexion bdd = new Conexion();
            List<ChatInbox> inboxList = new List<ChatInbox>();
            try
            {
                bdd.con.Open();
                MySqlCommand command = new MySqlCommand("CALL `Get_Messages`(" + Session["userid"] + ", 2, 0)", bdd.con);
                MySqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    inboxList.Add(new ChatInbox
                    {
                        idroom = (int)reader["idroom"],
                        roomname = (int)reader["idroom"] == 1 ? "General" : (string)reader["LastUser"],
                        lastMsgDate = (DateTime)reader["LastDateMsg"],
                        lastMsg = (string)reader["LastMessage"],
                        photoChat = (string)reader["profile_img"],
                        usernameLastMsg = (string)reader["LastUser"] == (string)Session["username"] ? "Tú" : (string)reader["LastUser"]
                    });

                }
                reader.Close();
                bdd.con.Close();
                if (inboxList.Count() == 0)
                {
                    inboxList = null;
                }
            }
            catch (Exception e)
            {
                string message = "Ocurrio un error al intentar el registro de usuario" + e;
            }
            ViewBag.inboxList = inboxList;
            return View();
        }

        public ActionResult ChatPartial(int idroom)
        {
            Conexion bdd = new Conexion();
            List<MensajesChat> messageList = new List<MensajesChat>();
            try
            {


                bdd.con.Open();
                MySqlCommand command = new MySqlCommand("CALL `Get_Messages`(" + Session["userid"] + ", 1, " + idroom + ")", bdd.con);
                MySqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    ViewBag.lastMsgId = (int)reader["lastMsgId"];
                    ViewBag.lastMsgOnRoom = (int)reader["lastMsgOnRoom"];
                    messageList.Add(new MensajesChat
                    {
                        userid = (int)reader["userid"],
                        msgid = (int)reader["idmsg"],
                        lastMsgId = (int)reader["lastMsgId"],
                        mensaje = (string)reader["mensaje"],
                        fechamsg = (DateTime)reader["datemsg"],
                        username = (string)reader["username"],
                        photoprofile = (string)reader["profile_img"],
                        roleuser = (int)reader["roleid"],
                        lastLogChat = (DateTime)reader["lastLoginChat"],
                        chatName = idroom == 1 ? (string)reader["RoomName"] : ""
                    });

                }
                command = new MySqlCommand("SELECT idmsg FROM mensajes WHERE ChatRoomId = 2 AND idmsg >= (SELECT lastMsgId FROM userinroom WHERE iduser = 2 AND idroom = 1)", bdd.con);
                reader = command.ExecuteReader();
                List<int> listMsg = new List<int>();
                while (reader.Read())
                {
                    listMsg.Add(reader["idmsg"] == null ? 0 : (int)reader["idmsg"]);
                }
                reader.Close();
                bdd.con.Close();
                ViewBag.idroom = idroom;
                ViewBag.listMessages = listMsg;
                if (messageList.Count() == 0)
                {
                    messageList = null;
                }
            }
            catch (Exception e)
            {
                string message = "Ocurrio un error al intentar el registro de usuario" + e;
            }
            return PartialView("_MessageList", messageList);
        }
    }
}