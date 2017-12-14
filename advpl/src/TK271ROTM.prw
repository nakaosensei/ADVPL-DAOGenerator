#INCLUDE 'PROTHEUS.CH
#INCLUDE "TOPCONN.CH"
/*
Este ponto de entrada permite a personalização de novas rotinas no browse inicial da rotina de atendimento Call Center.
É possível incluir no máximo duas novas rotinas customizadas.

-- Criada por Daniel (Totvs)
--Alterada por Johnny 04-04-2017

*/

User Function TK271ROTM()
	//Adiciona Rotina Customizada aos botoes do Browsea
	Local aRotina := {}
	aadd( aRotina, { 'Estorna Item' ,'U_ESTIT271', 0 , 7 })
Return aRotina

User Function ESTIT271()
	Local _area := getarea()
	Local _aSUA := SUA->(getarea())
	Local _aSUB := SUB->(getarea())
	Local _aSZ2 := SZ2->(getarea())
	private ONO 	   := LOADBITMAP( GETRESOURCES(), "LBNO"  )
	private OOK 	   := LOADBITMAP( GETRESOURCES(), "LBTIK" )
	private tpContrato := 'S' //tpContrato armazena (S ou N) fazendo referencia se o que foi selecionado esta Liberado ou não
	Private aLinhas := {} // array com o resultado do sql
	Private aButtons := {}
	PRIVATE NOPCA  := 0 // Controle de mensagem da listbox

	// Validação caso aponte para um registro que não existe
	// caso UDA_ULIBER retorno vazio
	tpContrato := POSICIONE("ADA",3,xFilial("ADA")+SUA->UA_NUM,"ADA_ULIBER")
	if tpContrato==''
		tpContrato := 'S'
	endif

	//SQL VERIFICA SE ESTA LIBERADO OU NÃO E RETORNA AS TABELAS ADB SUB para uma tabela temporaria TEMP
	if(tpContrato == 'N')
		cQuery := " SELECT ADB.*,SUB.* FROM "+RetSqlName("ADB")+" ADB,"+RetSqlName("ADA")+" ADA,"+RetSqlName("SUB")+" SUB,"+RetSqlName("SUA")+" SUA  "
		cQuery += " WHERE "
		cQuery += " ADB.ADB_NUMCTR = ADA.ADA_NUMCTR AND"
		cQuery += " ADA.ADA_UCALLC = SUA.UA_NUM AND"
		cQuery += " SUB.UB_NUM = SUA.UA_NUM AND"
		cQuery += " SUB.UB_PRODUTO = ADB.ADB_CODPRO AND"
		cQuery += " ADA.ADA_ULIBER ='N' AND"
		cQuery += " SUA.UA_NUM='" + SUA->UA_NUM + "' AND SUA.UA_FILIAL='" + xFilial('SUA') + "' "
		cQuery += " AND SUB.D_E_L_E_T_=' ' AND ADB.D_E_L_E_T_=' '"
		TCQUERY cQuery NEW ALIAS "TEMP"
		dbselectarea("TEMP")
		// preenchimento de array para alimentar a listbox e validações futuras
		while !eof()
			aadd(aLinhas,{.F.,ALLTRIM(TEMP->ADB_DESPRO),TEMP->ADB_QUANT,TEMP->UB_NUM,TEMP->UB_ITEM,TEMP->UB_PRODUTO,TEMP->ADB_NUMCTR,TEMP->ADB_ITEM})
			dbselectarea("TEMP")
			dbskip()
		enddo
		TEMP->(dbclosearea())

		//Criação de Tela, onde sera exibido os itens de ADB
		u_TK271Tel()

	else

		// condição Daniel
//		cQuery := " SELECT SZ2.*,B1_COD,B1_DESC,SUB.*,"
//		cQuery += " (SELECT T.Z2_ITEMOS FROM "+RetSqlName("SZ2")+" T WHERE T.Z2_NUMCTR = SZ2.Z2_NUMCTR AND T.Z2_NUMATEN = SZ2.Z2_NUMATEN AND T.Z2_ITEMCTR = SUB.UB_UITTROC AND T.D_E_L_E_T_=' ')  ITEM2"
//		cQuery += " FROM "+RetSqlName("SZ2")+" SZ2 "
//		cQUery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON Z2_PRODUTO=B1_COD "
//		cQuery += " INNER JOIN "+RetSqlName("AB7")+" AB7 ON Z2_NUMOS = AB7_NUMOS AND Z2_ITEMOS = AB7_ITEM"
//		cQuery += " INNER JOIN "+RetSqlName("ADB")+" ADB ON Z2_NUMCTR = ADB_NUMCTR AND Z2_PRODUTO = ADB_CODPRO AND Z2_ITEMCTR = ADB_ITEM"
//		cQuery += " INNER JOIN "+RetSqlName("SUB")+" SUB ON  Z2_NUMATEN = UB_NUM AND ADB_UNUMAT = UB_NUM AND ADB_UITATE = UB_ITEM"
//		cQuery += " WHERE Z2_NUMATEN='" + SUA->UA_NUM + "' AND Z2_FILIAL='" + xFilial('SZ2') + "' "
//		cQuery += " AND UB_UITTROC <> Z2_ITEMCTR "
//		cQuery += " AND ADB.ADB_UDTINI = ' ' AND ADB.ADB_UDTFIM = ' ' "
//		cQuery += " AND SZ2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' '  AND AB7.D_E_L_E_T_=' ' AND SUB.D_E_L_E_T_=' ' AND ADB.D_E_L_E_T_=' '"
//		cQuery += " ORDER BY UB_ITEM"

		cQuery := " SELECT SUA.*, SUB.*, SB1.*,ADA.*,ADB.*,AB7.*,SZ2.*, "
		cQuery += " (SELECT T.Z2_ITEMOS FROM "+RetSqlName("SZ2")+" T WHERE T.Z2_NUMCTR = ADB.ADB_NUMCTR AND T.Z2_ITEMCTR = SUB.UB_UITTROC AND T.D_E_L_E_T_=' ')  ITEM2
		cQuery += " FROM "+RetSqlName("SUA")+" SUA
		cQuery += " INNER JOIN "+RetSqlName("SUB")+" SUB ON UA_FILIAL=UB_FILIAL AND UA_NUM=UB_NUM
		cQuery += " INNER JOIN "+RetSqlName("ADB")+" ADB ON ADB.ADB_UNUMAT=SUB.UB_NUM AND ADB.ADB_UITATE = SUB.UB_ITEM
		cQuery += " INNER JOIN "+RetSqlName("ADA")+" ADA ON ADB.ADB_NUMCTR=ADA.ADA_NUMCTR
		cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON ADB.ADB_CODPRO = SB1.B1_COD
		cQuery += " INNER JOIN "+RetSqlName("SZ2")+" SZ2 ON ADB.ADB_NUMCTR = SZ2.Z2_NUMCTR AND ADB.ADB_ITEM = SZ2.Z2_ITEMOS
		cQuery += " INNER JOIN "+RetSqlName("AB7")+" AB7 ON SZ2.Z2_NUMOS = AB7.AB7_NUMOS AND SZ2.Z2_ITEMOS = AB7.AB7_ITEM
		cQuery += " WHERE SUA.D_E_L_E_T_=' ' AND SUB.D_E_L_E_T_=' ' AND ADB.D_E_L_E_T_=' ' AND ADA.D_E_L_E_T_=' '  AND SB1.D_E_L_E_T_= ' '
		cQuery += " AND UA_NUM = '" + SUA->UA_NUM + "' AND UA_FILIAL='" + xFilial('SUA') + "' "
		cQuery += " ORDER BY UB_ITEM"

		TCQUERY cQuery NEW ALIAS "TEMP"
		dbselectarea("TEMP")
		while !eof()
			aadd(aLinhas,{.F.,TEMP->B1_DESC,ALLTRIM(TEMP->Z2_PRODUTO),SUBSTR(TEMP->B1_COD,1,30),TEMP->Z2_NUMOS,TEMP->Z2_ITEMOS,TEMP->Z2_NUMCTR,TEMP->Z2_ITEMCTR,TEMP->ITEM2,TEMP->UB_UITTROC,TEMP->Z2_NUMATEN,TEMP->UB_ITEM})
			dbselectarea("TEMP")
			dbskip()
		enddo
		TEMP->(dbclosearea())

		//Criação de Tela, onde sera exibido os itens de ADB
		u_TK271Tel()

	endif

	// Restaura um ambiente salvo anteriormente pela função GETAREA()
	restarea(_aSZ2)
	restarea(_aSUB)
	restarea(_aSUA)
	restarea(_area)
RETURN

/*
Garanti Validações da tela, afim de minimizar erros do usuario
AUTOR: Johnny
Data modificação: 04/04/2017
*/
User Function TK271Valid()
	// 1- Garantir que não excute caso haja apenas 1 registro
	if len(aLinhas) <= 1
		alert("deve existir mais 1 registro para excutar esta ação !")
		NOPCA := 0
	else
		// 2- Garantir que não excute caso estiver tudo selecionado ou tudo desmarcado
		// OBS: aLinhas é o Array com o resultado do SQL
		// Caso aLinhas[i,1] = Falso, o capo da grid esta desmarcado
		// Então se cCont = 0, todos registro estão selecionados
		// Se cCont = tamanho de array, todos registros estão desmarcados
		// SOMENTE SERA DELETADO SE :
		// -- cCont >0 e tamanho do array for maior que cCont
		// -- Ter ao menos um registro marcado e ter mais que um item a lista
		cCont := 0
		for i:=1 to len(aLinhas)
			if aLinhas[i,1] == .F.
				cCont += 1
			endif
		endfor
		if cCont == 0
			alert("Você não pode excluir todos registros de uma vez !")
			NOPCA := 0
		endif
		if cCont == len(aLinhas)
			alert("Você deve selecionar ao menos 1 registro !")
			NOPCA := 0
		endif

		// 3- Deletar seleção
		if cCont > 0 .AND. len(aLinhas) > cCont
			NOPCA := MessageBox("Deseja realmente excluir este registro ?","Atenção !",4)
		endif
		//LEGENDA
		//NOPCA -> 6 = SIM, NOPCA -> 7 = NÃO, NOPCA -> 0 FECHAR
		if NOPCA == 6
			if tpContrato == 'N'
				//Chama a função que realiza o Delete sem (N) vigencia
				u_TK271TND()
			else
				//Chama a função que realiza o Delete com (S) vigencia
				u_TK271TSD()
			endif
			//Fecha a Tela, após a execução
			ODLGA:END()
		endif
	endif
return

/*
Delete de itens da SUB e ADB, Caso venda ainda não esteja em vigencia.
SUB -> ITENS DA VENDA
ADB -> ITENS DO CONTRATO
TND -- Tipo N Deleta, sem vigencia
AUTOR: Johnny
Data modificação: 04/04/2017
*/
User Function TK271TND()
	BEGIN TRANSACTION
		if reclock("SUA",.F.)
			for i:=1 to len(aLinhas)
				if aLinhas[i,1] == .T.
					dbselectarea("SUB")
					dbsetorder(1)
					//filial + UB_NUM + UB_ITEM + UB_PRODUTO
					if dbseek(xFilial()+aLinhas[i,4]+aLinhas[i,5]+aLinhas[i,6])
						if reclock("SUB",.F.)
							dbdelete()
							msunlock()
						else
							msginfo("Registro esta em uso. Nao sera possivel prosseguir.")
							DisarmTransaction()
						endif
					endif
					dbselectarea("ADB")
					dbsetorder(1)
					//filial + ABD_NUMCTR+ ABD_ITEM
					if dbseek(xFilial()+aLinhas[i,7]+aLinhas[i,8])
						if reclock("ADB",.F.)
							dbdelete()
							msunlock()
						else
							msginfo("Registro esta em uso. Nao sera possivel prosseguir.")
							DisarmTransaction()
						endif
					endif
				endif
			endfor
		else
			msginfo("Registro em uso. Nao sera possivel prosseguir.")
			DisarmTransaction()
		endif
	END TRANSACTION

return

/*
Delete de itens da SUB e ADB, Caso venda ainda não esteja em vigencia.
SUB -> ITENS DA VENDA
ADB -> ITENS DO CONTRATO
AB7 -> ITENS DA OS
SZ2 -> Z2_NUMCTR+Z2_ITEMCTR
TSD -- Tipo S Deleta, itens com vigencia
AUTOR: Johnny
Data modificação: 04/04/2017
*/
User Function TK271TSD()
	BEGIN TRANSACTION
		if reclock("SUA",.F.)
			for i:=1 to len(aLinhas)
				if aLinhas[i,1]
					dbselectarea("AB7")
					dbsetorder(1)
					//				TEMP->Z2_NUMOS,TEMP->Z2_ITEMOS
					if dbseek(xFilial()+aLinhas[i,5]+aLinhas[i,6])
						if !(AB7->AB7_TIPO $ "45")
							if reclock("AB7",.F.)
								dbdelete()
								msunlock()
								if dbseek(xFilial()+aLinhas[i,5]+aLinhas[i,9])
									reclock("AB7",.F.)
									dbdelete()
									msunlock()
								endif

							else
								msginfo("Registro "+cvaltochar(AB7->(RECNO()))+" da tabela AB7 esta em uso. Nao sera possivel prosseguir.")
								DisarmTransaction()
							endif
							dbselectarea("ADB")
							dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
							if dbseek(xFilial()+aLinhas[i,7]+aLinhas[i,8])
								IF reclock("ADB",.F.)
									dbdelete()
									msunlock()
								ELSE
									msginfo("Registro "+cvaltochar(ADB->(RECNO()))+" da tabela ADB esta em uso. Nao sera possivel prosseguir.")
									DisarmTransaction()
								ENDIF
							endif
							dbselectarea("SZ2")
							dbsetorder(1)//Z2_FILIAL+Z2_NUMCTR+Z2_ITEMCTR
							if dbseek(xFilial()+aLinhas[i,7]+aLinhas[i,8])
								IF reclock("SZ2",.F.)
									dbdelete()
									msunlock()
									if dbseek(xFilial()+aLinhas[i,7]+aLinhas[i,10])
										reclock("SZ2",.F.)
										dbdelete()
										msunlock()
									endif
								ELSE
									msginfo("Registro "+cvaltochar(SZ2->(RECNO()))+" da tabela SZ2 esta em uso. Nao sera possivel prosseguir.")
									DisarmTransaction()
								ENDIF
							endif
							dbselectarea("SUB")
							dbsetorder(1)
							//filial + UB_NUM + UB_ITEM + UB_PRODUTO
							if dbseek(xFilial()+aLinhas[i,11]+aLinhas[i,12]+aLinhas[i,3])
								if reclock("SUB",.F.)
									dbdelete()
									msunlock()
								else
									msginfo("Registro esta em uso. Nao sera possivel prosseguir.")
									DisarmTransaction()
								endif
							endif
						else
							alert("Item "+aLinhas[i,4]+" da OS "+aLinhas[i,5]+" ja foi atendido/encerrado.")
						endif
					endif
				endif
			next
		else
			msginfo("Registro "+cvaltochar(SUA->(RECNO()))+" da tabela SUA esta em uso. Nao sera possivel prosseguir.")
			DisarmTransaction()
		endif
	END TRANSACTION
return

/*
Criar Tela para listar os Itens
AUTOR: Johnny
Data modificação: 04/04/2017
*/
User Function TK271Tel()
	if len(aLinhas)>0
		DEFINE MSDIALOG ODLGA TITLE OEMTOANSI("SELECIONE OS PRODUTOS") FROM 0,0 TO 24,150 OF OMAINWND
		@ 1,0 LISTBOX OLBXA VAR CITBX FIELDS HEADER " ","PRODUTO" SIZE 595,152 ON DBLCLICK (ALINHAS[OLBXA:NAT,1]:=!ALINHAS[OLBXA:NAT,1],OLBXA:REFRESH())
		OLBXA:SETARRAY(ALINHAS)
		OLBXA:BLINE := {|| {IF(ALINHAS[OLBXA:NAT,1],OOK,ONO),ALINHAS[OLBXA:NAT,2],ALINHAS[OLBXA:NAT,2]}}
		OLBXA:bHEADERCLICK := {|A,B,C| Invert(a,b,@aLinhas) }

		aadd(aButtons,{"SDUORDER",{|| Invert(oLBXA,00,@aLinhas)},OemToAnsi( "Desmarcar Todos" ),OemtoAnsi( "Desmarcar Todos" )})
		aadd(aButtons,{"SDUORDER",{|| Invert(oLBXA,99,@aLinhas)},OemToAnsi( "Marcar Todos" ),OemtoAnsi( "Marcar Todos" )})

		ACTIVATE MSDIALOG ODLGA CENTER ON INIT ENCHOICEBAR(ODLGA,{|| U_TK271Valid()},{|| ,ODLGA:END()},,ABUTTONS)

	else
		msginfo("Nao existem itens pra estornar.")
	endif
return