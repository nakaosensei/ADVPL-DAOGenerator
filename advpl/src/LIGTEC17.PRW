#include 'protheus.ch'
#include 'parmtype.ch'
#include "TOPCONN.CH"
#include "XMLXFUN.CH"
#include "TBICONN.CH"

/*
Verificar se o cliente nCod
possui uma base de atendimento
Ou seja, verificar se ele está
cadastrado na tabela AA3

*Exemplo da memória: Alert(M->AB1_CODCLI)
*/

user function LIGTEC17(nCod, nLoja)
	//Dados para inserção
	aCab040:={}// Cabecalho do AA3Local 
	aItens:={} 
	lRet:=.T.   
	dData:=dDataBase
	lMsErroAuto:=.F.
	
	//Buscar no Banco de dados
	DbSelectArea("AA3")
	DbSetOrder(8) //AA3_FILIAL + AA3_CODCLI + AA3_LOJA
	DbGoTop()
	
	IF !dbSeek(xFilial("AA3") + nCod + nLoja)
		//Alert("Cliente não possui base de atendimento")
		
		//Pegar serie
		dbselectarea("SX6")
		dbsetorder(1)
		dbseek("    "+"MV_ATBSSEQ")
		nNumser := SOMA1(ALLTRIM(SX6->X6_CONTEUD))
		       
		reclock("SX6",.F.)
		SX6->X6_CONTEUD := nNumser
		msunlock()
		nNumser := alltrim(GETMV("MV_ATBSPRF"))+nNumser
		
		RECLOCK("AA3", .T.)
			AA3->AA3_FILIAL	:=xFilial("AA3")
			AA3->AA3_CODCLI	:=nCod
			AA3->AA3_LOJA	:=nLoja
			AA3->AA3_CODPRO	:="990006"
			AA3->AA3_NUMSER	:=nNumser
			AA3->AA3_DTVEND	:=dData
		MSUNLOCK()
		
		/*Aadd(aCab040, { "AA3_CODCLI", nCod, NIL } )
		Aadd(aCab040, { "AA3_LOJA", nLoja, NIL } )
		Aadd(aCab040, { "AA3_CODPRO", "990006", NIL } )
		Aadd(aCab040, { "AA3_NUMSER", nNumser , NIL } )
		Aadd(aCab040, { "AA3_DTVEND", dData, NIL } )*/
		
		//AB2->AB2_CODPRO:=AA3_CODPRO
		//M->AB2_CODPRO:=AA3_CODPRO
			
		/*TECA040(, aCab040, aItens, 3)                
		If lMsErroAuto                               
			lRet:=!lMsErroAuto
			Alert("Erro!")                
		Endif                                                                               
		aCab040 := {}*/
				
	ENDIF 

return " "
