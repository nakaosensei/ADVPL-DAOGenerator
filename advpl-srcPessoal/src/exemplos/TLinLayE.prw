#include 'protheus.ch'
#include 'parmtype.ch'
#include "TOTVS.CH"
 
USER FUNCTION TLINLAYE() 
	 DEFINE DIALOG oWindow TITLE "Exemplo TCBrowse" FROM 180,180 TO 550,700 PIXEL 
	  // Monta um Menu Suspenso   
	  oTMenuBar := TMenuBar():New(oWindow)   	 
	  oTMenu1 := TMenu():New(0,0,0,0,.T.,,oWindow)   
	  oTMenu2 := TMenu():New(0,0,0,0,.T.,,oWindow)   
	  oTMenuBar:AddItem('Arquivo'  , oTMenu1, .T.)   
	  oTMenuBar:AddItem('Relatorio', oTMenu2, .T.)	   
	  oPanel:= tPanel():New(75,01,"",oWindow,,.T.,,CLR_YELLOW,CLR_BLUE,100,100)	  
	  
	  // Cria Itens do Menu   
	  oTMenuItem := TMenuItem():New(oWindow,'TMenuItem 01',,,,{|| TButton():New( 76, 002, "GoUp()", oPanel,{|| oBrowse:GoUp(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. ) },,'AVGLBPAR1',,,,,,,.T.)   
	  oTMenu1:Add(oTMenuItem)   
	  oTMenu2:Add(oTMenuItem)   
	 
	  oTMenuItem := TMenuItem():New(oWindow,'TMenuItem 02',,,,{|| TButton():New( 76, 052, "GoDown()" , oPanel,{|| oBrowse:GoDown(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )},,,,,,,,,.T.)   
	  oTMenu1:Add(oTMenuItem)   
	  oTMenu2:Add(oTMenuItem)          
	  
	  ACTIVATE DIALOG oWindow CENTERED
return

USER FUNCTION hwNakao()
	MsgAlert("Hello World")
return
