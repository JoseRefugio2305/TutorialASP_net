using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TutorialASP_net.Datos
{
    public class Conexion
    {
        public MySqlConnection con = new MySqlConnection("Database=MVCtutorial;Data Source=localhost;User Id=root;Password=");
    }
}