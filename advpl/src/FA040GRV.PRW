User function FA040GRV

_a := 1

if _a==2
	if reclock("SE1",.F.)
	SE1->E1_PARCELA := "2"
	msunlock()
	endif
endif

return