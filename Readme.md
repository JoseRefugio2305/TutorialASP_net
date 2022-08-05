# Tutorial ASP.net MVC
## Tutorial utilizado:
[Asp.net MVC Tutorial for Beginners (with Bootstrap and Jquery)](https://youtube.com/playlist?list=PLM5JAv_WpgH_FKWlsGkbiKUczG4BU8mv5)
> En lugar de usar SQL Server como se hace en el tutorial se usó MySQL 
## Requerimientos
- Visual Studio Community 2019
- MySQL 5.7
  - [MySQL Connector/NET 8.0.30](https://dev.mysql.com/downloads/connector/net/)
  - [MySQL for Visual Studio 1.2.10](https://dev.mysql.com/downloads/windows/visualstudio/1.2.html)
- Bootstrap 4.6

# Conexión a MySQL
La conexión a MySQL esta en el archivo Conexion.cs en el directorio Datos, ahí mismo esta el archivo SQL con la base de datos utilizada


```c#
public class Conexion
    {
        public MySqlConnection con = new MySqlConnection("Database=<DataBaseName>;"+
                                                          "Data Source=<Servidor>;"+
                                                          "User Id=<user>;"+
                                                          "Password=<Pass>");
    }
```