using System;
using System.Text.RegularExpressions;

namespace Client_Server
{
    public class Contact
    {
        /// <summary>
        /// Nombre
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// Correo electrónico
        /// </summary>
        public string Email { get; set; }
        /// <summary>
        /// Mensaje
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// Constructor vacío
        /// </summary>
        public Contact()
        {
            Name = "";
            Email = "";
            Message = "";
        }

        /// <summary>
        /// Constructor con los parámetros de contacto
        /// </summary>
        /// <param name="name">Nombre</param>
        /// <param name="email">Correo electrónico</param>
        /// <param name="message">Mensaje</param>
        public Contact(string name, string email, string message)
        {
            this.Name = name;
            this.Email = email;
            this.Message = message;
        }

        /// <summary>
        /// Método para validar los datos de contacto
        /// </summary>
        private void Validate()
        {
            // Nombre vacío
            if (string.IsNullOrEmpty(Name))
                throw new ArgumentException(Texts.EmptyName);

            // Correo vacío
            if (string.IsNullOrEmpty(Email))
                throw new ArgumentException(Texts.EmptyEmail);

            // Correo inválido
            if (!Regex.IsMatch(Email, Texts.EmailRegexp))
                throw new ArgumentException(Texts.InvalidEmail);

            // Mensaje vacío
            if (String.IsNullOrEmpty(Message))
                throw new ArgumentException(Texts.EmptyMessage);
        }

        /// <summary>
        /// Método para enviar mensaje
        /// </summary>
        /// <param name="isCorrect">Parámetro para indicar si se ejecutará correctamente o si se lanzará una excepción.</param>
        /// <remarks>
        /// No se incluye código para enviar mensaje. Solo la validación y el uso del parámetro correcto.
        /// </remarks>
        public void Send(bool isCorrect)
        {
            Validate();
            /*
             Código para envío de correo.
             */
            if (!isCorrect)
                throw new Exception("Error al enviar el correo.");
        }
    }
}