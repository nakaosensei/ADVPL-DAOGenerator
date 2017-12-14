#Include 'Protheus.ch'
#include 'parmtype.ch'
#include "TOTVS.CH" 
#include "rwmake.ch"
#INCLUDE "FWMVCDEF.CH"

/*
mBrwADA2  - Programa para monstrar contratos que forma enviados para negociação pelo setor de Agendamento
Autor      - Robson Adriano
Data       - 14/04/15
*/

User Function mBrwADA3()
	Local cFiltra := "ADA_FILIAL == '"+xFilial('ADA')+"' .And. ADA_ULIBER == 'S' .And. ADA_UCANCE == '1' .AND. ADA_MSBLQL <> '1'" 
	Local _areaS := getarea()
	//SA3 -> OLHAR AMANHA RetCodUsr()
	Private cAlias := "ADA"
	PRIVATE cCadastro := "Cadastro de Parceria"	
	PRIVATE aRotina     := {}
	Private aCORES := {}
	Private aIndexSA1 := {}
	/*
	As linhas abaixo, até o restarea(_areaS), são para:
	1)Garantir que somente um vendedor ou supervisor de SU7 terá acesso a tela
	2)Caso seja um vendedor, mostrar somente os contratos onde ele participou como vendedor 1 ou 2
	*/
	enableW := .F.
	codUsr := RetCodUsr()
	
	tpUsr := POSICIONE("SU7",4,xFilial("SU7")+codUsr,"U7_TIPO")
	if(AllTRIM(tpUsr)=="1")//Se for vendedor
		enableW := .T.
		dbSelectArea("SA3")
		dbSetOrder(7)//filial+codUsr
		if(dbSeek(xFilial("SA3")+codUsr)) //Achou o vendedor?		
			cFiltra+=" .AND. ADA_VEND1 == '"+SA3->A3_COD+"' .OR. ADA_VEND2 == '"+SA3->A3_COD+"'"	
		endif
	elseif(AllTRIM(tpUsr)=="2")//Se for supervisor
		enableW := .T.
	endif
	restarea(_areaS)
	if(enableW = .F.)
		MsgAlert("Você não tem acesso a essa tela, ela só é visivel para vendedores e supervisores. Cadastro de Operador(SU7)")
		return
	endif
	AADD(aRotina, { "Solic. Cancelamento",    "U_MBADA3E"   , 0, 3 })
	AADD(aRotina, { "Visualizar O.S",    "U_MBADA3C"   , 0, 2 })	
	Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSA1,@cFiltra) } 
	 
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	Eval(bFiltraBrw)
	
	mBrowse(6, 1, 22, 75, cAlias,,,,,,)
Return

//Enviar p financeiro solicitação de cancelamento
User function MBADA3A()
	Local _area := getarea()
	Local _aADA := ADA->(getarea())
	Local _emails := getmv("MV_UEMLCAN") //Situacao do boas vindas
	
	Local _emailGeoGrid := getmv("MV_UEMLGEO")
	Local _ocorrenciaGeoGrids := getmv("MV_UOCOGEO")
	Local _atendenteGeoGrids := getmv("MV_UATGEO")
	Local _msgLIGTEC07:= "REMOÇÃO DE CLIENTES DO GEOGRIDS"
	Local _msgEmptyOS := "NÃO FOI POSSIVEL CRIAR A ORDEM DE CADASTRO DE CLIENTES NO GEOGRIDS"
	Local _msgERRO := "ERRO AO TENTAR INCLUIR UMA OS DE CADASTRO DE CLIENTES NO GEOGRIDS "
	
	
	Local _nCtr := ADA->ADA_NUMCTR //número do contrato
	
	
	IF valTexto()
		RECLOCK("ADA",.F.)
			IF EMPTY(ADA->ADA_UDTFEC)
				ADA->ADA_UCANCE := '2'
			ELSE
				ADA->ADA_UCANCE := '3'		
			ENDIF
			ADA->ADA_UDSCAN := cTexto
			ADA->ADA_UMOTIV := ALLTRIM(SubStr(cItems,1,2))	
			
		MSUNLOCK()
		
		//função responsável por enviar e-mails
			//maicon@liguetelecom.com.br,elisangela@liguetelecom.com.br,michael@liguetelecom.com.br,luiz.fernando@liguetelecom.com.br,marcus@liguetelecom.com.br,sara@liguetelecom.com.br;jair.ramos@ligue.net;anaclaudia@plug.tv.br
		//U_LIGGEN03(_emails,"","","Solicitação de cancelamento",cTexto,.T.,"")
			
		u_TMKVPED_A()
			
		aItens := U_LIGTEC08(ADA->ADA_CODCLI, ADA->ADA_LOJCLI, _ocorrenciaGeoGrids,_nCtr)
				                              				
		//Funcao que monta o cabecalho(AB6) da O.S e usa TECA450 para gerar chamados
							//1	Cliente		2 Loja 		  3	Cond Pgto		4 msg	5 itens, 6 ATENDE, 7 ASSUNTO, 8 CTR
		_os := U_LIGTEC07(ADA->ADA_CODCLI, ADA->ADA_LOJCLI, ADA->ADA_CONDPG,_msgLIGTEC07,aItens,_atendenteGeoGrids,"2",_nCtr)
		
		if empty(_os) //GERAR SZ2 PARA FIM DE VINGENCIA NOS ITENS DO CONTRATO ANTIGO QUANDO FOR RETIRADO O EQUIPAMENTO
			MsgInfo(_msgEmptyOS  + AB6->AB6_CODCLI," Msg Info ")
			memowrite("\logerro\ERRO_"+strtran(time(),":","")+".log",_msgERRO+ADB->ADB_NUMCTR+" NA ROTINA AT450GRV")	
		endif
		
		Close(OdlgCanc)
		
		MSGINFO('Contrato: ' + ADA->ADA_NUMCTR + " foi enviado para Cancelamento !")
	ENDIF
	
	restarea(_aADA)
	restarea(_area)
return



user function preencheCombo()
	Local motivos := {}	
	dbselectarea("SX5")
	SX5->(dbsetorder(1))
	IF SX5->(dbseek(xFilial()+"Z2"))
		//Preenche o combo box com todos os motivos de cancelamento cadastrados no banco de dados
		while !eof() .and. xFilial() + "Z2" == SX5->X5_FILIAL + SX5->X5_TABELA
			AADD(motivos, ALLTRIM(X5_CHAVE)+ " - " + ALLTRIM(X5_DESCRI))		 	
			dbselectarea("SX5")
			dbskip()
		enddo
	ENDIF	 
return motivos

//Enviar para Financeiro Bloquear
User function MBADA3B()
	Local lOk := .f.
	Local nPend 	:= U_LIGFIN05(ADA->ADA_CODCLI,ADA->ADA_LOJCLI,ADA->ADA_NUMCTR) // Verificar pendencias anteriores
	Local nMulta 	:= U_LIGFIN09(ADA->ADA_NUMCTR,ADA->ADA_UVALI) // Calcular valor de multa
	Local nRessar := getmv("MV_UVLRESR") // Valor da multa em ressarcimento do serviço contrato
	Local oDlg

 	motivos := {}
	cItems := SPACE(15)
	motivos := u_preencheCombo()

	IF EMPTY (ADA->ADA_UDTFEC)
		nRessar := 0
	ENDIF
	
	Private oCombo
	Private oGet1
	Private cGet1 := nMulta //SERIAL, VAI GRAVAR NO AA3_NUMSER
	Private oGet2
	Private cGet2 := nRessar //MAC, VAI GRAVAR NO AA3_CHAPA
	Private oGet3
	Private cGet3 := nPend //MAC, VAI GRAVAR NO AA3_CHAPA
	Private oGet4
	Private cGet4 := ROUND(nMulta + nRessar + nPend,2) //MAC, VAI GRAVAR NO AA3_CHAPA
	
	cTexto := ADA->ADA_UDSCAN
	
	@ 116,001 To 476,1060 Dialog OdlgCanc Title "Preview de cancelamento de Contrato"
		@ 05,10 say "Contrato : " + ADA->ADA_NUMCTR  of OdlgCanc Pixel
		@ 15,10 say "Valores"of OdlgCanc Pixel
		
		@ 25,10 say "Multa : " of OdlgCanc Pixel
		@ 35, 010 MSGET oGet1 VAR cGet1 SIZE 80, 010 OF OdlgCanc COLORS 0, 16777215 PIXEL
		
		@ 25,090 say "Ressarcimento : " of OdlgCanc Pixel
		@ 35, 090 MSGET oGet2 VAR cGet2 SIZE 80, 010 OF OdlgCanc COLORS 0, 16777215 PIXEL
		
		@ 25, 180 say "Pendencias : "   of OdlgCanc Pixel
		@ 35, 180 MSGET oGet3 VAR cGet3 SIZE 80, 010 OF OdlgCanc COLORS 0, 16777215 PIXEL
		
		@ 25, 270 say "Total : "   of OdlgCanc Pixel
		@ 35, 270 MSGET oGet4 VAR cGet4 SIZE 80, 010 OF OdlgCanc COLORS 0, 16777215 PIXEL	
		
		@ 25, 360 say "Motivo Cancelamento : "   of OdlgCanc Pixel
		@ 35, 360 MSCOMBOBOX oCombo VAR cItems ITEMS motivos SIZE 100, 010 OF OdlgCanc COLORS 0, 16777215 PIXEL
		
		@ 25, 470 say "Novos motivos : "   of OdlgCanc Pixel
		@ 32, 470 Button "Cadastrar" SIZE 30, 14 Action  u_ver_supervisor() of OdlgCanc Pixel
		
		@ 50,20 Get cTexto Size 490,100 MEMO of OdlgCanc Pixel
		
		@ 155,200 Button "Salvar"         Size 35,14 Action U_MBADA3A() of OdlgCanc Pixel
		@ 155,250 Button "Sair"          Size 35,14 Action Close(OdlgCanc) of OdlgCanc Pixel
	
	Activate Dialog OdlgCanc CENTERED

return

/*===========================
Adicionar novos motivos,
verificar se é supervisor,
para cadastro de motivo
Autor: NOEMI SCHERER
DATA: 09/02/17
=============================*/
user function ver_supervisor()
	Local codUsr
	private lEh := .F.
	codUsr := RetCodUsr()
	
	dbSelectArea("SU7")
	dbSetOrder(4) //U7_FILIAL + U7_CODUSU
	dbGoTop()
	
	IF dbSeek(xFilial("SU7") + codUsr)
		IF SU7->U7_TIPO == "2"
			lEh := .T.
		ENDIF
	ENDIF

	IF lEh = .F.
		Alert("Somente supervisores podem criar um novo motivo")
	ELSE
		u_telaMotivos()
	ENDIF
	
return

User Function telaMotivos()
	Private cMot
	
	DEFINE MSDIALOG OdlgMot TITLE "Adicionar novo motivo: " FROM 000, 000  TO 240, 400 COLORS 0, 16777215 PIXEL
		
		@ 015, 015 SAY oSay1 PROMPT "Novo motivo :" SIZE 110, 024 OF OdlgMot PIXEL
		
		@ 030, 015 Get cMot Size 170, 050 MEMO of OdlgMot Pixel
		
		@ 090, 091 Button "Adicionar" 	SIZE 45, 13 Action  u_verf(cMot) of OdlgMot Pixel
			
		@ 090, 150 Button "Cancelar"   	SIZE 45, 13 Action Close(OdlgMot) of OdlgMot Pixel

	ACTIVATE DIALOG OdlgMot CENTERED

return

User Function verf(cMot)
	IF EMPTY(cMot)
		ALERT("Campo do motivo em branco")
	ELSE
		u_addMotivos(cMot)
	ENDIF
return

User Function addMotivos(cMot)
	
	Private uChave
	Private nChave
	Private um := 1
			
	dbSelectArea("SX5")
	dbSetOrder(1)
	dbGoTop()
	
	//Descobrir a ultima chave
	IF dbSeek(xFilial("SX5")+"Z2") 
		WHILE !EOF() .AND. SX5->X5_FILIAL + SX5->X5_TABELA == xFilial("SX5") + "Z2"
			uChave := SX5->X5_CHAVE
			dbSelectArea("SX5")
			dbSkip()
		ENDDO
		nChave := um + VAL(uChave)
	ENDIF
		
	//Adicionar novo motivo no banco
	IF dbSeek(xFilial("SX5")+"Z2")
			
		RECLOCK("SX5", .T.)
			SX5->X5_FILIAL := xFilial("SX5")
			SX5->X5_TABELA := "Z2"
			SX5->X5_CHAVE := cValToChar(nChave)
			SX5->X5_DESCRI := UPPER(cMot)
		MSUNLOCK()
	ENDIF
		
	MsgInfo("Motivo adicionado com sucesso!")
	Close(OdlgMot)
	Close(OdlgCanc)
	U_MBADA3B()

return


/*
=========================================
*/
//Enviar para Suporte realizar Agendamento novamente
User function MBADA3C()
	Local oVerde    := LoadBitmap(GetResources(),'BR_VERDE')    
	Local aList := {} 
	Local aBrowse  := {}
	Local _area := getarea() 
	Local _aAB6 := AB6->(getarea())
	LOCAL _nCtr := ADA->ADA_NUMCTR
	
	DEFINE DIALOG oDlg TITLE "Ordem de Serviço" FROM 180,180 TO 550,700 PIXEL 
	
	// Vetor com elementos do Browse 
	 
	//AADD(aBrowse, {.T.,'CLIENTE 001','RUA CLIENTE 001',111.11})
	//AADD(aBrowse, {.F.,'CLIENTE 002','RUA CLIENTE 002',222.22})
	
	dbselectarea("AB6")
	dbsetorder(7)//Z2_FILIAL+AB6_UNUMCT
	if dbseek(xFilial()+_nCtr) 
	 while !eof() .AND. xFilial()+_nCtr==AB6->AB6_FILIAL+AB6->AB6_UNUMCT
			IF AB6_USITU1	= '1'
				AADD(aBrowse, {oVerde,AB6->AB6_NUMOS,AB6->AB6_EMISSAO})
			ENDIF						
			dbselectarea("AB6")
			dbskip()
		enddo
	ENDIF
	/*
	aBrowse := {{oOK,"Nome","Antônio Gustavo"},;
	            {oNO,"Endereço","Rua A, 123 casa 4"},;
	            {oNO,"Telefone","(21) 99583-1r283"}}*/
	IF !EMPTY(aBrowse)
		// Cria Browse 
		oBrowse := TCBrowse():New( 25 , 5, 255, 135,,;
		                          {'','Ordem de Serviço','Emissão'},{20,120,50},;
		oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		
		// Seta vetor para a browse 
		oBrowse:SetArray(aBrowse) 
		
		// Monta a linha a ser exibina no Browse 
		
		oBrowse:bLine := {||{ aBrowse[oBrowse:nAt,01],;
		                      aBrowse[oBrowse:nAt,02],;
		                      aBrowse[oBrowse:nAt,03] } } 
		
		// Evento de clique no cabeçalho da browse 
		oBrowse:bHeaderClick := {|o, nCol| alert('bHeaderClick') } 
		
		// Evento de duplo click na celula 
		oBrowse:bLDblClick := {|| alert('bLDblClick') } 
		
		// Cria Botoes com metodos básicos 		
		TButton():New( 172, 05,  "Cliente", oDlg,{|| U_MBADA3F(aBrowse[oBrowse:nAt,02]) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
		TButton():New( 172, 50,  "O.S", oDlg,{|| U_MBADA3D(.T.,aBrowse[oBrowse:nAt,02]) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.) 			
		TButton():New( 172, 100, "Atender", oDlg,{|| U_MBADA3G(aBrowse[oBrowse:nAt,02])},40,010,,,.F.,.T.,.F.,,.F.,,,.F.)  
		TButton():New( 172, 145, "Ver Atends", oDlg,{|| U_LIGATOSW(aBrowse[oBrowse:nAt,02])},40,010,,,.F.,.T.,.F.,,.F.,,,.F.)  
		TButton():New( 172, 200, "Enviar Instalação", oDlg,{||  U_MBADA3D(.F.,aBrowse[oBrowse:nAt,02]) },60,010,,,.F.,.T.,.F.,,.F.,,,.F.) 
		
		ACTIVATE DIALOG oDlg CENTERED 
	ELSE
		MSGINFO('Não foi possivel localizar a Ordem de Serviço !')
	ENDIF
	
	restarea(_aAB6)
	restarea(_area)
return

//Enviar O.S novamente para Instalação
User function MBADA3D(_Visu,_numOs)
	Local _aAB6 := AB6->(getarea())
	
	dbselectarea("AB6")
	dbsetorder(1)//Z2_FILIAL+AB6_UNUMCT
	if dbseek(xFilial()+_numOs) 
		IF _Visu
			//AT450Visua("AB6",AB6->(recno()),2)
			FWExecView('Inclusao por FWExecView','AB6AB7_MVC', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
		ELSE
		 RECLOCK("AB6",.F.)
		 	AB6->AB6_STATUS := 'B'	
			AB6->AB6_USITU2 := '8'	
	 	MSUNLOCK()
	 	
	 	dbselectarea("ADA")
	 	RECLOCK("ADA",.F.)
	 		ADA->ADA_UCANCE := ' '
	 	MSUNLOCK()
	 	
	 	/*IF msgyesno("Deseja adicionar novo Item ao Contrato ?") 
	 		 _area := getarea()
			BEGIN TRANSACTION
			mafisini(ADA->ADA_CODCLI,ADA->ADA_LOJCLI,"C","N")
	
			dbselectarea("SUB")
			dbselectarea("SUA")
			TK271CallCenter("SUA",SUA->(RECNO()),3)
			
			restarea(_area)
			END TRANSACTION    
		ENDIF*/
		
	 	MSGINFO('Ordem de Serviço : ' + _numOs + " foi enviada novamente para o Agendamento !")
		ENDIF
	ELSE
		MSGINFO("Não foi possivel localizar a Ordem de Serviço !")	
	ENDIF	
		
	restarea(_aAB6)	
return

User Function MBADA3E()
	IF msgyesno("Tem certeza que deseja Cancelar o Contrato?") 
		u_MBADA3B()
	ENDIF
return

//Atualização de informação de cliente
User function MBADA3F(_numOs)
	Local aArea := GetArea()
	Local _aAB6 := AB6->(getarea())
	Local _aSA1 := SA1->(getarea())	
	dbselectarea("AB6")
	dbsetorder(1)//Z2_FILIAL+AB6_UNUMCT
	if dbseek(xFilial()+_numOs) 
		dbselectarea("SA1")
		dbsetorder(1)
		if dbseek(xFilial()+AB6->AB6_CODCLI+AB6->AB6_LOJA  )
			FWExecView('Inclusao por FWExecView','AGBSA1_MVC', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
		else
			ALERT('Não foi possivel localizar o Cliente do Tele Vendas.')
		endif		
	ENDIF			
	restarea(_aAB6)	
	restarea(_aSA1)
	RestArea( aArea )
return



//Atendimento da Ordem de Serviço
User function MBADA3G(_numOs)
	Local codCli
	Local lojCli
	Local produto
	Local savedOS
	Local codPro
	if(FWExecView('Inclusao por FWExecView','AB9_MVC', MODEL_OPERATION_INSERT, , { || .T.},{ || .T.} , , )=0)
		dbSelectArea("AB9")
		savedOS := AB9->AB9_NUMOS
		dbSelectArea("AB6")
		dbSetOrder(1)
		if(dbSeek(xFilial("AB6")+Substr(savedOS,1,6)))
			codCli := AB6->AB6_CODCLI    
			lojCli := AB6->AB6_LOJA		
		endif 
		dbSelectArea("AB7")
		dbSetOrder(1)
		if(dbSeek(xFilial("AB7")+_numOs))
			codPro := AB7->AB7_CODPRO
		endif		
		dbSelectArea("AB9")
		dbSetOrder(1)	          
		RECLOCK("AB9",.F.)	      
		AB9->AB9_CODCLI := codCli  
		AB9->AB9_LOJA := lojCli	    
		AB9->AB9_CODPRO := codPro	  
		MSUNLOCK()		                            	
	endif		
Return


static function valTexto()
	if len(alltrim(cTexto))>500
		msginfo("Texto muito grande. No maximo 500 caracteres.")
		return .f.
	endif
return .t.
