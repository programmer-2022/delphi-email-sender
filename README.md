1. Para el envio de correo electronico se deben copiar
los DLL ssleay32.dll libeay32.dll de la carpeta lib
hacia Win32/Debug, este directorio de salida generada tras la compilación.

2. Se deben crear variables de entorno con el nombre
GMAIL_ADDRESS_SENDER = [correo del remitente]
GMAIL_TOKEN_SENDER = [token generado desde google en reemplazo a la contrasena]

3. Se debe compilar la aplicacion nuevamente

4. Ejecutar aplicación y comprobar que lleguen los correos