#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function AGBSA1_MVC()
Local oBrowse	  := Nil 
Local cFiltra := ""

Private aRotina := MenuDef()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SA1")//Seleciona o Alias que estamos trabalhando.
oBrowse:SetDescription("Cadastro de Clientes")// "Descrição"
oBrowse:SetFilterDefault(cFiltra)

//oBrowse:AddLegend( "AB6_UVALAT==' '", "YELLOW", "Aguardando" )
//oBrowse:AddLegend( "AB6_UVALAT=='1'", "GREEN", "Conforme" )
//oBrowse:AddLegend( "AB6_UVALAT=='2'", "RED" , "Não Conforme" )

// Remove os botões de navegação na edição ou visualização do model
//oBrowse:SetUseCursor(.F.)
oBrowse:Activate()

Return

Static Function MenuDef() 
Local aRotina       := {}
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.AGBSA1_MVC' OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina Title 'Incluir' Action 'VIEWDEF.AGBSA1_MVC' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar' Action 'VIEWDEF.AGBSA1_MVC' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir' Action 'VIEWDEF.AGBSA1_MVC' OPERATION 5 ACCESS 0
	ADD OPTION aRotina Title 'Imprimir' Action 'VIEWDEF.AGBSA1_MVC' OPERATION 8 ACCESS 0
	ADD OPTION aRotina Title 'Numeros Livres' Action 'VIEWDEF.AGBSA1_MVC' OPERATION 8 ACCESS 0
	//ADD OPTION aRotina Title 'TESTE' Action 'U_AGASA101' OPERATION 9 ACCESS 0
Return aRotina
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author ROBSON

@since 24/07/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()
Local oStr1:= FWFormStruct(2, 'SA1')
Local oStr2:= FWFormStruct(2, 'AGB')
Local oStr3:= FWFormStruct(2, 'AGA')

oStr2:RemoveField( 'AGB_CODIGO' )
oStr2:RemoveField( 'AGB_ENTIDA' )
oStr2:RemoveField( 'AGB_CODENT' )

oStr3:RemoveField( 'AGA_CODIGO' )
oStr3:RemoveField( 'AGA_ENTIDA' )
oStr3:RemoveField( 'AGA_CODENT' )

oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FORM4' , oStr1,'FIELD1' )
oView:AddGrid('FORM6' , oStr2,'AGBDETAIL')
oView:AddGrid('FORM8' , oStr3,'AGADETAIL')   

oView:CreateFolder( 'FOLDER1')
oView:AddSheet('FOLDER1','SHEET2','Dados Cadastrais')
oView:CreateHorizontalBox( 'BOXFORM4', 50, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET2')
oView:SetOwnerView('FORM4','BOXFORM4')
oView:CreateHorizontalBox( 'BOX4', 50, /*owner*/, .F., 'FOLDER1', 'SHEET2')
oView:CreateFolder( 'FOLDER2', 	'BOX4' )
oView:AddSheet('FOLDER2','SHEET7','Endereço')
oView:AddSheet('FOLDER2','SHEET6','Telefones')
oView:CreateHorizontalBox( 'BOXFORM8', 100, /*owner*/, /*lUsePixel*/, 'FOLDER2', 'SHEET7')
oView:SetOwnerView('FORM8','BOXFORM8')
oView:CreateHorizontalBox( 'BOXFORM6', 100, /*owner*/, /*lUsePixel*/, 'FOLDER2', 'SHEET6')
oView:SetOwnerView('FORM6','BOXFORM6')

Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author ROBSON

@since 24/07/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel
Local oStr1:= FWFormStruct(1,'SA1')
Local oStr2:= FWFormStruct(1,'AGB')
Local oStr3:= FWFormStruct(1,'AGA')

oModel := MPFormModel():New('MODSA1AGB', /*bPreValidacao*/, { | oModel | AGBSA101A( oModel ) } , /*{ | oMdl | MVC001C( oMdl ) }*/ ,, /*bCancel*/ )
oModel:SetDescription('Cadastro de Clientes')

//Iniciar o campo com conteudo
oStr2:SetProperty('AGB_CODIGO' , MODEL_FIELD_INIT,{||'0'} )
oStr2:SetProperty('AGB_ENTIDA' , MODEL_FIELD_INIT,{||'SA1'} )
oStr2:SetProperty('AGB_CODENT' , MODEL_FIELD_INIT,{||SA1->A1_COD+SA1->A1_LOJA} )
oStr2:RemoveField( 'AGB_FILIAL' )

//Iniciar o campo com conteudo
oStr3:SetProperty('AGA_CODIGO' , MODEL_FIELD_INIT,{||'0'} )
oStr3:SetProperty('AGA_ENTIDA' , MODEL_FIELD_INIT,{||'SA1'} )
oStr3:SetProperty('AGA_CODENT' , MODEL_FIELD_INIT,{||SA1->A1_COD+SA1->A1_LOJA} )
oStr3:RemoveField( 'AGA_FILIAL' )


oModel:addFields('FIELD1',,oStr1)
oModel:addGrid('AGBDETAIL','FIELD1',oStr2)
oModel:addGrid('AGADETAIL','FIELD1',oStr3)

oModel:SetRelation('AGBDETAIL', { { 'AGB_FILIAL', 'xFilial( "AGB" )' }, { 'AGB_CODENT', 'A1_COD + A1_LOJA' } }, AGB->(IndexKey(1)) )
oModel:SetRelation('AGADETAIL', { { 'AGA_FILIAL', 'xFilial( "AGA" )' }, { 'AGA_CODENT', 'A1_COD + A1_LOJA' } }, AGA->(IndexKey(1)) )


oModel:getModel('FIELD1'):SetDescription('Form Field SA1')

//oModel:getModel('AGBDETAIL'):SetDescription('Telefones do Cliente')
//oModel:getModel('AGADETAIL'):SetDescription('Endereços do Cliente')

oModel:getModel('AGBDETAIL'):SetOptional(.T.)
oModel:getModel('AGADETAIL'):SetOptional(.T.)

Return oModel


Static Function AGBSA101A(oModel)
Local lRet      := .T.
Local aArea     := GetArea()
Local oModelAGA := oModel:GetModel( 'AGADETAIL' )
//Local nOpcA      := oModel:GetOperation()
Local oModelAGB  := oModel:GetModel( 'AGBDETAIL' )
//Local nOpcB      := oModel:GetOperation()
Local nI := 0

	For nI := 1 To oModelAGA:Length()
		oModelAGA:GoLine( nI )	
		
		IF !EMPTY(oModelAGA:GetValue('AGA_END'))
			If oModelAGA:IsInserted()
			
				cCod := GetSXENum("AGA","AGA_CODIGO") //Obtém o próximo número disponível para o alias especificado no parâmetro.
				ConfirmSX8() //confirma se o número já existe na base de dados
				oModelAGA:SetValue('AGA_CODIGO', cCod ) //atribui um dado a um campo
			endif

			
		endif
		
	Next nI

	nI := 0
	For nI := 1 To oModelAGB:Length()
		oModelAGB:GoLine( nI )
		
		If !EMPTY(oModelAGB:GetValue('AGB_TELEFO')) 
			If oModelAGB:IsInserted()
		
				cCod := GetSXENum("AGB","AGB_CODIGO")
				ConfirmSX8()
				oModelAGB:SetValue('AGB_CODIGO', cCod )
				
				IF ALLTRIM(FUNNAME())=="LIGCAL02"
					oModelAGB:SetValue('AGB_UCALLC', M->UA_NUM)
				ENDIF
			endif
		endif
		
	Next nI
		
RestArea(aArea)
	
FwModelActive( oModel, .T. )
return lRet
