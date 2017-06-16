using System;
using System.Web.UI;

namespace Client_Server
{
    public partial class Default : Page
    {
        #region Propiedades
        // Estas propiedades son equivalentes a las de la clase Textos
        // Son utilizadas para los mensajes mostrados en la página aspx
        protected static string EmptyName { get { return Texts.EmptyName; } }
        protected static string EmptyEmail { get { return Texts.EmptyEmail; } }
        protected static string InvalidEmail { get { return Texts.InvalidEmail; } }
        protected static string EmptyMessage { get { return Texts.EmptyMessage; } }
        protected static string MessageSent { get { return Texts.MessageSent; } }
        protected static string SendError { get { return Texts.SendError; } }
        protected static string EmailRegexp { get { return Texts.EmailRegexp; } }
        protected static string JSEmailRegexp { get { return Texts.EmailRegexp.Replace(@"\", @"\\").Replace("\"", "\\\""); } }
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            message.Text = "";
            if (Request.Form[name.UniqueID] != null)
                Send();
        }

        /// <summary>
        /// Método para enviar el mensaje
        /// </summary>
        private void Send()
        {
            try
            {
                // Se crea un objeto Contacto y se invoca al método Enviar
                // Los valores se obtienen por medio de POST de los controles TextBox
                // La propiedad UniqueID de un control ASP equivale al atributo name del elemento en HTML
                Contact contact = new Contact()
                {
                    Name = Request.Form[name.UniqueID],
                    Email = Request.Form[email.UniqueID],
                    Message = Request.Form[messageBody.UniqueID]
                };

                contact.Send(Request.Form["correct"] == "on");

                ShowMessage(MessageSent);
            }
            catch (Exception ex)
            {
                ShowMessage(string.Format("{0}\n{1}", SendError, ex.Message));
            }
        }

        /// <summary>
        /// Método para mostrar un mensaje en pantalla. Es equivalente al del mismo nombre en Javascript
        /// </summary>
        /// <param name="message">Aviso a mostrar</param>
        protected void ShowMessage(string message)
        {
            this.message.Text = string.Format("<p>{0}</p>", message.Replace("\n", "<br/>"));
        }
    }
}