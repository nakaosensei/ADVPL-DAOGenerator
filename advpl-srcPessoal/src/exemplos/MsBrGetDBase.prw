#include 'protheus.ch'
#include 'parmtype.ch'
#include "totvs.ch"

//Exemplo do MsBrGetDBase
user function getDbNk() 
  local aDados := {}
  local oBrowse := nil 
  DEFINE DIALOG oDlg TITLE "Forcenecores com MsBrGetDBase" FROM 0, 0 TO 580, 900 PIXEL           
  	dbSelectArea("SA2")
  	dbSetOrder(1)
  	dbGoTop()
  	count:=100
  	while(!EOF() .AND. count>0)
  		aAdd(aDados,{A2_NOME,A2_EMAIL,A2_CONTA,A2_LOJA})
  		dbSkip()
  		count--
  	enddo
     
    // Cria browse
    oBrowse := MsBrGetDBase():new( 0, 0, 560, 870,,,, oDlg,,,,,,,,,,,, .F., "", .T.,, .F.,,, )
 
    // Define vetor para a browse
    oBrowse:setArray( aDados )
 
    // Cria colunas do browse
    oBrowse:addColumn( TCColumn():new( "Nome", { || aDados[oBrowse:nAt, 1] },,,, "LEFT",, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( "Email", { || aDados[oBrowse:nAt, 2] },,,, "LEFT",, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( "Conta", { || aDados[oBrowse:nAt, 3] },,,, "LEFT",, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( "Loja", { || aDados[oBrowse:nAt, 4] },,,, "LEFT",, .F., .F.,,,, .F. ) )
    oBrowse:Refresh()
 
    // Cria Botões com métodos básicos
    TButton():new( 565, 002, "goUp()", oDlg, { || oBrowse:goUp(), oBrowse:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
    TButton():new( 565, 052, "goDown()", oDlg, { || oBrowse:goDown(), oBrowse:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
    TButton():new( 565, 102, "goTop()", oDlg, { || oBrowse:goTop(), oBrowse:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
    TButton():new( 565, 152, "goBottom()", oDlg, { || oBrowse:goBottom(), oBrowse:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
 
    ACTIVATE DIALOG oDlg CENTERED
 
return
