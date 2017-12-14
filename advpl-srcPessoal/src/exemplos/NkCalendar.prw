#include 'protheus.ch'
#include 'parmtype.ch'

user function NkCalendar()
	DEFINE DIALOG oDlg TITLE "Exemplo MsCalend" FROM 180,180 TO 550,700 PIXEL     
	// Cria objeto   
	oMsCalend := MsCalend():New(01,01,oDlg,.T.)   
	// Define o dia a ser exibido no calendário   
	oMsCalend:dDiaAtu := ctod( "01/01/2008" )   
	// Code-Block para mudança de Dia	
	
	oMsCalend:bChange := {|| Alert('Dia Selecionado: ' + dtoc(oMsCalend:dDiaAtu)) }     
	// Code-Block para mudança de mes   
	oMsCalend:bChangeMes := {|| alert('Mes alterado') }                  
	ACTIVATE DIALOG oDlg CENTERED
return oMsCalend:dDiaAtu

user function dynmcNkLbl(component)	
	res:=dtoc(u_NkCalendar())
	oSay1:= TSay():New(0,0,{||res},component,,oFont,,,,.T.,CLR_GRAY,CLR_GRAY,60,20)	
return 

user function calNkTest()
	 DEFINE DIALOG oDlg TITLE "Exemplo Calendar" FROM 0,0 TO 550,700 PIXEL 
	 
	 TButton():New( 0, 90, "Calendario", oDlg,{|| u_dynmcNkLbl(oDlg) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	 ACTIVATE DIALOG oDlg CENTERED   	 
return
