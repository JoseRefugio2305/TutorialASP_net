using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace TutorialASP_net.Models
{
    public class Employee
    {
        public int EmployeeID { set; get; }
        [Required(ErrorMessage="Ingresa el Nombre")]
        public string Name { set; get; }
        [Required(ErrorMessage = "Ingresa el Departamento")]
        public int DepartmentId { set; get; }
        public string DeptName { set; get; }
        //Con el required se especifica el mensaje de error que se mostrara cuando el dato no sea ingresado en el formulario
        [Required(ErrorMessage = "Ingresa el Pais")]
        public string Address { set; get; }
        [Required(ErrorMessage = "Ingresa el Sitio")]
        public string SiteName { set; get; }
    }
}