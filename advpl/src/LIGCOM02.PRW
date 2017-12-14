#include 'protheus.ch'
#include 'parmtype.ch'

/*
Ponto de entrada para validar usuário que 
realiza alteração/exclusão em solicitação de compras
Ponto de entrada para validar usuário que 
realiza alteração/exclusão em pedido de compras
AUTOR: Noemi Scherer
DATA: 24/02/17
*/


/*
Função responsável por veririficar
se o usuário logado
é o Rogério, leandro,
Gabriel ou Robson
*/
user function LIGCOM02()
	Local lModifca := .T.//Validações do usuario para continuar a exclusão da SC
	
	IF __CUSERID$GETMV("MV_UADMCOM")
		lModifca := .T.
	ELSE
		lModifca := .F.
	ENDIF
	
return lModifca