#Include 'Protheus.ch'

/*
mBrwADA2  - Programa para monstrar contratos que já foram liberados pelo financeiro e aguardam liberacao do equipamento
Autor      - Robson Adriano
Data       - 15/10/14

*/
User Function mBrwADA2()
Local cFiltra := "ADA_FILIAL == '"+xFilial('ADA')+"' .And. ADA_ULIBER == 'S' .And. ADA_ULIBEQ == 'N'"

Private cAlias := "ADA"
PRIVATE cCadastro := "Cadastro de Parceria"	
PRIVATE aRotina     := {}
Private aCORES := {}
Private aIndexSA1 := {}



AADD(aRotina, { "Liberar Equipamento",    "U_LIGTEC09"   , 0, 3 })
 
Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSA1,@cFiltra) } 
 
dbSelectArea(cAlias)
dbSetOrder(1)

Eval(bFiltraBrw)

mBrowse(6, 1, 22, 75, cAlias,,,,,,)
Return

