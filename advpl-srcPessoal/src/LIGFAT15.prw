#INCLUDE "rwmake.ch"
#include "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLIGFAT15  บ Autor ณ Daniel Gouvea      บ Data ณ  19/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Listagem de Comissoes                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ligue Telecom                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function LIGFAT15
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo       := ""
	Local nLin         := 80
	Local Cabec1       := "Relat๓rio de Comissionamento e Estorno de itens por periodo"
	Local Cabec2       := " "
	Local imprime      := .T.
	Local aOrd := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite           := 80
	Private tamanho          := "M"
	Private nomeprog         := "LIGFAT15" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo            := 18
	Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "LIGFAT15" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cPerg := "LIGFAT15B "
	Private cString := "SUA"

	validperg()

	if !pergunte(cPerg,.T.)
		return
	endif

	dbSelectArea("SUA")
	dbSetOrder(1)

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
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem

	aDadosR := {} //RENOVACOES
	aDadosV := {} //NOVAS VENDAS
	aDadosI := {} //INCREMENTOS
	aDadosRex := {} //RENOVACOES
	aDadosVex := {} //NOVAS VENDAS
	aDadosIex := {} //INCREMENTOS

	aDadosRGE := {} //RENOVACOES GERENTE
	aDadosVGE := {} //NOVAS VENDAS GERENTE
	aDadosIGE := {} //INCREMENTOS GERENTE
	aDadosReGE := {} //RENOVACOES GERENTE
	aDadosVeGE := {} //NOVAS VENDAS GERENTE
	aDadosIeGE := {} //INCREMENTOS GERENTE

	aValores := {}
	nRenova := 0
	nVenda  := 0
	nValor := 0
	aAtend := {}
	aOcorren := {}
	aItens := {}
	vendTipo := 'I'
	vendTercei := 'N'

	if val(MV_PAR02) == 01
		mescomp1 := "12"
		anocomp1 := alltrim(str(val(MV_PAR03)-1))
	elseif val(MV_PAR02) < 10
		mescomp1 := "0"+ alltrim(str(val(MV_PAR02)-1))
		anocomp1 := alltrim(MV_PAR03)
		MV_PAR02 := "0"+ alltrim(str(val(MV_PAR02)))
	endif

	//--------------------------------------------
	//SELECT QUE VAI VERIFICAR APENAS A VENDA
	cQuery := " SELECT SZA2.ZA_MES AS MES,SZA2.ZA_ANO AS ANO,SZA2.ZA_VENDAS AS VENDAS,SZA2.ZA_RENOVAC AS RENOVACAO,SZA2.ZA_INCREME AS INCREMENTO,SZA.*,SUA.*, SUB.*, SB1.*,ADA.*,ADB.* FROM "+RetSqlName("SUA")+" SUA
	cQuery += " INNER JOIN "+RetSqlName("SUB")+" SUB ON UA_FILIAL=UB_FILIAL AND UA_NUM=UB_NUM "
	cQuery += " INNER JOIN "+RetSqlName("ADB")+" ADB ON ADB.ADB_UNUMAT=SUB.UB_NUM AND ADB.ADB_UITATE = SUB.UB_ITEM "
	cQuery += " INNER JOIN "+RetSqlName("ADA")+" ADA ON ADB.ADB_NUMCTR=ADA.ADA_NUMCTR "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON ADB.ADB_CODPRO = SB1.B1_COD "
	cQuery += " LEFT JOIN "+RetSqlName("SZA")+" SZA ON SUA.UA_VEND = ZA_VEND AND ZA_MES = DATEPART(MM,ADA_UDTLIB) AND ZA_ANO = DATEPART(yyyy,ADA_UDTLIB) "
	cQuery += " LEFT JOIN "+RetSqlName("SZA")+" SZA2 ON SUA.UA_VEND = SZA2.ZA_VEND AND SZA2.ZA_MES = DATEPART(MM,UA_EMISSAO) AND SZA2.ZA_ANO = DATEPART(yyyy,UA_EMISSAO)"
	cQuery += " WHERE SUA.D_E_L_E_T_=' ' AND SUB.D_E_L_E_T_=' ' AND ADB.D_E_L_E_T_=' ' AND ADA.D_E_L_E_T_=' '  AND SB1.D_E_L_E_T_= ' ' "
	cQuery += " AND UA_VEND='"+MV_PAR01+"'"
	cQuery += " AND UA_FILIAL='"+xFilial("SUA")+"' AND UB_UMESINI<12 AND SUBSTRING(UB_PRODUTO,1,2)<>'02'  "
	cQuery += " AND SB1.B1_UITCONT = 'S' "
	cQuery += " AND ADB_UDTINI > '19500000' "
	cQuery += " AND '"+anocomp1+""+mescomp1+"21' <= convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112) "
	cQuery += " AND '"+MV_PAR03+""+MV_PAR02+"20' >= convert(varchar(8),DATEADD(MONTH,-ADB_UMESIN,ADB_UDTINI),112) "
	cQuery += " ORDER BY UA_FILIAL,UA_VEND,UA_NUM "
                                                           
	//--------------------------------------------

	TCQUERY cQuery NEW ALIAS "TEMP"
	dbselectarea("TEMP")
	if eof()
		alert("Nao existem dados para esses parametros.")
		TEMP->(dbclosearea())
		return
	endif
	While !EOF()
		if TEMP->UA_NUM $ MV_PAR13
			DBSELECTAREA("TEMP")
			DBSKIP()
			LOOP
		ENDIF
		if TEMP->UA_CODLIG $ MV_PAR05 //VENDA
			aadd(aDadosV,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),TEMP->UB_VLRITEM,alltrim(TEMP->B1_DESC),TEMP->B1_COMIS,TEMP->ADA_NUMCTR,TEMP->ZA_VENDAS,TEMP->ZA_RENOVAC,TEMP->ZA_INCREME,TEMP->ADA_UDTLIB})
			aadd(aDadosVGE,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),TEMP->UB_VLRITEM,alltrim(TEMP->B1_DESC),TEMP->B1_UCOM2,TEMP->ADA_NUMCTR,TEMP->ZA_VENDAS,TEMP->ZA_RENOVAC,TEMP->ZA_INCREME,TEMP->ADA_UDTLIB})

		elseif TEMP->UA_CODLIG $ MV_PAR07 //INCREMENTO
			dbselectarea("ADB")
			dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
			if dbseek(xFilial()+TEMP->UB_UCTR+TEMP->UB_UITTROC)
				_valor := iif(TEMP->UB_VLRITEM-ADB->ADB_TOTAL>0,TEMP->UB_VLRITEM-ADB->ADB_TOTAL,0)
				if _valor > 0
					aadd(aDadosI,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),_valor,TEMP->B1_COMIS,TEMP->ADA_NUMCTR,alltrim(TEMP->B1_DESC),TEMP->VENDAS,TEMP->RENOVACAO,TEMP->INCREMENTO,TEMP->UA_EMISSAO})
					aadd(aDadosIGE,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),_valor,TEMP->B1_UCOM2,TEMP->ADA_NUMCTR,alltrim(TEMP->B1_DESC),TEMP->VENDAS,TEMP->RENOVACAO,TEMP->INCREMENTO,TEMP->UA_EMISSAO})
				endif
			endif
		elseif TEMP->UA_CODLIG $ MV_PAR06 //RENOVACAO
			_valorDif := 0
			_valor    := 0
			if !empty(alltrim(TEMP->UB_UCTR+TEMP->UB_UITTROC))
				dbselectarea("ADB")
				dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
				if dbseek(xFilial()+TEMP->UB_UCTR+TEMP->UB_UITTROC)
					_valorDif := iif(TEMP->UB_VLRITEM-ADB->ADB_TOTAL>0,TEMP->UB_VLRITEM-ADB->ADB_TOTAL,0)
					_valor := ROUND(ADB->ADB_TOTAL*MV_PAR08,2)
				else
					_valor := ROUND(TEMP->UB_VLRITEM*MV_PAR08,2)
				endif
			else
				_valor := ROUND(TEMP->UB_VLRITEM*MV_PAR08,2)
			endif

			aadd(aDadosR,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),_valor,TEMP->B1_COMIS,TEMP->ADA_NUMCTR,alltrim(TEMP->B1_DESC),_valorDif,TEMP->VENDAS,TEMP->RENOVACAO,TEMP->INCREMENTO,TEMP->UA_EMISSAO})
			aadd(aDadosRGE,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),_valor,TEMP->B1_UCOM2,TEMP->ADA_NUMCTR,alltrim(TEMP->B1_DESC),_valorDif,TEMP->VENDAS,TEMP->RENOVACAO,TEMP->INCREMENTO,TEMP->UA_EMISSAO})
		endif

		dbselectarea("TEMP")
		dbskip()
	enddo
	//-------------------------------------------------------------------------
	//BUSCA TIPO DO VENDEDOR
	dbselectarea("SA3")
	dbsetorder(1)//SA3_FILIAL+A3_COD
	if dbseek(xFilial()+aDadosV[1,1])
		if SA3->A3_TIPO == 'E'
			vendTipo := SA3->A3_TIPO
		endif
		if SA3->A3_UTIPO == 'S'
			vendTercei := 'S'
		end
	endif

	TEMP->(dbclosearea())

	//-------------------------------------------------------------------------

	//AJUSTAR VALORES E REGRA DE COMISSAO DE PRODUTOS NรO INTERNET, VALOR ZERO NO CADASTRO DE PRODUTO
	//VENDA NOVA
	for i:=1 to len(aDadosV)
		cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
		cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosV[i,5]+" AND Z3_VEND ="+aDadosV[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
		TCQUERY cQuery NEW ALIAS "TEMP"
		dbselectarea("TEMP")
		IF TEMP->Z3_GRUPO = ' '
			//VENDEDOR COMUM
			TEMP->(DBCLOSEAREA())
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosV[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
		ENDIF
		if vendTercei == 'S'
			aDadosV[i,9] := 100 // vendedor terceirazo, regra atual 100%, caso da conecta
		endif
		while !eof()
			if TEMP->Z3_QINI<=aDadosV[i,11] + aDadosV[i,13]+ (aDadosV[i,12]/2)  .and. TEMP->Z3_QFIM>=aDadosV[i,11] + aDadosV[i,13]+ (aDadosV[i,12]/2)
				if vendTercei == 'S'
					aDadosV[i,9] := TEMP->Z3_COM1
				elseif aDadosV[i,9] == 0
					aDadosV[i,9] := TEMP->Z3_COM1
				endif
			endif
			dbselectarea("TEMP")
			dbskip()
		enddo
		TEMP->(DBCLOSEAREA())
	next i
	//VENDA INCREMENTO
	for i:=1 to len(aDadosI)
		cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
		cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosI[i,5]+" AND Z3_VEND ="+aDadosI[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
		TCQUERY cQuery NEW ALIAS "TEMP"
		dbselectarea("TEMP")
		IF TEMP->Z3_GRUPO = ' '
			//VENDEDOR COMUM
			TEMP->(DBCLOSEAREA())
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosI[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
		ENDIF
		while !eof()
			//,VENDAS,RENOVACAO,INCREMENTO
			if TEMP->Z3_QINI<=aDadosI[i,11] + aDadosI[i,13]+ (aDadosI[i,12]/2)  .and. TEMP->Z3_QFIM>=aDadosI[i,11] + aDadosI[i,13]+ (aDadosI[i,12]/2)
				if vendTercei == 'S'
					aDadosI[i,8] := TEMP->Z3_COM1
				elseif aDadosI[i,8] == 0
					aDadosI[i,8] := TEMP->Z3_COM1
				endif
			endif
			dbselectarea("TEMP")
			dbskip()
		enddo
		TEMP->(DBCLOSEAREA())
	next i
	//VENDA RENOVAวรO
	for i:=1 to len(aDadosR)
		cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
		cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosR[i,5]+" AND Z3_VEND ="+aDadosR[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
		TCQUERY cQuery NEW ALIAS "TEMP"
		dbselectarea("TEMP")
		IF TEMP->Z3_GRUPO = ' '
			//VENDEDOR COMUM
			TEMP->(DBCLOSEAREA())
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosR[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
		ENDIF
		while !eof()
			//,VENDAS,RENOVACAO,INCREMENTO
			if TEMP->Z3_QINI<=aDadosR[i,12] + aDadosR[i,14]+ (aDadosR[i,13]/2)  .and. TEMP->Z3_QFIM>=aDadosR[i,12] + aDadosR[i,14]+ (aDadosR[i,13]/2)
				if vendTercei == 'S'
					aDadosR[i,8] := TEMP->Z3_COM1
				elseif aDadosR[i,8] == 0
					aDadosR[i,8] := TEMP->Z3_COM1
				endif
			endif
			dbselectarea("TEMP")
			dbskip()
		enddo
		TEMP->(DBCLOSEAREA())
	next i

	//-------------------------------------------------------------------------
	//AJUSTE NO ARRAY DE GERENTE
	//AJUSTAR VALORES E REGRA DE COMISSAO DE PRODUTOS NรO INTERNET, VALOR ZERO NO CADASTRO DE PRODUTO
	//VENDA NOVA
	codUsr := RetCodUsr()
	tpUsr := POSICIONE("SU7",4,xFilial("SU7")+codUsr,"U7_TIPO")
	if(tpUsr == '2') //Gerente
		for i:=1 to len(aDadosVGE)
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosVGE[i,5]+" AND Z3_VEND ="+aDadosVGE[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
			IF TEMP->Z3_GRUPO = ' '
				//VENDEDOR COMUM
				TEMP->(DBCLOSEAREA())
				cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
				cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosVGE[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
				TCQUERY cQuery NEW ALIAS "TEMP"
				dbselectarea("TEMP")
			ENDIF
			while !eof()
				if TEMP->Z3_QINI<=aDadosVGE[i,11] + aDadosVGE[i,13]+ (aDadosVGE[i,12]/2)  .and. TEMP->Z3_QFIM>=aDadosVGE[i,11] + aDadosVGE[i,13]+ (aDadosVGE[i,12]/2)
					if vendTercei == 'S'
						aDadosVGE[i,9] := TEMP->Z3_COM2
					elseif aDadosVGE[i,9] == 0
						aDadosVGE[i,9] := TEMP->Z3_COM2
					endif
				endif
				dbselectarea("TEMP")
				dbskip()
			enddo
			TEMP->(DBCLOSEAREA())
		next i
		//VENDA INCREMENTO
		for i:=1 to len(aDadosIGE)
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosIGE[i,5]+" AND Z3_VEND ="+aDadosIGE[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
			IF TEMP->Z3_GRUPO = ' '
				//VENDEDOR COMUM
				TEMP->(DBCLOSEAREA())
				cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
				cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosIGE[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
				TCQUERY cQuery NEW ALIAS "TEMP"
				dbselectarea("TEMP")
			ENDIF
			while !eof()
				//,VENDAS,RENOVACAO,INCREMENTO
				if TEMP->Z3_QINI<=aDadosIGE[i,11] + aDadosIGE[i,13]+ (aDadosIGE[i,12]/2)  .and. TEMP->Z3_QFIM>=aDadosIGE[i,11] + aDadosIGE[i,13]+ (aDadosIGE[i,12]/2)
					if vendTercei == 'S'
						aDadosIGE[i,8] := TEMP->Z3_COM2
					elseif aDadosIGE[i,8] == 0
						aDadosIGE[i,8] := TEMP->Z3_COM2
					endif
				endif
				dbselectarea("TEMP")
				dbskip()
			enddo
			TEMP->(DBCLOSEAREA())
		next i
		//VENDA RENOVAวรO
		for i:=1 to len(aDadosRGE)
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosRGE[i,5]+" AND Z3_VEND ="+aDadosRGE[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
			IF TEMP->Z3_GRUPO = ' '
				//VENDEDOR COMUM
				TEMP->(DBCLOSEAREA())
				cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
				cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosRGE[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
				TCQUERY cQuery NEW ALIAS "TEMP"
				dbselectarea("TEMP")
			ENDIF
			while !eof()
				//,VENDAS,RENOVACAO,INCREMENTO
				if TEMP->Z3_QINI<=aDadosRGE[i,12] + aDadosRGE[i,14]+ (aDadosRGE[i,13]/2)  .and. TEMP->Z3_QFIM>=aDadosRGE[i,12] + aDadosRGE[i,14]+ (aDadosRGE[i,13]/2)
					if vendTercei == 'S'
						aDadosRGE[i,8] := TEMP->Z3_COM2
					elseif aDadosRGE[i,8] == 0
						aDadosRGE[i,8] := TEMP->Z3_COM2
					endif
				endif
				dbselectarea("TEMP")
				dbskip()
			enddo
			TEMP->(DBCLOSEAREA())
		next i
	endif
	//-------------------------------------------------------------------------------------------
	//SELECT QUE VAI VERIFICAR APENAS A CANCELAMENTOS COM 6 MESES
	// E QUE O VENDEDOR NรO ESTEJA EM PERIODO DE EXPERIENCIA
	cQuery := " SELECT SZA2.ZA_MES AS MES,SZA2.ZA_ANO AS ANO,SZA2.ZA_VENDAS AS VENDAS,SZA2.ZA_RENOVAC AS RENOVACAO,SZA2.ZA_INCREME AS INCREMENTO,SZA.*,SUA.*, SUB.*, SB1.*,ADA.*,ADB.* FROM "+RetSqlName("SUA")+" SUA
	cQuery += " INNER JOIN "+RetSqlName("SUB")+" SUB ON UA_FILIAL=UB_FILIAL AND UA_NUM=UB_NUM "
	cQuery += " INNER JOIN "+RetSqlName("ADB")+" ADB ON ADB.ADB_UNUMAT=SUB.UB_NUM AND ADB.ADB_UITATE = SUB.UB_ITEM "
	cQuery += " INNER JOIN "+RetSqlName("ADA")+" ADA ON ADB.ADB_NUMCTR=ADA.ADA_NUMCTR "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON ADB.ADB_CODPRO = SB1.B1_COD "
	cQuery += " LEFT JOIN "+RetSqlName("SZA")+" SZA ON SUA.UA_VEND = ZA_VEND AND ZA_MES = DATEPART(MM,ADA_UDTLIB) AND ZA_ANO = DATEPART(yyyy,ADA_UDTLIB) "
	cQuery += " LEFT JOIN "+RetSqlName("SZA")+" SZA2 ON SUA.UA_VEND = SZA2.ZA_VEND AND SZA2.ZA_MES = DATEPART(MM,UA_EMISSAO) AND SZA2.ZA_ANO = DATEPART(yyyy,UA_EMISSAO)"
	cQuery += " INNER JOIN "+RetSqlName("SA3")+" SA3 ON SUA.UA_VEND = SA3.A3_COD "
	cQuery += " WHERE SUA.D_E_L_E_T_=' ' AND SUB.D_E_L_E_T_=' ' AND ADB.D_E_L_E_T_=' ' AND ADA.D_E_L_E_T_=' '  AND SB1.D_E_L_E_T_= ' ' "
	cQuery += " AND UA_VEND='"+MV_PAR01+"'"
	cQuery += " AND UA_FILIAL='"+xFilial("SUA")+"' AND UB_UMESINI<12 AND SUBSTRING(UB_PRODUTO,1,2)<>'02'  "
	cQuery += " AND SB1.B1_UITCONT = 'S' "
	cQuery += " AND ADB_UDTINI > '19500000' "
	cQuery += " AND DATEDIFF(month,ADA_UDTLIB,ADA_UDTBLQ) <= 6 "
	cQuery += " AND DATEDIFF(month,A3_ADMIS,ADA_UDTBLQ) >= 3 "
	cQuery += " AND '"+anocomp1+""+mescomp1+"21' <= ADA_UDTBLQ "
	cQuery += " AND '"+MV_PAR03+""+MV_PAR02+"20' >= ADA_UDTBLQ "
	cQuery += " ORDER BY UA_FILIAL,UA_VEND,UA_NUM "

	TCQUERY cQuery NEW ALIAS "TEMP"
	dbselectarea("TEMP")
	while !eof()
		if TEMP->UA_CODLIG $ MV_PAR05 //VENDA
			aadd(aDadosVex,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),TEMP->UB_VLRITEM,alltrim(TEMP->B1_DESC),TEMP->B1_COMIS,TEMP->ADA_NUMCTR,TEMP->ZA_VENDAS,TEMP->ZA_RENOVAC,TEMP->ZA_INCREME,TEMP->ADA_UDTLIB})

		elseif TEMP->UA_CODLIG $ MV_PAR07 //INCREMENTO
			dbselectarea("ADB")
			dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
			if dbseek(xFilial()+TEMP->UB_UCTR+TEMP->UB_UITTROC)
				_valor := iif(TEMP->UB_VLRITEM-ADB->ADB_TOTAL>0,TEMP->UB_VLRITEM-ADB->ADB_TOTAL,0)
				if _valor > 0
					aadd(aDadosIex,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),_valor,TEMP->B1_COMIS,TEMP->ADA_NUMCTR,alltrim(TEMP->B1_DESC),TEMP->VENDAS,TEMP->RENOVACAO,TEMP->INCREMENTO,TEMP->UA_EMISSAO})
				endif
			endif
		elseif TEMP->UA_CODLIG $ MV_PAR06 //RENOVACAO
			_valorDif := 0
			_valor    := 0
			if !empty(alltrim(TEMP->UB_UCTR+TEMP->UB_UITTROC))
				dbselectarea("ADB")
				dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
				if dbseek(xFilial()+TEMP->UB_UCTR+TEMP->UB_UITTROC)
					_valorDif := iif(TEMP->UB_VLRITEM-ADB->ADB_TOTAL>0,TEMP->UB_VLRITEM-ADB->ADB_TOTAL,0)
					_valor := ROUND(ADB->ADB_TOTAL*MV_PAR08,2)
				else
					_valor := ROUND(TEMP->UB_VLRITEM*MV_PAR08,2)
				endif
			else
				_valor := ROUND(TEMP->UB_VLRITEM*MV_PAR08,2)
			endif

			aadd(aDadosRex,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),_valor,TEMP->B1_COMIS,TEMP->ADA_NUMCTR,alltrim(TEMP->B1_DESC),_valorDif,TEMP->VENDAS,TEMP->RENOVACAO,TEMP->INCREMENTO,TEMP->UA_EMISSAO})
		endif

		dbselectarea("TEMP")
		dbskip()
	enddo
	TEMP->(DBCLOSEAREA())

	//AJUSTAR VALORES E REGRA DE COMISSAO DE PRODUTOS NรO INTERNET, VALOR ZERO NO CADASTRO DE PRODUTO
	//VENDA NOVA
	for i:=1 to len(aDadosVex)
		cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
		cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosVex[i,5]+" AND Z3_VEND ="+aDadosVex[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
		TCQUERY cQuery NEW ALIAS "TEMP"
		dbselectarea("TEMP")
		IF TEMP->Z3_GRUPO = ' '
			//VENDEDOR COMUM
			TEMP->(DBCLOSEAREA())
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosVex[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
		ENDIF
		while !eof()
			if TEMP->Z3_QINI<=aDadosVex[i,11] + aDadosVex[i,13]+ (aDadosVex[i,12]/2)  .and. TEMP->Z3_QFIM>=aDadosVex[i,11] + aDadosVex[i,13]+ (aDadosVex[i,12]/2)
				if vendTercei == 'S'
					aDadosVex[i,9] := TEMP->Z3_COM1
				elseif aDadosVex[i,9] == 0
					aDadosVex[i,9] := TEMP->Z3_COM1
				endif
			endif
			dbselectarea("TEMP")
			dbskip()
		enddo
		TEMP->(DBCLOSEAREA())
	next i
	//VENDA INCREMENTO
	for i:=1 to len(aDadosIex)
		cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
		cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosIex[i,5]+" AND Z3_VEND ="+aDadosIex[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
		TCQUERY cQuery NEW ALIAS "TEMP"
		dbselectarea("TEMP")
		IF TEMP->Z3_GRUPO = ' '
			//VENDEDOR COMUM
			TEMP->(DBCLOSEAREA())
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosIex[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
		ENDIF
		while !eof()
			//,VENDAS,RENOVACAO,INCREMENTO
			if TEMP->Z3_QINI<=aDadosIex[i,11] + aDadosIex[i,13]+ (aDadosIex[i,12]/2)  .and. TEMP->Z3_QFIM>=aDadosIex[i,11] + aDadosIex[i,13]+ (aDadosIex[i,12]/2)
				if vendTercei == 'S'
					aDadosIex[i,8] := TEMP->Z3_COM1
				elseif aDadosIex[i,8] == 0
					aDadosIex[i,8] := TEMP->Z3_COM1
				endif
			endif
			dbselectarea("TEMP")
			dbskip()
		enddo
		TEMP->(DBCLOSEAREA())
	next i
	//VENDA RENOVAวรO
	for i:=1 to len(aDadosRex)
		cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
		cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosRex[i,5]+" AND Z3_VEND ="+aDadosRex[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
		TCQUERY cQuery NEW ALIAS "TEMP"
		dbselectarea("TEMP")
		IF TEMP->Z3_GRUPO = ' '
			//VENDEDOR COMUM
			TEMP->(DBCLOSEAREA())
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosRex[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
		ENDIF
		while !eof()
			//,VENDAS,RENOVACAO,INCREMENTO
			if TEMP->Z3_QINI<=aDadosRex[i,12] + aDadosRex[i,14]+ (aDadosRex[i,13]/2)  .and. TEMP->Z3_QFIM>=aDadosRex[i,12] + aDadosRex[i,14]+ (aDadosRex[i,13]/2)
				if vendTercei == 'S'
					aDadosRex[i,8] := TEMP->Z3_COM1
				elseif aDadosRex[i,8] == 0
					aDadosRex[i,8] := TEMP->Z3_COM1
				endif
			endif
			dbselectarea("TEMP")
			dbskip()
		enddo
		TEMP->(DBCLOSEAREA())
	next i

	//--------------------------------------------------------------------------------------------------------------
	// GERENTE
	//-------------------------------------------------------------------------------------------
	//SELECT QUE VAI VERIFICAR APENAS A CANCELAMENTOS COM 6 MESES
	if(tpUsr == '2') //Gerente
		cQuery := " SELECT SZA2.ZA_MES AS MES,SZA2.ZA_ANO AS ANO,SZA2.ZA_VENDAS AS VENDAS,SZA2.ZA_RENOVAC AS RENOVACAO,SZA2.ZA_INCREME AS INCREMENTO,SZA.*,SUA.*, SUB.*, SB1.*,ADA.*,ADB.* FROM "+RetSqlName("SUA")+" SUA
		cQuery += " INNER JOIN "+RetSqlName("SUB")+" SUB ON UA_FILIAL=UB_FILIAL AND UA_NUM=UB_NUM "
		cQuery += " INNER JOIN "+RetSqlName("ADB")+" ADB ON ADB.ADB_UNUMAT=SUB.UB_NUM AND ADB.ADB_UITATE = SUB.UB_ITEM "
		cQuery += " INNER JOIN "+RetSqlName("ADA")+" ADA ON ADB.ADB_NUMCTR=ADA.ADA_NUMCTR "
		cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON ADB.ADB_CODPRO = SB1.B1_COD "
		cQuery += " LEFT JOIN "+RetSqlName("SZA")+" SZA ON SUA.UA_VEND = ZA_VEND AND ZA_MES = DATEPART(MM,ADA_UDTLIB) AND ZA_ANO = DATEPART(yyyy,ADA_UDTLIB) "
		cQuery += " LEFT JOIN "+RetSqlName("SZA")+" SZA2 ON SUA.UA_VEND = SZA2.ZA_VEND AND SZA2.ZA_MES = DATEPART(MM,UA_EMISSAO) AND SZA2.ZA_ANO = DATEPART(yyyy,UA_EMISSAO)"
		cQuery += " INNER JOIN "+RetSqlName("SA3")+" SA3 ON SUA.UA_VEND = SA3.A3_COD "
		cQuery += " WHERE SUA.D_E_L_E_T_=' ' AND SUB.D_E_L_E_T_=' ' AND ADB.D_E_L_E_T_=' ' AND ADA.D_E_L_E_T_=' '  AND SB1.D_E_L_E_T_= ' ' "
		cQuery += " AND UA_VEND='"+MV_PAR01+"'"
		cQuery += " AND UA_FILIAL='"+xFilial("SUA")+"' AND UB_UMESINI<12 AND SUBSTRING(UB_PRODUTO,1,2)<>'02'  "
		cQuery += " AND SB1.B1_UITCONT = 'S' "
		cQuery += " AND ADB_UDTINI > '19500000' "
		cQuery += " AND DATEDIFF(month,ADA_UDTLIB,ADA_UDTBLQ) <= 6 "
		//cQuery += " AND DATEDIFF(month,A3_ADMIS,ADA_UDTBLQ) >= 3 " //
		cQuery += " AND '"+anocomp1+""+mescomp1+"21' <= ADA_UDTBLQ "
		cQuery += " AND '"+MV_PAR03+""+MV_PAR02+"20' >= ADA_UDTBLQ "
		cQuery += " ORDER BY UA_FILIAL,UA_VEND,UA_NUM "

		TCQUERY cQuery NEW ALIAS "TEMP"
		dbselectarea("TEMP")
		while !eof()
			if TEMP->UA_CODLIG $ MV_PAR05 //VENDA
				aadd(aDadosVeGE,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),TEMP->UB_VLRITEM,alltrim(TEMP->B1_DESC),TEMP->B1_UCOM2,TEMP->ADA_NUMCTR,TEMP->ZA_VENDAS,TEMP->ZA_RENOVAC,TEMP->ZA_INCREME,TEMP->ADA_UDTLIB})

			elseif TEMP->UA_CODLIG $ MV_PAR07 //INCREMENTO
				dbselectarea("ADB")
				dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
				if dbseek(xFilial()+TEMP->UB_UCTR+TEMP->UB_UITTROC)
					_valor := iif(TEMP->UB_VLRITEM-ADB->ADB_TOTAL>0,TEMP->UB_VLRITEM-ADB->ADB_TOTAL,0)
					if _valor > 0
						aadd(aDadosIeGE,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),_valor,TEMP->B1_UCOM2,TEMP->ADA_NUMCTR,alltrim(TEMP->B1_DESC),TEMP->VENDAS,TEMP->RENOVACAO,TEMP->INCREMENTO,TEMP->UA_EMISSAO})
					endif
				endif
			elseif TEMP->UA_CODLIG $ MV_PAR06 //RENOVACAO
				_valorDif := 0
				_valor    := 0
				if !empty(alltrim(TEMP->UB_UCTR+TEMP->UB_UITTROC))
					dbselectarea("ADB")
					dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
					if dbseek(xFilial()+TEMP->UB_UCTR+TEMP->UB_UITTROC)
						_valorDif := iif(TEMP->UB_VLRITEM-ADB->ADB_TOTAL>0,TEMP->UB_VLRITEM-ADB->ADB_TOTAL,0)
						_valor := ROUND(ADB->ADB_TOTAL*MV_PAR08,2)
					else
						_valor := ROUND(TEMP->UB_VLRITEM*MV_PAR08,2)
					endif
				else
					_valor := ROUND(TEMP->UB_VLRITEM*MV_PAR08,2)
				endif

				aadd(aDadosReGE,{TEMP->UA_VEND,TEMP->UA_NUM,TEMP->UA_CODLIG,substr(POSICIONE("SA1",1,XFILIAL("SA1")+TEMP->UA_CLIENTE+TEMP->UA_LOJA,"A1_NOME"),1,25),TEMP->B1_GRUPO,alltrim(TEMP->B1_COD),_valor,TEMP->B1_UCOM2,TEMP->ADA_NUMCTR,alltrim(TEMP->B1_DESC),_valorDif,TEMP->VENDAS,TEMP->RENOVACAO,TEMP->INCREMENTO,TEMP->UA_EMISSAO})
			endif

			dbselectarea("TEMP")
			dbskip()
		enddo
		TEMP->(DBCLOSEAREA())

		//AJUSTAR VALORES E REGRA DE COMISSAO DE PRODUTOS NรO INTERNET, VALOR ZERO NO CADASTRO DE PRODUTO
		//VENDA NOVA
		for i:=1 to len(aDadosVeGE)
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosVeGE[i,5]+" AND Z3_VEND ="+aDadosVeGE[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
			IF TEMP->Z3_GRUPO = ' '
				//VENDEDOR COMUM
				TEMP->(DBCLOSEAREA())
				cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
				cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosVeGE[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
				TCQUERY cQuery NEW ALIAS "TEMP"
				dbselectarea("TEMP")
			ENDIF
			while !eof()
				if TEMP->Z3_QINI<=aDadosVeGE[i,11] + aDadosVeGE[i,13]+ (aDadosVeGE[i,12]/2)  .and. TEMP->Z3_QFIM>=aDadosVeGE[i,11] + aDadosVeGE[i,13]+ (aDadosVeGE[i,12]/2)
					if vendTercei == 'S'
						aDadosVeGE[i,9] := TEMP->Z3_COM2
					elseif aDadosVeGE[i,9] == 0
						aDadosVeGE[i,9] := TEMP->Z3_COM2
					endif
				endif
				dbselectarea("TEMP")
				dbskip()
			enddo
			TEMP->(DBCLOSEAREA())
		next i
		//VENDA INCREMENTO
		for i:=1 to len(aDadosIeGE)
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosIeGE[i,5]+" AND Z3_VEND ="+aDadosIeGE[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
			IF TEMP->Z3_GRUPO = ' '
				//VENDEDOR COMUM
				TEMP->(DBCLOSEAREA())
				cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
				cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosIeGE[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
				TCQUERY cQuery NEW ALIAS "TEMP"
				dbselectarea("TEMP")
			ENDIF
			while !eof()
				//,VENDAS,RENOVACAO,INCREMENTO
				if TEMP->Z3_QINI<=aDadosIeGE[i,11] + aDadosIeGE[i,13]+ (aDadosIeGE[i,12]/2)  .and. TEMP->Z3_QFIM>=aDadosIeGE[i,11] + aDadosIeGE[i,13]+ (aDadosIeGE[i,12]/2)
					if vendTercei == 'S'
						aDadosIeGE[i,8] := TEMP->Z3_COM2
					elseif aDadosIeGE[i,8] == 0
						aDadosIeGE[i,8] := TEMP->Z3_COM2
					endif
				endif
				dbselectarea("TEMP")
				dbskip()
			enddo
			TEMP->(DBCLOSEAREA())
		next i
		//VENDA RENOVAวรO
		for i:=1 to len(aDadosReGE)
			cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
			cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosReGE[i,5]+" AND Z3_VEND ="+aDadosReGE[i,1]+" AND Z3_TIPO ='"+vendTipo+"'"
			TCQUERY cQuery NEW ALIAS "TEMP"
			dbselectarea("TEMP")
			IF TEMP->Z3_GRUPO = ' '
				//VENDEDOR COMUM
				TEMP->(DBCLOSEAREA())
				cQuery := "SELECT * FROM  "+RetSqlName("SZ3")+" SZ3"
				cQuery += " WHERE D_E_L_E_T_=' ' AND Z3_GRUPO ="+aDadosReGE[i,5]+" AND Z3_VEND = ' ' AND Z3_TIPO ='"+vendTipo+"'"
				TCQUERY cQuery NEW ALIAS "TEMP"
				dbselectarea("TEMP")
			ENDIF
			while !eof()
				//,VENDAS,RENOVACAO,INCREMENTO
				if TEMP->Z3_QINI<=aDadosReGE[i,12] + aDadosReGE[i,14]+ (aDadosReGE[i,13]/2)  .and. TEMP->Z3_QFIM>=aDadosReGE[i,12] + aDadosReGE[i,14]+ (aDadosReGE[i,13]/2)
					if vendTercei == 'S'
						aDadosReGE[i,8] := TEMP->Z3_COM2
					elseif aDadosReGE[i,8] == 0
						aDadosReGE[i,8] := TEMP->Z3_COM2
					endif
				endif
				dbselectarea("TEMP")
				dbskip()
			enddo
			TEMP->(DBCLOSEAREA())
		next i
	endif
	//--------------------------------------------------------------------------------------------------------------

	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
	@nLin,000 PSAY "Vendedor :"
	@nLin,013 PSAY aDadosV[1,1]+" "+substr(posicione("SA3",1,XFILIAL("SA3")+aDadosV[1,1],"A3_NOME"),1,20)

	nLin++
	nLin++
	IF MV_PAR04==2
		@nLin,00 PSAY "CTR"
		@nLin,07 PSAY "CLIENTE"
		@nLin,35 PSAY "GRUPO/PRODUTO"
		@nLin,96 PSAY "CICLO"
		@nLin,110 PSAY "VL BASE"
		@nLin,120 PSAY "%"
		@nLin,123 PSAY "COMISSAO"
		nLin++
	ENDIF
	nTot := 0
	nTotVen := 0
	nTotG := 0
	nTotS := 0
	for i:=1 to len(aDadosV) // VENDA NOVA
		If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		IF MV_PAR04==2 // ANALITICO
			@nLin,00 PSAY aDadosV[i,10]
			@nLin,07 PSAY aDadosV[i,4] //PICTURE "999"
			@nLin,35 PSAY aDadosV[i,5]+" "+ aDadosV[i,8]
			@nLin,96 PSAY Stod(aDadosV[i,14])
			@nLin,105 PSAY aDadosV[i,7] PICTURE PESQPICT("SUB","UB_VLRITEM")
			@nLin,117 PSAY aDadosV[i,9] PICTURE "@E 999.99"
			@nLin,121 PSAY ROUND(aDadosV[i,7]*aDadosV[i,9]/100,2) PICTURE "@E 999,999.99"
			nLin++
		ENDIF
		nTot += ROUND(aDadosV[i,7]*aDadosV[i,9]/100,2)
		nTotVen += aDadosV[i,7]
	next i

	@nLin,00 PSAY "TOTAL ITENS NOVOS:"
	@nLin,30 PSAY len(aDadosV)
	@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
	@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
	nTotG += nTot
	nLin++
	nLin++
	//---------------------------------------------------------
	IF MV_PAR04==2
		@nLin,00 PSAY "ITENS INCREMENTO"
		nLin++
		@nLin,00 PSAY "CTR"
		@nLin,07 PSAY "CLIENTE"
		@nLin,35 PSAY "GRUPO/PRODUTO"
		@nLin,90 PSAY "CICLO"
		@nLin,100 PSAY "VL BASE"
		@nLin,113 PSAY "% COM"
		@nLin,120 PSAY "VL COMISSAO"
		nLin++
	ENDIF
	nTot := 0
	nTotVen := 0
	for i:=1 to len(aDadosI) // INCREMENTO
		If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		IF MV_PAR04==2
			@nLin,00 PSAY aDadosI[i,9]
			@nLin,07 PSAY aDadosI[i,4]
			@nLin,35 PSAY aDadosI[i,5] +" "+ aDadosI[i,10]
			@nLin,90 PSAY Stod(aDadosI[i,14])
			@nLin,99 PSAY aDadosI[i,7] PICTURE "@E 999,999.99"
			@nLin,113 PSAY aDadosI[i,8] PICTURE "@E 999,999.99"
			@nLin,120 PSAY ROUND(aDadosI[i,7]*aDadosI[i,8]/100,2) PICTURE "@E 999,999.99"
			nLin++
		ENDIF
		nTot += ROUND(aDadosI[i,7]*aDadosI[i,8]/100,2)
		nTotVen += aDadosI[i,7]
	next i
	@nLin,00 PSAY "TOTAL ITENS INCREMENTO:"
	@nLin,30 PSAY len(aDadosI)
	@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
	@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
	nTotG += nTot
	nLin++
	nLin++
	//------------------------------------------------------------
	IF MV_PAR04==2
		@nLin,00 PSAY "ITENS RENOVAวรO"
		nLin++
		@nLin,00 PSAY "CTR"
		@nLin,07 PSAY "CLIENTE"
		@nLin,35 PSAY "GRUPO/PRODUTO"
		@nLin,90 PSAY "CICLO"                                 
		@nLin,100 PSAY "VL BASE"
		@nLin,113 PSAY "% COM"
		@nLin,120 PSAY "VL COMISSAO"
		nLin++
	ENDIF
	nTot := 0
	nTotVen := 0
	for i:=1 to len(aDadosR) // RENOVAวรO
		If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		IF MV_PAR04==2
			@nLin,00 PSAY aDadosR[i,9]
			@nLin,07 PSAY aDadosR[i,4]
			@nLin,35 PSAY aDadosR[i,5] +" "+ aDadosR[i,10]
			@nLin,90 PSAY Stod(aDadosR[i,15])
			@nLin,100 PSAY aDadosR[i,11]+aDadosR[i,7] PICTURE "@E 999,999.99"
			@nLin,113 PSAY aDadosR[i,8] PICTURE "@E 999,999.99"
			@nLin,120 PSAY ROUND((aDadosR[i,11]*aDadosR[i,8]/100)+(aDadosR[i,7]*aDadosR[i,8]/100),2) PICTURE "@E 999,999.99"
			nLin++
		ENDIF
		nTot += ROUND((aDadosR[i,11]*aDadosR[i,8]/100)+(aDadosR[i,7]*aDadosR[i,8]/100),2)
		nTotVen += aDadosR[i,11]+aDadosR[i,7]
	next i
	@nLin,00 PSAY "TOTAL ITENS RENOVAวรO:"
	@nLin,30 PSAY len(aDadosR)
	@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
	@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
	nTotG += nTot
	nLin++
	@nLin,100 PSAY "------------------------------"
	nLin++
	@nLin,100 PSAY "TOTAL COMISSรO :"
	@nLin,120 PSAY nTotG PICTURE "@E 999,999.99"
	nLin++
	nLin++
	nLin++
	//--------------------------------------------------------------------------------------------------
	@nLin,25 PSAY "ESTORNO DE ITENS NO PERIODO"
	@nLin,00 PSAY "-------------------------"
	@nLin,53 PSAY "-------------------------"
	nLin++
	nLin++
	IF MV_PAR04==2
		@nLin,00 PSAY "CTR"
		@nLin,07 PSAY "CLIENTE"
		@nLin,35 PSAY "GRUPO/PRODUTO"
		@nLin,90 PSAY "CICLO"
		@nLin,100 PSAY "VL BASE"
		@nLin,113 PSAY "% COM"
		@nLin,120 PSAY "VL COMISSAO"
		nLin++
	ENDIF
	nTot := 0
	nTotVen := 0
	for i:=1 to len(aDadosVex) // VENDA NOVA
		If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		IF MV_PAR04==2 // ANALITICO
			@nLin,00 PSAY aDadosVex[i,10]
			@nLin,07 PSAY aDadosVex[i,4] //PICTURE "999"
			@nLin,35 PSAY aDadosVex[i,5]+" "+ aDadosVex[i,8]
			@nLin,90 PSAY Stod(aDadosVex[i,14])
			@nLin,100 PSAY aDadosVex[i,7] PICTURE PESQPICT("SUB","UB_VLRITEM")
			@nLin,113 PSAY aDadosVex[i,9] PICTURE "@E 999.99"
			@nLin,120 PSAY ROUND(aDadosVex[i,7]*aDadosVex[i,9]/100,2) PICTURE "@E 999,999.99"
			nLin++
		ENDIF
		nTot += ROUND(aDadosVex[i,7]*aDadosVex[i,9]/100,2)
		nTotVen += aDadosVex[i,7]
	next i

	@nLin,00 PSAY "TOTAL ITENS DE VENDA ESTORNADO:"
	@nLin,40 PSAY len(aDadosVex)
	@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
	@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
	nTotS += nTot
	nLin++
	nLin++
	//---------------------------------------------------------
	IF MV_PAR04==2
		@nLin,00 PSAY "ITENS INCREMENTO"
		nLin++
		@nLin,00 PSAY "CTR"
		@nLin,07 PSAY "CLIENTE"
		@nLin,35 PSAY "GRUPO/PRODUTO"
		@nLin,90 PSAY "CICLO"
		@nLin,100 PSAY "VL BASE"
		@nLin,113 PSAY "% COM"
		@nLin,120 PSAY "VL COMISSAO"
		nLin++
	ENDIF
	nTot := 0
	nTotVen := 0
	for i:=1 to len(aDadosIex) // INCREMENTO
		If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		IF MV_PAR04==2
			@nLin,00 PSAY aDadosIex[i,9]
			@nLin,07 PSAY aDadosIex[i,4]
			@nLin,35 PSAY aDadosIex[i,5] +" "+ aDadosIex[i,10]
			@nLin,90 PSAY Stod(aDadosIex[i,14])
			@nLin,99 PSAY aDadosIex[i,7] PICTURE "@E 999,999.99"
			@nLin,113 PSAY aDadosIex[i,8] PICTURE "@E 999,999.99"
			@nLin,120 PSAY ROUND(aDadosIex[i,7]*aDadosIex[i,8]/100,2) PICTURE "@E 999,999.99"
			nLin++
		ENDIF
		nTot += ROUND(aDadosIex[i,7]*aDadosIex[i,8]/100,2)
		nTotVen += aDadosIex[i,7]
	next i
	@nLin,00 PSAY "TOTAL ITENS DE INCREMENTO ESTORNADO:"
	@nLin,40 PSAY len(aDadosIex)
	@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
	@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
	nTotS += nTot
	nLin++
	nLin++
	//------------------------------------------------------------
	IF MV_PAR04==2
		@nLin,00 PSAY "ITENS RENOVAวรO"
		nLin++
		@nLin,00 PSAY "CTR"
		@nLin,07 PSAY "CLIENTE"
		@nLin,35 PSAY "GRUPO/PRODUTO"
		@nLin,90 PSAY "CLICLO"
		@nLin,100 PSAY "VL BASE"
		@nLin,113 PSAY "% COM"
		@nLin,120 PSAY "VL COMISSAO"
		nLin++
	ENDIF
	nTot := 0
	nTotVen := 0
	for i:=1 to len(aDadosRex) // RENOVAวรO
		If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		IF MV_PAR04==2
			@nLin,00 PSAY aDadosRex[i,9]
			@nLin,07 PSAY aDadosRex[i,4]
			@nLin,35 PSAY aDadosRex[i,5] +" "+ aDadosRex[i,10]
			@nLin,90 PSAY Stod(aDadosRex[i,15])
			@nLin,100 PSAY aDadosRex[i,11]+aDadosRex[i,7] PICTURE "@E 999,999.99"
			@nLin,113 PSAY aDadosRex[i,8] PICTURE "@E 999,999.99"
			@nLin,120 PSAY ROUND((aDadosRex[i,11]*aDadosRex[i,8]/100)+(aDadosRex[i,7]*aDadosRex[i,8]/100),2) PICTURE "@E 999,999.99"
			nLin++
		ENDIF
		nTot += ROUND((aDadosRex[i,11]*aDadosRex[i,8]/100)+(aDadosRex[i,7]*aDadosRex[i,8]/100),2)
		nTotVen += aDadosRex[i,11]+aDadosRex[i,7]
	next i
	@nLin,00 PSAY "TOTAL ITENS DE RENOVAวรO ESTORNADO:"
	@nLin,40 PSAY len(aDadosRex)
	@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
	@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
	nTotS += nTot
	nLin++
	@nLin,100 PSAY "------------------------------"
	nLin++
	@nLin,100 PSAY "TOTAL ESTORNO :"
	@nLin,120 PSAY nTotS PICTURE "@E 999,999.99"

	nLin++
	nLin++
	nLin++
	nLin++
	//--------------------------------------------------------------------------------------------------
	@nLin,35 PSAY "TOTAL"
	@nLin,00 PSAY "-------------------------"
	@nLin,53 PSAY "-------------------------"
	nLin++
	@nLin,100 PSAY "TOTAL GERAL:"
	@nLin,120 PSAY (nTotG-nTotS) PICTURE "@E 999,999.99"

	//--------------------------------------------------------------------------------------------------
	//VALIDAวรO QUE SO EXIBE OS REGISTRO DO GERENTE PARA O MESMO
	if(tpUsr == '2') //Gerente
		nLin++
		nLin++
		nLin++
		@nLin,25 PSAY "    COMISSรO GERENTE     "
		@nLin,00 PSAY "-------------------------"
		@nLin,53 PSAY "-------------------------"
		nLin++
		nLin++

		IF MV_PAR04==2
			@nLin,00 PSAY "CTR"
			@nLin,07 PSAY "CLIENTE"
			@nLin,35 PSAY "GRUPO/PRODUTO"
			@nLin,96 PSAY "CICLO"
			@nLin,110 PSAY "VL BASE"
			@nLin,120 PSAY "%"
			@nLin,123 PSAY "COMISSAO"
			nLin++
		ENDIF
		nTot := 0
		nTotVen := 0
		nTotG := 0
		nTotS := 0
		for i:=1 to len(aDadosVGE) // VENDA NOVA
			If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			IF MV_PAR04==2 // ANALITICO
				@nLin,00 PSAY aDadosVGE[i,10]
				@nLin,07 PSAY aDadosVGE[i,4] //PICTURE "999"
				@nLin,35 PSAY aDadosVGE[i,5]+" "+ aDadosVGE[i,8]
				@nLin,96 PSAY Stod(aDadosVGE[i,14])
				@nLin,105 PSAY aDadosVGE[i,7] PICTURE PESQPICT("SUB","UB_VLRITEM")
				@nLin,117 PSAY aDadosVGE[i,9] PICTURE "@E 999.99"
				@nLin,121 PSAY ROUND(aDadosVGE[i,7]*aDadosVGE[i,9]/100,2) PICTURE "@E 999,999.99"
				nLin++
			ENDIF
			nTot += ROUND(aDadosVGE[i,7]*aDadosVGE[i,9]/100,2)
			nTotVen += aDadosVGE[i,7]
		next i

		@nLin,00 PSAY "TOTAL ITENS NOVOS:"
		@nLin,30 PSAY len(aDadosVGE)
		@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
		@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
		nTotG += nTot
		nLin++
		nLin++
		//---------------------------------------------------------
		IF MV_PAR04==2
			@nLin,00 PSAY "ITENS INCREMENTO"
			nLin++
			@nLin,00 PSAY "CTR"
			@nLin,07 PSAY "CLIENTE"
			@nLin,35 PSAY "GRUPO/PRODUTO"
			@nLin,90 PSAY "CICLO"
			@nLin,100 PSAY "VL BASE"
			@nLin,113 PSAY "% COM"
			@nLin,120 PSAY "VL COMISSAO"
			nLin++
		ENDIF
		nTot := 0
		nTotVen := 0
		for i:=1 to len(aDadosIGE) // INCREMENTO
			If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			IF MV_PAR04==2
				@nLin,00 PSAY aDadosIGE[i,9]
				@nLin,07 PSAY aDadosIGE[i,4]
				@nLin,35 PSAY aDadosIGE[i,5] +" "+ aDadosIGE[i,10]
				@nLin,90 PSAY Stod(aDadosIGE[i,14])
				@nLin,99 PSAY aDadosIGE[i,7] PICTURE "@E 999,999.99"
				@nLin,113 PSAY aDadosIGE[i,8] PICTURE "@E 999,999.99"
				@nLin,120 PSAY ROUND(aDadosIGE[i,7]*aDadosIGE[i,8]/100,2) PICTURE "@E 999,999.99"
				nLin++
			ENDIF
			nTot += ROUND(aDadosIGE[i,7]*aDadosIGE[i,8]/100,2)
			nTotVen += aDadosIGE[i,7]
		next i
		@nLin,00 PSAY "TOTAL ITENS INCREMENTO:"
		@nLin,30 PSAY len(aDadosIGE)
		@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
		@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
		nTotG += nTot
		nLin++
		nLin++
		//------------------------------------------------------------
		IF MV_PAR04==2
			@nLin,00 PSAY "ITENS RENOVAวรO"
			nLin++
			@nLin,00 PSAY "CTR"
			@nLin,07 PSAY "CLIENTE"
			@nLin,35 PSAY "GRUPO/PRODUTO"
			@nLin,90 PSAY "CICLO"
			@nLin,100 PSAY "VL BASE"
			@nLin,113 PSAY "% COM"
			@nLin,120 PSAY "VL COMISSAO"
			nLin++
		ENDIF
		nTot := 0
		nTotVen := 0
		for i:=1 to len(aDadosRGE) // RENOVAวรO
			If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			IF MV_PAR04==2
				@nLin,00 PSAY aDadosRGE[i,9]
				@nLin,07 PSAY aDadosRGE[i,4]
				@nLin,35 PSAY aDadosRGE[i,5] +" "+ aDadosRGE[i,10]
				@nLin,90 PSAY Stod(aDadosRGE[i,15])
				@nLin,100 PSAY aDadosRGE[i,11]+aDadosRGE[i,7] PICTURE "@E 999,999.99"
				@nLin,113 PSAY aDadosRGE[i,8] PICTURE "@E 999,999.99"
				@nLin,120 PSAY ROUND((aDadosRGE[i,11]*aDadosRGE[i,8]/100)+(aDadosRGE[i,7]*aDadosRGE[i,8]/100),2) PICTURE "@E 999,999.99"
				nLin++
			ENDIF
			nTot += ROUND((aDadosRGE[i,11]*aDadosRGE[i,8]/100)+(aDadosRGE[i,7]*aDadosRGE[i,8]/100),2)
			nTotVen += aDadosRGE[i,11]+aDadosRGE[i,7]
		next i
		@nLin,00 PSAY "TOTAL ITENS RENOVAวรO:"
		@nLin,30 PSAY len(aDadosRGE)
		@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
		@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
		nTotG += nTot
		nLin++
		@nLin,100 PSAY "------------------------------"
		nLin++
		@nLin,100 PSAY "TOTAL COMISSรO :"
		@nLin,120 PSAY nTotG PICTURE "@E 999,999.99"
		nLin++
		nLin++
		//--------------------------------------------------------------------------------------------------

		nLin++
		nLin++
		nLin++
		//--------------------------------------------------------------------------------------------------
		@nLin,25 PSAY " ESTORNO DE ITENS GERENTE "
		@nLin,00 PSAY "-------------------------"
		@nLin,53 PSAY "-------------------------"
		nLin++
		nLin++
		IF MV_PAR04==2
			@nLin,00 PSAY "CTR"
			@nLin,07 PSAY "CLIENTE"
			@nLin,35 PSAY "GRUPO/PRODUTO"
			@nLin,90 PSAY "CICLO"
			@nLin,100 PSAY "VL BASE"
			@nLin,113 PSAY "% COM"
			@nLin,120 PSAY "VL COMISSAO"
			nLin++
		ENDIF
		nTot := 0
		nTotVen := 0
		for i:=1 to len(aDadosVeGE) // VENDA NOVA
			If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			IF MV_PAR04==2 // ANALITICO
				@nLin,00 PSAY aDadosVeGE[i,10]
				@nLin,07 PSAY aDadosVeGE[i,4] //PICTURE "999"
				@nLin,35 PSAY aDadosVeGE[i,5]+" "+ aDadosVeGE[i,8]
				@nLin,90 PSAY Stod(aDadosVeGE[i,14])
				@nLin,100 PSAY aDadosVeGE[i,7] PICTURE PESQPICT("SUB","UB_VLRITEM")
				@nLin,113 PSAY aDadosVeGE[i,9] PICTURE "@E 999.99"
				@nLin,120 PSAY ROUND(aDadosVeGE[i,7]*aDadosVeGE[i,9]/100,2) PICTURE "@E 999,999.99"
				nLin++
			ENDIF
			nTot += ROUND(aDadosVeGE[i,7]*aDadosVeGE[i,9]/100,2)
			nTotVen += aDadosVeGE[i,7]
		next i

		@nLin,00 PSAY "TOTAL ITENS DE VENDA ESTORNADO:"
		@nLin,40 PSAY len(aDadosVeGE)
		@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
		@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
		nTotS += nTot
		nLin++
		nLin++
		//---------------------------------------------------------
		IF MV_PAR04==2
			@nLin,00 PSAY "ITENS INCREMENTO"
			nLin++
			@nLin,00 PSAY "CTR"
			@nLin,07 PSAY "CLIENTE"
			@nLin,35 PSAY "GRUPO/PRODUTO"
			@nLin,90 PSAY "CICLO"
			@nLin,100 PSAY "VL BASE"
			@nLin,113 PSAY "% COM"
			@nLin,120 PSAY "VL COMISSAO"
			nLin++
		ENDIF
		nTot := 0
		nTotVen := 0
		for i:=1 to len(aDadosIeGE) // INCREMENTO
			If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			IF MV_PAR04==2
				@nLin,00 PSAY aDadosIeGE[i,9]
				@nLin,07 PSAY aDadosIeGE[i,4]
				@nLin,35 PSAY aDadosIeGE[i,5] +" "+ aDadosIeGE[i,10]
				@nLin,90 PSAY Stod(aDadosIeGE[i,14])
				@nLin,99 PSAY aDadosIeGE[i,7] PICTURE "@E 999,999.99"
				@nLin,113 PSAY aDadosIeGE[i,8] PICTURE "@E 999,999.99"
				@nLin,120 PSAY ROUND(aDadosIeGE[i,7]*aDadosIeGE[i,8]/100,2) PICTURE "@E 999,999.99"
				nLin++
			ENDIF
			nTot += ROUND(aDadosIeGE[i,7]*aDadosIeGE[i,8]/100,2)
			nTotVen += aDadosIeGE[i,7]
		next i
		@nLin,00 PSAY "TOTAL ITENS DE INCREMENTO ESTORNADO:"
		@nLin,40 PSAY len(aDadosIeGE)
		@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
		@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
		nTotS += nTot
		nLin++
		nLin++
		//------------------------------------------------------------
		IF MV_PAR04==2
			@nLin,00 PSAY "ITENS RENOVAวรO"
			nLin++
			@nLin,00 PSAY "CTR"
			@nLin,07 PSAY "CLIENTE"
			@nLin,35 PSAY "GRUPO/PRODUTO"
			@nLin,90 PSAY "CLICLO"
			@nLin,100 PSAY "VL BASE"
			@nLin,113 PSAY "% COM"
			@nLin,120 PSAY "VL COMISSAO"
			nLin++
		ENDIF
		nTot := 0
		nTotVen := 0
		for i:=1 to len(aDadosReGE) // RENOVAวรO
			If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			IF MV_PAR04==2
				@nLin,00 PSAY aDadosReGE[i,9]
				@nLin,07 PSAY aDadosReGE[i,4]
				@nLin,35 PSAY aDadosReGE[i,5] +" "+ aDadosReGE[i,10]
				@nLin,90 PSAY Stod(aDadosReGE[i,15])
				@nLin,100 PSAY aDadosReGE[i,11]+aDadosReGE[i,7] PICTURE "@E 999,999.99"
				@nLin,113 PSAY aDadosReGE[i,8] PICTURE "@E 999,999.99"
				@nLin,120 PSAY ROUND((aDadosReGE[i,11]*aDadosReGE[i,8]/100)+(aDadosReGE[i,7]*aDadosReGE[i,8]/100),2) PICTURE "@E 999,999.99"
				nLin++
			ENDIF
			nTot += ROUND((aDadosReGE[i,11]*aDadosReGE[i,8]/100)+(aDadosReGE[i,7]*aDadosReGE[i,8]/100),2)
			nTotVen += aDadosReGE[i,11]+aDadosReGE[i,7]
		next i
		@nLin,00 PSAY "TOTAL ITENS DE RENOVAวรO ESTORNADO:"
		@nLin,40 PSAY len(aDadosReGE)
		@nLin,99 PSAY nTotVen PICTURE "@E 999,999.99"
		@nLin,120 PSAY nTot PICTURE "@E 999,999.99"
		nTotS += nTot
		nLin++
		@nLin,100 PSAY "------------------------------"
		nLin++
		@nLin,100 PSAY "TOTAL ESTORNO :"
		@nLin,120 PSAY nTotS PICTURE "@E 999,999.99"

		nLin++
		nLin++
		nLin++
		nLin++
		//--------------------------------------------------------------------------------------------------
		@nLin,35 PSAY "TOTAL"
		@nLin,00 PSAY "-------------------------"
		@nLin,53 PSAY "-------------------------"
		nLin++
		@nLin,100 PSAY "TOTAL GERAL:"
		@nLin,120 PSAY (nTotG-nTotS) PICTURE "@E 999,999.99"
	endif
	//--------------------------------------------------------------------------------------------------

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

STATIC FUNCTION VALIDPERG
	_SALIAS := ALIAS()
	AREGS := {}

	DBSELECTAREA("SX1")
	DBSETORDER(1)
	cPerg := PADR(cPerg,10)

	//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG
	AADD(AREGS,{cPerg,"01","VENDEDOR DE      ?","","","MV_CH1","C",06,0,0, "G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
	AADD(AREGS,{cPerg,"02","MสS ?             ","","","MV_CHG","C",02,0,0, "G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(AREGS,{cPerg,"03","ANO ?             ","","","MV_CHG","C",04,0,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(AREGS,{cPerg,"04","TIPO             ?","","","MV_CH5","N",01,0,0, "C","","MV_PAR04","Sintetico","","","","","Analitico","","","","","","","","","","","","","","","","","","","",""})
	AADD(AREGS,{cPerg,"05","CODIGOS VENDA     ","","","MV_CH6","C",80,0,0, "G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(AREGS,{cPerg,"06","CODIGOS RENOVACAO ","","","MV_CH7","C",80,0,0, "G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(AREGS,{cPerg,"07","CODIGOS INCREMENTO","","","MV_CH8","C",80,0,0, "G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(AREGS,{cPerg,"08","% SOBRE RENOVACAO ","","","MV_CH9","N",05,2,0, "G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(AREGS,{cPerg,"13","DESCONSID. ATEND. ","","","MV_CHE","C",80,0,0, "G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	FOR I:=1 TO LEN(AREGS)
		IF !DBSEEK(CPERG+AREGS[I,2])
			RECLOCK("SX1",.T.)
			FOR J:=1 TO FCOUNT()
				IF J <= LEN(AREGS[I])
					FIELDPUT(J,AREGS[I,J])
				ENDIF
			NEXT
			MSUNLOCK()
		ENDIF
	NEXT
	DBSELECTAREA(_SALIAS)
RETURN