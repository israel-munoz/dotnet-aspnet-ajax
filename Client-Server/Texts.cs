namespace Client_Server
{
    public class Texts
    {
        public static string EmptyName
        {
            get
            {
                return "Proporcione su nombre.";
            }
        }
        public static string EmptyEmail
        {
            get
            {
                return "Proporcione su correo electrónico.";
            }
        }
        public static string InvalidEmail
        {
            get
            {
                return "La dirección de correo no es correcta.";
            }
        }
        public static string EmptyMessage
        {
            get
            {
                return "Escriba un mensaje.";
            }
        }
        public static string MessageSent
        {
            get
            {
                return "Mensaje enviado. Gracias.";
            }
        }
        public static string SendError
        {
            get
            {
                return "No se pudo enviar el mensaje.";
            }
        }
        public static string EmailRegexp
        {
            get
            {
                return @"^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$";
            }
        }
    }
}