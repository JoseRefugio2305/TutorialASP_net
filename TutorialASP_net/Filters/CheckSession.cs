using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TutorialASP_net.Filters
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false)]
    public class CheckSession:AuthorizeAttribute
    {
        
        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            base.OnAuthorization(filterContext);
            if (HttpContext.Current.Session["username"] == null)
            {
                filterContext.Result = new RedirectResult("~/User/Login");
            }
           

        }
    }
}