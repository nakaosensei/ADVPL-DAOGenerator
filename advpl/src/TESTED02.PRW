#include "topconn.ch"
#include "protheus.ch"

User Function TESTED02()

wfprepenv("01","LG01")

cQuery := " SELECT AB6_UNUMCT FROM "+RetSqlName("AB6")+" AB6 WHERE AB6.D_E_L_E_T_=' ' "
cQuery += " AND AB6_UNUMCT<>' ' AND NOT EXISTS ( "
cQuery += " SELECT * FROM "+RetSqlName("SZ2")+" WHERE D_E_L_E_T_=' ' AND Z2_NUMOS=AB6_NUMOS) "
cQuery += " AND AB6_EMISSA>='20161220' AND AB6_UCODAT<>' ' "
cQuery += " ORDER BY AB6_FILIAL,AB6_NUMOS "
TCQUERY cQuery NEW ALIAS "TEMP"

dbselectarea("TEMP")
while !eof()                 
	
	
	dbselectarea("TEMP")
	dbskip()
enddo
TEMP->(dbclosearea())
	
	dbselectarea("ADB")
	dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
	if dbseek(xFilial()+TEMP->AB6_UNUMCT)
	     while !eof() .and. ADB->ADB_FILIAL+ADB->ADB_NUMCTR==xFilial()+TEMP->AB6_UNUMCT

			RECLOCK("SZ2",.T.)
			SZ2->Z2_FILIAL  := xFilial()
			SZ2->Z2_NUMATEN := TEMP->AB6_UCODAT
			SZ2->Z2_NUMCTR  := TEMP->AB6_UNUMCT
			SZ2->Z2_ITEMCTR := ADB->ADB_ITEM
			SZ2->Z2_NUMOS   := TEMP->AB6_NUMOS
			SZ2->Z2_PRODUTO := ADB->ADB_CODPRO
			SZ2->Z2_ITEMOS  := 
			SZ2->Z2_ACAO    := aDados[J,15]
			MSUNLOCK() 
	
	     
		DBSELECTAREA("ADB")
		DBSKIP()
	ENDIF

return
