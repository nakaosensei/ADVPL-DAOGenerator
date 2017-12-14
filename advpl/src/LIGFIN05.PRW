#Include 'Protheus.ch'
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³LIGFIN05  ºAUTOR  ³ROBSON ADRIANO      º DATA ³  21/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³VERIFICAR CONTAS A RECEBER EM ABERTO DO CLIENTE QUE FOR     º±±
±±º          ³PASSADO POR PARAMETRO					                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ LIG                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   



/*Parametros - _cliente,_loja 
	Retorna .T. SE O CLIENTE NAO TIVER CONTAS RECEBER EM ABERTO	
*/
User Function LIGFIN05(_pCodCli,_pLoja,_pNum)
Local	_NTotal := 0 

	IF SELECT("TSE1")!=0
		TSE1->(DBCLOSEAREA())
	ENDIF

	DbSelectArea("SE1")
		cQuery := "SELECT E1_OK, E1_STATUS, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_NOMCLI, E1_LOJA, E1_EMISSAO,"
		cQuery += " E1_VENCTO, E1_VALOR,E1_SALDO"
		cQuery += " FROM " + RetSqlName("SE1") + " SE1 "
		cQuery += " WHERE SE1.D_E_L_E_T_ = ' ' "
		cQuery += " AND SE1.E1_SALDO > 0 "
		cQuery += " AND SE1.E1_VENCREA < " + DTOS(DATE() + 30)
   		cQuery += " AND SE1.E1_CLIENTE = '" + _pCodCli + "'"
		cQuery += " AND SE1.E1_LOJA = '" + _pLoja + "'"
		cQuery += " AND SE1.E1_NUM = '" + _pNum + "'"
		cQuery += " ORDER BY SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_CLIENTE,SE1.E1_LOJA, SE1.E1_VENCTO"	
	TCQUERY cQuery NEW ALIAS "TSE1"
	DbSelectArea("TSE1")
	DBGOTOP()
	
	WHILE !EOF() 	
		_NTotal += TSE1->E1_SALDO 
		
		DbSelectArea("TSE1")
   		DBSKIP()
	ENDDO
	
	
	DBCLOSEAREA("TSE1")
	
Return ROUND(_NTotal,2) 
