#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOPCONN.CH"

user function FILTRAAA7()
	Local _area := getarea()
	Private aLinhas := {}
	cQuery := " SELECT * FROM "+RetSqlName("AA7")+" WHERE AA7_CODPRO = "+AA3->AA3_CODPRO
	TCQUERY cQuery NEW ALIAS "TEMP"
	dbselectarea("TEMP")
	while !eof() .AND. len(aLinhas) == 0
		aadd(aLinhas,{AA7_CODPRO})
		dbselectarea("TEMP")
		dbskip()
	enddo
	TEMP->(dbclosearea())
	restarea(_area)

	if len(aLinhas) >= 1
		Set Filter to AA7->AA7_CODPRO==AA3->AA3_CODPRO
	endif

return (.T.)