<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Client_Server.Default" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Prueba de validación desde cliente y desde servidor con AJAX</title>
    <link rel="stylesheet" href="content/styles.css" />
</head>
<body>
    <header>
        <h1>Prueba de validación desde cliente y desde servidor con AJAX</h1>
    </header>

    <form id="form1" runat="server">
        <fieldset>
            <legend>Enviar mensaje</legend>
            <p>
                <asp:Label runat="server" AssociatedControlID="name" Text="Nombre:" />
                <asp:TextBox runat="server" ID="name" />
            </p>
            <p>
                <asp:Label runat="server" AssociatedControlID="email" Text="Correo:" />
                <asp:TextBox runat="server" ID="email" type="email" />
            </p>
            <p>
                <asp:Label runat="server" AssociatedControlID="messageBody" Text="Mensaje:" />
                <asp:TextBox runat="server" ID="messageBody" TextMode="MultiLine" />
            </p>
            <div class="buttons">
                <asp:Button ID="send" runat="server" Text="Enviar" />
            </div>
            <p class="send-type">
                <asp:CheckBox ID="correct" runat="server" Text="Envío correcto" />
            </p>
            <div class="message">
                <asp:Literal ID="message" runat="server" />
            </div>
        </fieldset>
    </form>
    <script src="<%= ResolveClientUrl("~/scripts/jquery-1.12.4.js")%>"></script>
    <script>
    <%--
        == Etiquetas de servidor
        El contenido entre símbolos <% %> (como este bloque de comentarios) es procesado por el servidor. Lo que aparece entre
        <%= %> es "impreso" en la página web.
        Por ejemplo, al escribir
          $('#<%= send.ClientID %>')
        El servidor procesa la instrucción send.ClientID, donde "ClientID" es una propiedad de "send" que guarda el
        atributo "id" del elemento HTML. En el código fuente de la página, aparecerá de esta forma:
          $('#send'); ó
          $('#id_send');
        El atributo id no es necesariamente el ID del control en ASP (control con atributo runat="server"), ya que el servidor
        procesa los controles y genera las etiquetas HTML, pudiendo cambiar los atributos id o name para que no se repitan.

        En el caso de la instrucción
          throw Error('<%= EmptyName %>');
        El servidor busca la propiedad EmptyName en el código fuente de esta página (default.aspx.cs), donde existe una
        propiedad con ese nombre con el atributo "protected", siendo el resultado éste:
          throw Error('Proporcione su nombre.');

        == AJAX de jQuery y servicios Web
        Cuando el servicio web incluye el atributo [System.Web.Script.Services.ScriptService], puede ser invocado desde JavaScript.
        La función ajax de jQuery invoca al servicio web:
        $.ajax({
            url:'[servicioWeb.asmx]/[MetodoWeb]',
            type:'POST',
            dataType:'json',
            contentType:'application/json; charset=utf-8',
            data: JSON.stringify(parametros),
            success: function(resultado) { },
            error: function(resultado) { }
        }
        Json: http://es.wikipedia.org/wiki/Json
        El objeto JSON existe nativamente en los navegadores actuales. Para los navegadores antiguos donde no existe, debe importarse
        la librería de esta página: https://github.com/douglascrockford/JSON-js/blob/master/json2.js
        JSON incluye dos métodos:
        - stringify: Convierte un objeto JavaScript a String
            JSON.stringify({ name: "Fulano", email: "fulano@hotmail.com" }); -> "{ \"name\": \"fulano\", \"email\": \"fulano@hotmail.com\" }"
          Esta conversión la podríamos escribir a mano, pero JSON evita errores de nuestra parte.
        - parse: Convierte una cadena de texto en objeto JavaScript
            "{ \"name\": \"fulano\", \"email\": \"fulano@hotmail.com\" }" -> { name: "Fulano", email: "fulano@hotmail.com" };
        La función success se ejecuta al terminar el servicio web. La variable resultado.d tiene el valor regresado por el método web.
          [WebMethod]
          public string Metodo(){
              return "valor";
          }
        Este método devuelve un string.

          [WebMethod]
          public bool Metodo() {
              return true;
          }
        Este método devuelve un booleano.

          [WebMethod]
          public Contact Metodo() {
              return new Contact("Nombre", "Correo", "Mensaje");
          }
        Este método devuelve un objeto equivalente a la clase Contact, pero para JavaScript

        Los servicios web con el atributo [System.Web.Script.Services.ScriptService] permiten la interacción
        entre objetos de .NET y de javascript, haciéndolos equivalentes.

        El método ejecutado en el error de ajax devuelve un parámetro con una variable responseText, que es una
        cadena de texto convertible a objeto por medio de JSON. Este objeto es equivalente a la clase Exception
        arrojada por el servicio web. De ahí que podemos usar su propiedad Message.

        El servicio web y el code-behind de la página reutilizan elementos para evitar repetición de código, como
        las variables de la clase Texts y la función para enviar mensaje de la clase Contact.
     --%>
        // Al cargar la página, se ejecuta esta función
        $(function () {
            // Disparador del evento click del botón para enviar mensaje
            $('#<%= send.ClientID %>').on('click', function (e) {
                e.preventDefault(); // Se detiene el comportamiento normal del botón.
                var errorHandled = false; // Indica si el error es controlado desde el código. Se usa en el bloque catch

                try {
                    var name = $('#<%= name.ClientID %>'); // input del nombre
                    var mail = $('#<%= email.ClientID %>'); // input del correo
                    var msg = $('#<%= messageBody.ClientID %>'); // input del mensaje

                    if (name.val() === '') {
                        // Error de nombre vacío
                        errorHandled = true;
                        name.focus();
                        throw Error('<%= EmptyName %>');
                    }
                    if (mail.val() === '') {
                        // Error de correo vacío
                        errorHandled = true;
                        mail.focus();
                        throw Error('<%= EmptyEmail %>');
                    }
                    try { mail.val().match(new RegExp("<%= JSEmailRegexp %>")); }
                    catch (ex) {
                        // Error de correo inválido
                        errorHandled = true;
                        mail.focus();
                        throw Error('<%= InvalidEmail %>');
                    }
                    if (msg.val() === '') {
                        // Error de mensaje vacío
                        errorHandled = true;
                        msg.focus();
                        throw Error('EmptyMessage');
                    }

                    // Checkbox para generar mensaje correcto o incorrecto
                    var c = $('#<%= correct.ClientID %>').prop('checked') ? true : false;
                    // Parámetros que se enviarán por AJAX
                    var parametros = { name: name.val(), email: mail.val(), messageBody: msg.val(), correct: c };

                    $.ajax({
                        url: 'mailService.asmx/SendMessage', // Se llama al servicio web más el nombre del método
                        type: 'POST', // Debe ser de tipo POST
                        dataType: 'json', // Se usa JSON para la transmisión de datos
                        contentType: 'application/json; charset=utf-8',
                        data: JSON.stringify(parametros), // Se convierte el objeto con los parámetros a una cadena de texto JSON
                        success: sendSuccess, // Si la operación es correcta, se ejecuta la función "enviado"
                        error: sendError // Si la operación es incorrecta, se ejecuta la función "noEnviado"
                    });

                } catch (ex) {
                    // Si el error fue controlado, se muestra un mensaje
                    if (errorHandled) {
                        showMessage('<%= SendError %>\n' + ex);
                    } else {
                        // Si el error no fue controlado, se hace el submit para intentar enviar el mensaje desde el servidor
                        this.form.submit();
                    }
                }
            });
        });

        function sendSuccess(res) {
            // El objeto res incluye un parámetro d, con un objeto de javascript del resultado devuelto por el método web
            if (res.d === true) {
                showMessage('<%= MessageSent %>');
            } else {
                showMessage('<%= SendError %>');
            }
        }

        function sendError(res) {
            // El objeto res incluye una variable de texto responseText, en formato JSON,
            // con la excepción de .NET lanzada por el método web. Se convierte a objeto de
            // javascript con la función JSON.parse, para obtener la variable Message
            var error = JSON.parse(res.responseText).Message;
            showMessage('<%= SendError %>\n' + error);
        }

        function showMessage(message) {
            // Este método muestra el aviso indicado en pantalla
            var a = $('.message');
            a.children().remove();
            a.append('<p>' + message.replace('\n', '<br/>') + '</p>');
        }
    </script>
</body>
</html>
