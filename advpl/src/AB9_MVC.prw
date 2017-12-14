#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#include "rwmake.ch"
#INCLUDE "TOTVS.CH"

User Function AB9_MVC()
	Local oBrowse := Nil 
	Local cFiltra := ""	
	Private aRotina := MenuDef()	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("AB9")//Seleciona o Alias que estamos trabalhando.
	oBrowse:SetDescription("Atendimento da Ordem de Serviço")// "Descrição"
	oBrowse:SetFilterDefault(cFiltra)	
	oBrowse:SetUseCursor(.F.)
	oBrowse:Activate()
Return

Static Function MenuDef() 
	Local aRotina  := {}
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.AB9_MVC' OPERATION 2  ACCESS 0 //"Visualizar"
Return aRotina

Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZA0 := FWFormStruct( 1, 'AB9')	
	Local oModel // Modelo de dados que será construído	
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('MODAB9' )	
	oStruZA0:addField('Laudo','Laudo','AB9_MEMO1', 'C', 6, 0, {||.T.},nil,,.F.,nil,.T.,.F.,.F.)
	
	FWMemoVirtual( oStruZA0,{ { 'AB9_MEMO1' , 'AB9_MEMO2'} } )
	// Adiciona ao modelo um componente de formulário
	oModel:AddFields( 'AB9MASTER', /*cOwner*/, oStruZA0)
	// Adiciona a descrição do Modelo de Dados
	oModel:SetDescription( 'Modelo de dados de Cliente' )
	// Adiciona a descrição do Componente do Modelo de Dados
	oModel:GetModel( 'AB9MASTER' ):SetDescription( 'Dados do Cliente' )
	// Retorna o Modelo de dados
	FWMemoVirtual( oStruZA0,{ { 'AB9_MEMO1' , 'AB9_MEMO2' } } )
Return oModel

Static Function ViewDef()
	// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
	Local oModel := FWLoadModel( 'AB9_MVC' )
	// Cria a estrutura a ser usada na View
	Local oStruZA0 := FWFormStruct( 2, 'AB9' )
	Local oView		
	oView := FWFormView():New()	          
	FWMemoVirtual( oStruZA0,{ { "AB9_MEMO1" , "AB9_MEMO2" } } )
	oStruZA0:RemoveField( 'AB9_GARANT' )  
	oStruZA0:RemoveField( 'AB9_OBSOL'  )  
	oStruZA0:RemoveField( 'AB9_ACUMUL' )   
	oStruZA0:RemoveField( 'AB9_ATUPRE' )   
	oStruZA0:RemoveField( 'AB9_ATUOBS' )   
	oStruZA0:RemoveField( 'AB9_NUMSER' )   
	oStruZA0:RemoveField( 'AB9_TAREFA' )   
	oStruZA0:RemoveField( 'AB9_TFDESC' )   
	oStruZA0:RemoveField( 'AB9_STATAR' )   
	oStruZA0:RemoveField( 'AB9_TMKLST' )   
	oStruZA0:RemoveField( 'AB9_USITU2' )   	 
	// Define qual o Modelo de dados será utilizado na View
	oView:SetModel( oModel )
	// Adiciona no nosso View um controle do tipo formulário
	// (antiga Enchoice)
	oView:AddField( 'VIEW_AB9', oStruZA0, 'AB9MASTER' )
	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )
	// Relaciona o identificador (ID) da View com o "box" para exibição
	oView:SetOwnerView( 'VIEW_AB9', 'TELA' )	
Return oView