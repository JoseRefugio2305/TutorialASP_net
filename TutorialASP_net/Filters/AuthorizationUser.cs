using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TutorialASP_net.Filters
{
    [AttributeUsage(AttributeTargets.All,AllowMultiple =false)]
    public class AuthorizationUser:AuthorizeAttribute 
    {
        private string role;
        public AuthorizationUser(string role)
        {
            this.role = role;
        }

        public override void OnAuthorization(AuthorizationContext filterContext)
        {

            try
            {
                
                if (HttpContext.Current.Session["username"] == null)
                {
                    filterContext.Result = new RedirectResult("~/User/Login");
                }
                else
                {
                    
                    string rolecurrentuser = HttpContext.Current.Session["role"].ToString();
                    if (!role.Contains(rolecurrentuser))
                    {
                        filterContext.Result = new RedirectResult("~/Home/");
                    }                   
                }
            }
            catch(Exception e)
            {
                filterContext.Result = new RedirectResult("~/User/Login");
            }
        }
    }
}