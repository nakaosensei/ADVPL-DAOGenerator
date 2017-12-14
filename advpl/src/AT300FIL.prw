#Include 'Protheus.ch'

User Function AT300FIL()
Local cFiltra := ""
IF __CUSERID$GETMV("MV_UCHINTR")
	cFiltra := "AB1_ATEND = '" + UPPER(SUBSTR(CUSUARIO,7,15)) + "'"
ENDIF

Return cFiltra

