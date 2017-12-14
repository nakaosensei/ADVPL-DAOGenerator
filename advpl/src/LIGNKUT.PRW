#include 'parmtype.ch'
#Include 'Protheus.ch'
#include "TOTVS.CH" 
#include "rwmake.ch"

// @Author : Thiago Nakao

user function LIGNKUT()	
return

//Retorna o nome de um cliente a partir de sua chave
user function LGNMCLI(filial,codCli,loja)
	Local _area := getarea()
	dbSelectArea("SA1")
	dbSetOrder(1)
	if(dbSeek(filial+codCli+loja))
		return SA1->A1_NOME
	endif
	restarea(_area)
return ""

user function LGDSEND(codAga)
	area := getarea()
	dbSelectArea("AGA")
	dbSetOrder(2)
	if(dbSeek(xFilial("AGA")+codAga) .and. ALLTRIM(codAga)<>"")
		return AGA->AGA_END
	endif
	restarea(area)
return ""

//Retorna o nome de um atendente dado o seu codigo
user function LGNMAT(filial,codTEC)
	Local _area := getarea()
	dbSelectArea("AA1")
	dbSetOrder(1)
	if(dbSeek(filial+codTEC))
		return AA1->AA1_NOMTEC
	endif
	restarea(_area)
return ""

//Retorna o nome de um vendedor dado o seu codigo
user function LGNMVND(filial,codVend)
	Local _area := getarea()
	dbSelectArea("SA3")
	dbSetOrder(1)
	if(dbSeek(filial+codVend))
		return SA3->A3_NOME
	endif
	restarea(_area)
return ""

//LIGUE GET INICIO VIGENCIA: Essa função retorna o inicio da vigencia de um contrato ADA
user function LGIVADA(filial,numCtr)
	Local _area := getarea()
	_DAUXDT := ""
    _CNUMCTR := ""
    //INICIO - PRODUTOS CONTRATO
    DBSELECTAREA("ADB")
    DBSETORDER(1)
    DBGOTOP()
    IF DBSEEK(XFILIAL("ADB")+numCtr)
     WHILE !EOF() .AND. ADB->ADB_FILIAL+ADB->ADB_NUMCTR==filial+numCtr
	      _cItemCtr := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + ADB->ADB_CODPRO, "B1_UITCONT")
	      IF (_cItemCtr = 'S') 
		      IF !EMPTY( ADB->ADB_UDTINI) .AND. EMPTY( ADB->ADB_UDTFIM)  
			      IF EMPTY(_DAUXDT)
			          _DAUXDT := MonthSub(ADB->ADB_UDTINI,ADB->ADB_UMESIN)
			      ENDIF			         
			      IF ADB->ADB_UDTINI < _DAUXDT
			         _DAUXDT := MonthSub(ADB->ADB_UDTINI,ADB->ADB_UMESIN)
			      ENDIF 
		      ENDIF           
	      ENDIF	          
	      DBSELECTAREA("ADB")
	      DBSKIP()
     ENDDO
     //FIM - M 
    ENDIF	
	restarea(_area)	
return _DAUXDT

//LIGUE GET NOME ITENS CONTRATO: Essa função retorna os ids e nomes dos produtos dos itens do contrato
//OUT:{{cod,nome},{cod2,nome2},{cod3,nome3}}
user function LGGNMITC(filial,numCtr)
	Local _area := getarea()
	Public _itensCtr := {}	
    DBSELECTAREA("ADB")
    DBSETORDER(1)
    DBGOTOP()    
    IF DBSEEK(XFILIAL("ADB")+numCtr)
	    WHILE !EOF() .AND. ADB->ADB_FILIAL+ADB->ADB_NUMCTR==filial+numCtr
		     aAdd(_itensCtr,{ALLTRIM(ADB->ADB_CODPRO),ALLTRIM(ADB->ADB_DESPRO)})  
		     DBSELECTAREA("ADB")
		     DBSKIP()
	    ENDDO
    ENDIF	
	restarea(_area)	
return _itensCtr

/*
Remove as strings vazias de um vetor de strings
*/
user function rmBlank(aDados)
	aDados2 := {}
	for i:=1 to len(aDados)
		if ALLTRIM(aDados[i])<>""
			aAdd(aDados2,aDados[i])
		endif
	next	
return aDados2

//A função abaixo exibe uma window com dois botões, um sim e um não
//A variavel retRes retorna a opção selecionada.
//IN: titulo da dialog, texto de exibicao
user function LIGYNW(title,textoExb)
	private retRes := .F.
	DEFINE MSDIALOG oDlg1 TITLE title FROM 000, 000  TO 80, 350 COLORS 0, 16777215 PIXEL
	//@ posY, posX SAY texto SIZE nLargura,nAltura UNIDADE OF oObjetoRef  
    @ 001, 001 SAY textoExb SIZE 030, 010 OF oDlg1
    TButton():New( 25, 10, "Sim", oDlg1,{|| retRes := .T.,Close(oDlg1)},40,010,,,.F.,.T.,.F.,,.F.,,,.F.) 
	TButton():New( 25, 75, "Nao", oDlg1,{|| retRes := .F.,Close(oDlg1)},40,010,,,.F.,.T.,.F.,,.F.,,,.F.) 
    ACTIVATE DIALOG oDlg1 CENTERED
return retRes

//Gerar Tabela(Visual, para interface grafica, com browse e tal) de atendimento de uma OS(AB9)
User Function gTbAtOs(nrOS,oDlg1,posX,posY,altura,comprimento)
	Local _aAB9 := AB9->(getarea())
	Local nX
	Local aHeaderEx := {}
	Local aColsEx := {}
	Local aFieldFill := {}
	Local aFields := {"AB9_NUMOS","AB9_SEQ","AB9_CODCLI","AB9_LOJA","A1_NOME","AB9_CODTEC","AA1_NOMTEC","AB9_DTCHEG","AB9_DTSAID","AB9_CODPRB","AB9_TIPO","AB9_MEMO2","AB9_STATAR","AB9_MPONTO"}
	Local aAlterFields := {"AB9_MEMO2"}
	Static oMSNewGetDados1
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
	   If SX3->(DbSeek(aFields[nX]))
	      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	    Endif
	Next nX	
	dbselectarea("AB9")
	dbsetorder(1)	
	if dbseek(xFilial()+nrOS)
		while !eof() .and. xFilial()+nrOS == AB9->AB9_FILIAL+SubStr(AB9->AB9_NUMOS,1,len(AB9->AB9_NUMOS)-2)
			aAdd(aColsEx,{AB9->AB9_NUMOS,AB9->AB9_SEQ,AB9->AB9_CODCLI,AB9->AB9_LOJA,u_LGNMCLI(xFilial("SA1"),AB9->AB9_CODCLI,AB9->AB9_LOJA),AB9->AB9_CODTEC,u_LGNMAT(AB9->AB9_FILIAL,AB9->AB9_CODTEC),AB9->AB9_DTCHEG,AB9->AB9_DTSAID,AB9->AB9_CODPRB,AB9->AB9_TIPO,MSMM(AB9->AB9_MEMO1),AB9->AB9_STATAR,AB9->AB9_MPONTO})
			dbselectarea("AB9")
			dbskip()
		enddo
	endif	
	oMSNewGetDados1 := MsNewGetDados():New( posY, posX, altura, comprimento, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg1, aHeaderEx, aColsEx)
	restarea(_aAB9)
Return

user function cDateToD(d,m,y)//Converte uma data em dia/mes/ano para uma quantidade de dias
	m := INT((m + 9) % 12)
	y := y - INT(m/10)
return 365*y + INT(y/4) - INT(y/100) + INT(y/400) + INT((m*306 + 5)/10) + ( d - 1 )

//Retorna a diferença entre duas datas em dias, sDt2 deve ser a data maior
//formato dia/mes/ano
user function gDateDif(sDt1,sDt2)
	dt1 := StrTokArr(ALLTRIM(sDt1), "/")
	dt2 := StrTokArr(ALLTRIM(sDt2), "/")
	fDt1 := {}
	fDt2 := {}
	for i:=1 to len(dt1)
		aAdd(fDt1,VAL(dt1[i]))
		aAdd(fDt2,VAL(dt2[i]))
	next	
return u_cDateToD(fDt2[1],fDt2[2],fDt2[3])-u_cDateToD(fDt1[1],fDt1[2],fDt1[3]) 

//Adiciona x meses a data sDt, sendo x a variavel months, "05/12/1994 e o numerico 14 por exemplo"
user function addMonths(sDt,months)
	dt := StrTokArr(ALLTRIM(sDt), "/")
	ftDt := {}
	for i:=1 to len(dt)
		aAdd(ftDt,VAL(dt[i]))		
	next
	ftDt[2]+=months
	while(ftDt[2]>12)
		ftDt[2]-=12
		ftDt[3]+=1
	enddo
return CVALTOCHAR(ftDt[1])+"/"+CVALTOCHAR(ftDt[2])+"/"+CVALTOCHAR(ftDt[3])


//Gerar Tabela generica
//In: oDlg1,posX,posY,altura,comprimento
//aFields: Campos das colunas da tabela, ex:
//exemplo: Local aFields := {"ADA_NUMCTR","ADA_EMISSA","ADA_UTIPO","ADA_CODCLI","A1_NOME","ADA_VEND1","A3_NOME","ADA_STATUS","ADA_UVALI"}
//aBrowse: Registros da  tabela, devem seguir a mesma ordem de aFields, posição de aBrowse deve conter um registro. { {"01","Thiago Nakao","Programador"},{"02","Robson Stirle","Programador"} }
User Function gTbGen(oDlg1,posX,posY,altura,comprimento,aFields,aBrowse)
	Local oBrowse := {}
	Local aHeader := {}
	Local sizeCols := {}	
	//Preenchimento dos dados do cabeçalho
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
	   If SX3->(DbSeek(aFields[nX]))
	      aAdd(aHeader, AllTrim(X3Titulo()))
	      aAdd(sizeCols,SX3->X3_TAMANHO)
	    Endif
	Next nX	
	
	// Cria Browse
    oBrowse := TCBrowse():New( posX , posY, comprimento, altura,, aHeader,sizeCols, oDlg1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.T. )
    oBrowse:SetArray(aBrowse)      
    oBrowse:bLine := {||u_gInListB(aFields,aBrowse,oBrowse)}   
Return

user function gInListB(aFields,aBrowse,oBrowse)
	innerList := {}
	if(len(aBrowse)=0)
		tmp:={}
		for i:=1 to len(aFields)
			aAdd(tmp,"")
		next
		aBrowse := {tmp}
	endif
	for i:=1 to len(aFields)
    	aAdd(innerList,aBrowse[oBrowse:nAt,i])
    next
return innerList

//ligcsa1 -> GRAGA E GRAGB

//A função abaixo valida se um email é valido, ela apenas verifica a presença do arroba no email e se é somente um
user function LGVEML(email)
	Local split := {}
	if(email = nil .OR. ALLTRIM(email)=="")
		return ""
	endif
		
	split := StrTokArr(ALLTRIM(email), "@")	
	if len(split) = 2 .AND. RAT("@", ALLTRIM(email)) <> len(ALLTRIM(email))
		return email
	else
		return ""
	endif
return

user function sSmpMail(destinatario,titulo,mensagem)//Send Simple Mail
	u_LIGGEN03(destinatario,"","",titulo,mensagem,.F.,nil)
return

user function sendMails(emailsList,titulo,mensagem)
	for i:=1 to len(emailsList)
		u_sSmpMail(emailsList[i],titulo,mensagem)
	next
return

user function nkMailCli(mensagem,nomeCli,nkdestinatario,titulo)
	msg := "<br><div style='height:82px; width:100%;background-color:#16348b;position:relative;'><div style='position:absolute;left:25px;'><img src='http://liguetelecom.com.br/images/site/logo.png' alt='' height='80px' width='160px' hspace='20'></div></div>"
	msg := msg + "<br> <b style='color:blue;padding-left: 1cm;'>"+DTOC(Date())+"</b>"
	msg := msg + "<br><br><div style='padding-left: 1cm;font-size: 130%;color:black'>Olá, <b>"+nomeCli+"</b></div>"
	//msg := msg + "<br><p style='padding-left: 1cm;color:black'>Obrigado por confiar em nosso trabalho e contratar os nossos serviços. Para nós é uma honra tê-lo como nosso cliente, esperamos que a nossa parceria seja duradoura e proveitosa.</p>"
	msg := msg + "<br><div style='padding-left:1cm;color:black'>"+mensagem+"</div>"
	msg := msg + "<br><br><b style='padding-left: 1cm;color:gray;font-size:110%'>Em caso de Dúvidas, ligue para o fone: (44)3810-0000</b>"
	msg := msg + "<br><br><a style='padding-left: 1cm;' href='http://www.ligue.net'>www.ligue.net</a>"
	msg := msg + "<br><br><b style='padding-left: 1cm;color:black;'>Este e-mail foi enviado automáticamente pelo sistema, não responder para este e-mail.</b>"
	u_sSmpMail(nkdestinatario,titulo,msg)
return

//Create FullScreen Dialog
//OUT: 
//POS 1 = Dialog, POS2 = Posição final da dialog em Y, POS3 = Posição final da dialog em X
//POS 4 = Posicao inicial dialog em Y, POS5 = Posicao inicial dialog em X
//Os componentes devem ficar nas pos final em x e y dividido por 2 para que esteja correto, 
//existe um exemplo na LIGCAL10
user function cFCDlg(titulo)
	 Local _area := getarea()
	 Local aSize:= {}
	 Local aObjects:= {} 
	 Local aInfo:= {} 
	 // Obtém a a área de trabalho e tamanho da dialog
	 aSize := MsAdvSize()
	 AAdd( aObjects, { 100, 100, .T., .T. } ) 
	 // Dados da Enchoice 
	 AAdd( aObjects, { 200, 200, .T., .T. } ) 
	 // Dados da getdados 
	 // Dados da área de trabalho e separação
	 aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
	 // Chama MsObjSize e recebe array e tamanhos
	 aPosObj := MsObjSize( aInfo, aObjects,.T.) 
	 DEFINE MSDIALOG oDlg1 TITLE titulo FROM aSize[7],0 To aSize[6],aSize[5] COLORS 0, 16777215 PIXEL
return {oDlg1,aSize[6],aSize[5],aSize[7],0}

//Essa funcao quebra a linha de uma string, mesma coisa que o \n do java ou c
user function barraN(string)
return string + Chr(13) + Chr(10)

user function helloWorld()
	MsgAlert("Hello world!")
	//strMensg := "<br><div style='height:82px; width:100%;background-color:#16348b;position:relative;'><div style='position:absolute;left:25px;'><img src='http://liguetelecom.com.br/images/site/logo.png' alt='Smiley face' height='82px' width='122px' hspace='20'></div></div><br><h1>Titulo</h1><p>Body</p>"
    //msg := "Olá Nakao, esse é um teste"
   	//u_sMailCli(msg,"05/10/2017", "Thiago Nakao","nakaosensei@gmail.com","Ordem de Serviço atendida - Ligue Telecomunicações")
   	//u_nkMailCli(msg,"05/10/2017", "Thiago Nakao","nakaosensei@gmail.com","Ordem de Serviço atendida - Ligue Telecomunicações")
   	//u_nkMailCli(msg,"05/10/2017", "Thiago Nakao","danilo@liguetelecom.com.br","Ordem de Serviço atendida - Ligue Telecomunicações")
   	//u_nkMailCli(msg,"05/10/2017", "Thiago Nakao","thiago.nakao@ligue.net","Ordem de Serviço atendida - Ligue Telecomunicações")
	//u_DSB1Cad(xFilial("SB1"),"777778","PRODUTO TESTE 2","SE","UN","01","0199","29","M","D","N","N","S","N","N","N","2","M","N","2","N","N","1","1","2",1,"S","2","1","2")
	CONOUT("SUA")
	CONOUT(u_LGGTFIELDS("SUA"))
	CONOUT("SUB")
	CONOUT(u_LGGTFIELDS("SUB"))
	//MsgAlert("Enviou")
	//MsgAlert(u_LIGVAL("06   "))
	//u_testaEscopo1()
return .T.

user function testaEscopo1()
	privada1 := ""
	u_escopo2()
	MsgAlert("Chamada escopo1: "+privada1)
	
return

user function escopo2()
	privada1 := "def"
	MsgAlert("Chamada 1 escopo 2: "+privada1)
	privada1 := "teste 2"
	MsgAlert("Chamada 2 escopo 2: "+privada1)
return

//In: Uma string contendo S ou N ; Out: Sim ou Não
user function csntf(sIn)
	if ALLTRIM(sIn)=="S" .or. ALLTRIM(sIn)=="Y"
		return "Sim"
	elseif ALLTRIM(sIn)=="N"
		return "Não"
	endif
return ""

user function teste()
return .T.

/* 
	mbrowse exemplo
	LOCAL aCores := {}
	PRIVATE cAlias := 'ADA'
	PRIVATE cCadastro := "Contratos proximos de serem finalizados"
	PRIVATE aRotina := {{"Env.Emails","U_helloWorld()",0,1}}   
	_diasCPV := getmv("MV_ADAPFV")
	cFiltro  := "ADA_FILIAL == '"+xFilial('ADA')+"' .And. ADA_UCANCE <> '1' .AND. ADA_MSBLQL <> '1' .AND. "+CVALTOCHAR(u_gDateDif(DTOC(Date()),u_addMonths(DTOC(u_LGIVADA(ADA->ADA_FILIAL,ADA->ADA_NUMCTR)),ADA->ADA_UVALI)))+"<="+ CVALTOCHAR(_diasCPV) 
	dbSelectArea("ADA")
	dbSetOrder(1)	 
	mBrowse( ,,,,"ADA",,,,,,aCores,,,,,,,,cFiltro)
*/