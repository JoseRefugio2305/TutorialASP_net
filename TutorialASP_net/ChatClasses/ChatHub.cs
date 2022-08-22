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
        public static int count = 0;
        public void Send(string nameGroup,string name, string message,string profileChatImg)
        {
            Conexion bdd = new Conexion();
            try
            {
                bdd.con.Open();
                MySqlCommand command = new MySqlCommand();
                command.Connection = bdd.con;
                int chatId = Int32.Parse(nameGroup);
                command.CommandText = "CALL `InsertarMSG`('" + name + "', '" + message + "'," + chatId + ")";
                command.ExecuteNonQuery();
                
                bdd.con.Close();
                //Clients.Group(nameGroup).sendChat(name, message, profileChatImg);
                Clients.Group(nameGroup).sendChat(name, message, profileChatImg);
            }
            catch (Exception e)
            {
                message = "Ocurrio un error al enviar el mensaje"+e;
            }
            
        }
        public void AddToGroup(string room, string name)
        {
            Conexion bdd = new Conexion();
            try
            {
                bdd.con.Open();
                MySqlCommand command = new MySqlCommand();
                command.Connection = bdd.con;
                int chatId = Int32.Parse(room);
                command.CommandText = "UPDATE ";
                command.ExecuteNonQuery();

                bdd.con.Close();
                //Clients.Group(nameGroup).sendChat(name, message, profileChatImg);
                Groups.Add(Context.ConnectionId, room);
                Clients.Group(room).sendChat("AddGroup", name + " se ha unido a la sala de chat", "");
            }
            catch (Exception e)
            {
                string message = "Ocurrio un error al enviar el mensaje" + e;
            }
            
        }
        public void RemoveFromGroup(string room, string name)
        {
            Groups.Remove(Context.ConnectionId, room);
            Clients.Group(room).sendChat("AddGroup", name + " se ha unido a la sala de chat", "");
        }
        public override Task OnConnected()
        {
            
            count++;
            Clients.All.ConnectedCount(count);
            return base.OnConnected();
        }
        public override Task OnDisconnected(bool stopCalled)
        {
            count--;
            Clients.All.ConnectedCount(count);
            return base.OnDisconnected(stopCalled);
        }
    }
}