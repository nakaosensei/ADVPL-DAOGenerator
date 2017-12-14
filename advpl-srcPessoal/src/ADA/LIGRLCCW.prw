#include 'protheus.ch'
#include 'parmtype.ch'

user function LIGRLCCW()
	LOCAL aCores := {}
	PRIVATE cAlias := 'ADA'
	PRIVATE cCadastro := "Relatório de contratos para cancelar"
	PRIVATE aRotina := {{"Env.Emails","U_helloWorld()",0,1}}   	
	cFiltro  := "ADA_FILIAL == '"+xFilial('ADA')+"' .And. ADA_ULIBER == 'S' .And. ADA_UCANCE == '1'"// .AND. ADA_MSBLQL <> '1'" 
	mBrowse( ,,,,"ADA",,,,,,aCores,,,,,,,,cFiltro)
return