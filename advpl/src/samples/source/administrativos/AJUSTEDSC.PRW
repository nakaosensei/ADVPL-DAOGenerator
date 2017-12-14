#INCLUDE "PROTHEUS.CH"

Static lFWCodFil := FindFunction("FWCodFil")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AJUSTEDSC ³ Autor ³ TOTVS                 ³ Data ³26.06.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ajusta valores de desconto nao gravados no registro princi- ³±±
±±³          ³pal da baixa CR                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AJUSTDSC()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static aPergRet := {}            

LOCAL aParamBox := {}  
LOCAL bOk := {|| .T.}
LOCAL aButtons := {}
LOCAL lCentered := .T.
LOCAL nPosx
LOCAL nPosy
LOCAL cLoad := "AJTDSC"
LOCAL lCanSave := .T.
LOCAL lUserSave := .T.
LOCAL dData	 := dDataBase  
Local nTamFilial:= IIf( lFWCodFil, FWGETTAMFILIAL, 2 )
Local cFilDe
Local cFilAte
Local cTitulo := "Ajuste Desconto SE5"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas         ³
//³---------------------------------         ³
//³ aPergRet[1] - Data Inicial ?             ³
//³ aPergRet[2] - Data Final ?               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aParamBox,{1, "Filial De"	   ,Space(nTamFilial),"@!","","XM0",".T.",nTamFilial ,.F.}) //Filial centralizadora                                
AADD(aParamBox,{1, "Filial Ate"	   ,Space(nTamFilial),"@!","","XM0",".T.",NTamFilial ,.F.}) //Filial centralizadora                                AADD(aParamBox,{1, "Data Final"	   ,dData	  ,"" 	 			 			  ,""   ,""	  ,""   ,50 ,.T.}) //Vencimento Final ?      			   
AADD(aParamBox,{1, "Data Inicia"	   ,dData	  			,""  ,"",""   ,""   ,50         ,.T.}) //Vencimento Inicial ?     
AADD(aParamBox,{1, "Data Final"	   ,dData	  			,""  ,"",""	  ,""   ,50         ,.T.}) //Vencimento Final ?      			   

lRet := ParamBox(aParamBox, cTitulo, aPergRet, bOk, aButtons, lCentered, nPosx,nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)

If lRet
	Processa({|lEnd| AjtDesc()},"Ajustanto Base","Ajustanto Base",.F.)
EndIf

ALERT("Processo Terminado")

Return(.T.)

//------------------------------------------------------------
// AJTDESC
// Ajuste dos descontos nao registrados no registro principal
//------------------------------------------------------------
Static Function AJTDESC()

Local cFilDe		:= aPergRet[1]
Local cFilAte		:= aPergRet[2]
Local dDataIni		:= aPergRet[3]
Local dDataFim		:= aPergRet[4]
Local cQuery		:= ""
Local nRegSM0		:= SM0->(Recno())
Local nNumRegSM0	:= 0

dbSelectArea("SM0")
dbSeek(cEmpAnt,.T.)
While !Eof() .and. SM0->M0_CODIGO == cEmpAnt
	nNumRegSM0++
	DbSkip()
Enddo
SM0->(dbGoto(nRegSM0))

ProcRegua(nRegSM0)

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

While SM0->(!Eof()) .and. SM0->M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte

	dbSelectArea("SE5")
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

	IncProc("Atualizando Filial..."+SM0->M0_FILIAL )

	cQuery:= "SELECT SE5A.E5_VALOR NVALDESCO, SE5B.R_E_C_N_O_ NRECNOSE5 "
	cQuery+= "			FROM " + RetSqlName("SE5")+" SE5A "
	cQuery+= "		   LEFT JOIN " + RetSqlName("SE5")+" SE5B ON "
	cQuery+= "		      SE5B.E5_FILIAL = SE5A.E5_FILIAL AND "
	cQuery+= "		      SE5B.E5_PREFIXO = SE5A.E5_PREFIXO AND "
	cQuery+= "		      SE5B.E5_NUMERO = SE5A.E5_NUMERO AND "
	cQuery+= "		      SE5B.E5_PARCELA = SE5A.E5_PARCELA AND "
	cQuery+= "		      SE5B.E5_TIPO = SE5A.E5_TIPO AND "
	cQuery+= "		      SE5B.E5_CLIFOR = SE5A.E5_CLIFOR AND "
	cQuery+= "		      SE5B.E5_LOJA = SE5A.E5_LOJA AND "
	cQuery+= "		      SE5B.E5_SEQ = SE5A.E5_SEQ AND "
	cQuery+= "		      SE5B.E5_TIPODOC = 'VL' AND "
	cQuery+= "		      SE5B.E5_VLDESCO = 0 AND "
	cQuery+= "		      SE5B.D_E_L_E_T_ = '  ' 
	cQuery+= "		WHERE "
	cQuery+= "		SE5A.E5_FILIAL = '"+xFilial("SE5")+"' AND "
	cQuery+= "		SE5A.E5_TIPODOC = 'DC' AND "
	cQuery+= "		SE5A.E5_DATA >= '"+DTOS(dDataIni)+"' AND "
	cQuery+= "		SE5A.E5_DATA <= '"+DTOS(dDataFim)+"' AND "
	cQuery+= "		SE5A.D_E_L_E_T_ = '  ' "

	cQuery+= "		UNION ALL "
	cQuery+= "		SELECT SE5A.E5_VALOR NVALDESCO, SE5B.R_E_C_N_O_ NRECNOSE5 "
	cQuery+= "		FROM " + RetSqlName("SE5")+" SE5A "
	cQuery+= "		   LEFT JOIN " + RetSqlName("SE5")+" SE5B ON "
	cQuery+= "		      SE5B.E5_FILIAL = SE5A.E5_FILIAL AND "
	cQuery+= "		      SE5B.E5_PREFIXO = SE5A.E5_PREFIXO AND "
	cQuery+= "		      SE5B.E5_NUMERO = SE5A.E5_NUMERO AND "
	cQuery+= "		      SE5B.E5_PARCELA = SE5A.E5_PARCELA AND "
	cQuery+= "		      SE5B.E5_TIPO = SE5A.E5_TIPO AND "
	cQuery+= "		      SE5B.E5_CLIFOR = SE5A.E5_CLIFOR AND "
	cQuery+= "		      SE5B.E5_LOJA = SE5A.E5_LOJA AND "
	cQuery+= "		      SE5B.E5_SEQ = SE5A.E5_SEQ AND "
	cQuery+= "		      SE5B.E5_TIPODOC = 'BA' AND "
	cQuery+= "		      SE5B.E5_VLDESCO = 0 AND "
	cQuery+= "		      SE5B.D_E_L_E_T_ = '  ' "
	cQuery+= "		WHERE "
	cQuery+= "		SE5A.E5_FILIAL = '"+xFilial("SE5")+"' AND "
	cQuery+= "		SE5A.E5_TIPODOC = 'DC' AND "
	cQuery+= "		SE5A.E5_DATA >= '"+DTOS(dDataIni)+"' AND "
	cQuery+= "		SE5A.E5_DATA <= '"+DTOS(dDataFim)+"' AND "
	cQuery+= "		SE5A.D_E_L_E_T_ = '  '

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRBSE5", .F., .T.)

	dbSelectArea("TRBSE5")
		
	While !Eof()

		If NRECNOSE5 > 0
	   	SE5->(DBGOTO(TRBSE5->NRECNOSE5))
   		RECLOCK("SE5")
   		SE5->E5_VLDESCO := TRBSE5->NVALDESCO
			MSUNLOCK()
		Endif			   	

		dbSelectArea("TRBSE5")
		dbSkip()
		
	Enddo

	dbSelectArea("TRBSE5")
	dbCloseArea()
	dbSelectArea("SE5")
	dbSetOrder(1)
	If Empty(xFilial("SE5"))
		Exit
	Endif
	dbSelectArea("SM0")
	dbSkip()
	Loop
		
Enddo

SM0->(dbGoTo(nRegSM0))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

Return
