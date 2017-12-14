#include 'protheus.ch'
#include 'parmtype.ch'

user function AT300VLD()
	nOpcao := ParamIxb[1]
	if(nOpcao = 1)
		u_LIGCAB1()
	endif	
return .T.