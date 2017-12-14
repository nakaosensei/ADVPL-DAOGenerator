#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User function SF2460I()
Local _area := getarea()
Local _aSE1 := SE1->(getarea())
Local _aSA1 := SA1->(getarea())

dbselectarea("SA1")
dbsetorder(1)
if dbseek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
	dbselectarea("SE1")
	dbsetorder(2)
	if dbseek(xfilial()+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DUPL)
		while !eof() .and. SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DUPL == SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM
			IF SE1->E1_PREFIXO=='XY1' //WORKAROUND PRO PROBLEMA DE CHAVE UNICA NO SE1. VIDE P.E. M4601DUP
				_cCliente := SF2->F2_CLIENTE
				_cNum := SF2->F2_DOC
				cQuery := " SELECT MAX(E1_PARCELA) AS PARCELA FROM "+RetSqlName("SE1")+" SE1 "
				cQuery += " WHERE D_E_L_E_T_=' ' AND E1_CLIENTE='"+_cCliente+"' AND E1_NUM='"+_cNum+"' "
				TCQUERY cQuery NEW ALIAS "TEMP"
				dbselectarea("TEMP")
				if !eof()
					cParc := SOMA1(TEMP->PARCELA)
					cParc := SOMA1(cParc)
					If reclock("SE1",.F.)
						SE1->E1_PARCELA := cParc
						SE1->E1_PREFIXO := "G1C"
						msunlock()
					endif
				endif
				TEMP->(dbclosearea())
			ENDIF
			dbselectarea("SE1")
			dbskip()
		Enddo
	endif
endif
restarea(_aSA1)
restarea(_aSE1)
restarea(_area)
RETURN