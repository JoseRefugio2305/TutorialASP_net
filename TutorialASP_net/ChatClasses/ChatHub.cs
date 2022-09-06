using Microsoft.AspNet.SignalR;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using TutorialASP_net.Datos;
using TutorialASP_net.Models;

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
                MySqlDataReader reader = command.ExecuteReader();
                MensajesChat newMsg = new MensajesChat();

                while (reader.Read())
                {
                                        newMsg.msgid = (int)reader["idmsg"];
                    newMsg.mensaje = (string)reader["mensaje"];
                    newMsg.fechamsg = (DateTime)reader["datemsg"];
                    newMsg.username = (string)reader["username"];
                    newMsg.photoprofile = (string)reader["profile_img"];
                    newMsg.roleuser = (int)reader["roleid"];
                }

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
            
            Groups.Add(Context.ConnectionId, room);
            Clients.Group(room).sendChat("AddGroup", name + " se ha unido a la sala de chat", "");
        }
        public void RemoveFromGroup(string room, string name, int lastMsgView)
        {
            Conexion bdd = new Conexion();
            try
            {
                bdd.con.Open();
                MySqlCommand command = new MySqlCommand();
                command.Connection = bdd.con;
                int chatId = Int32.Parse(room);
                command.CommandText = "UPDATE userinroom set lastLoginChat=CURRENT_TIMESTAMP, lastMsgId="+lastMsgView+" where iduser=(SELECT userid FROM siteuser WHERE username='" + name + "' AND idroom=" + room + ")";
                command.ExecuteNonQuery();

                bdd.con.Close();
                //Clients.Group(nameGroup).sendChat(name, message, profileChatImg);
                Groups.Remove(Context.ConnectionId, room);
                Clients.Group(room).sendChat("RemoveToGroup", name + " ha salido del Chat", "");
            }
            catch (Exception e)
            {
                string message = "Ocurrio un error al enviar el mensaje" + e;
            }
            
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