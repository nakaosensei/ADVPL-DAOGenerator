#include 'parmtype.ch'
#Include 'Protheus.ch'
#include "TOTVS.CH" 
#include "rwmake.ch"
#include 'FWMVCDEF.CH'
#include "AP5MAIL.CH"


user function LIGCAL10()	
return PROCESSA({||LGCAL10A()}) //Chama a tela

static function LGCAL10A()		
	LOCAL _NQTREGUA := 0
	Local oDlgData := u_cFCDlg("Contratos proximos do termino")	//Gera uma dialog generica full screen, a fun��o est� no arquivo LIGNKUT.prw
	Local posFnY := oDlgData[2]
	Local posFnX := oDlgData[3]	
	Local oDlg1 := oDlgData[1]	 	
	Private aFields := {"ADA_NUMCTR","ADA_EMISSA","ADA_UTIPO","ADA_CODCLI","A1_LOJA","A1_NOME","ADA_VEND1","A3_NOME","ADA_VEND2","A3_NOME","ADA_STATUS","ADA_UDTBLQ","ADA_UNFIMP","ADA_UVALI","Dias Restantes"}//Nome dos campos que devem ser exibidos na tabela
	Private aBrowse := {}
	private codVend := ""
	out := u_LGCAL10B() //Fun��o que valida o usuario e retorna o codigo do vendedor caso seja na pos 2
	enableW := out[1]
	codVend := out[2]
	if(enableW = .F.)
		MsgAlert("Voc� n�o tem acesso a essa tela, ela s� � visivel para vendedores e supervisores. Cadastro de Operador(SU7)")
		return 
	endif		
	
	//O codigo abaixo serve para mostrar a window de "carregando" enquanto ocorre a busca no bancp
	DBSELECTAREA("ADA")
	DBSETORDER(1)
	DBGOTOP()
	WHILE !EOF()
	 IF ADA->ADA_ULIBER=="S"//LIB FINANCEIRO
	  _NQTREGUA++
	 ENDIF
	 DBSKIP()
	ENDDO	
	PROCREGUA(_NQTREGUA)
	
	aBrowse := u_LGCAL10D(aBrowse)  //Essa fun��o carrega todos os dados da tabela em uma lista
	//Membros de oDlg1
	u_LGCAL10E(oDlg1,001,0,INT(posFnY/2)-30,INT(posFnX/2),aFields,aBrowse) //Gera uma tabela para os contratos
	//TButton():New( INT(posFnY/2)-15, INT(posFnX/2)-130, "Env.Emails", oDlg1,{||u_LGCAL10C(aBrowse) },60,010,,,.F.,.T.,.F.,,.F.,,,.F.) 
	TButton():New( INT(posFnY/2)-15, INT(posFnX/2)-60, "Sair", oDlg1,{||Close(oDlg1) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.) 
	ACTIVATE MSDIALOG oDlg1 CENTERED
		
return
//Fun��o para dizer e o usuario logado no sistema � valido e para identificar o vendedor caso seja um
user function LGCAL10B()
	enableW := .F.
	_areaS := getarea()
	codUsr := RetCodUsr()	
	tpUsr := POSICIONE("SU7",4,xFilial("SU7")+codUsr,"U7_TIPO")
	if(AllTRIM(tpUsr)=="1")//Se for vendedor
		enableW := .T.
		dbSelectArea("SA3")
		dbSetOrder(7)//filial+codUsr
		if(dbSeek(xFilial("SA3")+codUsr)) //Achou o vendedor?		
			codVend := SA3->A3_COD	
		endif
	elseif(AllTRIM(tpUsr)=="2")//Se for supervisor
		enableW := .T.
	endif
	restarea(_areaS)
return {enableW,codVend}

user function LGCAL10C(aBrowse)//Fun��o para envio de email para usu�rios de contratos da LGCAL10A
	Local email:=""
	Local usrNoMail:=""
	Local tituloDefault := "Contrato Ligue pr�ximo do vencimento"
	Local msgEmail := ""
	Local itensCt := {}
	for i:=1 to len(aBrowse)
		email:=POSICIONE( "SA1", 1, XFILIAL( "SA1" ) + aBrowse[i][4] + aBrowse[i][5], "A1_EMAIL")
		if(AllTrim(email)=="")
			usrNoMail+=aBrowse[i][6]+"("+aBrowse[i][4]+")"+"; "
		else
			msgEmail := "Bom dia "+aBrowse[i][6]+"."+ Chr(13) + Chr(10) +"Notamos que o seu contrato com a Ligue Telecom est� pr�ximo de vencer, o numero � "+ ALLTRIM(aBrowse[i][1]) +",no momento lhe oferecemos os seguintes servi�os:"+Chr(13) + Chr(10)
			itensCt := u_LGGNMITC(xFilial("ADB"),aBrowse[i][1])
			for j:=1 to len(itensCt)
				msgEmail+= Chr(13) + Chr(10) +itensCt[j][2]+"("+itensCt[j][1]+")"//Nome e codigo do produto do item do contrato
			next
			MsgAlert(msgEmail)
		endif
		msgEmail:=""
	next	
	if (ALLTRIM(usrNoMail)=="") = .F.
		MsgAlert(usrNoMail)
	endif	
return

user function LGCAL10D(aBrowse)//Fun��o para preencher a lista de contratos proximos do vencimento
	dbselectarea("ADA")
	dbsetorder(1)
	dbGoTop()	
	dtAtual:=""
	menorDt := ""
	dtDif := 0
	_diasCPV := getmv("MV_ADAPFV")
	if dbseek(xFilial())
		dtAtual := DTOC(Date())		
		while !eof()
			menorDt:=u_LGIVADA(ADA->ADA_FILIAL,ADA->ADA_NUMCTR)//LIGUE GET INICIO VIGENCIA: Essa fun��o retorna o inicio da vigencia de um contrato ADA, est� em LIGNKUT.prw
			if(VALTYPE(menorDt)=="D")
				menorDt := DTOC(menorDt)	
				dtDif := u_gDateDif(dtAtual,u_addMonths(menorDt,ADA->ADA_UVALI))	
				//MsgAlert(ADA->ADA_NUMCTR +" - "+CVALTOCHAR(dtDif))	
				if(Alltrim(codVend) == "")												
					if xFilial("ADA") == ADA->ADA_FILIAL .AND. ALLTRIM(ADA->ADA_UCANCE)<>"1" .AND. (ALLTRIM(ADA->ADA_UFIREP)=="N" .OR. ALLTRIM(ADA->ADA_UFIREP)=="") .AND. dtDif<=_diasCPV .AND. dtDif>=0 .AND. ALLTRIM(ADA->ADA_MSBLQL)<>"1"
						aAdd(aBrowse,{ADA->ADA_NUMCTR,DTOC(ADA->ADA_EMISSA),ADA->ADA_UTIPO,ADA->ADA_CODCLI,ADA->ADA_LOJCLI,u_LGNMCLI(xFilial("SA1"),ADA->ADA_CODCLI,ADA->ADA_LOJCLI),ADA->ADA_VEND1,u_LGNMVND(xFilial("SA3"),ADA->ADA_VEND1),ADA->ADA_VEND2,u_LGNMVND(xFilial("SA3"),ADA->ADA_VEND2),ADA->ADA_STATUS,DTOC(ADA->ADA_UDTBLQ),u_csntf(ADA->ADA_UNFIMP),ADA->ADA_UVALI,dtDif})
					endif				
				else
					if xFilial("ADA") == ADA->ADA_FILIAL .AND. ALLTRIM(ADA->ADA_UCANCE)<>"1" .AND. (ALLTRIM(ADA->ADA_UFIREP)=="N" .OR. ALLTRIM(ADA->ADA_UFIREP)=="") .AND. dtDif<=_diasCPV .AND. dtDif>=0 .AND. ALLTRIM(ADA->ADA_MSBLQL)<>"1" .AND. (ADA_VEND1==codVend .OR. ADA_VEND2==codVend)
						aAdd(aBrowse,{ADA->ADA_NUMCTR,DTOC(ADA->ADA_EMISSA),ADA->ADA_UTIPO,ADA->ADA_CODCLI,ADA->ADA_LOJCLI,u_LGNMCLI(xFilial("SA1"),ADA->ADA_CODCLI,ADA->ADA_LOJCLI),ADA->ADA_VEND1,u_LGNMVND(xFilial("SA3"),ADA->ADA_VEND1),ADA->ADA_VEND2,u_LGNMVND(xFilial("SA3"),ADA->ADA_VEND2),ADA->ADA_STATUS,DTOC(ADA->ADA_UDTBLQ),u_csntf(ADA->ADA_UNFIMP),ADA->ADA_UVALI,dtDif})
					endif
				endif
			endif
			dbselectarea("ADA")	
			dbskip()						
		enddo		
	endif
return aBrowse

User Function LGCAL10E(oDlg1,posX,posY,altura,comprimento,aFields,aBrowse)
	Local oBrowse := {}
	Local aHeader := {}
	Local sizeCols := {}
	
	//Preenchimento dos dados do cabe�alho
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)-1
	   If SX3->(DbSeek(aFields[nX]))
	      aAdd(aHeader, AllTrim(X3Titulo()))
	      aAdd(sizeCols,SX3->X3_TAMANHO)
	    Endif
	Next nX		
	aAdd(aHeader, aFields[len(aFields)])
	aAdd(sizeCols,10)
	
	// Cria Browse
    oBrowse := TCBrowse():New( posX , posY, comprimento, altura,, aHeader,sizeCols, oDlg1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.T. )
    oBrowse:SetArray(aBrowse)      
    oBrowse:bLine := {||u_gInListB(aFields,aBrowse,oBrowse)}   
Return


