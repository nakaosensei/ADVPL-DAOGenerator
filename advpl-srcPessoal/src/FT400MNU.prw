#include "protheus.ch"
#include "TOTVS.CH" 
#include "rwmake.ch"

User Function FT400MNU()

IF __CUSERID$GETMV("MV_UADMCTR")
	aadd(aRotina,{'Libera Financeiro','U_LIGTEC02' , 0 , 3,0,NIL})
	aadd(aRotina,{'Cancelar Contrato','U_FT400MA' , 0 , 3,0,NIL})
ENDIF

return


User Function FT400MA()
nMulta := 0
	IF msgyesno("Deseja cancelar o Contrato ?") 			
		IF !EMPTY (ADA->ADA_UDTFEC)
//			U_FT400MB()
//		ELSE
			nMulta 	:= U_LIGFIN09(ADA->ADA_NUMCTR,ADA->ADA_UVALI) // Calcular valor de multa
		ENDIF	
		U_FT400MC()	
	endif
return 

//Dialog para contratos que não entraram em vigencia.
User Function FT400MB()
Local oButton1
Local oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
Local oSay1

Private oDlgMB
private oGet1Mb
private cGet1Mb := SPACE(20)

cTexto := ADA->ADA_UDSCAN

	DEFINE MSDIALOG oDlgMB TITLE "Cancelamento" FROM 000, 000  TO 190, 400 COLORS 0, 16777215 PIXEL
		@ 008, 004 SAY oSay1 PROMPT "Favor informar a Data de Cancelamento:" SIZE 185, 014 OF oDlgMB FONT oFont1 COLORS 0, 16777215 PIXEL
		@ 024, 005 MSGET oGet1Mb VAR cGet1Mb SIZE 075, 010 OF oDlgMB COLORS 0, 16777215 PIXEL PICTURE "@D 99/99/9999"
		
		@ 062,101 Button "Salvar"         Size 35,14 Action U_FT400MB1() of oDlgMB Pixel
		@ 062,151 Button "Sair"          Size 35,14 Action oDlgMB:End() of oDlgMB Pixel
	ACTIVATE MSDIALOG oDlgMb		

Return

User Function FT400MB1()
	U_FT400MF(cGet1Mb)
	U_FT400MG()
	oDlgMB:End()
Return


User Function FT400MC()
Local oButton1
Local oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
Local oGet1
Local cGet1 := SPACE(20)
Local oSay1
Private oDlgMC

aItems1 := {"NÃO", "SIM"}
cTexto := ADA->ADA_UDSCAN

motivos := {}
cItems := SPACE(15)
motivos := u_preencheCombo()

	DEFINE MSDIALOG oDlgMC TITLE "Cancelamento do contrato : " + ADA->ADA_NUMCTR  FROM 000, 000  TO 390, 600 COLORS 0, 16777215 PIXEL
		@ 008, 010 SAY oSay1 PROMPT "Favor informar a Data de Cancelamento:" SIZE 185, 014 OF oDlgMC FONT oFont1 COLORS 0, 16777215 PIXEL
		@ 020, 010 MSGET oGet1 VAR cGet1 SIZE 075, 010 OF oDlgMC COLORS 0, 16777215 PIXEL PICTURE "@D 99/99/9999"
		
		@ 040, 010 say "Motivo Cancelamento : "   of oDlgMC Pixel
		@ 052, 010 MSCOMBOBOX oCombo VAR cItems ITEMS motivos SIZE 100, 010 OF oDlgMC COLORS 0, 16777215 PIXEL
		
//		@ 040, 270 say "Novos motivos : "   of oDlgMC Pixel
//		@ 052, 270 Button "Cadastrar" SIZE 30, 14 Action  u_ver_supervisor() of oDlgMC Pixel
		
		@ 070, 010 SAY oSay1 PROMPT "Isento?" SIZE 185, 014 OF oDlgMC FONT oFont1 COLORS 0, 16777215 PIXEL
		 cCombo1:=  aItems1[1]      
		 oCombo1 := TComboBox():New(082,010,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},; 
	     aItems1,100,20,oDlgMC,,; 
	     ,,,,.T.,,,,,,,,,'cCombo1')   
		 
		@ 100,10 Get cTexto Size 280,70 MEMO of oDlgMC Pixel
		@ 172,171 Button "Salvar"         	Size 50,14 Action U_FT400MH(cGet1,cCombo1) of oDlgMC Pixel
		@ 172,241 Button "Sair"          	Size 50,14 Action Close(oDlgMC) of oDlgMC Pixel
	ACTIVATE MSDIALOG oDlgMC	
Return


User Function FT400MD()
Local oButton1
Local oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
Local oSay1
Local oSay2
Private oDlgMD
//nRessar := getmv("MV_UVLRESR") // Valor da multa em ressarcimento do serviço contrato
		
		private oGet1Md 
		private cGet1Md := getmv("MV_UVLRESR") 	
		cTexto := ADA->ADA_UDSCAN

	DEFINE MSDIALOG oDlgMD TITLE "Faturamento" FROM 000, 000  TO 390, 600 COLORS 0, 16777215 PIXEL
		@ 008, 010 SAY oSay1 PROMPT "Deseja faturar o contrato : " + ADA->ADA_NUMCTR+ " ?" SIZE 185, 014 OF oDlgMD FONT oFont1 COLORS 0, 16777215 PIXEL

		@ 040, 010 SAY oSay2 PROMPT "Ressarcimento:" SIZE 185, 014 OF oDlgMD FONT oFont1 COLORS 0, 16777215 PIXEL 
		lCheck1 := .T.
		oCheck1Md := TCheckBox():Create( oDlgMD,,54,10,'',100,210,,,,,,,,.T.,,,)
		oCheck1Md:bSetGet := {|| lCheck1 } 
		oCheck1Md:bLClicked := {|| lCheck1:=!lCheck1 } 
		oCheck1Md:bWhen := {|| .T.  }
		
		@ 052, 023 MSGET oGet1Md VAR cGet1Md SIZE 075, 010 OF oDlgMD COLORS 0, 16777215 PIXEL PICTURE "@E 999.99" VALID !Vazio()
		
		@ 80,10 Get cTexto Size 280,70 MEMO of oDlgMD Pixel
		@ 172,171 Button "Sim"         Size 50,14 Action   U_FT400MI(cGet1Md) 	of oDlgMD Pixel
		@ 172,241 Button "Não"           Size 50,14 Action U_FT400MM() 		of oDlgMD Pixel
	ACTIVATE MSDIALOG oDlgMD	
Return

//Tela de multa mais pendencias anteriores.
User Function FT400ME()
Local nPend 	:= U_LIGFIN05(ADA->ADA_CODCLI,ADA->ADA_LOJCLI,ADA->ADA_NUMCTR) // Verificar pendencias anteriores
Local oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)


	lCheck1 := .T.
	lCheck2 := .T.
	Private oDlgME
	Private oGet1Me
	Private cGet1Me := nMulta 	
	Private oGet2Me
	Private cGet2Me := ROUND(nMulta +  nPend,2)
	Private oGet3Me
	Private cGet3Me := nPend 
	
	cTexto := ADA->ADA_UDSCAN
	
	DEFINE MSDIALOG oDlgME TITLE "Multa + pendencias " FROM 000, 000  TO 390, 600 COLORS 0, 16777215 PIXEL
		@ 05,10 say "Multa + pendencias " OF oDlgME FONT oFont1 COLORS 0, 16777215 PIXEL
		
		@ 020, 010 SAY oSay2 PROMPT "Multa:" SIZE 185, 014 OF oDlgME FONT oFont1 COLORS 0, 16777215 PIXEL 
		oCheck1Me := TCheckBox():Create( oDlgME,,34,10,'',100,210,,,,,,,,.T.,,,)
		oCheck1Me:bSetGet := {|| lCheck1 } 
		oCheck1Me:bLClicked := {|| lCheck1:=!lCheck1 } 
		oCheck1Me:bWhen := {|| .T.  }
		@ 032, 023 MSGET oGet1Me VAR cGet1Me SIZE 075, 010 OF oDlgME COLORS 0, 16777215 PIXEL PICTURE "@E 999,999,999.99"
		
		@ 020, 221 say "Total" OF oDlgME FONT oFont1 COLORS 0, 16777215 PIXEL
		@ 032, 221 MSGET oGet2Me VAR cGet2Me SIZE 075, 010 OF oDlgME COLORS 0, 16777215 PIXEL PICTURE "@E 999,999,999.99"
		
		@ 045, 010 SAY oSay2 PROMPT "Pendencias:" SIZE 185, 014 OF oDlgME FONT oFont1 COLORS 0, 16777215 PIXEL
		oCheck2Me := TCheckBox():Create( oDlgME,,59,10,'',100,210,,,,,,,,.T.,,,)
		oCheck2Me:bSetGet := {|| lCheck2 } 
		oCheck2Me:bLClicked := {|| lCheck2:=!lCheck2 } 
		oCheck2Me:bWhen := {|| .T.  }
		@ 057, 023 MSGET oGet3Me VAR cGet3Me SIZE 075, 010 OF oDlgME COLORS 0, 16777215 PIXEL PICTURE "@E 999,999,999.99"
	
		@ 80,10 Get cTexto Size 280,70 MEMO of oDlgME Pixel
		//@ 172,171 Button "Sim"         Size 50,14 Action U_FT400MD() of oDlgME Pixel
		@ 172,241 Button "Confirmar"           Size 50,14 Action U_FT400MJ() of oDlgME Pixel
	ACTIVATE MSDIALOG oDlgME	
Return

//Preencher fim de vig
User Function FT400MF(_cData)
Local _area := getarea()
Local _aADB := ADB->(getarea())
		
		//Colocar Fim de Vigencia nos itens do contrato
		dbselectarea("ADB")
		dbsetorder(1)
		if dbseek(xFilial()+ADA->ADA_NUMCTR)
			while !eof() .and. xFilial()+ADA->ADA_NUMCTR==ADB->ADB_FILIAL+ADB->ADB_NUMCTR
				IF !EMPTY(ADB_UDTINI) .AND. EMPTY(ADB_UDTFIM)
					RECLOCK("ADB",.F.)
						IF EMPTY(ADB->ADB_UDTFIM)
							ADB->ADB_UDTFIM := CTOD(_cData)
						ENDIF
					MSUNLOCK()	
				ENDIF
				
				dbselectarea("ADB")
				dbskip()
			enddo
		endif
		
		RECLOCK("ADA",.F.)
			ADA->ADA_MSBLQL := '1'	
			ADA->ADA_UDSCAN := cTexto
			ADA->ADA_UDTBLQ := CTOD(_cData)
			ADA->ADA_UMOTIV := ALLTRIM(SubStr(cItems,1,2))	
		MSUNLOCK()
		
		MSGINFO("Contrato : " + ADA->ADA_NUMCTR + " cancelado !")				
restarea(_aADB)
restarea(_area)		
Return

//Verificar O.S do contrato em aberto e fechar
User Function FT400MG()
Local _area := getarea()
Local _aAB6 := AB6->(getarea())
Local _CosInclu := ""

	//Encerrar O.S
		dbselectarea("AB6")
		dbsetorder(7)//Z2_FILIAL+AB6_UNUMCT
		if dbseek(xFilial()+ADA->ADA_NUMCTR) 
 			while !eof() .AND. xFilial()+ADA->ADA_NUMCTR==AB6->AB6_FILIAL+AB6->AB6_UNUMCT
			
				IF AB6->AB6_STATUS <> 'E'
					//Encerrar Itens da O.S
					dbselectarea("AB7")
					dbsetorder(1)
					IF dbseek(xFilial()+AB6->AB6_NUMOS)
					while !eof() .AND. xFilial()+AB6->AB6_NUMOS==AB7->AB7_FILIAL+AB7->AB7_NUMOS
							dbselectarea("AB7")
							RECLOCK("AB7",.F.)
								AB7->AB7_TIPO := '5'	
							MSUNLOCK()
						
						dbskip()
						enddo
					ENDIF
					
					dbselectarea("AB6")
					RECLOCK("AB6",.F.)
						AB6->AB6_STATUS := 'E'	
						AB6->AB6_MSG := ALLTRIM(AB6->AB6_MSG) + " - CANCELADA VIA CTR"
					MSUNLOCK()
					
					_CosInclu += " OS: " + AB6->AB6_NUMOS+ " ; "
				ENDIF
				dbskip()
			enddo
		ENDIF
		
			
		IF !EMPTY(_CosInclu)
			MsgInfo("Ordem de serviços encerradas do Contrato : " + _CosInclu )
		ENDIF
restarea(_aAB6)	
restarea(_area)	
Return

//Contratos que foram isento de cobranças
User Function FT400MH(_cData,_cCombo)
Local _msgOS := ""

	U_FT400MF(_cData)//Colocar fim de Vigencia
	IF _cCombo == "SIM" //ISENTO
	 	U_FT400MG()//Fechar O.S que estão em aberto no CTR
		
		//REMOVE OS CONTAS A RECEBER QUE ESTIVER EM ABERTO
		_CPREF	:= ALLTRIM(GETMV("MV_UPRFCTR"))
		U_LIGFIN10(ADA->ADA_CODCLI, ADA->ADA_LOJCLI, _CPREF, ADA->ADA_NUMCTR ," ","REF","CANCELAMENTO CTR")
		oDlgMC:End()
	ELSE
		oDlgMC:End()
		//Abrir dialog para Ressarcimento(FaturamentoS)
		U_FT400MD()
	END
Return 


//Lançar cobrança do ressarcimento 
User Function FT400MI(_pValor)
Local _area := getarea()
Local _aADA := ADA->(getarea())

IF lCheck1
	IF VALTYPE(_pValor) == "N"
		_NVALOR := _pValor
	ELSE
		_NVALOR := VAL(_pValor)
	END
	
	IF _NVALOR > 0
		aCampos := {}
		aAdd( aCampos, { 'Z5_NUMCTR'	, 	ADA->ADA_NUMCTR } )
		aAdd( aCampos, { 'Z5_CODCLI' 	, 	ADA->ADA_CODCLI } )
		aAdd( aCampos, { 'Z5_LOJCLI' 	, 	ADA->ADA_LOJCLI } )
		aAdd( aCampos, { 'Z5_TIPO' 		, 	'2' } )	
		aAdd( aCampos, { 'Z5_DATA'		, 	DDATABASE } )	
		aAdd( aCampos, { 'Z5_PRODNF' 	, 	'010034' } )	
		aAdd( aCampos, { 'Z5_QTDCOB' 	, 	1 } )	
		aAdd( aCampos, { 'Z5_QUANT' 	, 	1 } )	
		aAdd( aCampos, { 'Z5_PRCVEN' 	, 	_NVALOR } )	
		aAdd( aCampos, { 'Z5_TOTAL' 	, 	_NVALOR } )	
		
		If !Import( 'SZ5', aCampos )
			lRet := .F.
		EndIf
		
		
	ELSE
		msginfo("Por favor informe um valor válido!")
		return
	ENDIF
ENDIF

_CCTRINI  	:=		ADA->ADA_NUMCTR
_CCTRFIM  	:=		ADA->ADA_NUMCTR 
_CCONDINI  := 	ADA->ADA_CONDPG
_CCONDFIM  := 	ADA->ADA_CONDPG 	

U_LIGFAT01()

restarea(_aADA)	
restarea(_area)

U_FT400ME()
oDlgMD:End()
Return


User Function FT400MJ()
Local  aArray:={}
Local  aTit :={}
Local  _cOcoDet := getmv("MV_UOCODET")
Local  _cAtReti := getmv("MV_UATRETI") // COD ATENDENTE DE RETIRADA DE EQUIPAMENTO	
Private lMsErroAuto := .F.

IF lCheck1 //CRIAR TITULO DE MULTA DE ACORDO COM VALOR INFORMADO
	U_FT400MK()
ENDIF

IF !lCheck2 //Lançar decrescimo em titulo em abertos do cliente do CTR
	//U_FT400ML()
	_CPREF	:= ALLTRIM(GETMV("MV_UPRFCTR"))
	U_LIGFIN10(ADA->ADA_CODCLI, ADA->ADA_LOJCLI, _CPREF, ADA->ADA_NUMCTR ," ","REF","CANCELAMENTO CTR")
ENDIF

oDlgME:End()
FINA280()
//MsExecAuto( { |x,y| FINA280(x,y)},3,,)
/*If lMsErroAuto	
	MostraErro()
Endif*/
IF msgyesno("Deseja gerar Ordem de Serviço para retirada de equipamento ?") 	
	ch := U_FIN06C(ADA->ADA_CODCLI,ADA->ADA_LOJCLI,_cOcoDet,_cAtReti,ADA->ADA_NUMCTR,"RETIRADA DE EQUIPAMENTO POR CANCELAMENTO DE CONTRATO")
	msginfo('O.S de retirada de equipamento criada : ' + ch)
ENDIF
return

//ADICIONAR SE1
User Function FT400MK()
	IF VALTYPE(cGet1Me) == "N"
		_NVALOR := cGet1Me
	ELSE
		_NVALOR := VAL(cGet1Me)
	END

	IF _NVALOR > 0

		_CCLI	:= ADA->ADA_CODCLI
		_CLOJ	:= ADA->ADA_LOJCLI
		_CPREF	:= "MUL" //ALLTRIM(GETMV("MV_UPRFCTR"))
		_CNUM 	:= ADA->ADA_NUMCTR
		_CTIPO	:= "BOL"
		_DEMIS 	:= DDATABASE
		_CCOND	:= "100"
		_NTXJUR := GETMV("MV_UTXJUR")
	
		DBSELECTAREA("SE1")
		DBSETORDER(1)
		DBGOTOP()
		DBSEEK(XFILIAL("SE1")+_CPREF+PADR(_CNUM,9)+"999",.T.)
		DBSKIP(-1)
		IF SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM==XFILIAL("SE1")+_CPREF+PADR(_CNUM,9)
			_CPARC := SOMA1(SE1->E1_PARCELA)
		ELSE
			_CPARC := "001"
		ENDIF
			
		DBSELECTAREA("SA1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SA1")+_CCLI+_CLOJ)
		_CNAT	:= SA1->A1_NATUREZ
						
		DBSELECTAREA("SE1")
		RECLOCK("SE1",.T.)
			SE1->E1_FILIAL  := XFILIAL("SE1")
			SE1->E1_FILORIG := "LG01"
			SE1->E1_PREFIXO := _CPREF
			SE1->E1_NUM     := _CNUM
			SE1->E1_PARCELA := _CPARC
			SE1->E1_TIPO    := "BOL"
			SE1->E1_CLIENTE := _CCLI
			SE1->E1_LOJA    := _CLOJ
			SE1->E1_NOMCLI  := POSICIONE("SA1",1,XFILIAL("SA1")+_CCLI+_CLOJ,"A1_NREDUZ")
			SE1->E1_NATUREZ := _CNAT
			SE1->E1_EMISSAO := _DEMIS
			SE1->E1_EMIS1   := _DEMIS
			SE1->E1_LA      := "S"
			SE1->E1_SITUACA := "0"
			SE1->E1_SALDO   := _NVALOR
			SE1->E1_HIST    := "FATURAMENTO"
			SE1->E1_VENCTO  := _DEMIS
			SE1->E1_VENCREA := _DEMIS
			SE1->E1_VENCORI := _DEMIS
			SE1->E1_MOEDA   := 1
			SE1->E1_VALOR   := _NVALOR
			SE1->E1_PORCJUR := _NTXJUR
			SE1->E1_VLCRUZ  := _NVALOR
			SE1->E1_STATUS  := "A"
			SE1->E1_SERIE	:= " "
			//SE1->E1_ORIGEM	:= "LIGFAT01"
		   	SE1->E1_ORIGEM  := "FINA040"
			SE1->E1_FLUXO   := " "
			SE1->E1_TIPODES := " "
			SE1->E1_FRETISS	:= "1"
			SE1->E1_RELATO	:= "2"
			SE1->E1_TPDESC	:= "C"
			SE1->E1_APLVLMN	:= "1"
		MSUNLOCK()
	ENDIF
Return

//Lançar decrescimo em titulo em abertos do cliente do CTR
User Function FT400ML()
Local _area := getarea()
Local _aSE1 := SE1->(getarea())
Local _CPREF	:= ALLTRIM(GETMV("MV_UPRFCTR"))
//Encerrar O.S
	dbselectarea("SE1")
	dbsetorder(2)//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	if dbseek(xFilial()+ADA->ADA_CODCLI+ADA->ADA_LOJCLI+_CPREF+ADA->ADA_NUMCTR) 
 		while !eof() .AND. xFilial()+ADA->ADA_CODCLI+ADA->ADA_LOJCLI+_CPREF+ADA->ADA_NUMCTR == SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+ALLTRIM(SE1->E1_NUM)
			IF EMPTY(SE1->E1_BAIXA)
				dbselectarea("SE1")
				RECLOCK("SE1",.F.)
					SE1->E1_DECRESC := SE1->E1_SALDO	
				MSUNLOCK()
			ENDIF	
			dbskip()
			enddo
		ENDIF
restarea(_aSE1)	
restarea(_area)	
Return

User Function FT400MM()
	U_FT400ME()
	oDlgMD:End()
Return



Static Function Import( cAlias, aCampos )
Local oModel, oAux, oStruct
Local nI := 0
Local nPos := 0
Local lRet := .T.
Local aAux := {}
dbSelectArea( cAlias )
dbSetOrder( 1 )

// Aqui ocorre o instânciamento do modelo de dados (Model)
// Neste exemplo instanciamos o modelo de dados do fontrre COMP011_MVC
// que é a rotina de manutenção de compositores/interpretes
oModel := FWLoadModel( 'LIGFAT07' )
// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão
oModel:SetOperation( 3 )
// Antes de atribuirmos os valores dos campos temos que ativar o modelo
oModel:Activate()
// Instanciamos apenas referentes às dados
oAux := oModel:GetModel('FIELD' +cAlias )
// Obtemos a estrutura de dados
oStruct := oAux:GetStruct()
aAux := oStruct:GetFields()

For nI := 1 To Len( aCampos )
	// Verifica se os campos passados existem na estrutura do modelo
	If ( nPos := aScan(aAux,{|x| AllTrim( x[3] )== AllTrim(aCampos[nI][1]) } ) ) > 0
	// È feita a atribuição do dado ao campo do Model
		If !( lAux := oModel:SetValue( 'FIELD' +cAlias, aCampos[nI][1], aCampos[nI][2] ) )
			// Caso a atribuição não possa ser feita, por algum motivo (validação, por
			// o método SetValue retorna .F.
			lRet := .F.
			Exit
		EndIf
	EndIf
Next nI

If lRet
	// Faz-se a validação dos dados, note que diferentemente das tradicionais
	// "rotinas automáticas"
	// neste momento os dados não são gravados, são somente validados.
	If ( lRet := oModel:VldData() )
		oModel:CommitData()
	EndIf
EndIf

If !lRet
// Se os dados não foram validados obtemos a descrição do erro para gerar LOG ou mensagem de aviso
aErro := oModel:GetErrorMessage()
// A estrutura do vetor com erro é:
// [1] identificador (ID) do formulário de origem
// [2] identificador (ID) do campo de origem
// [3] identificador (ID) do formulário de erro
// [4] identificador (ID) do campo de erro
// [5] identificador (ID) do erro
// [6] mensagem do erro
// [7] mensagem da solução
// [8] Valor atribuído
// [9] Valor anterior
AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1] ) + ']' )
AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' )
AutoGrLog( "Id do formulário de erro: " + ' [' + AllToChar( aErro[3] ) + ']' )
AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' )
AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']' )
AutoGrLog( "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' )
AutoGrLog( "Mensagem da solução: " + ' [' + AllToChar( aErro[7] ) + ']' )
AutoGrLog( "Valor atribuído: " + ' [' + AllToChar( aErro[8] ) + ']' )
AutoGrLog( "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' )
MostraErro()
EndIf
// Desativamos o Model
oModel:DeActivate()
Return lRet