using Microsoft.AspNet.SignalR;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using TutorialASP_net.Datos;

namespace TutorialASP_net.ChatClasses
{
    public class ChatHub : Hub
    {
        public void Send(string name, string message,string profileChatImg)
        {
            Conexion bdd = new Conexion();
            try
            {
                bdd.con.Open();
                MySqlCommand command = new MySqlCommand();
                command.Connection = bdd.con;
                command.CommandText = "CALL `InsertarMSG`('" + name + "', '" + message + "')";
                command.ExecuteNonQuery();
                
                bdd.con.Close();

            }
            catch (Exception e)
            {
                message = "Ocurrio un error al intentar el registro de usuario";
            }
            Clients.All.sendChat(name, message, profileChatImg);
        }
    }
}