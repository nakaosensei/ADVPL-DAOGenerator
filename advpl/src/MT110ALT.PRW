#include 'protheus.ch'
#include 'parmtype.ch'

/*
Valida o registro posicionado
da solicitação de compra
*/
user function MT110ALT()
	Local lExecuta :=  .F.
	
	_cUser := ALLTRIM(UsrRetName(RetCodUsr())) 
	
	IF  U_LIGCOM02() .OR. ALLTRIM(SC1->C1_SOLICIT) == _cUser
		lExecuta :=  .T.
	ELSE
		MsgInfo("Usuário não possui permissão para alterar ou excluir")
	ENDIF
	
return lExecuta