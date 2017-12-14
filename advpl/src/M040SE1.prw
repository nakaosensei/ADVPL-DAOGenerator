#include "protheus.ch" 

User Function M040SE1

_a := 1

if _a==2
	if reclock("SE1",.F.)
	SE1->E1_PARCELA := "2"
	msunlock()
	endif
endif

return