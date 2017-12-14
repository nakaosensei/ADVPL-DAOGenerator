#include 'protheus.ch'
#include 'parmtype.ch'
/*
@author: nakao
A função vldSB1() apenas valida o codigo de um produto, 
é verificado se o mesmo existe no banco(SB1), caso exista, retorna .T., se nao
.F., esta inclusa no atributo do campo de validação do usuario em AB7_CODPRO
*/
user function vldSB1()	
	dbSelectArea("SB1")	
	dbSetOrder(1) //Filial+cod
	if(dbSeek(xFilial("SB1")+ALLTRIM(M->AB7_CODPRO)))
		return .t.
	else
		return .f.
	endif			  
return .T.