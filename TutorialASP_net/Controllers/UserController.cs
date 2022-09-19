using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TutorialASP_net.Models;
using TutorialASP_net.Datos;
using MySql.Data.MySqlClient;
using TutorialASP_net.Filters;
using System.IO;

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
            if (newUser.email!=null && newUser.password!=null && newUser.username!=null)
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
                        command1.CommandText = "CALL `RegisterUser`('"+newUser.username+"', '"+newUser.email+"', '"+newUser.password+"')";
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
                    message = "Ocurrio un error al intentar el registro de usuario";
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
        public JsonResult LoginUser(LogeoUser logUser)
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
                    //command.CommandText = "SELECT * FROM siteuser WHERE email='"+logUser.email+"' AND password='"+logUser.password+"'";
                    command.CommandText = "CALL `LoginUser`('"+logUser.email.Trim()+"', '"+logUser.password.Trim()+"')";
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
                    message = "Ocurrio un error al intentar el inicio de usuario" + e;
                }

            }
            else
            {
                message = "Debes llenar todos los datos requeridos para registrarte";
            }
            return Json(new { success = IsSuccess, message = message }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult UserProfile(int iduser)
        {
            User usuario = new User();
            usuario = UserProfileInfo(usuario, iduser);
            if (Session["userid"] != null)
            {
                if ((int)Session["userid"] == iduser)
                {
                    ViewBag.isowner = true;
                }
                else
                {
                    ViewBag.isowner = false;
                } 
            }
            else
            {
                ViewBag.isowner = false;
            }
            if (usuario.email == null)
            {
                usuario = null;
            }
            return View(usuario);
        }

        public User UserProfileInfo(User usuario,int iduser)
        {
            try
            {
                bdd.con.Open();
                MySqlCommand command = new MySqlCommand();
                command.Connection = bdd.con;
                command.CommandText = "SELECT * FROM siteuser WHERE userid=" + iduser;
                MySqlDataReader reader = command.ExecuteReader();

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
                bdd.con.Close();

            }
            catch (Exception e)
            {
                usuario = null;
            }
            return usuario;
        }

        [HttpPost]
        public JsonResult EditProfile(User eduser)
        {
            string message, response,is_exist = "";
            try
            {
                bdd.con.Open();
                MySqlCommand command = new MySqlCommand();
                command.Connection = bdd.con;
                //command.CommandText = "SELECT * FROM siteuser WHERE email='"+logUser.email+"' AND password='"+logUser.password+"'";
                command.CommandText = "CALL `EditUserProfile`('"+eduser.username+"', '"+eduser.email+"', "+Session["userid"]+")";
                MySqlDataReader reader = command.ExecuteReader();

                while (reader.Read())
                {
                    is_exist = (string)reader["is_exists"];
                }
                if (is_exist == "Existe")
                {
                    message = "El usuario/correo ingresados ya estan siendo usados por otro usuario";
                    response = "ERROR";
                }
                else
                {
                    message = "Informacion Actualizada";
                    response = "OK";
                }
                reader.Close();
                bdd.con.Close();
            }
            catch(Exception e)
            {
                message = "Hubo un error al intentar modificar la informacion "+e;
                response = "ERROR";
            }
            return Json(new { message = message, response = response }, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult EditImgProfile(User imguser)
        {
            string message, response = "";
            try
            {
                string RelativePath, Destination;
                RelativePath = Destination = null;
                if (imguser.ImgProfileFile != null && imguser.ImgProfileFile.ContentType.Contains("image/"))
                {
                    string folders = string.Concat("/static/img/user/", Session["userid"], "/profile/");
                    string ruta = Server.MapPath(string.Concat("~", folders));
                    Random rand = new Random();
                    string filename = string.Concat(Session["userid"].ToString(),"-", DateTime.Now.ToShortDateString().Replace("/", ""),"-",rand.Next(0,100).ToString(),Path.GetExtension(imguser.ImgProfileFile.FileName));//imguser.ImgProfileFile.FileName;
                    Destination = string.Concat(ruta, filename);
                    RelativePath = string.Concat(folders, filename);
                    Directory.CreateDirectory(ruta);
                    //modelo.File.SaveAs(Destination);
                    imguser.ImgProfileFile.SaveAs(Path.Combine(ruta, filename));
                    try
                    {
                        bdd.con.Open();
                        MySqlCommand command = new MySqlCommand();
                        command.Connection = bdd.con;
                        //command.CommandText = "SELECT * FROM siteuser WHERE email='"+logUser.email+"' AND password='"+logUser.password+"'";
                        command.CommandText = "UPDATE siteuser SET profile_img='"+RelativePath+"' WHERE userid=" + Session["userid"];
                        command.ExecuteNonQuery();
                        bdd.con.Close();
                        Session["photo"] = RelativePath;
                        message = "Imagen subida";
                        response = "OK";
                    }
                    catch (Exception e)
                    {
                        message = "Imagen no subida";
                        response = "ERROR";
                    }
                    
                }
                else
                {
                    message = "Imagen no subida";
                    response = "ERROR";
                }
                
            }
            catch(Exception e)
            {
                message = "Imagen no subida"+e;
                response = "ERROR";
            }
            return Json(new { message = message,response=response }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult LogOut()
        {
            Session.Clear();
            Session.Abandon();
            return RedirectToAction("Login");
        }
    }
}