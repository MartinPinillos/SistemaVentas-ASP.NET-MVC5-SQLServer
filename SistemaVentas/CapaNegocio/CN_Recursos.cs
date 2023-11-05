using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;
using System.Net.Mail;
using System.Net;
using System.IO;

namespace CapaNegocio
{
    public class CN_Recursos
    {
        //Metodo para generar clave automatica para los usuarios 
        public static string GenerarClave()
        {
            //Guid permite generar numeros unicos aleatorios, N le da formato de caracter alfanumerico, Substring(0,6): permite dar una clave de 6 digitos
            string clave = Guid.NewGuid().ToString("N").Substring(0, 6);
            return clave;
        }

        //Metodo para generar el correo para enviar
        public static bool EnviarCorreo(string correo, string asunto, string mensaje)
        {
            bool resultado = false;

            try
            {
                MailMessage mail = new MailMessage();
                mail.To.Add(correo);
                mail.From = new MailAddress("martinpinillosme@gmail.com");
                mail.Subject = asunto;
                mail.Body = mensaje;
                mail.IsBodyHtml = true;

                //Creacion del servidor para el envio del correo
                var smtp = new SmtpClient()
                {
                    Credentials = new NetworkCredential("martinpinillosme@gmail.com", "jqmdclxmltpidvln"), 
                    Host = "smtp.gmail.com",
                    Port = 587,
                    EnableSsl = true
                };

                smtp.Send(mail);
                resultado = true;
            }
            catch (Exception ex)
            {
                resultado = false;
            }
            return resultado;
        }

        //Encriptacion de Texto en SHA256
        public static string ConvertirSha256(string texto)
        {
            StringBuilder Sb = new StringBuilder();
            using (SHA256 hash = SHA256Managed.Create())
            {
                Encoding enc = Encoding.UTF8;
                byte[] result = hash.ComputeHash(enc.GetBytes(texto));

                foreach (byte b in result)
                    Sb.Append(b.ToString("x2"));
            }
            return Sb.ToString();
        }

        //Metodo para el "ImagenProducto" que convierte una cadena de texto de la ruta de una imagen en Base64 
        public static string ConvertirBase64(string ruta, out bool conversion)
        {
            string textoBase64 = string.Empty;
            conversion = true;

            try
            {
                byte[] bytes = File.ReadAllBytes(ruta);
                textoBase64 = Convert.ToBase64String(bytes);
            }
            catch
            {
                conversion = false;
            }
            return textoBase64;
        }
    }
}
