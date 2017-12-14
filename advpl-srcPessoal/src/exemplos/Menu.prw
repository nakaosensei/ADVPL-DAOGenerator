#include "TOTVS.CH"
#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

user function MenuNakao()
	DEFINE DIALOG oDlg TITLE "Primeira tentativa de Menu sério" FROM 200,200 TO 700,750 PIXEL
	//Menu no topo
	oTMenuBar := TMenuBar():New(oDlg)
	oTMenu1 := TMenu():New(0,0,0,0,.T.,,oDlg)   
	oTMenu2 := TMenu():New(0,0,0,0,.T.,,oDlg)
	oTMenu3 := TMenu():New(0,0,0,0,.T.,,oDlg) 
	oTMenuBar:AddItem('Tabela de Clientes'  , oTMenu1, .T.)
	oTMenuBar:AddItem('Cadastrar Cliente'  , oTMenu2, .T.)
	oTMenuBar:AddItem('Alterar Cliente'  , oTMenu3, .T.)
	
	oPanel:= tPanel():New(10,01,"",oDlg,,.T.,,CLR_WHITE,CLR_WHITE,300,300)
	
	oTMenuItem := TMenuItem():New(oDlg,'Listar 40 clientes',,,,{|| u_ExibeTabelaCliente(oPanel) },,'AVGLBPAR1',,,,,,,.T.)   
	oTMenu1:Add(oTMenuItem)    
	
	oTMenuItem := TMenuItem():New(oDlg,'Cadastrar cliente default',,,,{|| u_ExibeTelaCadastro(oPanel) },,'AVGLBPAR1',,,,,,,.T.)   
	oTMenu2:Add(oTMenuItem)  
	
	ACTIVATE DIALOG oDlg CENTERED   
	
return

user function ExibeTabelaCliente(oDlg)
	Local aList := {}	
	dbSelectArea("SA1") //Seleciona a area SA1, cadastro de clientes
	dbSetOrder(1)	//A1_FILIAL + A1_COD + A1_LOJA, assim serão identificados os registros	
	dbGoTop()//Posiciona o cursor no inicio da area de trabalho ativa
	count = 0	
	aBrowse:={}
	while (!EOF() .And. count<100)
		aAdd(aBrowse,{A1_COD,A1_NOME})
		count++
		dbSkip()//Pula para o proximo registro
	enddo		
	oBrowse := TCBrowse():New( 01 , 01, 260, 156,, {'Codigo','Nome'},{20,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	oBrowse:SetArray(aBrowse)	
	x:=50
	oBrowse:bLine := {||{aBrowse[oBrowse:nAt,01],aBrowse[oBrowse:nAt,02]} }
    // Evento de clique no cabeçalho da browse
    oBrowse:bHeaderClick := {|o, nCol| alert('bHeaderClick') }
    // Evento de duplo click na celula
    oBrowse:bLDblClick := {|| alert('bLDblClick') }
	DbCloseArea()	
return

user function ExibeTelaCadastro(oDlg)
	oSay1:= TSay():New(01,01,{||''},oDlg,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	dbSelectArea("SA1")
	RECLOCK("SA1", .T.)
	SA1->A1_FILIAL := xFilial("SA1")//Filial de acordo com as configurações do Protheus
	SA1->A1_COD := "44444532"
	SA1->A1_LOJA := "001"
	SA1->A1_NOME := "Testerson da Silva"
	SA1->A1_NREDUZ := "Testerson da Silva"
	MSUNLOCK()
	oSay1:SetText("Cadastro de usuario: Nome:Testerson da Silva Codigo:44444. Cadastrado com sucesso!")
return




