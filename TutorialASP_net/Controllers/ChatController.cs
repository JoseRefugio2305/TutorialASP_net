using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.IO;
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
                        usernameLastMsg = (string)reader["LastUser"] == (string)Session["username"] ? "Tú" : (string)reader["LastUser"],
                        msgType = (int)reader["type"]
                    });

                }
                reader.Close();

                MySqlCommand commandS = new MySqlCommand("SELECT * FROM stikers", bdd.con);
                MySqlDataReader readerS = commandS.ExecuteReader();
                List<Stikers> stikersList = new List<Stikers>();
                while (readerS.Read())
                {
                    stikersList.Add(new Stikers
                    {
                        id = (int)readerS["id"],
                        ruta = "/static/img/stikers/" + (string)readerS["ruta"]
                    });
                }
                readerS.Close();
                ViewBag.stikers = stikersList;

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
        //[AuthorizationUser(role: "123")]
        //public ActionResult ChatRoom(int idroom)
        //{
        //    Conexion bdd = new Conexion();
        //    List<MensajesChat> messageList = new List<MensajesChat>();
        //    try
        //    {


        //        bdd.con.Open();
        //        MySqlCommand command = new MySqlCommand("CALL `Get_Messages`(" + Session["userid"] + ", 1, " + idroom + ")", bdd.con);
        //        MySqlDataReader reader = command.ExecuteReader();
        //        while (reader.Read())
        //        {
        //            ViewBag.lastMsgId = (int)reader["lastMsgId"];
        //            ViewBag.lastMsgOnRoom = (int)reader["lastMsgOnRoom"];
        //            messageList.Add(new MensajesChat
        //            {
        //                userid = (int)reader["userid"],
        //                msgid = (int)reader["idmsg"],
        //                lastMsgId = (int)reader["lastMsgId"],
        //                mensaje = (string)reader["mensaje"],
        //                fechamsg = (DateTime)reader["datemsg"],
        //                username = (string)reader["username"],
        //                photoprofile = (string)reader["profile_img"],
        //                roleuser = (int)reader["roleid"],
        //                lastLogChat = (DateTime)reader["lastLoginChat"],
        //                chatName = idroom == 1 ? (string)reader["RoomName"] : ""
        //            });

        //        }
        //        command = new MySqlCommand("CALL `Get_Messages`(" + Session["userid"] + ", 1, " + idroom + ")", bdd.con);
        //        reader.Close();
        //        bdd.con.Close();
        //        ViewBag.idroom = idroom;
        //        if (messageList.Count() == 0)
        //        {
        //            messageList = null;
        //        }
        //    }
        //    catch (Exception e)
        //    {
        //        string message = "Ocurrio un error al intentar el registro de usuario" + e;
        //    }
        //    return View(messageList);
        //}

        //[AuthorizationUser(role: "123")]
        //public ActionResult _TempView()
        //{
            
        //}
        [AuthorizationUser(role: "123")]
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
                        chatName = idroom == 1 ? (string)reader["RoomName"] : "",
                        msgtype = (int)reader["message_type"]!=1&& (int)reader["message_type"]!=2?
                                  reader["mensaje"].ToString().Contains(".jpg") || reader["mensaje"].ToString().Contains(".png") || reader["mensaje"].ToString().Contains(".gif") || reader["mensaje"].ToString().Contains(".jpeg")? (int)reader["message_type"] : 4: (int)reader["message_type"]
                    });

                }
                reader.Close();
                command = new MySqlCommand("SELECT idmsg FROM mensajes WHERE ChatRoomId = " + idroom + " AND idmsg >= (SELECT lastMsgId FROM userinroom WHERE iduser = " + Session["userid"]+" AND idroom = "+idroom+")", bdd.con);
                reader = command.ExecuteReader();
                string listMsg = "";
                while (reader.Read())
                {
                    listMsg+= Convert.ToString((int)reader["idmsg"])+",";
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
            Session["idChat"] = idroom;
            return PartialView("_MessageList", messageList);
        }

        [AuthorizationUser(role: "123")] 
        [HttpPost]
        public JsonResult SubirArchivos(List<HttpPostedFileBase> files)//,string idChat
        {
            string message= "";
            bool success = true;
            List<string> FilesNames=new List<string>();
            //List<string> cadal = new List<string>();
            try
            {
                
                //for(var i = 0; i < files.Count(); i++)
                //{
                //    cadal.Add(CadenaAleatoria());
                //}
                string RelativePath, Destination;
                RelativePath = Destination = null;
                int cont = 0;
                files.ForEach(fileUpload =>
                {
                    if (fileUpload != null)
                    {
                        string folders = string.Concat("/static/img/Chats/", Session["idChat"], "/", Session["userid"], "/");
                        string ruta = Server.MapPath(string.Concat("~", folders));
                        //Random rand = new Random();
                        //string filename = string.Concat(Session["userid"].ToString(), "-", DateTime.Now.ToShortDateString().Replace("/", ""), "-", cadal[cont], Path.GetExtension(fileUpload.FileName));//imguser.ImgProfileFile.FileName;
                        //Destination = string.Concat(ruta, filename);
                        //RelativePath = string.Concat(folders, filename);
                        Directory.CreateDirectory(ruta);
                        //modelo.File.SaveAs(Destination);
                        string reducename = fileUpload.FileName.Length > 50 ? string.Concat(fileUpload.FileName.Substring(0, 49), Path.GetExtension(fileUpload.FileName)) : fileUpload.FileName;
                        fileUpload.SaveAs(Path.Combine(ruta, reducename));
                        FilesNames.Add(string.Concat(folders, reducename));

                    }
                    else
                    {
                        message = "Algunos Archivos no fueron subidos";
                        success = false;
                    }
                    cont++;
                });
           

            }
            catch (Exception e)
            {
                message = "Algunos archivos no fueron subidos" + e;
                success = false;
            }
            return Json(new { success=success, message = message, listaArchivos = FilesNames}, JsonRequestBehavior.AllowGet);
        }

        //public string CadenaAleatoria()
        //{
        //    var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        //    var Charsarr = new char[8];
        //    var random = new Random();

        //    for (int i = 0; i < Charsarr.Length; i++)
        //    {
        //        Charsarr[i] = characters[random.Next(characters.Length)];
        //    }

        //    return new String(Charsarr);
        //}

        public FileResult DownLoadFile(string ruta)
        {
            var file = Server.MapPath(ruta);
            string fileName = ruta.Split('/')[6];
            return File(file, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);
        }
    }
    
}

