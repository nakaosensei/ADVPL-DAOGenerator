#Include "PROTHEUS.ch"
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#include "TOTVS.CH"

user function LIGFIN17()
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo       := ""
	Local nLin         := 80
	Local Cabec1       := "Relatório de Consistências"
	Local Cabec2       := " "
	Local imprime      := .T.
	Local aOrd := {}

	private aCliYate := {}
	private aClitotvs := {}
	private	aVetContra := {}
	private	aVetCo := {}
	private ctotvs := ""

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite           := 80
	Private tamanho          := "M"
	Private nomeprog         := "LIGFAT17" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo            := 18
	Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "LIGFAT17" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cPerg := ""
	Private cString := ""

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	LIGFIN17C()
	LIGFIN17B()
	LIGFIN17A() //carrega vetores

	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
	@nLin,000 PSAY "Cadastro do Yate ATIVO sem Codigo Totvs :"
	nLin++
	for i:=1 to len(aCliYate) // vetor com resultado do SQL
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		@nLin,000 PSAY aCliYate[i]
		nLin++
	next
	nLin++
	@nLin,000 PSAY "------------------------------------------------------------------------"
	nLin++
	@nLin,000 PSAY "Cadastro do Yate ATIVO sem Codigo Totvs e sem existencia de contrato :"
	nLin++
	@nLin,000 PSAY ctotvs
	nLin++
	@nLin,000 PSAY "------------------------------------------------------------------------"
	nLin++
	@nLin,000 PSAY "Contratos diferentes com mesmo codigo Yate :"

	for x = 1 to len(aVetContra)
		nLin++
		@nLin,000 PSAY "Codigo Yate: " + aVetContra[x,1] + " Ocorrencias "+ ALLTRIM(STR(aVetContra[x,2]))
		for y = 1 to len(aVetContra[x,3])
			nLin++
			@nLin,010 PSAY "Contrato: " + aVetContra[x,3][y,1] + " Cliente :" + aVetContra[x,3][y,2]
		next
		nLin++
	next
	nLin++
	@nLin,000 PSAY "------------------------------------------------------------------------"
	nLin++
	@nLin,000 PSAY "Yate com Contrato Totvs e Contrato sem Yate"
	for x = 1 to len(aVetCo)
		nLin++
		@nLin,010 PSAY "Contrato: " + aVetCo[x,1] + " Cliente: " + aVetCo[x,2] + " Codigo Yate: " + ALLTRIM(STR(aVetCo[x,3]))
	next

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

return

STATIC FUNCTION LIGFIN17A()
	local aVetYat := {}
	//--------------------------------------
	//-- CONSULTA YATE SEM CODIGO DO TOTVS--
	//--------------------------------------
	_NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
	_NCONNPTG  := TCLINK("POSTGRES/PostGreLigue","10.0.1.98",7890) //CONECTA AO POSTGRES

	_CQUERY := " select * from integrador.internet i
	_CQUERY += " inner join integrador.cliente c on c.cd_cliente = i.cd_cliente
	_CQUERY += " where i.in_situacao <> 'B' and (c.cd_totvs = '' or c.cd_totvs is null)

	IF SELECT("TRB0")!=0
		TRB0->(DBCLOSEAREA())
	ENDIF
	TCQUERY CHANGEQUERY(_CQUERY) NEW ALIAS "TRB0"

	DbSelectArea("TRB0")
	while !eof()
		aadd(aCliYate,TRB0->cd_cliente)
		dbselectarea("TRB0")
		dbskip()
	enddo

	TRB0->(DBCLOSEAREA())
	TCUNLINK(_NCONNPTG)  //FECHA CONEXAO POSTGRES
	TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL

	//--------------------------------------------
	cYate := ""
	for x=1 to len(aCliYate)
		if x = len(aCliYate)
			cYate += AllTRIM(STR(aCliYate[x]))
		else
			cYate += AllTRIM(STR(aCliYate[x])+",")
		endif
	next

	cQuery := " SELECT * FROM "+RetSqlName("ADA")+" ADA"
	cQuery += " WHERE ADA_UIDYAT IN ("+cYate+") "

	TCQUERY cQuery NEW ALIAS "TEMP"
	dbselectarea("TEMP")

	While !EOF()
		aadd(aClitotvs,{TEMP->ADA_NUMCTR,TEMP->ADA_UIDYAT})
		dbselectarea("TEMP")
		dbskip()
	enddo
	TEMP->(dbclosearea())

	aVetYat := AClone(aCliYate)
	for x=1 to len(aClitotvs)
		for y=1 to len(aVetYat)
			if VAL(aClitotvs[x,2]) == aVetYat[y] .and. aVetYat[y] != 0
				aVetYat[y] := 0
			endif
		next
	next

	ctotvs := ""
	for y=1 to len(aVetYat)
		if  aVetYat[y] != 0
			ctotvs += Alltrim(STR(aVetYat[y])+",")
		endif
	next

	//	if len(aCliYate) == len(aClitotvs)
	//		alert("Esta OK")
	//	else
	//		alert("Yate´s sem contrato : " + cTotvs)
	//	endif
return

STATIC FUNCTION LIGFIN17B()
	//--------------------------------------
	//-- CONSULTA ADA com mais de um YATE --
	//--------------------------------------

	aVetADA := {}

	cQuery := "select ADA_UIDYAT, count(ADA_UIDYAT) AS TOTAL from "+RetSqlName("ADA")
	cQuery += " where D_E_L_E_T_ = '' and ADA_UDTBLQ = '' and ADA_UIDYAT <> ''
	cQuery += " group by ADA_UIDYAT
	cQuery += " having  count(ADA_UIDYAT) >  1"

	//--------------------------------------------

	TCQUERY cQuery NEW ALIAS "TEMP"
	dbselectarea("TEMP")

	While !EOF()
		aadd(aVetContra,{TEMP->ADA_UIDYAT,TEMP->TOTAL})
		dbselectarea("TEMP")
		dbskip()
	enddo

	TEMP->(dbclosearea())

	for x = 1 to len(aVetContra)
		cQuery := "select ADA_NUMCTR,ADA_CODCLI from "+RetSqlName("ADA")
		cQuery += " where D_E_L_E_T_ = '' AND ADA_UIDYAT = '"+aVetContra[x,1]+"'

		TCQUERY cQuery NEW ALIAS "TEMP"
		dbselectarea("TEMP")
		if eof()
			TEMP->(dbclosearea())
		endif
		While !EOF()
			aadd(aVetADA,{TEMP->ADA_NUMCTR,TEMP->ADA_CODCLI})
			dbselectarea("TEMP")
			dbskip()
		enddo

		aadd(aVetContra[x],aClone(aVetADA))
		aVetADA := {}
		TEMP->(dbclosearea())
	next

return

STATIC FUNCTION LIGFIN17C()
	aVetC :={}

	_NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
	_NCONNPTG  := TCLINK("POSTGRES/PostGreLigue","10.0.1.98",7890) //CONECTA AO POSTGRES

	_CQUERY := " select c.cd_totvs,c.cd_cliente from integrador.internet i
	_CQUERY += " inner join integrador.cliente c on c.cd_cliente = i.cd_cliente
	_CQUERY += " where i.in_situacao != 'B' and c.cd_totvs != '' and c.cd_totvs is not null"

	IF SELECT("TRB0")!=0
		TRB0->(DBCLOSEAREA())
	ENDIF
	TCQUERY CHANGEQUERY(_CQUERY) NEW ALIAS "TRB0"

	DbSelectArea("TRB0")
	while !eof()
		if ALLTRIM(TRB0->cd_totvs) != ''
			aadd(aVetC,{TRB0->cd_totvs,TRB0->cd_cliente})
		endif
		dbselectarea("TRB0")
		dbskip()
	enddo

	TRB0->(DBCLOSEAREA())
	TCUNLINK(_NCONNPTG)  //FECHA CONEXAO POSTGRES
	TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL

	for x = 1 to len(aVetC)
		cQuery := "select ADA_NUMCTR,ADA_CODCLI from "+RetSqlName("ADA")
		cQuery += " where D_E_L_E_T_ = '' AND ADA_UIDYAT = '' AND ADA_NUMCTR = '"+aVetC[x,1]+"'

		//--------------------------------------------

		TCQUERY cQuery NEW ALIAS "TEMP"
		dbselectarea("TEMP")

		While !EOF()
			aadd(aVetCo,{TEMP->ADA_NUMCTR,TEMP->ADA_CODCLI,aVetC[x,2]})
			dbselectarea("TEMP")
			dbskip()
		enddo

		TEMP->(dbclosearea())
	next
return
