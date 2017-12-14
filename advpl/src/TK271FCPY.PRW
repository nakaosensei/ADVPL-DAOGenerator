#Include 'Protheus.ch'

User Function TK271FCPY()
Local _area := getarea()
Local _aSUA := SUA->(getarea())
Local _cSuaAnt := paramIXB[1]
Local _cSuaNov := paramIXB[2]
		 
dbselectarea("SUA")
	dbsetorder(1)
	if dbseek(xFilial() + _cSuaNov)
			RECLOCK("SUA",.F.)
				SUA->UA_UCCANT := _cSuaAnt
			MSUNLOCK()	
	ENDIF

restarea(_aSUA)
restarea(_area)
Return