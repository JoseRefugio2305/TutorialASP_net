﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace TutorialASP_net.Models
{
    public class MensajesChat
    {
        public int userid { set; get; }
        public string username { set; get; }
        [Required(ErrorMessage = "No pedes enviar mensajes vacios")]
        public string mensaje { set; get; }
        public DateTime fechamsg { set; get; }
        public string photoprofile { set; get; }
    }
}