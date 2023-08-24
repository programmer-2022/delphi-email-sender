unit frm_home;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdMessage, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTP;

type
  TForm1 = class(TForm)
    txtDestinatario: TEdit;
    txtAsunto: TEdit;
    txtMensaje: TMemo;
    lblDestinatario: TLabel;
    lblAsunto: TLabel;
    lblMensaje: TLabel;
    btnEnviar: TButton;
    { Objetos }
    SMTP: TIdSMTP;
    SSL: TIdSSLIOHandlerSocketOpenSSL;
    Data: TIdMessage;
    { Procedimientos}
    procedure FormCreate(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure setupForm;
  end;

  procedure loadEnvVariables;
  procedure clearTextFields;
  function validateFields: Boolean;

var
  Form1: TForm1;
  emailAddressSender: string;
  tokenSender: string;

implementation

{$R *.dfm}

{ Cargar variables de entorno }
procedure loadEnvVariables;
begin
  emailAddressSender := GetEnvironmentVariable('GMAIL_ADDRESS_SENDER');
  tokenSender        := GetEnvironmentVariable('GMAIL_TOKEN_SENDER');
end;

{ Limpiar campos de texto }
procedure clearTextFields;
begin
    Form1.txtDestinatario.Text := '';
    Form1.txtAsunto.Text := '';
    Form1.txtMensaje.Text := '';
end;

{ Validar campos de texto }
function validateFields: Boolean;
begin
  Result := (Trim(Form1.txtDestinatario.Text) = '') or (Trim(Form1.txtMensaje.Text) = '') or (Trim(Form1.txtAsunto.Text) = '');
end;

{ Configuracion del formulario }
procedure TForm1.setupForm;
begin
  BorderStyle := bsToolWindow;
end;

{ Evento Create Form }
procedure TForm1.FormCreate(Sender: TObject);
begin
  loadEnvVariables;
  setupForm;
end;

{ Evento Click del Boton }
procedure TForm1.btnEnviarClick(Sender: TObject);
begin
    if validateFields then
    begin
        ShowMessage('Por favor, llene todos los campos.');
        Exit;
    end;

    try
      SMTP.Username := emailAddressSender;
      SMTP.Password := tokenSender;
      DATA.Subject := txtAsunto.Text;
      DATA.Recipients.EMailAddresses := txtDestinatario.Text;
      DATA.Body := txtMensaje.Lines;
      try
        SMTP.Connect;
        SMTP.Send(DATA);
      finally
        SMTP.Disconnect(True);
        ShowMessage('Correo enviado con éxito');
        clearTextFields;
        txtDestinatario.SetFocus;
      end;

    except
      on e: Exception do
        ShowMessage(e.Message);
   end;
end;

end.
