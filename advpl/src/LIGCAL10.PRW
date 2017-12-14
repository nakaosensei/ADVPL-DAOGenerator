#include 'parmtype.ch'
#Include 'Protheus.ch'
#include "TOTVS.CH"
#include "rwmake.ch"
#include 'FWMVCDEF.CH'
#include "AP5MAIL.CH"
#include "topconn.ch"

user function LIGCAL10()
	LGCAL10A()
	//return PROCESSA({||LGCAL10A()}) //Chama a tela
	//	processa( {|| LGCAL10A() }, "Carregando", "Processando aguarde...", .f.)
return

static function LGCAL10A()

	LOCAL _NQTREGUA := 0
	Local oDlgData := u_cFCDlg("Contratos proximos do termino")	//Gera uma dialog generica full screen, a função está no arquivo LIGNKUT.prw
	Local posFnY := oDlgData[2]
	Local posFnX := oDlgData[3]
	Local oDlg1 := oDlgData[1]
	Local aHeader := {}
	Local sizeCols := {}
	Private aFields := {"","ADA_NUMCTR","ADA_EMISSA","ADA_UTIPO","ADA_CODCLI","A1_LOJA","A1_NOME","ADA_VEND1","A3_NOME","ADA_VEND2","A3_NOME","ADA_STATUS","ADA_UNFIMP","ADA_UVALI","Dias Restantes"}//Nome dos campos que devem ser exibidos na tabela
	Private aBrowse := {}
	private codVend := ""
	private ONO 	   := LOADBITMAP( GETRESOURCES(), "LBNO"  )
	private OOK 	   := LOADBITMAP( GETRESOURCES(), "LBTIK" )
	Private aButtons := {}
	PRIVATE NOPCA  := 0 // Controle de mensagem da listbox
	private vend := ""

	out := u_LGCAL10B() //Função que valida o usuario e retorna o codigo do vendedor caso seja na pos 2
	enableW := out[1]
	codVend := out[2]
	tpUsr := out[3]
	if(enableW = .F.)
		MsgAlert("Você não tem acesso a essa tela, ela só é visivel para vendedores e supervisores. Cadastro de Operador(SU7)")
		return
	endif

	vend := codVend
	if(tpUsr == "2") //Gerente
		aBrowse := u_LGCAL10D(aBrowse)  //Essa função carrega todos os dados da tabela em uma lista

	endif
	//	Membros de oDlg1
	u_LGCAL10E(aFields,aHeader,sizeCols) //Gera uma tabela para os contratos

	DEFINE MSDIALOG ODLGA TITLE OEMTOANSI("CONTRATOS") FROM 0,0 TO 35,160 OF OMAINWND
	@ 1,0 LISTBOX OLBXA VAR CITBX FIELDS HEADER "","CTR","EMISSAO","TIPO","COD","CLIENTE","CTR VENDEDOR","NOME","CODIGO","VENDEDOR RENOVAÇÃO","DIAS REMANESCENTES" SIZE 630,235 ON DBLCLICK (aBrowse[OLBXA:NAT,1]:=!aBrowse[OLBXA:NAT,1],OLBXA:REFRESH())

	Aadd( aButtons, {"ITENS", {|| U_LGCAL10F(aBrowse[OLBXA:nAt])}, "Itens do Contrato...", "Itens do Contrato" , {|| .T.}} )
	if(tpUsr == '2') //Gerente
		OLBXA:SETARRAY(aBrowse)
		OLBXA:BLINE := {|| {IF(aBrowse[OLBXA:NAT,1],OOK,ONO),aBrowse[OLBXA:NAT,2],aBrowse[OLBXA:NAT,3],aBrowse[OLBXA:NAT,4],aBrowse[OLBXA:NAT,5],aBrowse[OLBXA:NAT,6],aBrowse[OLBXA:NAT,7],aBrowse[OLBXA:NAT,8],aBrowse[OLBXA:NAT,9],aBrowse[OLBXA:NAT,10],aBrowse[OLBXA:NAT,11]}}

		Aadd( aButtons, {"RENOVAÇÕES VENDEDOR", {|| listVend()}, "Renovações Vendedor...", "Renovações Vendedor" , {|| .T.}} )
		Aadd( aButtons, {"TODOS REGISTROS", {|| processa( {|| u_LGCAL10H() }, "Carregando", "Processando aguarde...", .f.)}, "Todos Registros...", "Todos Registros" , {|| .T.}} )
		
		ACTIVATE MSDIALOG ODLGA CENTER ON INIT ENCHOICEBAR(ODLGA,{|| u_CAL10VAL()},{|| ,ODLGA:END()},,ABUTTONS)
	else
		aBrowse := u_LGCAL10I(aBrowse) // somente do vendedor
		OLBXA:SETARRAY(aBrowse)
		OLBXA:BLINE := {|| {IF(aBrowse[OLBXA:NAT,1],OOK,ONO),aBrowse[OLBXA:NAT,2],aBrowse[OLBXA:NAT,3],aBrowse[OLBXA:NAT,4],aBrowse[OLBXA:NAT,5],aBrowse[OLBXA:NAT,6],aBrowse[OLBXA:NAT,7],aBrowse[OLBXA:NAT,8],aBrowse[OLBXA:NAT,9],aBrowse[OLBXA:NAT,10],aBrowse[OLBXA:NAT,11]}}
		
		ACTIVATE MSDIALOG ODLGA CENTER ON INIT ENCHOICEBAR(ODLGA,{|| ,ODLGA:END()},{|| ,ODLGA:END()},,ABUTTONS)
	endif

return
//Função para dizer e o usuario logado no sistema é valido e para identificar o vendedor caso seja um
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
return {enableW,codVend,tpUsr}

user function LGCAL10C(aBrowse)//Função para envio de email para usuários de contratos da LGCAL10A
	Local email:=""
	Local usrNoMail:=""
	Local tituloDefault := "Contrato Ligue próximo do vencimento"
	Local msgEmail := ""
	Local itensCt := {}
	for i:=1 to len(aBrowse)
		email:=POSICIONE( "SA1", 1, XFILIAL( "SA1" ) + aBrowse[i][4] + aBrowse[i][5], "A1_EMAIL")
		if(AllTrim(email)=="")
			usrNoMail+=aBrowse[i][6]+"("+aBrowse[i][4]+")"+"; "
		else
			msgEmail := "Bom dia "+aBrowse[i][6]+"."+ Chr(13) + Chr(10) +"Notamos que o seu contrato com a Ligue Telecom está próximo de vencer, o numero é "+ ALLTRIM(aBrowse[i][1]) +",no momento lhe oferecemos os seguintes serviços:"+Chr(13) + Chr(10)
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
	//u_sSmpMail("nakaosensei@gmail.com","teste advpl","Look at my horse, my horse is amazing")
return

user function LGCAL10D(aBrowse)//Função para preencher a lista de contratos proximos do vencimento

	cQuery := " SELECT (SELECT MIN(ADB2.ADB_UDTINI) FROM "+RetSqlName("ADB")+" ADB2 WHERE ADA.ADA_NUMCTR = ADB2.ADB_NUMCTR AND ADB2.ADB_UDTINI <> '' AND ADB2.ADB_UDTFIM = ''),"
	cQuery += " ADB_UDTINI,ADA_NUMCTR,ADA_EMISSA,
	cQuery += " CASE ADA_UTIPO WHEN 'P' THEN 'PLUG' WHEN 'F' THEN 'FTTH' ELSE 'VOIP' END as ADA_UTIPO,"
	cQuery += " ADA_CODCLI,ADA_LOJCLI,ADA_VEND1,ADA_VEND2,ADA_STATUS,ADA_UDTBLQ,ADA_UNFIMP,ADA_UVALI,A1_VEND,"
	cQuery += " DATEDIFF(DAY,GETDATE(),convert(varchar(8),DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),112)) as DIAS"
	cQuery += " FROM "+RetSqlName("ADA")+" ADA"
	cQuery += " INNER JOIN "+RetSqlName("ADB")+" ADB ON ADB.ADB_NUMCTR=ADA.ADA_NUMCTR"
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON ADB.ADB_CODPRO = SB1.B1_COD "
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON ADA.ADA_CODCLI = SA1.A1_COD "
	cQuery += " WHERE ADA_ULIBER = 'S' AND ADA_UCANCE <> 1"
	cQuery += " AND ADB_UDTINI > '19500000'"
	cQuery += " AND (ADA_UFIREP='N' OR ADA_UFIREP='')"
	cQuery += " AND ADA_MSBLQL<>'1' AND B1_UITCONT = 'S' AND ADB_UDTINI <> '' AND ADB_UDTFIM = ''"
	cQuery += " AND ADB_UDTINI = (SELECT MIN(ADB2.ADB_UDTINI) FROM "+RetSqlName("ADB")+" ADB2 WHERE ADA.ADA_NUMCTR = ADB2.ADB_NUMCTR AND ADB2.ADB_UDTINI <> '' AND ADB2.ADB_UDTFIM = '')"
	cQuery += " AND DATEDIFF(DAY,GETDATE(),convert(varchar(8),DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),112)) <= "+STR(getmv("MV_ADAPFV"))
	cQuery += " group by ADA_NUMCTR,ADA_EMISSA,ADA_UTIPO,ADA_CODCLI,ADA_LOJCLI,ADA_CODCLI,ADA_VEND1,ADA_VEND2,ADA_STATUS,ADA_UDTBLQ,ADA_UNFIMP,ADA_UVALI,A1_VEND,DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),ADB_UDTINI"
	cQuery += " order BY DATEDIFF(DAY,GETDATE(),convert(varchar(8),DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),112)) ASC"
	TCQUERY cQuery NEW ALIAS "TEMP"
	dbselectarea("TEMP")

	while !eof()
		aAdd(aBrowse,{.F.,TEMP->ADA_NUMCTR,TEMP->ADA_EMISSA,TEMP->ADA_UTIPO,TEMP->ADA_CODCLI,alltrim(u_LGNMCLI(xFilial("SA1"),TEMP->ADA_CODCLI,TEMP->ADA_LOJCLI)),TEMP->ADA_VEND1,u_LGNMVND(xFilial("SA3"),TEMP->ADA_VEND1),TEMP->A1_VEND,u_LGNMVND(xFilial("SA3"),TEMP->A1_VEND),TEMP->DIAS})
		dbselectarea("TEMP")
		dbskip()

	enddo

	TEMP->(dbclosearea())
return aBrowse

User Function LGCAL10E(aFields,aHeader,sizeCols)
	Local oBrowse := {}

	//Preenchimento dos dados do cabeçalho
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
Return

User Function LGCAL10F(contrato)
	Local oDlgData := u_cFCDlg("Itens do Contrato")	//Gera uma dialog generica full screen, a função está no arquivo LIGNKUT.prw
	Local posFnY := oDlgData[2]
	Local posFnX := oDlgData[3]
	Local oDlg2 := oDlgData[1]
	Local aHeader := {}
	Local sizeCols := {}
	Private aFields := {"ADB_NUMCTR","ADB_ITEM","ADB_CODPRO","ADB_DESPRO","ADB_QUANT","ADB_PRCVEN","ADB_TOTAL","ADB_UDTINI","ADB_UDTFIM","ADB_UVEND1","ADB_UVEND2"}//Nome dos campos que devem ser exibidos na tabela
	Private aBrowse := {}

	DBSELECTAREA("ADB")
	DBSETORDER(1)
	DBGOTOP()
	IF DBSEEK(XFILIAL("ADB")+contrato[2])
		WHILE !EOF() .AND. ADB->ADB_FILIAL+ADB->ADB_NUMCTR==XFILIAL("ADB")+contrato[2]
			aAdd(aBrowse,{ADB->ADB_NUMCTR,ADB->ADB_ITEM,ADB->ADB_CODPRO,ADB->ADB_DESPRO,ADB->ADB_QUANT,ADB->ADB_PRCVEN,ADB->ADB_TOTAL,ADB->ADB_UDTINI,ADB->ADB_UDTFIM,ADB->ADB_UVEND1,ADB->ADB_UVEND2})

			DBSELECTAREA("ADB")
			DBSKIP()
		enddo
	endif

	//Membros de oDlg1
	u_LGCAL10E(aFields,aHeader,sizeCols) //Gera uma tabela para os contratos

	// Cria Browse
	oBrowse2 := TCBrowse():New( 001 , 0, INT(posFnX/2), INT(posFnY/2)-30,, aHeader,sizeCols, oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.T. )
	oBrowse2:SetArray(aBrowse)
	oBrowse2:bLine := {||u_gInListB(aFields,aBrowse,oBrowse2)}

	//TButton():New( INT(posFnY/2)-15, INT(posFnX/2)-130, "Linha atual", oDlg2,{|| U_LGCAL10F(aBrowse[oBrowse2:nAt]) },60,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( INT(posFnY/2)-15, INT(posFnX/2)-60, "Sair", oDlg2,{||Close(oDlg2) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
	ACTIVATE MSDIALOG oDlg2 CENTERED
Return

STATIC FUNCTION busVend()
	Local aItems:= {}
	DBSELECTAREA("SA3")
	DBSETORDER(1)
	if dbseek(xFilial())
		WHILE !EOF()
			AADD(aItems,SA3->A3_COD +' - '+SA3->A3_NOME)
			dbselectarea("SA3")
			dbskip()
		ENDDO
	endif

	DEFINE DIALOG oDlg TITLE "Vendedor Responsavel" FROM 180,180 TO 230,515 PIXEL
	// Usando New
	vend := SubStr(aItems[1],1,7)
	cCombo1:= aItems[1]
	oCombo1 := TComboBox():New(02,02,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
	aItems,100,20,oDlg,,{|| vend := SubStr(aItems[oCombo1:nAt],1,7)};
	,,,,.T.,,,,,,,,,'cCombo1')

	ACTIVATE DIALOG oDlg CENTERED ON INIT ENCHOICEBAR(oDlg,{|| processa( {|| u_CAL10SAV() }, "Gravando", "Processando aguarde...", .f.)},{|| ,oDlg:END()},,)
	//    ACTIVATE MSDIALOG ODLGA CENTER ON INIT ENCHOICEBAR(ODLGA,{|| busVend()},{|| ,ODLGA:END()},,ABUTTONS)
RETURN

User Function CAL10VAL()
	// 1- Garantir que não excute caso haja registro selecionado

	cCont := 0
	for i:=1 to len(aBrowse)
		if aBrowse[i,1] == .F.
			cCont += 1
		endif
	endfor
	if cCont == len(aBrowse)
		alert("Você deve selecionar ao menos 1 registro !")
		NOPCA := 7
	endif

	// 3- Deletar seleção
	if cCont > 0 .AND. len(aBrowse) > cCont
		NOPCA := MessageBox("Deseja Mover os registros selecionados ?","Atenção !",4)
	endif
	//LEGENDA
	//NOPCA -> 6 = SIM, NOPCA -> 7 = NÃO, NOPCA -> 0 FECHAR
	if NOPCA == 6
		busVend()
		//Fecha a Tela, após a execução
		//		ODLGA:END()
	elseif NOPCA == 7
	else
		//Fecha a Tela, após a execução
		ODLGA:END()
	endif

return

User Function CAL10SAV()
	procregua(len(aBrowse))
	if reclock("SA1",.F.)
		for i:=1 to len(aBrowse)
			incproc("Gravando dados....")
			if aBrowse[i,1] == .T.
				dbselectarea("SA1")
				dbsetorder(1)
				//filial + A1_COD
				if dbseek(xFilial()+aBrowse[i,5])
					if reclock("SA1",.F.)
						SA1->A1_VEND := vend
						msunlock()
					else
						msginfo("Registro esta em uso. Nao sera possivel prosseguir.")
					endif
				endif
			endif
		endfor
	else
		msginfo("Registro em uso. Nao sera possivel prosseguir.")
	endif
	oDlg:END()
	aBrowse :={}
	aBrowse := u_LGCAL10D(aBrowse)
	OLBXA:SETARRAY(aBrowse)
	OLBXA:BLINE := {|| {IF(aBrowse[OLBXA:NAT,1],OOK,ONO),aBrowse[OLBXA:NAT,2],aBrowse[OLBXA:NAT,3],aBrowse[OLBXA:NAT,4],aBrowse[OLBXA:NAT,5],aBrowse[OLBXA:NAT,6],aBrowse[OLBXA:NAT,7],aBrowse[OLBXA:NAT,8],aBrowse[OLBXA:NAT,9],aBrowse[OLBXA:NAT,10],aBrowse[OLBXA:NAT,11]}}
	//	OLBXA:REFRESH()
	ODLGA:REFRESH()

return

STATIC FUNCTION listVend()
	Local aItems:= {}
	DBSELECTAREA("SA3")
	DBSETORDER(1)
	if dbseek(xFilial())
		WHILE !EOF()
			AADD(aItems,SA3->A3_COD +' - '+SA3->A3_NOME)
			dbselectarea("SA3")
			dbskip()
		ENDDO
	endif

	DEFINE DIALOG oDlg TITLE "Vendedor Responsavel" FROM 180,180 TO 230,515 PIXEL
	// Usando New
	vend := SubStr(aItems[1],1,7)
	cCombo1:= aItems[1]
	oCombo1 := TComboBox():New(02,02,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
	aItems,100,20,oDlg,,{|| vend := SubStr(aItems[oCombo1:nAt],1,7)};
	,,,,.T.,,,,,,,,,'cCombo1')

	ACTIVATE DIALOG oDlg CENTERED ON INIT ENCHOICEBAR(oDlg,{|| processa( {|| u_LGCAL10G()  }, "Atualizando", "Processando aguarde...", .f.)},{|| ,oDlg:END()},,)

	//    ACTIVATE MSDIALOG ODLGA CENTER ON INIT ENCHOICEBAR(ODLGA,{|| busVend()},{|| ,ODLGA:END()},,ABUTTONS)
RETURN

user function LGCAL10G()//Função para preencher a lista de contratos proximos do vencimento

	cQuery := " SELECT (SELECT MIN(ADB2.ADB_UDTINI) FROM "+RetSqlName("ADB")+" ADB2 WHERE ADA.ADA_NUMCTR = ADB2.ADB_NUMCTR AND ADB2.ADB_UDTINI <> '' AND ADB2.ADB_UDTFIM = ''),"
	cQuery += " ADB_UDTINI,ADA_NUMCTR,ADA_EMISSA,
	cQuery += " CASE ADA_UTIPO WHEN 'P' THEN 'PLUG' WHEN 'F' THEN 'FTTH' ELSE 'VOIP' END as ADA_UTIPO,"
	cQuery += " ADA_CODCLI,ADA_LOJCLI,ADA_VEND1,ADA_VEND2,ADA_STATUS,ADA_UDTBLQ,ADA_UNFIMP,ADA_UVALI,A1_VEND,"
	cQuery += " DATEDIFF(DAY,GETDATE(),convert(varchar(8),DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),112)) as DIAS"
	cQuery += " FROM "+RetSqlName("ADA")+" ADA"
	cQuery += " INNER JOIN "+RetSqlName("ADB")+" ADB ON ADB.ADB_NUMCTR=ADA.ADA_NUMCTR"
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON ADB.ADB_CODPRO = SB1.B1_COD "
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON ADA.ADA_CODCLI = SA1.A1_COD "
	cQuery += " WHERE ADA_ULIBER = 'S' AND ADA_UCANCE <> 1"
	cQuery += " AND ADB_UDTINI > '19500000'"
	cQuery += " AND (ADA_UFIREP='N' OR ADA_UFIREP='')"
	cQuery += " AND ADA_MSBLQL<>'1' AND B1_UITCONT = 'S' AND ADB_UDTINI <> '' AND ADB_UDTFIM = ''"
	cQuery += " AND ADB_UDTINI = (SELECT MIN(ADB2.ADB_UDTINI) FROM "+RetSqlName("ADB")+" ADB2 WHERE ADA.ADA_NUMCTR = ADB2.ADB_NUMCTR AND ADB2.ADB_UDTINI <> '' AND ADB2.ADB_UDTFIM = '')"
	cQuery += " AND DATEDIFF(DAY,GETDATE(),convert(varchar(8),DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),112)) <= "+STR(getmv("MV_ADAPFV"))
	cQuery += " AND SA1.A1_VEND = "+vend
	cQuery += " group by ADA_NUMCTR,ADA_EMISSA,ADA_UTIPO,ADA_CODCLI,ADA_LOJCLI,ADA_CODCLI,ADA_VEND1,ADA_VEND2,ADA_STATUS,ADA_UDTBLQ,ADA_UNFIMP,ADA_UVALI,A1_VEND,DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),ADB_UDTINI"
	cQuery += " order BY DATEDIFF(DAY,GETDATE(),convert(varchar(8),DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),112)) ASC"
	TCQUERY cQuery NEW ALIAS "TEMP"
	dbselectarea("TEMP")

	aBrowse :={}
	procregua(len(aBrowse))
	while !eof()
		aAdd(aBrowse,{.F.,TEMP->ADA_NUMCTR,TEMP->ADA_EMISSA,TEMP->ADA_UTIPO,TEMP->ADA_CODCLI,alltrim(u_LGNMCLI(xFilial("SA1"),TEMP->ADA_CODCLI,TEMP->ADA_LOJCLI)),TEMP->ADA_VEND1,u_LGNMVND(xFilial("SA3"),TEMP->ADA_VEND1),TEMP->A1_VEND,u_LGNMVND(xFilial("SA3"),TEMP->A1_VEND),TEMP->DIAS})
		incproc("Atualizando dados....")
		dbselectarea("TEMP")
		dbskip()

	enddo

	TEMP->(dbclosearea())

	oDlg:END()

	OLBXA:SETARRAY(aBrowse)
	OLBXA:BLINE := {|| {IF(aBrowse[OLBXA:NAT,1],OOK,ONO),aBrowse[OLBXA:NAT,2],aBrowse[OLBXA:NAT,3],aBrowse[OLBXA:NAT,4],aBrowse[OLBXA:NAT,5],aBrowse[OLBXA:NAT,6],aBrowse[OLBXA:NAT,7],aBrowse[OLBXA:NAT,8],aBrowse[OLBXA:NAT,9],aBrowse[OLBXA:NAT,10],aBrowse[OLBXA:NAT,11]}}
	//	OLBXA:REFRESH()
	ODLGA:REFRESH()

return

user function LGCAL10H()
	procregua(len(aBrowse))
	opc := MessageBox("Deseja Atualizar todos registros ?","Atenção !",4)
	if opc == 6
		incproc("Atualizando dados....")
		aBrowse :={}
		aBrowse := u_LGCAL10D(aBrowse)
		OLBXA:SETARRAY(aBrowse)
		OLBXA:BLINE := {|| {IF(aBrowse[OLBXA:NAT,1],OOK,ONO),aBrowse[OLBXA:NAT,2],aBrowse[OLBXA:NAT,3],aBrowse[OLBXA:NAT,4],aBrowse[OLBXA:NAT,5],aBrowse[OLBXA:NAT,6],aBrowse[OLBXA:NAT,7],aBrowse[OLBXA:NAT,8],aBrowse[OLBXA:NAT,9],aBrowse[OLBXA:NAT,10],aBrowse[OLBXA:NAT,11]}}
		//	OLBXA:REFRESH()
		ODLGA:REFRESH()
	endif

return

user function LGCAL10I()//Função para preencher a lista de contratos proximos do vencimento

	cQuery := " SELECT (SELECT MIN(ADB2.ADB_UDTINI) FROM "+RetSqlName("ADB")+" ADB2 WHERE ADA.ADA_NUMCTR = ADB2.ADB_NUMCTR AND ADB2.ADB_UDTINI <> '' AND ADB2.ADB_UDTFIM = ''),"
	cQuery += " ADB_UDTINI,ADA_NUMCTR,ADA_EMISSA,
	cQuery += " CASE ADA_UTIPO WHEN 'P' THEN 'PLUG' WHEN 'F' THEN 'FTTH' ELSE 'VOIP' END as ADA_UTIPO,"
	cQuery += " ADA_CODCLI,ADA_LOJCLI,ADA_VEND1,ADA_VEND2,ADA_STATUS,ADA_UDTBLQ,ADA_UNFIMP,ADA_UVALI,A1_VEND,"
	cQuery += " DATEDIFF(DAY,GETDATE(),convert(varchar(8),DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),112)) as DIAS"
	cQuery += " FROM "+RetSqlName("ADA")+" ADA"
	cQuery += " INNER JOIN "+RetSqlName("ADB")+" ADB ON ADB.ADB_NUMCTR=ADA.ADA_NUMCTR"
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON ADB.ADB_CODPRO = SB1.B1_COD "
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON ADA.ADA_CODCLI = SA1.A1_COD "
	cQuery += " WHERE ADA_ULIBER = 'S' AND ADA_UCANCE <> 1"
	cQuery += " AND ADB_UDTINI > '19500000'"
	cQuery += " AND (ADA_UFIREP='N' OR ADA_UFIREP='')"
	cQuery += " AND ADA_MSBLQL<>'1' AND B1_UITCONT = 'S' AND ADB_UDTINI <> '' AND ADB_UDTFIM = ''"
	cQuery += " AND ADB_UDTINI = (SELECT MIN(ADB2.ADB_UDTINI) FROM "+RetSqlName("ADB")+" ADB2 WHERE ADA.ADA_NUMCTR = ADB2.ADB_NUMCTR AND ADB2.ADB_UDTINI <> '' AND ADB2.ADB_UDTFIM = '')"
	cQuery += " AND DATEDIFF(DAY,GETDATE(),convert(varchar(8),DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),112)) <= "+STR(getmv("MV_ADAPFV"))
	cQuery += " AND SA1.A1_VEND = "+vend
	cQuery += " group by ADA_NUMCTR,ADA_EMISSA,ADA_UTIPO,ADA_CODCLI,ADA_LOJCLI,ADA_CODCLI,ADA_VEND1,ADA_VEND2,ADA_STATUS,ADA_UDTBLQ,ADA_UNFIMP,ADA_UVALI,A1_VEND,DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),ADB_UDTINI"
	cQuery += " order BY DATEDIFF(DAY,GETDATE(),convert(varchar(8),DATEADD(MONTH,ADA_UVALI,convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112)),112)) ASC"
	TCQUERY cQuery NEW ALIAS "TEMP"
	dbselectarea("TEMP")

	aBrowse :={}
	procregua(len(aBrowse))
	while !eof()
		aAdd(aBrowse,{.F.,TEMP->ADA_NUMCTR,TEMP->ADA_EMISSA,TEMP->ADA_UTIPO,TEMP->ADA_CODCLI,alltrim(u_LGNMCLI(xFilial("SA1"),TEMP->ADA_CODCLI,TEMP->ADA_LOJCLI)),TEMP->ADA_VEND1,u_LGNMVND(xFilial("SA3"),TEMP->ADA_VEND1),TEMP->A1_VEND,u_LGNMVND(xFilial("SA3"),TEMP->A1_VEND),TEMP->DIAS})
		incproc("Atualizando dados....")
		dbselectarea("TEMP")
		dbskip()

	enddo

	TEMP->(dbclosearea())

	//	oDlg:END()

//	OLBXA:SETARRAY(aBrowse)
//	OLBXA:BLINE := {|| {IF(aBrowse[OLBXA:NAT,1],OOK,ONO),aBrowse[OLBXA:NAT,2],aBrowse[OLBXA:NAT,3],aBrowse[OLBXA:NAT,4],aBrowse[OLBXA:NAT,5],aBrowse[OLBXA:NAT,6],aBrowse[OLBXA:NAT,7],aBrowse[OLBXA:NAT,8],aBrowse[OLBXA:NAT,9],aBrowse[OLBXA:NAT,10],aBrowse[OLBXA:NAT,11]}}
//	//	OLBXA:REFRESH()
//	ODLGA:REFRESH()

return aBrowse

