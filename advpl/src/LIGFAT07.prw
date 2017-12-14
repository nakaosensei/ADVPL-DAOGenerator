#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


User Function LIGFAT07()
Local oBrowse	  := Nil 
Local cFiltra := ""
Private aRotina := MenuDef()
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SZ5")//Seleciona o Alias que estamos trabalhando.
	oBrowse:SetDescription("Cadastro de Clientes")// "Descrição"
	oBrowse:SetFilterDefault(cFiltra)
	oBrowse:Activate()
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author ROBSON

@since 11/11/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

 
Local oStr1:= FWFormStruct(2, 'SZ5')
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FORM2' , oStr1,'FIELDSZ5' ) 
oView:CreateFolder( 'FOLDER1')
oView:AddSheet('FOLDER1','SHEET2','Cobranças Faturamento')
oView:CreateHorizontalBox( 'BOXFORM2', 100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET2')
oView:SetOwnerView('FORM2','BOXFORM2')


Return oView

Static Function MenuDef()
Local aRotina := {}
	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.LIGFAT07', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir' , 'VIEWDEF.LIGFAT07', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar' , 'VIEWDEF.LIGFAT07', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir' , 'VIEWDEF.LIGFAT07', 0, 5, 0, NIL } )
	aAdd( aRotina, { 'Imprimir' , 'VIEWDEF.LIGFAT07', 0, 8, 0, NIL } )
	aAdd( aRotina, { 'Copiar' , 'VIEWDEF.LIGFAT07', 0, 9, 0, NIL } )
Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author ROBSON

@since 11/11/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

 
Local oStr1:= FWFormStruct(1,'SZ5')
oModel := MPFormModel():New('MODELSZ5')
oModel:addFields('FIELDSZ5',,oStr1)
oModel:SetPrimaryKey({ 'Z5_FILIAL', 'Z5_CODCLI' })



Return oModel

