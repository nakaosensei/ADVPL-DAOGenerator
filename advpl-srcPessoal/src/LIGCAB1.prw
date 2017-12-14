#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
/*
	Author: @nakaosensei
	A function abaixo(LIGINCAB1()) foi criada para a utilização do ponto 
	de entrada AT300INC, que permite a inclusão de eventos após o cadastro
	de um chamado técnico, a proposta inicial foi cadastrar uma base de atendimento automaticamente
	para que o chamado possa ser realizado quando não houver uma para aquele
	atendimento. Mas posteriormente mais códigos podem ser inseridos
*/
user function LIGCAB1() //Evento do cadastro de AB1
	dbSelectArea("AB1")	
	numSer=GetSXENum("AA3","AA3_NUMSER")
	RollBackSx8()
	hasBase := u_NkEBA(AB1->AB1_CODCLI,AB1->AB1_LOJA,"010003",numSer,xFilial("AA3"))
	MsgAlert(hasBase)
	MsgAlert("Chamado "+AB1->AB1_NRCHAM)
	/*if(hasBase = .F.)
		u_GrBaseA(AB1->AB1_CODCLI,AB1->AB1_LOJA,"010003",numSer,AB1->AB1_EMISSA,xFilial("AA3"))
	endif*/	
	dbCloseArea()
return

user function NkEBA(codCli,loja,codPro,nSerie,filial) //Essa função verifica se existe uma base de atendimento para um chamado técnico
 	dbSelectArea("AA3")
	dbSetOrder(1)		// FILIAL+CODCLI+LOJA+CODPRO+NUMERO SERIE
	dbSeek(xFilial("AA3") + filial + codCli + loja + codPro + nSerie)     // Busca exata 
	if FOUND() 
		return .T.
	else
		return .F.
	endif
return

user function GrBaseA(codCli,loja,codPro,nSerie,dataVnd,filial) //Gera uma base de atendimento
	Local bases   := {}	
	Local itens := {} 	
	Local lRet := .T.   
	Local nILocal 
	BEGIN TRANSACTION	
		PRIVATE lMsErroAuto := .F.
		PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "TEC" TABLES "AA3","AA4","SXB"
		aAdd(bases, { "AA3_FILIAL" , filial, NIL } )
		aAdd(bases, { "AA3_CODCLI" , codCli, NIL } )
		aAdd(bases, { "AA3_LOJA", loja, NIL } ) 
		aAdd(bases, { "AA3_CODPRO", codPro, NIL } )
		aAdd(bases, { "AA3_NUMSER", nSerie  , NIL } )
		aAdd(bases, { "AA3_DTVEN", dataVnd, NIL } )
		TECA040(,bases,itens,3)
		If lMsErroAuto
			ConOut("Erro na inclusao!")
			mostraerro("\logerro\")
			MOSTRAERRO()
		Endif	
	END TRANSACTION
return
