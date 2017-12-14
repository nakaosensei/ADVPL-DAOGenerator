#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³LIGCAD01  ºAUTOR  ³CASSIUS CARLOS      º DATA ³  14/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³DEFINE O CODIGO DOS CLIENTES							      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ LIG                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION LIGCAD01()
Local _area := GETAREA()
Local _aSA1 := SA1->(getarea())
Local lRet  := .t. 

IF INCLUI
	dbselectarea("SA1")
	dbsetorder(3)
	if dbseek(xFilial()+M->A1_CGC) .AND. M->A1_PESSOA $ "FJ" .AND. M->A1_CGC==SA1->A1_CGC
		alert("Ja existe cliente com esse CNPJ/CPF")
		lRet := .f.
	else
			IF M->A1_PESSOA == "J" .AND. !EMPTY(M->A1_CGC)
				M->A1_COD  := SUBSTR(M->A1_CGC,1,9)
				M->A1_LOJA := SUBSTR(M->A1_CGC,10,3)
			ELSEIF M->A1_PESSOA == "F" .AND. !EMPTY(M->A1_CGC)
				M->A1_COD  := SUBSTR(M->A1_CGC,1,9)
				M->A1_LOJA := "001"
			ELSEIF EMPTY(M->A1_CGC)
				DBSELECTAREA("SA1")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SA1")+"999999999",.T.)
				DBSKIP(-1)
				IF SUBSTR(SA1->A1_COD,1,5)=="99999"
					M->A1_COD  := "99999"+STRZERO(VAL(SUBSTR(SA1->A1_COD,6,4))+1,4)
					M->A1_LOJA := "001"
				ELSE
					M->A1_COD  := "999990001"
					M->A1_LOJA := "001"
				ENDIF
			ENDIF
		ENDIF
endif	
restarea(_aSA1)
restarea(_area)
RETURN lRet
