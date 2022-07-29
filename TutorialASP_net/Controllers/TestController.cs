using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TutorialASP_net.Models;
using TutorialASP_net.Datos;
using MySql.Data.MySqlClient;
using System.Data;

namespace TutorialASP_net.Controllers
{
    public class TestController : Controller
    {
        Conexion bdd = new Conexion();
        // GET: Test
        public ActionResult Index()
        {
            ViewBag.Name = "Jose Refugio";
            List<string> list = new List<string>();
            list.Add("Aldo");
            list.Add("Pedro");
            list.Add("Pablo");
            list.Add("Alfredo");
            list.Add("Ashis");
            ViewBag.NamesList = list;

            List<Employee> employeeList = new List<Employee>();
            Employee employee = new Employee();
            employeeList.Add(new Employee { EmployeeID = 1, Name = "Jose Refugio", DepartmentId = 1 });
            employeeList.Add(new Employee { EmployeeID = 2, Name = "Aldo", DepartmentId = 2 });
            employeeList.Add(new Employee { EmployeeID = 3, Name = "Pedro", DepartmentId = 3 });
            employeeList.Add(new Employee { EmployeeID = 4, Name = "Alfredo", DepartmentId = 4 });
            employeeList.Add(new Employee { EmployeeID = 5, Name = "Ashis", DepartmentId = 2 });
            employeeList.Add(new Employee { EmployeeID = 6, Name = "Aniceto", DepartmentId = 2 });

            ViewBag.EmployeeList = employeeList;
            ViewData["EmployeeList"] = employeeList;

            ViewBag.EmployeeNameVB = "Jose Refugio";
            ViewData["EmployeeNameVD"] = "Alma";
            TempData["EmployeeNameTD"] = "Ashis";

            TempData.Keep();//Con esta linea le decimos que el TempData permanezca y pueda ser usado en una vista diferente a la de index
            return View(employeeList);
        }

        public ActionResult SecondPage()
        {
            return View();
        }

        public ActionResult BDD()
        {
            
            List<Employee> employeeListbdd = new List<Employee>();
            //MySqlConnection myConnection = new MySqlConnection("Database=MVCtutorial;Data Source=localhost;User Id=root;Password=");
            //myConnection.Open();
            bdd.con.Open();
            MySqlCommand command = new MySqlCommand("SELECT * FROM employee AS e INNER JOIN department AS d ON e.DepartmentId=d.DepartmentId", bdd.con);
            MySqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                employeeListbdd.Add(new Employee { EmployeeID = (int)reader["EmployeeId"], 
                    Name = (string)reader["Name"], 
                    DepartmentId = (int)reader["DepartmentId"],
                    DeptName=(string)reader["DeptName"],
                    Address = (string)reader["Address"]
                });

            }
            reader.Close(); 
            bdd.con.Close();
            return View(employeeListbdd);
        }
        public ActionResult EmployeeDetails(int EmpID)
        {
            bdd.con.Open();
            MySqlCommand command = new MySqlCommand("SELECT * FROM employee AS e INNER JOIN department AS d ON e.DepartmentId=d.DepartmentId WHERE EmployeeId="+EmpID, bdd.con);
            MySqlDataReader reader = command.ExecuteReader();
            Employee employee = new Employee();
            while (reader.Read())
            {
                employee.EmployeeID = (int)reader["EmployeeId"];
                employee.Name = (string)reader["Name"];
                employee.DepartmentId = (int)reader["DepartmentId"];
                employee.DeptName = (string)reader["DeptName"];
                employee.Address = (string)reader["Address"];
            }
            reader.Close();
            bdd.con.Close();
            return View(employee);
        }

        public ActionResult RegisterEmployee()
        {
            List<Department> departments = new List<Department>();
            bdd.con.Open();
            MySqlCommand command = new MySqlCommand("SELECT * FROM department", bdd.con);
            MySqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                departments.Add(new Department
                {
                    DepartmentId = (int)reader["DepartmentId"],
                    DeptName = (string)reader["DeptName"]
                });
            }
            reader.Close();
            bdd.con.Close();
            ViewBag.DepartmentList = new SelectList(departments, "DepartmentId", "DeptName");
            return View();
        }

        [HttpPost]
        public ActionResult RegisterEmployee(Employee newemployee)
        {//newemployee.Address!=null && newemployee.DepartmentId!=0 && newemployee.Name!=null && newemployee.SiteName!=null
            if (ModelState.IsValid)
            {
                bdd.con.Open();
                MySqlCommand command = new MySqlCommand();
                command.Connection = bdd.con;
                command.CommandText = "INSERT INTO employee (DepartmentId,Name,Address) Values (" + newemployee.DepartmentId + ",'" + newemployee.Name + "','" + newemployee.Address + "'); ";

                command.ExecuteNonQuery();
                MySqlCommand command2 = new MySqlCommand("SELECT MAX(EmployeeId) as EmployeeId FROM Employee", bdd.con);
                MySqlDataReader reader = command2.ExecuteReader();
                int lastempid = 0;
                while (reader.Read())
                {
                    lastempid = (int)reader["EmployeeId"];
                }
                reader.Close();
                MySqlCommand command3 = new MySqlCommand();
                command3.Connection = bdd.con;
                command3.CommandText = "INSERT INTO Sites (EmployeeId, SiteName) VALUES (" + lastempid + ",'" + newemployee.SiteName + "')";

                command3.ExecuteNonQuery();

                bdd.con.Close();
            }
            List<Department> departments = new List<Department>();
            bdd.con.Open();
            MySqlCommand command4 = new MySqlCommand("SELECT * FROM department", bdd.con);
            MySqlDataReader reader2 = command4.ExecuteReader();
            while (reader2.Read())
            {
                departments.Add(new Department
                {
                    DepartmentId = (int)reader2["DepartmentId"],
                    DeptName = (string)reader2["DeptName"]
                });
            }
            reader2.Close();
            bdd.con.Close();
            ViewBag.DepartmentList = new SelectList(departments, "DepartmentId", "DeptName");
            return View(newemployee);
        }
        
        public ActionResult DeleteEmployee(int EmployeeId)
        {
            bdd.con.Open();
            MySqlCommand command3 = new MySqlCommand();
            command3.Connection = bdd.con;
            command3.CommandText = "DELETE FROM employee WHERE EmployeeId="+EmployeeId;

            command3.ExecuteNonQuery();

            bdd.con.Close();
            return Json(new { result=true},JsonRequestBehavior.AllowGet);
    
        }

        public ActionResult EmployeeTablePartial()
        {
            List<Employee> employeeListbdd = new List<Employee>();
            //MySqlConnection myConnection = new MySqlConnection("Database=MVCtutorial;Data Source=localhost;User Id=root;Password=");
            //myConnection.Open();
            bdd.con.Open();
            MySqlCommand command = new MySqlCommand("SELECT * FROM employee AS e INNER JOIN department AS d ON e.DepartmentId=d.DepartmentId", bdd.con);
            MySqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                employeeListbdd.Add(new Employee
                {
                    EmployeeID = (int)reader["EmployeeId"],
                    Name = (string)reader["Name"],
                    DepartmentId = (int)reader["DepartmentId"],
                    DeptName = (string)reader["DeptName"],
                    Address = (string)reader["Address"]
                });

            }
            reader.Close();
            bdd.con.Close();
            return PartialView("_EmployeeTable", employeeListbdd);
        }

        public ActionResult ShowPartial()
        {
            return PartialView("_PruebaPartialViewSimple");
        }
    }
}