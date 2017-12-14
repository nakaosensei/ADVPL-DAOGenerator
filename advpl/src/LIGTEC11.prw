#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#include "rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "MSGRAPHI.CH"
#Include "TOPCONN.CH"

//Desenvolvido por Robson Adriano
//Para os atendentes visualizar as Ordem de serviços fechadas pelo boas vindas.

User Function LIGTEC11()
Local oBrowse	  := Nil 
Local _cSituBoas := getmv("MV_UBOASV") //Situacao do boas vindas
Local cFiltra := "AB6_STATUS = 'E' .AND. AB6_USITU1 = " + _cSituBoas

Private aRotina := MenuDef()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("AB6")//Seleciona o Alias que estamos trabalhando.
oBrowse:SetDescription("Ordem de Serviço : Boas Vindas")// "Descrição"
oBrowse:SetFilterDefault(cFiltra)

oBrowse:AddLegend( "AB6_UVALAT==' '", "YELLOW", "Aguardando" )
oBrowse:AddLegend( "AB6_UVALAT=='1'", "GREEN", "Conforme" )
oBrowse:AddLegend( "AB6_UVALAT=='2'", "RED" , "Não Conforme" )

// Remove os botões de navegação na edição ou visualização do model
oBrowse:SetUseCursor(.F.)

oBrowse:Activate()
Return

User Function TEC11LEG()
Local aLegenda := {}
	AADD(aLegenda,{"BR_VERDE" ,"Conforme" })
	AADD(aLegenda,{"BR_AMARELO" ,"Aguardando" })
	AADD(aLegenda,{"BR_VERMELHO" ,"Não Conforme" })
BrwLegenda("Validação Help Desk", "Legenda", aLegenda)
Return (aLegenda)

Static Function MenuDef() 
Local aRotina       := {}
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.LIGTEC11' OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Validar Visita" ACTION 'U_TEC11A' OPERATION 4  ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Legenda" ACTION 'U_TEC11LEG' OPERATION 6  ACCESS 0 //"Leganda"
	IF __CUSERID$GETMV("MV_UADMHD")
		ADD OPTION aRotina TITLE "Grafico" ACTION 'U_TEC11B' OPERATION 1  ACCESS 0 //"Excluir"
	ENDIF
Return aRotina

Static Function ModelDef()
Local oModel
Local oStr1:= FWFormStruct(1,'AB6')
Local oStr2:= FWFormStruct(1,'AB7')

oModel := MPFormModel():New('ModelName')

oModel:addFields('FIELD1',,oStr1)
oModel:AddGrid( 'DETAIL1', 'FIELD1', oStr2 )

oModel:SetRelation( 'DETAIL1', { { 'AB7_FILIAL', 'xFilial( "AB7" )' }, { 'AB7_NUMOS', 'AB6_NUMOS' } }, AB7->( IndexKey( 1 ) ) )

Return oModel

Static Function ViewDef()
Local oView
Local oModel := ModelDef()
 
Local oStr1:= FWFormStruct(2, 'AB6')
Local oStr2:= FWFormStruct(2, 'AB7')

oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FORM1' , oStr1,'FIELD1' ) 
oView:AddGrid( 'TABLE1', oStr2, 'DETAIL1' )

oView:CreateHorizontalBox( 'BOXFORM1', 40)
oView:CreateHorizontalBox( 'BOXTABLE1', 60)

oView:SetOwnerView('FORM1','BOXFORM1')
oView:SetOwnerView('TABLE1','BOXTABLE1')

Return oView

User Function TEC11A()
Local lOk:=.f.
Local oDlg

cTexto := ""
cCombo := "1" 
aItem := {"1=Conforme", "2=Não Conforme"} 

@ 116,001 To 416,1020 Dialog oDlgMemo Title "Validação da Ordem de Serviço 'Boas Vindas'"
@ 05,010 SAY "Situação:" OF oDlgMemo Pixel
@ 05,050 ComboBox oCombo Var cCombo Items aItem Size 085,09 Of oDlgMemo Pixel 

@ 20,10 Get cTexto Size 490,110 MEMO of OdlgMemo Pixel

@ 135,200 Button "Salvar"         Size 35,14 Action FRSalva() of OdlgMemo Pixel
@ 135,250 Button "Sair"          Size 35,14 Action Close(oDlgMemo) of OdlgMemo Pixel
Activate Dialog oDlgMemo  
Return

static function valTexto()
	if len(alltrim(cTexto))>400
		msginfo("Texto muito grande. No maximo 400 caracteres.")
		return .f.
	endif
	
	if EMPTY(alltrim(cTexto))
		msginfo("Por favor informe uma Mensagem.")
		return .f.
	ENDIF
return .t.

Static Function FRSalva()
	IF valTexto()
		RecLock("AB6",.f.)
			AB6->AB6_UVALAT := cCombo
			AB6->AB6_UMEMO := cTexto
		msunlock()     
	
		msginfo("Mensagem gravada com sucesso")
		Close(oDlgMemo)
	endif
Return

User Function TEC11B()
Private	CPERG       := "LIGTEC13  "
contA := 0
contN := 0
contC := 0 

validperg()   //Chama perguntas
If !pergunte(cPerg,.T.)
	Return()
Endif

_CQUERY := " SELECT AB6.AB6_UVALAT "
_CQUERY += " FROM "+RETSQLNAME("AB6")+" AB6 "
_CQUERY += " WHERE "                               
_CQUERY += " AB6.AB6_EMISSA >= '"+DTOS(MV_PAR01)+"'                                  
_CQUERY += " AND AB6.AB6_EMISSA <= '"+DTOS(MV_PAR02)+"'                                                                                                              
_CQUERY += " AND AB6.AB6_USITU1= '7'"                                                                              
_CQUERY += " AND AB6.D_E_L_E_T_=' ' "                                           
                                                                                                                         
_CQUERY := CHANGEQUERY(_CQUERY)

IF SELECT("TEMP1")!=0
	TEMP1->(DBCLOSEAREA())
ENDIF
TCQUERY _CQUERY NEW ALIAS "TEMP1"
dbSelectArea("TEMP1") 
dbGoTop()

While ! TEMP1->(EOF())	
	IF EMPTY(TEMP1->AB6_UVALAT)
		contA ++
	ELSE
		IF TEMP1->AB6_UVALAT = '1'
			contC++
		ELSE
			contN++
		ENDIF
	ENDIF 
dbselectarea("TEMP1") 		
dbSkip()
enddo	

DEFINE DIALOG oDlg TITLE "Visualição de Help Desk" FROM 180,180 TO 550,700 PIXEL

    // Cria o gráfico
    oGraphic := TMSGraphic():New( 01,01,oDlg,,,RGB(239,239,239),260,184)    
    oGraphic:SetTitle('Titulo do Grafico', "Data:" + dtoc(Date()), CLR_HRED, A_LEFTJUST, GRP_TITLE )
    oGraphic:SetMargins(2,6,6,6)
    oGraphic:SetLegenProp(GRP_SCRRIGHT, CLR_LIGHTGRAY, GRP_AUTO, .T.)
     
    // Itens do Gráfico
    nSerie := oGraphic:CreateSerie( GRP_PIE ) 
    oGraphic:Add(nSerie, contC, 'Conforme', CLR_HGREEN )  
    oGraphic:Add(nSerie, contN, 'Não Conforme', CLR_HRED)
    oGraphic:Add(nSerie, contA, 'Aguardando', CLR_YELLOW )
 
ACTIVATE DIALOG oDlg CENTERED 

DBSELECTAREA("TEMP1")
TEMP1->(DBCLOSEAREA())
Return Nil

Static Function ValidPerg
LOCAL _AREA := GETAREA()
LOCAL AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
CPERG 	:= PADR(CPERG,10)

AADD(AREGS,{CPERG,"01","Data Inicio  ?  "," ?"," ?","MV_CH01","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{CPERG,"02","Data Fim ?  "," ?"," ?","MV_CH01","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})

FOR I:=1 TO LEN(AREGS)
	IF !DBSEEK(CPERG+AREGS[I,2])
		RECLOCK("SX1",.T.)
		FOR J:=1 TO FCOUNT()
			IF J <= LEN(AREGS[I])
				FIELDPUT(J,AREGS[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
RESTAREA(_AREA)
RETURN
