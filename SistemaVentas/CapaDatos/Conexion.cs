using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace CapaDatos
{
    public class Conexion
    {
        //La variable cadena que obtiene la conexion a la base de datos esta en el Web.Config
        public static string cn = ConfigurationManager.ConnectionStrings["cadena"].ToString();
    }
}
