using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace TutorialASP_net.ChatClasses
{
    public class ChatHub : Hub
    {
        public void Send(string name, string message)
        {
            Clients.All.sendChat(name,message);
        }
    }
}