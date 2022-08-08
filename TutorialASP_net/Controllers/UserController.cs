using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TutorialASP_net.Models;
using TutorialASP_net.Datos;
using MySql.Data.MySqlClient;

namespace TutorialASP_net.Controllers
{
    public class UserController : Controller
    {
        // GET: User
        Conexion bdd = new Conexion();
        public ActionResult Registration()
        {
            return View();
        }
        [HttpPost]
        public JsonResult RegisterUser(User newUser)
        {
            Boolean IsSuccess = false;
            string message = "";
            if (ModelState.IsValid)
            {
                try
                {
                    bdd.con.Open();
                    MySqlCommand command = new MySqlCommand();
                    command.Connection = bdd.con;
                    command.CommandText = "CALL `ExistsUser`('" + newUser.username + "', '" + newUser.email + "')";
                    MySqlDataReader reader = command.ExecuteReader();
                    string is_User = "No Existe";
                    string is_Useremail = "No Existe";
                    while (reader.Read())
                    {
                        is_User = (string)reader["is_Username"];
                        is_Useremail = (string)reader["is_Useremail"];
                    }
                    reader.Close();
                    if (is_User == "No Existe" && is_Useremail == "No Existe")
                    {
                        MySqlCommand command1 = new MySqlCommand();
                        command1.Connection = bdd.con;
                        command1.CommandText = "INSERT INTO siteuser (username,email,password,roleid)" +
                        "VALUES('" + newUser.username + "','" + newUser.email + "','" + newUser.password + "'," + 1 + ")";
                        command1.ExecuteNonQuery();
                        message = "Bienvenido " + newUser.username + ", ahora seras redigido para inicia sesion.";
                        IsSuccess = true;
                    }
                    else if (is_User == "Existe")
                    {
                        message = "Lo sentimos, el nombre de usuario ya existe en el sistema";
                        IsSuccess = false;
                    }
                    else if (is_Useremail == "Existe")
                    {
                        message = "Lo sentimos, el correo de usuario ya existe en el sistema";
                        IsSuccess = false;
                    }
                    bdd.con.Close();

                }
                catch (Exception e)
                {
                    message = "Ocurrio un error al intentar el registro de usuario" + e;
                }
                
            }
            else
            {
                message = "Debes llenar todos los datos requeridos para registrarte";
            }
            return Json(new { success = IsSuccess, message=message }, JsonRequestBehavior.AllowGet);
        }
        
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public JsonResult LoginUser(User logUser)
        {
            Boolean IsSuccess = false;
            string message = "";
            if (logUser.email!=null && logUser.password!=null)
            {
                try
                {
                    bdd.con.Open();
                    MySqlCommand command = new MySqlCommand();
                    command.Connection = bdd.con;
                    command.CommandText = "SELECT * FROM siteuser WHERE email='"+logUser.email+"' AND password='"+logUser.password+"'";
                    MySqlDataReader reader = command.ExecuteReader();
                    User usuario = new User();
                    while (reader.Read())
                    {
                        usuario.userid = (int)reader["userid"];
                        usuario.username = (string)reader["username"];
                        usuario.email = (string)reader["email"];
                        usuario.password = (string)reader["password"];
                        usuario.profile_img = (string)reader["profile_img"];
                        usuario.roleid = (int)reader["roleid"];
                    }
                    reader.Close();
                    if (usuario.email != null)
                    {
                        Session["userid"] = usuario.userid;
                        Session["username"] = usuario.username;
                        Session["email"] = usuario.email;
                        Session["photo"] = usuario.profile_img;
                        Session["role"] = usuario.roleid;
                        message = "Bienvenido "+usuario.username;
                        IsSuccess = true;
                    }
                    else
                    {
                        message = "Usuario o contrasena incorrectos";
                    }
                    bdd.con.Close();

                }
                catch (Exception e)
                {
                    message = "Ocurrio un error al intentar el registro de usuario" + e;
                }

            }
            else
            {
                message = "Debes llenar todos los datos requeridos para registrarte";
            }
            return Json(new { success = IsSuccess, message = message }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult LogOut()
        {
            Session.Clear();
            Session.Abandon();
            return RedirectToAction("Login");
        }
    }
}