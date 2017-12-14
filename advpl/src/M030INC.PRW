#include 'protheus.ch'
#include 'parmtype.ch'

user function M030INC()
	If (PARAMIXB <> 3)
		//MsgAlert("In")
		u_LIGCSA1()
		//MsgAlert("Out")
	endif
return