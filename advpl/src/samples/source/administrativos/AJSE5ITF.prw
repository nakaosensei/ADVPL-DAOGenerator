#INCLUDE "AJSE5ITF.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJSE5ITF  บAutor  ณMarcello Gabriel    บFecha ณ 11/08/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza os registros de lancamentos de ITF para que sejam บฑฑ
ฑฑบ          ณ considerados no extrato bancario.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro - Peru                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AjSE5ITF()
	Local aScrRes	:= {}
	Local oPnlBotoes
	Local oPnlTopo
	Local oPnlEsq
	Local oPnlDir
	Local oSep1

	Private lProcessar := .F.
	Private oDlgITF
	Private oFonte14
	Private oPnlPrin
	Private oSayMsg
	Private oBtnSair
	Private oBtnAtual

	#IFNDEF TOP
		MsgStop(STR0001 + ".") //"Esta atualiza็ใo ้ disponibilizada somente para ambientes TopConnect"
	#ELSE
		oFonte14 := TFont():New("Arial",10,20,,.T.,,,,.F.,,,,,,,)
		aScrRes := MsAdvSize(.F.,.F.,400)
		cMsg := STR0002 + "." + CRLF + CRLF //"Este programa farแ os ajustes no movimento bancแrio referente aos lan็amentos de ITF"
		cMsg += STR0003 + "." + CRLF + CRLF//"Este ajustes sใo necessแrios para que esses lan็amentos sejam incluํdos no extrato bancแrio"
		cMsg += STR0019 + "." + CRLF + CRLF + CRLF + CRLF 		//"Antes de executar este programa, fa็a uma c๓pia da base de dados"
		cMsg += STR0004 //"Deseja continuar com sua execu็ใo?"
		oDlgITF := TDialog():New(0,0,200,500,STR0005 + " ITF",,,,,,,,,.T.,,,,,) //"Movimento bancแrio"
			oPnlEsq := TPanel():New(01,01,,oDlgITF,,,,,,5,5,.F.,.F.)
				oPnlEsq:Align := CONTROL_ALIGN_LEFT
				oPnlEsq:nWidth := 10
			oPnlDir := TPanel():New(01,01,,oDlgITF,,,,,,5,5,.F.,.F.)
				oPnlDir:Align := CONTROL_ALIGN_RIGHT
				oPnlDir:nWidth := 10
			oPnlTopo := TPanel():New(01,01,,oDlgITF,,,,,,5,30,.F.,.F.)
				oPnlTopo:Align := CONTROL_ALIGN_TOP
				oPnlTopo:nHeight := 10
			oPnlBotoes := TPanel():New(01,01,,oDlgITF,,,,,,5,30,.F.,.F.)
				oPnlBotoes:Align := CONTROL_ALIGN_BOTTOM
				oPnlBotoes:nHeight := 20
				oBtnSair := TButton():New(0,0,STR0006,oPnlBotoes,{|| oDlgITF:End()},30,10,,,,.T.,,STR0007,,,,)  //"Nใo"###"Encerra a execu็ใo do programa"
					oBtnSair:Align := CONTROL_ALIGN_RIGHT
				oSep1 := TPanel():New(01,01,,oPnlBotoes,,,,,,3,30,.F.,.F.)
					oSep1:Align := CONTROL_ALIGN_RIGHT
				oBtnAtual := TButton():New(0,0,STR0008,oPnlBotoes,{|| AjustaSE5()},30,10,,,,.T.,,STR0009,,,,) //"Sim"###"Atualiza o movimento bancแrio"
					oBtnAtual:Align := CONTROL_ALIGN_RIGHT
			oPnlPrin := TPanel():New(01,01,,oDlgITF,,,,,,5,5,.F.,.F.)
				oPnlPrin:Align := CONTROL_ALIGN_ALLCLIENT
				oSayMsg := TSay():New(0,0,{|| cMsg},oPnlPrin,,,,,,.T.,,,10,10)
					oSayMsg:Align := CONTROL_ALIGN_TOP
					oSayMsg:nHeight := 150
			oDlgITF:lCentered := .T.
		oDlgITF:Activate()
	#ENDIF
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASE5 บAutor  ณMarcello Gabriel    บFecha ณ 11/08/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz os ajustes nos lancamentos referentes a ITF            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro - Peru                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSE5()
	Local cQuery	:= ""
	Local cWhere	:= ""
	Local cAliasSE5	:= ""
	Local nReg		:= 0
	Local nTotReg	:= 0
	Local oMeter
	
	oBtnSair:Free()
	oBtnAtual:cCaption := STR0011  		//"Interromper"
	oBtnAtual:cMsg := STR0007			//"Encerra a execu็ใo do programa"
	oBtnAtual:cToolTip := STR0007		//"Encerra a execu็ใo do programa"
	oBtnAtual:bAction := {|| lProcessar := .F.}
	cWhere := " where E5_FILIAL = '" + xFilial("SE5") + "'"
	cWhere += " and E5_HISTOR = 'ITF'"
	cWhere += " and E5_DTDISPO = '" + Space(TamSX3("E5_DTDISPO")[1]) + "'"
	cWhere += " and E5_PROCTRA <> '" +  Space(TamSX3("E5_PROCTRA")[1]) + "'"
	cWhere += " and D_E_L_E_T_=''"
	/**/
	cMsg := STR0012 + "." //"Verificando a base de dados"
	oSayMsg:Refresh()
	cAliasSE5 := GetNextAlias()
	cQuery := "select count(*) registros from " + RetSqlName("SE5")
	cAliasSE5 := GetNextAlias()
	cQuery := ChangeQuery(cQuery + cWhere)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE5,.T.,.T.)
	nTotReg := (cAliasSE5)->registros
	DbSelectArea(cAliasSE5)
	DbCloseArea()
	/**/
	If nTotReg > 0
		cMsg := STR0013 + "." //"Selecionando os registros a serem alterados"
		oSayMsg:Refresh()
		cQuery := "select R_E_C_N_O_ REGSE5 from " + RetSqlName("SE5")
		cAliasSE5 := GetNextAlias()
		cQuery := ChangeQuery(cQuery + cWhere)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE5,.T.,.T.)
		DbSelectArea(cAliasSE5)
		DbGoTop()
		oMeter := TMeter():New(0,0,,100,oPnlPrin,10,10,,.T.,,,,,,,,)
			oMeter:Align := CONTROL_ALIGN_TOP
		cMsg := STR0014 + "." //"Atualizando a base"
		oSayMsg:Refresh()
		nReg := 0
		lProcessar := .T.
		Begin Transaction
			While lProcessar .And. !((cAliasSE5)->(Eof()))
				SE5->(DbGoTo((cAliasSE5)->REGSE5))
				RecLock("SE5",.F.)
				Replace SE5->E5_DTDISPO	With SE5->E5_DTDIGIT
				SE5->(MsUnLock())
				(cAliasSE5)->(DbSkip())
				nReg++
				oMeter:Set(nReg / nTotReg * 100)
			Enddo
			If !lProcessar
				DisarmTrans()
			Endif
		End Transaction
		DbSelectArea(cAliasSE5)
		DbCloseArea()
		If lProcessar
			cMsg := STR0015 + "." //"Atualiza็ใo encerrada"
		Else
			cMsg := STR0016 + "." //"Opera็ใo cancelada"
		Endif
		oSayMsg:Refresh()
	Else
		cMsg := STR0015 + "." + CRLF + CRLF	//"Atualiza็ใo encerrada"
		cMsg += STR0017 + "."	//"Nใo hแ lan็amentos referentes a ITF que necessitem de ajustes"
		oSayMsg:Refresh()
	Endif
	oBtnAtual:cCaption := STR0018 //"Encerrar"
	oBtnAtual:bAction := {|| oDlgITF:End()}
Return()