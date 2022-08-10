using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TutorialASP_net.Filters;

namespace TutorialASP_net.Controllers
{
    
    public class ChatController : Controller
    {
        // GET: Chat
        public static Dictionary<int, string> Rooms = new Dictionary<int, string>() { { 1, "Programacion" },{ 2, "Negocios" }  };
        [AuthorizationUser(role: "123")]
        public ActionResult Index()
        {
            return View();
        }
    }
}