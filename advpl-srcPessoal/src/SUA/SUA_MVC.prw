#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#include "rwmake.ch"
#INCLUDE "TOTVS.CH"
/*
	@Author: nakao 
	Descrição: MVC de SUA/SUB	
*/
User Function SUA_MVC()
	Local oBrowse := Nil 
	Local cFiltra := ""
	Local codVend := ""	
	Local _area   := getArea()
	Private aRotina 
	/*
	A partir do codigo do usuario logado, procura-se na tabela de operadores por
	um operador com aquele código e é obtido o seu tipo de usuario, que pode ser(1=Vendedor, 2=Supervisor),
	depois, caso seja um vendedor, é retornado um filtro para mostrar apenas os registros do vendedor logado.
	*/	
	dbSelectArea("SUA")
	codUsr := ALLTRIM(RetCodUsr())	
	//codUsr:="000013"							
	tpUsr := POSICIONE("SU7",4,xFilial("SU7")+codUsr,"U7_TIPO")	
	if(AllTRIM(tpUsr)=="1")//Se é vendedor						
		dbSelectArea("SA3")												
		dbSetOrder(7)														
		if(dbSeek(xFilial("SA3")+codUsr))//Se achou o vendedor, então filtre				
			cFiltra+="SUA->UA_VEND == '"+SA3->A3_COD+"' .AND. SUA->UA_STATUS == 'ORC'"
			codVend := SA3->A3_COD
		endif															
	endif
	restArea(_area)	
	aRotina := MenuDef(codVend)
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SUA")//Seleciona o Alias que estamos trabalhando.
	oBrowse:SetDescription("Atendimento - Call Center")// "Descrição"
	oBrowse:SetFilterDefault(cFiltra)	
	oBrowse:SetUseCursor(.F.)
	oBrowse:Activate()
Return

Static Function MenuDef(codVend) 
	Local aRotina  := {}
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.SUA_MVC' OPERATION 2  ACCESS 0 
	if(codVend=="")
		ADD OPTION aRotina TITLE "Incluir"	ACTION 'VIEWDEF.SUA_MVC' OPERATION 3  ACCESS 1 
		ADD OPTION aRotina TITLE "Alterar"	ACTION 'VIEWDEF.SUA_MVC' OPERATION 4  ACCESS 2 
	endif
Return aRotina

Static Function ModelDef()	
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStru0 := FWFormStruct( 1, 'SUA')
	Local oStru1 := FWFormStruct( 1, 'SUB')
	Local oModel 	
		
	oModel := MPFormModel():New('MODSUA')	
	oModel:addFields('SUAMASTER',,oStru0)
	oModel:AddGrid('SUBGRID','SUAMASTER',oStru1)		
	oModel:SetRelation('SUBGRID',{{'UB_FILIAL','xFilial( "SUB" )'},{'UB_NUM', 'UA_NUM'}},SUB->(IndexKey(1)))
	
	oModel:SetDescription('Modelo de dados')	
	oModel:GetModel('SUAMASTER'):SetDescription('Dados')
Return oModel

Static Function ViewDef()	
	Local oView	
	Local oModel := FWLoadModel('SUA_MVC')
	Local oStru0 := FWFormStruct(2,'SUA')
	Local oStru1 := FWFormStruct(2,'SUB')
	oView := FWFormView():New()
	oView:SetModel(oModel)	
	oView:AddField('FORM',oStru0,'SUAMASTER')
	oView:AddGrid('TABLE',oStru1,'SUBGRID')	
	oView:CreateHorizontalBox('BOXFORM',40)
	oView:CreateHorizontalBox('BOXTABLE',60)
	oView:SetOwnerView('FORM','BOXFORM')
	oView:SetOwnerView('TABLE','BOXTABLE')	
Return oView