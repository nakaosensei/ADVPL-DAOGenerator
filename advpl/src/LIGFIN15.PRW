#include 'protheus.ch'
#include 'parmtype.ch'

/*===============================
Chmar função de envio de email
para enviar boleto atualziado
AUTOR: Noemi Scherer
DATA: 02/02/17
=================================*/
user function LIGFIN15(nCod, nCliente, nomeArq, dir)
	Local oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
	Local cFile
	
	dbSelectArea("SA1")
	dbSetOrder(1) //A1_FILIAL + A1_COD + A1_LOJA
	dbGoTop()
	
	IF dbSeek(xFilial("SA1") + nCod)
		cPara  := SA1->A1_EMAIL
	ENDIF
	
	cCopia := u_usuario_logado()
	cAssunto := "Boleto - LIGUE TELECOMUNICAÇÕES LTDA"
	LHTML := .F.
	
	cTexto := "BOLETO  ANEXO! " + Chr(13) + Chr(10) +"O detalhamento da fatura encontra-se disponível no portal do cliente. ";
	+ Chr(13) + Chr(10) +"As notas fiscais e os boletos correspondentes à prestação do serviço estão disponíveis para download no portal do cliente.";
	+ Chr(13) + Chr(10) +"Para Acessar o portal do Cliente : http://portal.liguetelecom.com.br/. ";
	+ Chr(13) + Chr(10) +"Para se Cadastrar, clique em 'Ainda não é cadastrado' e insira os dados do contratante dos serviços.";
	+ Chr(13) + Chr(10) +"Qualquer duvida estamos a disposição," + Chr(13) + Chr(10) + " obrigada."

	dirArq := dir+nomeArq+".pdf"
	CpyT2S(dirArq, "\BKP", .F.)
	cFile := "\BKP\"+nomeArq+".pdf"	
	
	DEFINE MSDIALOG OdlgMemo TITLE "Enviar email para: "+nCliente FROM 000, 000  TO 500, 600 COLORS 0, 16777215 PIXEL
			
		@ 015, 015 SAY oSay1 PROMPT "Email: *" SIZE 185, 014 OF OdlgMemo FONT oFont1 COLORS 0, 16777215 PIXEL
			
		@ 030, 015 Get cPara Size 220, 015 MEMO of OdlgMemo Pixel
			
			
		@ 045, 015 SAY oSay2 PROMPT "cc " SIZE 185, 014 OF OdlgMemo FONT oFont1 COLORS 0, 16777215 PIXEL
			
		@ 060, 015 Get cCopia Size 220, 015 MEMO of OdlgMemo Pixel
			
			
		@ 080, 015 SAY oSay3 PROMPT "Assunto: *" SIZE 185, 014 OF OdlgMemo FONT oFont1 COLORS 0, 16777215 PIXEL
			
		@ 100, 015 Get cAssunto Size 220, 015 MEMO of OdlgMemo Pixel
			
			
		@ 120, 015 SAY oSay4 PROMPT "Descrição do email: *" SIZE 185, 014 OF OdlgMemo FONT oFont1 COLORS 0, 16777215 PIXEL
			
		@ 135, 015 Get cTexto Size 220, 090 MEMO of OdlgMemo Pixel
			
		
		@ 230, 015 SAY oSay4 PROMPT "[*] Campo obrigatório" SIZE 160, 008 OF OdlgMemo FONT oFont1 COLORS 0, 16777215 PIXEL	
		
			
		@ 230, 191 Button "Enviar" 	SIZE 50, 14 Action u_verif_dados(cPara,cCopia,cAssunto,cTexto,lHtml,cFile) of OdlgMemo Pixel
			
		@ 230, 250 Button "Sair"   		SIZE 50, 14 Action OdlgMemo:End() of OdlgMemo Pixel
	
	ACTIVATE DIALOG OdlgMemo CENTERED
	
return


user function usuario_logado()
	codUsr := RetCodUsr()
	
	mailUser := UsrRetMail ( [ codUsr ] )

return mailUser


user function verif_dados(cPara,  cCopia, cAssunto, cTexto, lHtml, cFile)
	IF EMPTY(cPara) .OR. EMPTY(cAssunto) .OR. EMPTY(cTexto)
		ALERT("Os campos email, assunto ou descrição não foram preenchidos")
	
	ELSE
		u_LIGGEN03(cPara, cCopia,"" ,cAssunto,cTexto,lHtml,cFile)
		MsgInfo("Email enviado com sucesso!")
		OdlgMemo:End()
		
	ENDIF
	
return