#include "Protheus.ch"
#include "TopConn.ch"

/*--------------------------------------------------------------------*
| Func:  EmailAnexo()
| Autor: Eduardo Paranhos (clone educacional)
| Data:  10/08/2026
| Desc:  Email com anexo gerado dinamicamente (relatorio PDF simulado)
| Obs.:  Exemplo generico — dados ficticios
*---------------------------------------------------------------------*/

User Function EmailAnexo(cDest, cTipo)

    Local cArquivo := ""
    Local aAnexos := {}
    Local lEnviado := .F.

    Default cDest := "contabilidade@empresa-exemplo.com.br"
    Default cTipo := "RAZAO" // RAZAO, DIARIO, BALANCETE

    // Gera arquivo
    cArquivo := GenerateReportFile(cTipo)

    If !Empty(cArquivo) .And. File(cArquivo)
        AAdd(aAnexos, cArquivo)

        lEnviado := MailSend("smtp.empresa-exemplo.com.br", 587, ;
                             "protheus@empresa-exemplo.com.br", "senha-segura", ;
                             "Protheus <protheus@empresa-exemplo.com.br>", ;
                             cDest, "Relatorio Contabil: " + cTipo, ;
                             "Segue em anexo o relatorio " + cTipo + ".", ;
                             .F., aAnexos, .F., .F., .F., .F.)

        If lEnviado
            ConOut("[EmailAnexo] Relatorio " + cTipo + " enviado para: " + cDest)
        EndIf

        // Limpa arquivo temporario
        fErase(cArquivo)
    Else
        ConOut("[EmailAnexo] Falha ao gerar arquivo: " + cTipo)
    EndIf

Return lEnviado

/*--------------------------------------------------------------------*
| GenerateReportFile — Simula geracao de arquivo de relatorio
*---------------------------------------------------------------------*/
Static Function GenerateReportFile(cTipo)

    Local cFile := ""
    Local nHandle := 0

    cFile := "/tmp/protheus_" + cTipo + "_" + DtoS(Date()) + ".txt"

    nHandle := fCreate(cFile)
    If nHandle != -1
        fWrite(nHandle, "Relatorio: " + cTipo + Chr(13) + Chr(10))
        fWrite(nHandle, "Data: " + DtoC(Date()) + Chr(13) + Chr(10))
        fWrite(nHandle, "----------------------------------------" + Chr(13) + Chr(10))
        fWrite(nHandle, "Conteudo do relatorio gerado pelo Protheus." + Chr(13) + Chr(10))
        fWrite(nHandle, "Dados exemplificativos — ambiente de homologacao." + Chr(13) + Chr(10))
        fClose(nHandle)
    EndIf

Return cFile
