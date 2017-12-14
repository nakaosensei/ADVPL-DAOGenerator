#include "protheus.ch"
#include "topconn.ch"

USer Function LIGFIN14()
Local cRet := cRet

_A := 1

IF FUNNAME()=="" .OR. _A=="2"
	_cCliente := SF2->F2_CLIENTE
	_cNum := SF2->F2_DOC
	cQuery := " SELECT MAX(E1_PARCELA) AS PARCELA FROM "+RetSqlName("SE1")+" SE1 "
	cQuery += " WHERE D_E_L_E_T_=' ' AND E1_CLIENTE='"+_cCliente+"' AND E1_NUM='"+_cNum+"' "
	TCQUERY cQuery NEW ALIAS "TEMP"
	dbselectarea("TEMP")
	if !eof()
		cRet := SOMA1(TEMP->PARCELA)
	endif
	TEMP->(dbclosearea())
	
ENDIF

return cRet
