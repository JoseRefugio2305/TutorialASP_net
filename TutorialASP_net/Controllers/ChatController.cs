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
        public static Dictionary<int, string> Rooms = new Dictionary<int, string>() { { 1, "Programacion" },{ 2, "Negocios" }  };
        [AuthorizationUser(role: "123")]
        public ActionResult Index()
        {
            Conexion bdd = new Conexion();
            List<MensajesChat> messageList = new List<MensajesChat>();
            try
            {
                
                //MySqlConnection myConnection = new MySqlConnection("Database=MVCtutorial;Data Source=localhost;User Id=root;Password=");
                //myConnection.Open();
                bdd.con.Open();
                MySqlCommand command = new MySqlCommand("SELECT *  FROM mensajes AS m INNER JOIN siteuser AS su ON m.userid=su.userid ORDER BY m.idmsg ASC", bdd.con);
                MySqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    messageList.Add(new MensajesChat { userid = (int)reader["userid"],
                        mensaje=(string)reader["mensaje"],
                        fechamsg=(DateTime)reader["datemsg"],
                        username=(string)reader["username"], 
                        photoprofile=(string)reader["profile_img"]});

                }
                reader.Close();
                bdd.con.Close();

            }
            catch (Exception e)
            {
                string message = "Ocurrio un error al intentar el registro de usuario";
            }
            return View(messageList);
        }
    }
}