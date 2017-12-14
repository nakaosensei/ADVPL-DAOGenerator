#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*
INCLUSAO DE ITENS NO MENU DA ORDEM DE SERVI�O
*/

User Function TC450ROT()
Local aRotAdic:= {}
	aAdd(aRotAdic, { 'Imprimir','U_LIGTEC03', 0 , 2} )
	aAdd(aRotAdic, { 'Cliente','U_450ROTE()', 0 , 2} )
	aAdd(aRotAdic, { 'Atender','TECA460()', 0 , 3} )
	aAdd(aRotAdic, { 'Cancelar','U_450ROTB()', 0 , 3} )
	
	IF __CUSERID$GETMV("MV_UADMOSI")
		aAdd(aRotAdic, { 'Enviar Comercial','U_450ROTA()', 0 , 3} )
		aAdd(aRotAdic, { 'Liberar Ativa��o','U_450ROTC()', 0 , 3} )
	ENDIF
Return aRotAdic

//Enviar Contrato e Ordem servi�o para comercial Negociar
User function 450ROTA()
Local _area := getarea()
Local _aADA := ADA->(getarea())

//IF	AB6->AB6_STATUS = 'B'	
	dbselectarea("ADA")
	dbsetorder(1)
	if dbseek(xFilial() + AB6->AB6_UNUMCT)
	 	RECLOCK("ADA",.F.)
			ADA->ADA_UCANCE := '1'	
	 	MSUNLOCK()
	 
		dbselectarea("AB6")
		RECLOCK("AB6",.F.)
			AB6->AB6_STATUS := 'C'	
			AB6->AB6_USITU2 := '7'
		MSUNLOCK()
		 
		MSGINFO('Ordem de Servi�o foi enviada para Comercial ! Contrato : ' + ADA->ADA_NUMCTR)
	ELSE
		MSGINFO('N�o foi possivel localizar o Contrato, por favor verifique o Contrato que est� na Ordem de Servi�o !')
	endif
//ELSE
//	MSGINFO('Aten��o apenas Ordem de Servi�os atendidas podem ser enviadas para Negocia��o!')
//ENDIF

restarea(_aADA)
restarea(_area)
return

//Cancelar O.S 
User function 450ROTB()

Local _area := getarea()
IF u_LIGYNW("Cancelar OS","Deseja realmente Cancelar esta OS ?")

//IF	AB6->AB6_STATUS = 'B'	
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
			AB6->AB6_USITU2 := '7'
			AB6->AB6_MSG := ALLTRIM(AB6->AB6_MSG) + " - CANCELADA VIA OS"
	MSUNLOCK()
		 
	//DBSELECTAREA(SZ2) E DELETE
	//DBSELECTAREA(ADB) E DELETE
	/*
	dbselectarea("AB7")
	dbsetorder(1) //AB7_FILIAL+AB7_NUMOS+AB7_ITEM
	if dbseek(xFilial()+AB6->AB6_NUMOS)
		while !eof() .and. xFilial()+AB6->AB6_NUMOS==AB7->AB7_FILIAL+AB7->AB7_NUMOS
	
			dbselectarea("SZ2")
			dbsetorder(2)
			dbGoTop()
			
			//(xFilial()+ SZ2->Z2_NUMOS + SZ2->Z2_PRODUTO + SZ2->Z2_ITEMOS) 
			if dbseek(xFilial()+ AB6->AB6_NUMOS + AB7->AB7_CODPRO + AB7->AB7_ITEM)
		
				
				RecLock("SZ2", .F.)
					DBDELETE()
				MsUnLock()	
			
				dbselectarea("ADB")
				dbsetorder(1)
				dbGoTop()
				if dbseek(xFilial()+ SZ2->Z2_NUMCTR + SZ2->Z2_ITEMCTR)	
					
					RecLock("ADB", .F.)
						DBDELETE()
					MsUnLock()		
						
				endif
				
			endif
			dbselectarea("AB7")
			dbskip()
		enddo
	endif//if ab7
		 */
	MSGINFO('Ordem de Servi�o fechada, OS : ' + AB6->AB6_NUMOS)
//ELSE
//	MSGINFO('Ordem de Servi�o n�o tem atendimento !')
//ENDIF

ENDIF
restarea(_area)

return

User function 450ROTC()
Local _area := getarea()
Local _aAB6 := AB6->(getarea())  
Local _nCtr := AB6->AB6_UNUMCT
if msgyesno("Tem certeza de que deseja liberar os equipamentos? Fazendo isso ser�o disparadas as Ordens de Servi�o referentes aos itens de ativa��o.") 
	_cCaixa := ""
	_cSplitter := ""
	_cPorta := ""		
	_cMac := ""
	_cSerial := ""
				
	_aAB7 := AB7->(getarea())
	_aAA3 := AA3->(getarea()) 	 	
	DbSelectArea("AB7")
	DbSetOrder(1)//AB7_FILIAL+AB7_NUMOS
	if dbseek(xFilial()+AB6->AB6_NUMOS)					
		
		DbSelectArea("AA3")
		DbSetOrder(1)//AA3_FILIAL+AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER
		if dbseek(xFilial()+AB6->AB6_CODCLID+AB6->AB6_LOJA+AB7->AB7_CODPRO+AB7->AB7_NUMSER)
			_cCaixa 		:= 		AA3->AA3_UCAIXA
			_cSplitter 		:= 		AA3->AA3_USPLT
			_cPorta 		:= 		AA3->AA3_UPORTA
			_cMac 			:= 		AA3->AA3_UMAC
			_cSerial 		:= 		AA3->AA3_CHAPA
		endif
	endif
	restarea(_aAB7)
	restarea(_aAA3)
				
	_aADA := ADA->(getarea())  
	dbselectarea("ADA")
	dbsetorder(1)
	IF dbseek(xFilial("ADA")+ _nCtr)	
		cx := U_LIGTEC09(_cCaixa,_cSplitter,_cPorta,_cMac,_cSerial)
			
		ret := U_450ROTD(_nCtr)
			
		restarea(_aAB6)
		dbselectarea("AB6")
		IF ret
			RECLOCK("AB6",.F.)
				AB6->AB6_STATUS := "D"	
			MSUNLOCK()
				
			dbselectarea("ADA")
			RECLOCK("ADA",.F.)
				ADA->ADA_ULIBEQ := "S"
				ADA->ADA_UDTLBE := date()
			MSUNLOCK()
		ELSE
			RECLOCK("AB6",.F.)
				AB6->AB6_STATUS := "C"	
			MSUNLOCK()
		ENDIF
	ELSE
		ALERT('N�o foi possivel localizar o Contrato vinculado a essa Ordem de Servi�o, por favor verifique o Contrato que est� vinculado a O.S')
	ENDIF
	restarea(_aADA)	
ENDIF
				
restarea(_area)
return

//Validar se todos os Itens foram liberados para ativa��o
User Function 450ROTD(_nCtr)
Local _area := getarea()
Local _aADB := ADB->(getarea())  
Local ret := .T.

	dbselectarea("ADB")
	dbsetorder(1)
	if dbseek(xFilial()+ADA->ADA_NUMCTR)
		while !eof() .and. xFilial()+ADA->ADA_NUMCTR==ADB->ADB_FILIAL+ADB->ADB_NUMCTR		
			// VERIFICAR APENAS OS ADB QUE S�O ITENS DO CONTRATO (EX: INTERNET,TELEFONE, ASSINATURA)
			_cItemCtr := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + ADB->ADB_CODPRO, "B1_UITCONT")
			IF (_cItemCtr = 'S' .AND. ADB->ADB_ULIBEQ <> 'S')			
				RETURN .F.	
			ENDIF
				
			dbselectarea("ADB")
			dbskip()
		enddo
	endif
	
restarea(_aADB)	
restarea(_area)	
return ret

//Abrir 
User Function 450ROTE()
Local _area := getarea()
Local _aSA1 := SA1->(getarea())

dbselectarea("SA1")
dbsetorder(1)
if dbseek(xFilial()+AB6->AB6_CODCLI+AB6->AB6_LOJA  )
	FWExecView('Inclusao por FWExecView','AGBSA1_MVC', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
else
	ALERT('N�o foi possivel localizar o Cliente do Tele Vendas.')
endif	
	
restarea(_aSA1)
restarea(_area)	
return 