using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TutorialASP_net.Models
{
    public class SendFilesVM
    {
        public List<HttpPostedFileBase> files { get; set; }
    }
}