#include 'protheus.ch'
#include 'parmtype.ch'

/*
Valida a alteração e
exclusão de um pedido 
de compra
*/
User Function MT120ALT()
	Local lExecuta :=  .T.
	IF Paramixb[1] == 4 .OR.  Paramixb[1] == 5
		lExecuta :=  U_LIGCOM02()
	
		IF !lExecuta
	   		MsgInfo("Usuário não possui permissão para alterar ou excluir")
		ENDIF
	ENDIF

Return lExecuta