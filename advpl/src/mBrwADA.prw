#include "protheus.ch"
 
USER FUNCTION mBrwADA()

Private cAlias := "ADA"
 
PRIVATE cCadastro := "Cadastro de Parceria"	
PRIVATE aRotina     := {}
Private aCORES := {}       

AADD(aRotina, { "Ver linhas",    "U_LIGCAL08"   , 0, 3 })
AADD(aRotina, { "Pesquisar", "AxPesqui", 0, 1 })
AADD(aRotina, { "Visualizar", "U_VisualADB"  , 0, 2 })
AADD(aRotina, { "Legenda",    "U_LIGLEGEN"   , 0, 3 })
AADD(aRotina, { "Solic. Cancelamento",    "U_MBADA3B"   , 0, 3 })

AAdd(aCORES, {"ADA_ULIBER == 'N '", "BR_BRANCO"} )
AAdd(aCORES, {"ADA_ULIBER == 'S'", "BR_VERDE"  } )
AAdd(aCORES, {"ADA_ULIBER == 'R'", "BR_AMARELO"} )
 
dbSelectArea(cAlias)
dbSetOrder(1)
 
mBrowse(6, 1, 22, 75, cAlias,,,,,,aCORES)
 
RETURN NIL  

User Function LIGLEGEN()
Local aLeg 		:= {}
Aadd(aLeg,{"BR_BRANCO"   , OemToAnsi( "Sem vinculo")})
Aadd(aLeg,{"BR_VERDE"   , OemToAnsi( "Aprovado")})
Aadd(aLeg,{"BR_AMARELO"   , OemToAnsi( "Reprovado")})
BrwLegenda( cCadastro   , "Legendas",aLeg)
Return(Nil)

//Visualizar____________________________________________________________________________________________________

User Function VisualADB(cAlias,nReg,nOpcx)

Local aArea     := GetArea()
Local aStruADB  := {}
Local aSize     := {}
Local aObjects  := {}
Local aInfo     := {}
Local aPosGet   := {}
Local aPosObj   := {}
Local aRegADB   := {}
Local nX        := 0
Local nUsado    := 0
Local nGetLin   := 0
Local nOpcA     := 0
Local nSaveSx8  := GetSx8Len()
Local cQuery    := ""
Local cAliasADB := "ADB"
Local cAliasADA := "ADA"
Local cStatus	:= ""
Local lQuery    := .F.
Local lAlter    := .F.
Local lCopia    := (aRotina[nOpcX][4]==6 .And. nOpcX == 6)
Local lVisual   := aRotina[nOpcX][4]==2
Local lEncerra	  := (aRotina[nOpcX][4]==6 .And. nOpcX == 7)
Local lContinua := .T.                              
Local lCanDel   := (SuperGetMv("MV_DELCTR",.F.,"2") == "2")
Local lDeleta   := .T.
Local lEncerOk	:= .F.
Local oDlg
Local oGetD
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
Local lParcial 	:= .F.
Local lNewCont 	:= .F.
Local lFt400VCP := ExistBlock("FT400VCP")

PRIVATE aTELA[0][0]
PRIVATE aGETS[0]
PRIVATE aHeader := {}
PRIVATE aCols   := {}
PRIVATE N       := 1


If lEncerra .And. (cAliasADA)->ADA_STATUS <> "C"  //Verifica se o status do contrato permite o encerramento.
	Help(" ",1,"FT400NAOEN")              //Somente contratos com o status "C" Parcialmente Entregue
	lContinua := .F.                      
EndIf

If !lVisual
	If !SoftLock("ADA")
		lContinua := .F.
	EndIf
EndIf

If lCanDel .And. nOpcx == 5

	#IFDEF TOP	
	
		cAliasSC6 := "SC6QRY"		
	
		cQuery := "SELECT COUNT(*) CONTRATO FROM "
		cQuery += RetSqlName("SC6") + " SC6 "
		cQuery += "WHERE "
		cQuery += "SC6.C6_FILIAL  = '" + xFilial("SC6") + "' AND "
		cQuery += "SC6.C6_CONTRAT = '" + ADA->ADA_NUMCTR + "' AND "
		cQuery += "SC6.D_E_L_E_T_ = ' ' "		
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC6,.T.,.T.)

		If 	(cAliasSC6)->CONTRATO > 0
			Help(" ",1,"NODELETA")
			lContinua := .F.
			lDeleta   := .F.
		Endif

		dbSelectArea(cAliasSC6)
		dbCloseArea()
		dbSelectArea("SC6")
	
	#ELSE
		cArqInd:=	CriaTrab(,.F.)
		dbSelectArea("SC6")
		IndRegua("SC6",cArqInd,"C6_FILIAL+C6_CONTRAT")
		nIndex := RetIndex("SC6")
		dbSetIndex(cArqInd+OrdBagExt())
		dbSetOrder(nIndex+1)
		dbGotop()

		If SC6->(MsSeek(xFilial("SC6")+ADA->ADA_NUMCTR))
			Help(" ",1,"NODELETA")
			lContinua := .F.						
			lDeleta := .F.
		Endif

		RetIndex("SC6")
		FErase(cArqInd+OrdBagExt())
		
	#ENDIF	

	
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Encerramento do Contrato de Parceria                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
ADB->(DbSetOrder(1))
ADB->(MsSeek(xFilial("ADB")+ADA->ADA_NUMCTR) )
While !Eof() .And. ADB->ADB_NUMCTR == ADA->ADA_NUMCTR
	If (cAliasADB)->ADB_QTDEMP > 0 .And. ((cAliasADB)->ADB_QTDEMP <= (cAliasADB)->ADB_QUANT)
		lParcial := .T.
		Exit
	EndIf
	ADB->(dbSkip())
EndDo

If lEncerra .And. ADA->ADA_STATUS == "C"  .And. lParcial
	lEncerOk := .T.
	If MsgYesNo("STR0034"+" "+(cAliasADA)->ADA_NUMCTR+"."+" ";
				+"STR0035"+" ";
				+"STR0036")
		lCopia := .T.
		lContinua := .T.
		lNewCont  := .T.
	Else
		If MsgYesNo("STR0037"+" "+(cAliasADA)->ADA_NUMCTR+" "+"STR0038")
			lContinua := .F.
		Else 
			lContinua := .F.
			lEncerOk := .F.			
		EndIf
	EndIf
EndIf
				

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Inicializa os dados da Enchoice                                       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
RegToMemory( "ADA", .F., .T. )
If lCopia
	M->ADA_NUMCTR := ADA->ADA_NUMCTR //CriaVar("ADA_NUMCTR",.T.)
	M->ADA_EMISSA := dDataBase
	M->ADA_NOMCLI := Posicione("SA1",1,xFilial("SA1")+M->ADA_CODCLI+M->ADA_LOJCLI,"A1_NOME")
EndIf
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Montagem do aheader                                                   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("ADB")
While !Eof() .And. SX3->X3_ARQUIVO=="ADB"
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
		nUsado++
		Aadd(aHeader,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE ,;
			SX3->X3_TAMANHO ,;
			SX3->X3_DECIMAL ,;
			SX3->X3_VALID	,;
			SX3->X3_USADO	,;
			SX3->X3_TIPO	,;
			SX3->X3_ARQUIVO ,;
			SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Montagem do acols                                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
dbSelectArea("ADB")
dbSetOrder(1)
#IFDEF TOP
	If aScan(aHeader,{|x| x[8] == "M"})==0
		lQuery    := .T.
		aStruADB  := ADB->(dbStruct())
		cAliasADB := "ADB"

		cQuery := "SELECT ADB.*,ADB.R_E_C_N_O_ ADBRECNO "
		cQuery += "FROM "+RetSqlName("ADB")+" ADB "
		cQuery += "WHERE ADB.ADB_FILIAL='"+xFilial("ADB")+"' AND "
		cQuery += "ADB.ADB_NUMCTR='"+ADA->ADA_NUMCTR+"' AND "
		cQuery += "ADB.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY "+SqlOrder(ADB->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

		dbSelectArea("ADB")
		dbCloseArea()

		dbUseArea(.T.,cAliasADB,TcGenQry(,,cQuery),cAliasADB,.T.,.T.)

		For nX := 1 To Len(aStruADB)
			If aStruADB[nX][2]<>"C"
				TcSetField(cAliasADB,aStruADB[nX][1],aStruADB[nX][2],aStruADB[nX][3],aStruADB[nX][4])
			EndIf
		Next nX
	Else
#ENDIF
	MsSeek(xFilial("ADB")+ADA->ADA_NUMCTR)
	#IFDEF TOP
	EndIf
	#ENDIF
While !Eof() .And. (cAliasADB)->ADB_FILIAL == xFilial("ADB") .And.;
	(cAliasADB)->ADB_NUMCTR == ADA->ADA_NUMCTR 
	If (!lEncerra) .Or. ( lEncerra .And. (cAliasADB)->(FieldGet(FieldPos("ADB_QUANT"))) - (cAliasADB)->(FieldGet(FieldPos("ADB_QTDEMP"))) > 0)
		aadd(aCOLS,Array(nUsado+1))
		For nX := 1 To nUsado
			If aHeader[nX][10]=="V"
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
			Else      
				If lEncerra .And. AllTrim(aHeader[nX][2]) == "ADB_QUANT"
					aCols[Len(aCols)][GdFieldPos("ADB_QUANT")] := (cAliasADB)->(FieldGet(FieldPos(aHeader[nX][2]))) - (cAliasADB)->(FieldGet(FieldPos("ADB_QTDEMP")))
				ElseIf lEncerra .And. AllTrim(aHeader[nX][2]) == "ADB_ITEM"	// Renumera itens caso algum item ja tenha sido entregue totalmente e nao e apresentado no aCols.
					aCols[Len(aCols)][nX] := StrZero(Len(aCols),TamSx3("ADB_ITEM")[1])
				Else
					aCols[Len(aCols)][nX] := (cAliasADB)->(FieldGet(FieldPos(aHeader[nX][2])))
				EndIf
			EndIf
		Next nX 
		If lEncerra
			aCols[Len(aCols)][GdFieldPos("ADB_TOTAL")] := (cAliasADB)->(FieldGet(FieldPos("ADB_PRCVEN"))) * ((cAliasADB)->(FieldGet(FieldPos("ADB_QUANT"))) - (cAliasADB)->(FieldGet(FieldPos("ADB_QTDEMP"))))	
		EndIf
	
		aCOLS[Len(aCols)][nUsado+1] := .F.
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		//� Calculo do tamanho dos objetos                                        �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		If lVisual .Or. lCopia .Or. ((cAliasADB)->ADB_QTDEMP < (cAliasADB)->ADB_QUANT .And. Empty((cAliasADB)->ADB_PEDCOB))
			lAlter := .T.
		EndIf
		aadd(aRegADB,IIf(lQuery,(cAliasADB)->ADBRECNO,ADB->(RecNo())))
	EndIf
	dbSelectArea(cAliasADB)
	dbSkip()
EndDo

If lFt400VCP
	Execblock("FT400VCP",.F.,.F.,{nOpcx,lNewCont})
Endif

If lQuery
	dbSelectArea(cAliasADB)
	dbCloseArea()
	ChkFile("ADB",.F.)
EndIf
lContinua := lAlter .And. lContinua

cStatus := (cAliasADA)->ADA_STATUS
If cStatus == "C" .And. nOpcx == 4
	Help(" ",1,"FT400NAOAL")
	lContinua := .F.
EndIf

If cStatus == "E" .And. nOpcx == 4
	Help(" ",1,"FT400NAOAE")
	lContinua := .F.
EndIf

If lContinua
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Calculo do tamanho dos objetos                                        �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{160,200,240,265}} )
	nGetLin := aPosObj[3,1]

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	EnChoice( "ADA", nReg, nOpcX, , , , , aPosObj[1],,3,,,,,,.T.)
	@ nGetLin,aPosGet[1,1]  SAY OemToAnsi("Total:")				SIZE 020,09 OF oDlg	PIXEL //"Total :"
	@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR 0 PICTURE TM(0,16,2)		SIZE 040,09 OF oDlg PIXEL
	@ nGetLin,aPosGet[1,3]  SAY OemToAnsi("Desc:")				SIZE 020,09 OF oDlg PIXEL //"Desc. :"
	@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,2)		SIZE 040,09 OF oDlg	PIXEL	
	@ nGetLin+10,aPosGet[1,3]  SAY OemToAnsi("=")					SIZE 020,09 OF oDlg PIXEL
	@ nGetLin+10,aPosGet[1,4]  SAY oSAY3 VAR 0						SIZE 040,09 PICTURE TM(0,16,2) OF oDlg PIXEL
	oDlg:Cargo	:= {|n1,n2,n3| oSay1:SetText(n1),oSay2:SetText(n2),oSay3:SetText(n3) }
	SetKey(VK_F4,{|| MaViewSB2(GdFieldGet("ADB_CODPRO",n))})
	oGetD:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcX,"Ft400LinOk","Ft400TudOk","+ADB_ITEM",!lVisual,,1,,300,"Ft400FldOk")
	PRIVATE oGetDad := oGetD
	Ft400Rodap(oGetD)
	ACTIVATE MSDIALOG oDlg ON INIT Ft400Bar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),If(!Obrigatorio(aGets,aTela),nOpcA:=0,oDlg:End()),nOpcA:=0)},{||oDlg:End()},nOpcX)
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Desabilita a Tecla F4                                        �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	SetKey(VK_F4,Nil)
	If nOpcA==1 .And. !lVisual
		Begin Transaction
			If Ft400Grava(IIf(aRotina[nOpcX][4]==5,3,2),IIf(!lCopia,aRegADB,Nil))
				EvalTrigger()
				While (GetSx8Len() > nSaveSx8)
					ConfirmSx8()
				EndDo
			EndIf
		    // Encerra o contrato e gera um novo contrato.
			If lEncerOk
				RecLock("ADA")
				cStatus := "E"
				(cAliasADA)->ADA_STATUS := cStatus
				MsUnLock()
			EndIf			
		End Transaction
	EndIf
Else
	If !lAlter .And. lDeleta
		Help(" ",1,"FT400TOEMP")
	EndIf
	Begin Transaction
	    // Encerra o contrato, mas nao gera um novo contrato.
		If lEncerOk
			RecLock("ADA")
			cStatus := "E"
			(cAliasADA)->ADA_STATUS := cStatus
			MsUnLock()
		EndIf
	End Transaction	
EndIf
While (GetSx8Len() > nSaveSx8)
	RollBackSx8()
EndDo
MsUnLockAll()
RestArea(aArea)
Return(.T.)
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    쿑t400Bar  � Autor � Eduardo Riera         � Data �24.06.2002낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � EnchoiceBar especifica do FATA400                          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   � Nenhum                                                     낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros� oDlg: 	Objeto Dialog                                     낢�
굇�          � bOk:  	Code Block para o Evento Ok                       낢�
굇�          � bCancel: Code Block para o Evento Cancel                   낢�
굇�          � nOpc:	nOpc transmitido pela mbrowse                     낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�   DATA   � Programador   쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇튗anna C.  |30/03/07|9.12  쿍ops 118469 - Alterado o nome dos Bitmaps   낢�
굇�        	 �        |      쿭efinidos pela Engenharia para o Protheus 10낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
Static Function Ft400Bar(oDlg,bOk,bCancel,nOpc)

Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

If ExistBlock("FT400BAR")
	aButtonUsr := ExecBlock("FT400BAR",.F.,.F.)
	If ValType(aButtonUsr) == "A"
		For nI   := 1  To  Len(aButtonUsr)
			Aadd(aButtons,aClone(aButtonUsr[nI]))
		Next nI
	EndIf
EndIf
Return(EnchoiceBar(oDlg,bOK,bcancel,,aButtons))