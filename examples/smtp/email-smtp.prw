#include "Protheus.ch"
#include "TopConn.ch"
#include "TBICONN.CH"

/*--------------------------------------------------------------------*
| Func:  EmailSMTP()
| Autor: Eduardo Paranhos (clone educacional)
| Data:  10/08/2026
| Desc:  Envio de email via SMTP com autenticacao no Protheus
| Obs.:  Exemplo generico — servidor e credenciais ficticios
*---------------------------------------------------------------------*/

User Function EmailSMTP(cDest, cAssunto, cCorpo)

    Local lEnviado := .F.
    Local cServer  := "smtp.empresa-exemplo.com.br"
    Local cPort    := "587"
    Local cConta   := "protheus@empresa-exemplo.com.br"
    Local cSenha   := "senha-segura-aqui"
    Local cFrom    := "Protheus ERP <protheus@empresa-exemplo.com.br>"

    Default cDest    := "destinatario@exemplo.com"
    Default cAssunto := "Notificacao do Protheus"
    Default cCorpo   := "Mensagem automatica do sistema Protheus."

    // Envia email
    lEnviado := MailSend(cServer, Val(cPort), cConta, cSenha, ;
                         cFrom, cDest, cAssunto, cCorpo, .F.)

    If lEnviado
        ConOut("[EmailSMTP] Email enviado para: " + cDest)
    Else
        ConOut("[EmailSMTP] Falha ao enviar email")
    EndIf

Return lEnviado

/*--------------------------------------------------------------------*
| EmailSMTPComAnexo — Envia email com arquivo anexo
*---------------------------------------------------------------------*/
User Function EmailSMTPComAnexo(cDest, cArquivo)

    Local lEnviado := .F.
    Local cServer  := "smtp.empresa-exemplo.com.br"
    Local cPort    := "587"
    Local cConta   := "protheus@empresa-exemplo.com.br"
    Local cSenha   := "senha-segura-aqui"
    Local aAnexos  := {}

    Default cDest    := "cliente@exemplo.com"
    Default cArquivo := "/tmp/relatorio.pdf"

    // Adiciona anexo
    If File(cArquivo)
        AAdd(aAnexos, cArquivo)
    EndIf

    lEnviado := MailSend(cServer, Val(cPort), cConta, cSenha, ;
                         "Protheus <protheus@empresa-exemplo.com.br>", ;
                         cDest, "Documento Fiscal - Protheus", ;
                         "Segue em anexo o documento solicitado.", ;
                         .F., aAnexos, .F., .F., .F., .F.)

Return lEnviado
