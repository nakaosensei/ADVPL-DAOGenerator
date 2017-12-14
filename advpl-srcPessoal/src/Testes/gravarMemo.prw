#include 'protheus.ch'
#include 'parmtype.ch'

user function gravarMemo()
	COBSLRD := "LAUDO TESTE NAKAO"
	chave = MSMM(,35,,COBSLRD,1,,,"SUA","UA_CODOBS")
	MsgAlert("RESULTADO")
	MsgAlert(chave)
return