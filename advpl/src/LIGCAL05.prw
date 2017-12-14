#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"


//Desenvolvido por Robson Adriano
//Para Gerente de Vendas visualizar contratos Reprovados e aprovar Contratos com restri��es.

User Function LIGCAL05()
Local oBrowse	  := Nil 
Local cFiltra := "ADA_ULIBER <> 'S' .AND. ADA_MSBLQL <> 1"
Private aRotina := MenuDef()

	codUsr := RetCodUsr()
	tpUsr := POSICIONE("SU7",4,xFilial("SU7")+codUsr,"U7_TIPO")
	if(AllTRIM(tpUsr)=="1")//Se for vendedor
		dbSelectArea("SA3")
		dbSetOrder(7)//filial+codUsr
		if(dbSeek(xFilial("SA3")+codUsr)) //Achou o vendedor?		
			cFiltra+=" .AND. ADA_VEND1 == '"+SA3->A3_COD+"' .OR. ADA_VEND2 == '"+SA3->A3_COD+"'"	
		endif
	endif

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("ADA")//Seleciona o Alias que estamos trabalhando.
oBrowse:SetDescription("Contratos reprovados")// "Descri��o"
oBrowse:SetFilterDefault(cFiltra)
// Remove os bot�es de navega��o na edi��o ou visualiza��o do model
oBrowse:SetUseCursor(.F.)

oBrowse:Activate()
Return

User Function LIGCAL5A()
	IF ADA_ULIBER == 'R' 
		U_LIGTEC02()
		msginfo("Contrato foi liberado. O.S Foi criada !")
	ELSE
		msginfo("Apenas contratos reprovados podem ser liberados, os demais contratos devem aguardar an�lise do financeiro.")
	END 
Return

User Function LIGCAL5B()
	IF ADA_ULIBER == 'N' 
		msginfo("Contrato j� est� na fila para an�lise de cr�dito do financeiro.")
	ELSE
		RECLOCK("ADA",.F.)
		ADA->ADA_ULIBER := "N"
		MSUNLOCK()	   
		msginfo("Contrato foi enviado para nova an�lise de cr�dito do Financeiro.")                                 	
	END            
Return


//Abrir 
User Function LIGCAL5C()
Local _area := getarea()
Local _aSA1 := SA1->(getarea())

dbselectarea("SA1")
dbsetorder(1)
if dbseek(xFilial()+ADA->ADA_CODCLI+ADA->ADA_LOJCLI)
	FWExecView('Inclusao por FWExecView','AGBSA1_MVC', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
else
	ALERT('N�o foi possivel localizar o Cliente do Tele Vendas.')
endif	
	
restarea(_aSA1)
restarea(_area)	
return 

Static Function LIGCAL5D(oModel)
Local lRet      := .T.
Local aArea     := GetArea()
Local oModel := oModel:GetModel( 'DETAIL1' )
//Local nOpcA      := oModel:GetOperation()

Local nI := 0

	For nI := 1 To oModel:Length()
		oModel:GoLine( nI )	
		
			If oModel:IsInserted()
			
				oModel:SetValue('ADB_CODCLI', ADA->ADA_CODCLI )
				oModel:SetValue('ADB_LOJCLI', ADA->ADA_LOJCLI )
			endif				
	Next nI
			
RestArea(aArea)
FwModelActive( oModel, .T. )
return lRet

Static Function MenuDef() 
Local aRotina       := {}
	ADD OPTION aRotina TITLE "Pesquisar"	ACTION 'AxPesqui'        OPERATION 1  ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.LIGCAL05' OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Incluir"	ACTION 'VIEWDEF.LIGCAL05' OPERATION 3  ACCESS 0 //"Incluir" 
	ADD OPTION aRotina TITLE "Alterar"	ACTION 'VIEWDEF.LIGCAL05' OPERATION 4  ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"	ACTION 'VIEWDEF.LIGCAL05' OPERATION 5  ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Cliente" ACTION 'U_LIGCAL5C' OPERATION 4  ACCESS 0
	IF __CUSERID$GETMV("MV_UADMCTR")
		ADD OPTION aRotina TITLE "Liberar Contrato" ACTION 'U_LIGCAL5A' OPERATION 4  ACCESS 0 
	ENDIF 
	ADD OPTION aRotina TITLE "Enviar Fianceiro" ACTION 'U_LIGCAL5B' OPERATION 4  ACCESS 0
Return aRotina

Static Function ModelDef()
Local oModel
Local oStr1:= FWFormStruct(1,'ADA')
Local oStr2:= FWFormStruct(1,'ADB')

oModel := MPFormModel():New('ModelName', /*bPreValidacao*/, { | oModel | LIGCAL5D( oModel ) } , /*{ | oMdl | MVC001C( oMdl ) }*/ ,, /*bCancel*/ )


oStr2:addField('Cod Cli','Cod Cli','ADB_CODCLI', 'C', 9, 0, {||.T.},nil,,.F.,nil,.T.,.F.,.F.)
oStr2:addField('loja Cli','Loja Cli','ADB_LOJCLI', 'C', 3, 0, {||.T.},nil,,.F.,nil,.T.,.F.,.F.)


oModel:addFields('FIELD1',,oStr1)
oModel:AddGrid( 'DETAIL1', 'FIELD1', oStr2 )

oModel:SetRelation( 'DETAIL1', { { 'ADB_FILIAL', 'xFilial( "ADB" )' }, { 'ADB_NUMCTR', 'ADA_NUMCTR' } }, ADB->( IndexKey( 1 ) ) )

Return oModel

Static Function ViewDef()
Local oView
Local oModel := ModelDef()
 
Local oStr1:= FWFormStruct(2, 'ADA')
Local oStr2:= FWFormStruct(2, 'ADB')

oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FORM1' , oStr1,'FIELD1' ) 
oView:AddGrid( 'TABLE1', oStr2, 'DETAIL1' )

oView:CreateHorizontalBox( 'BOXFORM1', 40)
oView:CreateHorizontalBox( 'BOXTABLE1', 60)

oView:SetOwnerView('FORM1','BOXFORM1')
oView:SetOwnerView('TABLE1','BOXTABLE1')

//
oView:AddIncrementField( 'TABLE1', 'ADB_ITEM' )

Return oView

