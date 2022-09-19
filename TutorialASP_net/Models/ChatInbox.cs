using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TutorialASP_net.Models
{
    public class ChatInbox
    {
        public int idroom { set; get; }
        public string roomname { set; get; }
        public DateTime lastMsgDate { set; get; }
        public string lastMsg { set; get; }
        public string photoChat { set; get; }
        public string usernameLastMsg { set; get; }
        public int msgType { set; get; }
    }
}