#include 'protheus.ch'
#include 'parmtype.ch'

/*
MSC1110D: Antes da apresentaçao da dialog de exclusão 
da SC possibilita validar a solicitação posicionada 
para continuar e executar a exclusão ou não.
*/
user function MSC1110D()
	Local lExclui := U_LIGCOM02()
	
	IF lExclui = .F.
		MsgInfo("Usuário não possui permissão para exclusão")
	ENDIF
	
return lExclui