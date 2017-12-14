#include 'protheus.ch'
#include 'parmtype.ch'

user function AB9TRCDCL(numOSF)
	Local numOS := SubStr( numOSF, 1, 6 ) 	
	dbSelectArea("AB6")
	dbSetOrder(1)
	if(dbSeek(xFilial("AB6")+numOS))
		return AB6->AB6_CODCLI
	endif		
return