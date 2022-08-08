using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace TutorialASP_net.Models
{
    public class LogeoUser
    {
        [Required(ErrorMessage = "Ingresa el Email de Usuario")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}" + @"\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\" + @".)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessage = "Email no valido")]
        public string email { set; get; }
        [Required(ErrorMessage = "Ingresa la Contrasena de Usuario")]
        public string password { set; get; }
    }
}