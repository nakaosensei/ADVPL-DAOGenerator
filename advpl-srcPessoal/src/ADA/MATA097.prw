#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TOTVS.CH"
#Include "IMPIRPF.CH"
#INCLUDE "MATA097.CH"

/*
±±³Fun‡…o    ³A097Libera³ Autor ³ Edson Maricate        ³ Data ³15.10.1998³±±
±±³Descri‡…o ³ Programa de Liberacao de Pedidos de Compra.                ³±±
±±³Sintaxe e ³ Void A096Inclui(ExpC1,ExpN1)                               ³±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±³ Uso      ³ Generico                                                   ³±±
*/

user function A097Libera(cAlias,nReg, nOpcx)
	Local nSaldo,nOpc,nSavOrd := IndexOrd()
	Local cTipoLim  := ""
	Local CRoeda    := ""
	Local nMoeda	 := 1
	Local aRetSaldo :={}
	Local cAprov    := ""
	Local lAprov    :=.F.
	Local cObs 		 := CriaVar("CR_OBS")
	Local ca097User := RetCodUsr()
	Local cCodLiber := SCR->CR_APROV
	Local dRefer 	 := dDataBase
	Local nSalDif	 := 0,cName
	Local oBtn1,oBtn2,oBtn3,oDlg
	Local nTotal    := 0
	Local aArea		 := GetArea()
	Local cSavColor := ""
	Local cGrupo	 := ""
	Local lMta097   := ExistBlock("MTA097")
	Local lLiberou	 := .F.
	Local cDocto    := SCR->CR_NUM
	Local cTipo     := SCR->CR_TIPO
	Local lLibOk    := .F.
	PRIVATE bFilSCRBrw := {|| Nil}
	
	If ExistBlock("MT097LIB")
		ExecBlock("MT097LIB",.F.,.F.)
	EndIf
	
	If ExistBlock("MT097LOK")
		If !ExecBlock("MT097LOK",.F.,.F.)
			Return
		EndIf
	EndIf
	
	If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
		Help(" ",1,"A097LIB")  //Aviso(STR0038,STR0039,{STR0037},2) //"Atencao!"###"Este pedido ja foi liberado anteriormente. Somente os pedidos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados."###"Voltar"
		Return .T.
	EndIf
	
	dbSelectArea("SAL")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa as variaveis utilizadas no Display.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRetSaldo := MaSalAlc(cCodLiber,dRefer)
	nSaldo 	 := aRetSaldo[1]
	CRoeda 	 := A097Moeda(aRetSaldo[2])
	cName  	 := UsrRetName(ca097User)
	nTotal   := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
	Do Case
		Case SAK->AK_TIPO == "D"
			cTipoLim :=OemToAnsi(STR0007) // "Diario"
		Case  SAK->AK_TIPO == "S"
			cTipoLim := OemToAnsi(STR0008) //"Semanal"
		Case  SAK->AK_TIPO == "M"
			cTipoLim := OemToAnsi(STR0009) //"Mensal"
		Case  SAK->AK_TIPO == "A"
		//	cTipoLim := OemToAnsi(STR0064) //"Anual"
		EndCase
	
	If SCR->CR_TIPO == "NF"
		dbSelectArea("SF1")
		dbSetOrder(1)
		dbSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE)))
		cGrupo := SF1->F1_APROV
	Else
		dbSelectArea("SC7")
		dbSetOrder(1)
		dbSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
		cGrupo := SC7->C7_APROV
	EndIf
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
	dbSelectArea("SAL")
	dbSetOrder(3)
	dbSeek(xFilial()+SC7->C7_APROV+SAK->AK_COD)
	If SAL->AL_LIBAPR != "A"
		lAprov := .T.
		cAprov := OemToAnsi(STR0010) // "VISTO / LIVRE"
	EndIf
	
	nSalDif := nSaldo - IIF(lAprov,0,nTotal)
	If (nSalDif) < 0
		Help(" ",1,"A097SALDO") //Aviso(STR0040,STR0041,{STR0037},2) //"Saldo Insuficiente"###"Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."###"Voltar"
		Return
	EndIf
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 370,410 TITLE OemToAnsi(STR0011) PIXEL  //"Liberacao do PC"
		@ 0.5,01 TO 44,204 LABEL "" OF oDlg PIXEL
		@ 45,01  TO 160,204 LABEL "" OF oDlg PIXEL
		@ 07,06  Say OemToAnsi(STR0012) OF oDlg PIXEL //"Numero do Pedido "
		@ 07,120 Say OemToAnsi(STR0013) OF oDlg SIZE 50,9 PIXEL //"Emissao "
		@ 19,06  Say OemToAnsi(STR0014) OF oDlg PIXEL //"Fonecedor "
		@ 31,06  Say OemToAnsi(STR0015) OF oDlg PIXEL SIZE 30,9 //"Aprovador "
		@ 31,120 Say OemToAnsi(STR0016) SIZE 60,9 OF oDlg PIXEL  //"Data de ref.  "
		@ 53,06  Say OemToAnsi(STR0017) +CRoeda OF oDlg PIXEL //"Limite min.  "
		@ 53,110 Say OemToAnsi(STR0018)+CRoeda SIZE 60,9 OF oDlg PIXEL //"Limite max. "
		@ 65,06  Say OemToAnsi(STR0019)+CRoeda  OF oDlg PIXEL //"Limite  "
		@ 65,110 Say OemToAnsi(STR0020) OF oDlg PIXEL //"Tipo lim."
		@ 77,06  Say OemToAnsi(STR0021)+CRoeda OF oDlg PIXEL //"Saldo na data  "
		@ 89,06  Say OemToAnsi(STR0022)+CRoeda OF oDlg PIXEL //"Total do pedido  "
		@ 101,06 Say OemToAnsi(STR0023) +CRoeda SIZE 130,10 OF oDlg PIXEL //"Saldo disponivel apos liberacao  "
		@ 113,06 Say OemToAnsi(STR0033) SIZE 100,10 OF oDlg PIXEL //"Observa‡äes "
		@ 07,58  MSGET SCR->CR_NUM     When .F. SIZE 28 ,9 OF oDlg PIXEL
		@ 07,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45 ,9 OF oDlg PIXEL
		@ 19,45  MSGET SA2->A2_NOME    When .F. SIZE 155,9 OF oDlg PIXEL
		@ 31,45  MSGET cName           When .F. SIZE 50 ,9 OF oDlg PIXEL
		@ 31,155 MSGET dRefer          When .F. SIZE 45 ,9 OF oDlg PIXEL
		@ 53,50  MSGET SAK->AK_LIMMIN Picture "@E 999,999,999.99" When .F. SIZE 55,9 OF oDlg PIXEL RIGHT
		@ 53,155 MSGET SAK->AK_LIMMAX Picture "@E 999,999,999.99" When .F. SIZE 45,9 OF oDlg PIXEL RIGHT
		@ 65,50  MSGET SAK->AK_LIMITE Picture "@E 999,999,999.99" When .F. SIZE 55,9 OF oDlg PIXEL RIGHT
		@ 65,155 MSGET cTipoLim When .F. SIZE 45,9 OF oDlg PIXEL CENTERED
		@ 77,115 MSGET nSaldo Picture "@E 999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		If lAprov
			@ 89,115 MSGET cAprov Picture "@!" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		Else
			@ 89,115 MSGET nTotal Picture "@E 999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		EndIf     
		@ 101,115 MSGET nSalDif Picture "@E 999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	//	@ 113,115 MSGET cObs Picture "@!" SIZE 85,45 OF oDlg PIXEL
		@ 113,55 GET OMEMO VAR cObs MEMO SIZE 145,45 PIXEL OF oDlg 
		
	
	If ExistBlock("MT097BUT")
	//	@ 132,39 BUTTON OemToAnsi(STR0063) SIZE 40 ,11  FONT oDlg:oFont ACTION (ExecBlock("MT097BUT",.F.,.F.))  OF oDlg PIXEL
	Endif	
	
		@ 165, 80 BUTTON OemToAnsi(STR0024) SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End())  OF oDlg PIXEL
		@ 165,121 BUTTON OemToAnsi(STR0025) SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL
		@ 165,162 BUTTON OemToAnsi(STR0026) SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED
	If nOpc == 2 .Or. nOpc == 3
		IF len(cObs)>=250
			MessageBox("O Campo Observação suporta ate 250 caracteres, então o mesmo sera reduzido!","ATENÇÃO",48)
			cObs := LEFT(cObs,250)
		ENDIF

	    SCR->(dbClearFilter())
	    SCR->(dbGoTo(nReg))
		lLibOk := IIf( SCR->CR_TIPO == "NF",A097Lock(Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE)),SCR->CR_TIPO),A097Lock(Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)),SCR->CR_TIPO) )
		If lLibOk
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoIniLan("000055")
			Begin Transaction
				If lMta097 .And. nOpc == 2
				   If ExecBlock("MTA097",.F.,.F.)
						Processa({|lEnd| lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dDataBase,If(nOpc==2,4,6))})
				   EndIf
				Else
					Processa({|lEnd| lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dDataBase,If(nOpc==2,4,6))})
				EndIf
				If lLiberou
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					PcoDetLan("000055","02","MATA097")
					
					If SCR->CR_TIPO == "NF"
						dbSelectArea("SF1")
						Reclock("SF1",.F.)
						SF1->F1_STATUS := If(SF1->F1_STATUS=="B"," ",SF1->F1_STATUS)
						MsUnlock()
					Else
						If SuperGetMv("MV_EASY")=="S" .AND. SC7->(FieldPos("C7_PO_EIC"))<>0 .And. !Empty(SC7->C7_PO_EIC)
							If SW2->(dbSeek(xFilial("SW2")+SC7->C7_PO_EIC)) .AND. SW2->(FieldPos("W2_CONAPRO"))<>0 .AND. !Empty(SW2->W2_CONAPRO)
								Reclock("SW2",.F.)
								SW2->W2_CONAPRO := "L"
								MsUnlock()
							EndIf
						EndIf
						dbSelectArea("SC7")
						While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial()+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							PcoDetLan("000055","01","MATA097")
							Reclock("SC7",.F.)
							SC7->C7_CONAPRO := "L"
							MsUnlock()
							dbSkip()
						EndDo
					EndIf
				EndIf
			End Transaction
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoFinLan("000055")
		Else
			Help(" ",1,"A097LOCK")
			SC7->(MsUnlockAll())
		Endif
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
	                         
	#IFDEF TOP 
		If TcSrvType() == "AS/400" 
			set filter to  &(cXFiltraSCR)
		Else	
	#ENDIF 
//			SCR->(Eval(bFilSCRBrw))
	#IFDEF TOP
		EndIf 		
	#ENDIF 
			
	dbSelectArea("SC7")
	
	If ExistBlock("MT097END")
		ExecBlock("MT097END",.F.,.F.,{cDocto,cTipo,nOpc})
	EndIf
	
	RestArea(aArea)
Return .T.
