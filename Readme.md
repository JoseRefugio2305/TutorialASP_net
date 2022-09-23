# Tutorial ASP.net MVC
## Tutorial utilizado:
[Asp.net MVC Tutorial for Beginners (with Bootstrap and Jquery)](https://youtube.com/playlist?list=PLM5JAv_WpgH_FKWlsGkbiKUczG4BU8mv5)
> En lugar de usar SQL Server como se hace en el tutorial se usó MySQL 
## Tutoriales de SignalR utilizados
- [¿Cómo mostrar los usuarios activos en tiempo real en C# .Net con SignalR? | Real time](https://www.youtube.com/watch?v=zGtQbuWc3jc&list=WL&index=2&t=822s&ab_channel=hdeleon.net)
- [Crear Chat con Salas en C# .Net | Aplicaciones en tiempo real con SignalR](https://www.youtube.com/watch?v=_J7EG8_KE4Y&list=WL&index=1&t=973s&ab_channel=hdeleon.net)
## Requerimientos
- Visual Studio Community 2019
- MySQL 5.7
  - [MySQL Connector/NET 8.0.30](https://dev.mysql.com/downloads/connector/net/)
  - [MySQL for Visual Studio 1.2.10](https://dev.mysql.com/downloads/windows/visualstudio/1.2.html)
- Bootstrap 4.6

## Plantilla para subir multiples archivos con vista previa de nombre 
- [JAVASCRIPT INPUT FILE MULTIPLE SIN REPETICIONES CON PREVIA](https://programadorwebvalencia.com/javascript-input-file-multiple-sin-repeticiones-y-previa/)

En el tutorial se muestra un input file que es capaz de identificar archivos repetidos, puede dar una lista previa de los nombres de los archivos seleccionados, es posible el reordenarlos, ademas de que se pueden eliminar archivos de la seleccion.


## Plantilla Chat
- [Message Chat Box](https://bootsnipp.com/snippets/1ea0N)
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

