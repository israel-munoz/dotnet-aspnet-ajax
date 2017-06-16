using System.ComponentModel;
using System.Web.Script.Services;
using System.Web.Services;

namespace Client_Server
{
    /// <summary>
    /// Summary description for mailService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    [ScriptService]
    public class mailService : WebService
    {
        /// <summary>
        /// Método web para enviar mensaje
        /// </summary>
        /// <param name="name">Nombre</param>
        /// <param name="email">Correo electrónico</param>
        /// <param name="messageBody">Mensaje</param>
        /// <param name="correct">Indicador para enviar mensaje correcto o incorrecto</param>
        /// <returns></returns>
        [WebMethod]
        public bool SendMessage(string name, string email, string messageBody, bool correct)
        {
            Contact contact = new Contact(name, email, messageBody);
            contact.Send(correct);
            return true;
        }
    }
}
