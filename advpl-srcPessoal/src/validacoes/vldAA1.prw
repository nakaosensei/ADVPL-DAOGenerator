#include 'protheus.ch'
#include 'parmtype.ch'

/*
A fun��o vldAB9Atd() apenas valida o codigo de um atendente, 
� verificado se o mesmo existe no banco, caso exista, retorna .T., se nao
.F., esta inclusa no atributo do campo de valida��o do usuario em AB9_CODTEC
*/
user function vldAB9Atd()
	dbSelectArea("AA1")	
	dbSetOrder(1)	
return ExistCpo("AA1") 