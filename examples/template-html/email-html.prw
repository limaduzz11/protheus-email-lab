#include "Protheus.ch"
#include "TopConn.ch"

/*--------------------------------------------------------------------*
| Func:  EmailHTML()
| Autor: Eduardo Paranhos (clone educacional)
| Data:  10/08/2026
| Desc:  Envio de email com template HTML e dados dinamicos do Protheus
| Obs.:  Exemplo generico — dados ficticios
*---------------------------------------------------------------------*/

User Function EmailHTML(cDest)

    Local cHTML := ""
    Local lEnviado := .F.

    Default cDest := "gestor@empresa-exemplo.com.br"

    // Monta template HTML com dados do banco
    cHTML := BuildHTMLReport()

    // Envia
    lEnviado := MailSend("smtp.empresa-exemplo.com.br", 587, ;
                         "protheus@empresa-exemplo.com.br", "senha-segura", ;
                         "Protheus <protheus@empresa-exemplo.com.br>", ;
                         cDest, "Resumo Diario de Vendas", cHTML, .F.)

Return lEnviado

/*--------------------------------------------------------------------*
| BuildHTMLReport — Monta HTML com dados dinamicos
*---------------------------------------------------------------------*/
Static Function BuildHTMLReport()

    Local cHTML := ""
    Local nTotalVendas := 0.0
    Local nQtdNF := 0
    Local dHoje := Date()

    // Busca dados do dia
    DbSelectArea("SF2")
    DbSetOrder(1)
    nTotalVendas := 0
    nQtdNF := 0

    DbGoTop()
    While !Eof()
        If SF2->F2_EMISSAO == dHoje
            nTotalVendas += SF2->F2_VALBRUT
            nQtdNF++
        EndIf
        DbSkip()
    EndDo

    // Monta HTML
    cHTML += "<html><body style='font-family:Arial,sans-serif'>"
    cHTML += "<h2 style='color:#1a73e8'>Resumo de Vendas — " + DtoC(dHoje) + "</h2>"
    cHTML += "<table border='1' cellpadding='8' cellspacing='0' style='border-collapse:collapse'>"
    cHTML += "<tr style='background:#1a73e8;color:white'>"
    cHTML += "<th>Indicador</th><th>Valor</th></tr>"
    cHTML += "<tr><td>Notas Fiscais emitidas</td><td>" + cValToChar(nQtdNF) + "</td></tr>"
    cHTML += "<tr><td>Total de vendas</td><td>R$ " + Transform(nTotalVendas, "@E 999,999,999.99") + "</td></tr>"
    cHTML += "<tr><td>Ticket medio</td><td>R$ " + Transform(Iif(nQtdNF > 0, nTotalVendas / nQtdNF, 0), "@E 999,999.99") + "</td></tr>"
    cHTML += "</table>"
    cHTML += "<p style='color:#666;font-size:12px'>Relatorio gerado automaticamente pelo Protheus.</p>"
    cHTML += "</body></html>"

Return cHTML
