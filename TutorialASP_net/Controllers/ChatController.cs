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
                        idroom = (int)reader["ChatRoomId"],
                        roomname = (int)reader["ChatRoomId"]==1?(string)reader["RoomName"]: (string)reader["username"],
                        lastMsgDate = (DateTime)reader["lastdate"],
                        lastMsg=(string)reader["mensaje"],
                        photoChat=(string)reader["profile_img"],
                        usernameLastMsg=(string)reader["username"]==(string)Session["username"]?"Tú": (string)reader["username"]
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
                string message = "Ocurrio un error al intentar el registro de usuario" +e;
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
                MySqlCommand command = new MySqlCommand("CALL `Get_Messages`(0, 1, "+idroom+")", bdd.con);
                MySqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    messageList.Add(new MensajesChat
                    {
                        userid = (int)reader["userid"],
                        mensaje = (string)reader["mensaje"],
                        fechamsg = (DateTime)reader["datemsg"],
                        username = (string)reader["username"],
                        photoprofile = (string)reader["profile_img"],
                        roleuser = (int)reader["roleid"],
                        lastLogChat = (DateTime)reader["lastLoginChat"],
                        chatName=idroom==1? (string)reader["RoomName"]:""
                    });

                }
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
    }
}