using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace TutorialASP_net.Models
{
    public class User
    {
        public int userid { set; get; }
        [Required(ErrorMessage = "Ingresa el Nombre de Usuario")]
        public string username { set; get; }
        [Required(ErrorMessage = "Ingresa el Email de Usuario")]
        public string email { set; get; }
        [Required(ErrorMessage = "Ingresa la Contrasena de Usuario")]
        public string password { set; get; }
        
        public string profile_img { set; get; }

        public int roleid { set; get; }
    }
}