#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#include "rwmake.ch"
#INCLUDE "TOTVS.CH"


user function AB6AB7_MVC()
Local oBrowse	  := Nil 
Local cFiltra := ""

Private aRotina := MenuDef()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("AB6")//Seleciona o Alias que estamos trabalhando.
oBrowse:SetDescription("Cadastro de Clientes")// "Descrição"
oBrowse:SetFilterDefault(cFiltra)

//oBrowse:AddLegend( "AB6_UVALAT==' '", "YELLOW", "Aguardando" )
//oBrowse:AddLegend( "AB6_UVALAT=='1'", "GREEN", "Conforme" )
//oBrowse:AddLegend( "AB6_UVALAT=='2'", "RED" , "Não Conforme" )

// Remove os botões de navegação na edição ou visualização do model
//oBrowse:SetUseCursor(.F.)
oBrowse:Activate()	
return

Static Function MenuDef() 
Local aRotina       := {}
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.AB6AB7_MVC' OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina Title 'Incluir' Action 'VIEWDEF.AB6AB7_MVC' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar' Action 'VIEWDEF.AB6AB7_MVC' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir' Action 'VIEWDEF.AB6AB7_MVC' OPERATION 5 ACCESS 0
	ADD OPTION aRotina Title 'Imprimir' Action 'VIEWDEF.AB6AB7_MVC' OPERATION 8 ACCESS 0
	//ADD OPTION aRotina Title 'TESTE' Action 'U_AGASA101' OPERATION 9 ACCESS 0
Return aRotina

Static Function ModelDef()
Local oModel
Local oStr1:= FWFormStruct(1,'AB6')
Local oStr2:= FWFormStruct(1,'AB7')

oModel := MPFormModel():New('MODAB6AB7', /*bPreValidacao*/, /*{ | oModel | AGASA101( oModel ) } */, /*{ | oMdl | MVC001C( oMdl ) }*/ ,, /*bCancel*/ )

oStr2:RemoveField( 'AB7_MEMO1' )
oStr2:RemoveField( 'AB7_MEMO2' )
oStr2:RemoveField( 'AB7_MEMO3' )
oStr2:RemoveField( 'AB7_MEMO4' )

oStr1:SetProperty('*' , MODEL_FIELD_NOUPD, .T.)

oStr2:SetProperty('AB7_TIPO' , MODEL_FIELD_NOUPD, .T.)
oStr2:SetProperty('AB7_CODPRO' , MODEL_FIELD_NOUPD, .T.)
oStr2:SetProperty('AB7_NUMSER' , MODEL_FIELD_NOUPD, .T.)
oStr2:SetProperty('AB7_CODPRB' , MODEL_FIELD_NOUPD, .T.)

oModel:addFields('FIELD1',,oStr1)
oModel:AddGrid( 'AB7DETAIL1', 'FIELD1', oStr2 )

oModel:SetRelation( 'AB7DETAIL1', { { 'AB7_FILIAL', 'xFilial( "AB7" )' }, { 'AB7_NUMOS', 'AB6_NUMOS' } }, AB7->( IndexKey( 1 ) ) )

Return oModel

Static Function ViewDef()
Local oView
Local oModel := ModelDef()
Local oStr1:= FWFormStruct(2, 'AB6')
Local oStr2:= FWFormStruct(2, 'AB7')

oStr2:RemoveField( 'AB7_MEMO1' )
oStr2:RemoveField( 'AB7_MEMO2' )
oStr2:RemoveField( 'AB7_MEMO3' )
oStr2:RemoveField( 'AB7_MEMO4' )
oStr2:RemoveField( 'AB7_NUMHDE' )
oStr2:RemoveField( 'AB7_CODCON' )

//oModelZA2:SetVldActivate( { |oModel| COMP011ACT( oModelZA2 ) } )

oView := FWFormView():New()
oView:SetModel(oModel)


oView:AddField('FORM1' , oStr1,'FIELD1' ) 
oView:AddGrid( 'TABLE1', oStr2, 'AB7DETAIL1' )

oView:CreateHorizontalBox( 'BOXFORM1', 40)
//oView:CreateHorizontalBox( 'BOXFORM1', 70,,, 'PASTAS', 'SHEET1')
oView:CreateHorizontalBox( 'BOXTABLE1', 60)
//oView:CreateHorizontalBox( 'BOXTABLE1', 30,,, 'PASTAS2', 'SHEET2')

oView:SetOwnerView('FORM1','BOXFORM1')
oView:SetOwnerView('TABLE1','BOXTABLE1')

//oView:SetViewAction( 'BUTTONOK' ,{ |oView| AGASA101( oView ) } )
Return oView
