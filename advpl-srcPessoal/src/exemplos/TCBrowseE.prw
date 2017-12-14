#include "TOTVS.CH"
#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

USER FUNCTION TCBROWSE()
	Local oOK := LoadBitmap(GetResources(),'br_verde')
	Local oNO := LoadBitmap(GetResources(),'br_vermelho')
	Local aList := {}
	
	dbSelectArea("SA1") //Seleciona a area SA1, cadastro de clientes
	dbSetOrder(1)	//A1_FILIAL + A1_COD + A1_LOJA, assim serão identificados os registros
    DEFINE DIALOG oDlg TITLE "Exemplo TCBrowse" FROM 180,180 TO 550,700 PIXEL
    	// Vetor com elementos do Browse
    	mode = "DBSKIP"
    	if (mode=="DBSEEK")    	
    		dbSeek(xFilial("SA1") + "001333589" + "001")//Busca no banco pela Ligia Cristina Machado
	    	if FOUND()    	
	    		aBrowse := { {SA1->A1_COD,SA1->A1_NOME} }
	    	endif
	    else 
	    	if(mode=="DBSKIP")
	    		aBrowse := {}
		    	dbGoTop()//Posiciona o cursor no inicio da area de trabalho ativa
		    	count := 0
		    	while (!EOF() .And. count<40)
		    		aAdd(aBrowse,{A1_COD,A1_NOME})
		    		count++
		    		dbSkip()//Pula para o proximo registro
		    	enddo
		    endif
        endif
        // Cria Browse
        oBrowse := TCBrowse():New( 01 , 01, 260, 156,, {'Codigo','Nome'},{20,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
        
        // Seta vetor para a browse
        oBrowse:SetArray(aBrowse)
 
        // Monta a linha a ser exibina no Browse
        oBrowse:bLine := {||{aBrowse[oBrowse:nAt,01],aBrowse[oBrowse:nAt,02]} }
 
        // Evento de clique no cabeçalho da browse
        oBrowse:bHeaderClick := {|o, nCol| alert('bHeaderClick') }
 
        // Evento de duplo click na celula
        oBrowse:bLDblClick := {|| alert('bLDblClick') }
 
        // Cria Botoes com metodos básicos
        TButton():New( 160, 002, "GoUp()", oDlg,{|| oBrowse:GoUp(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 160, 052, "GoDown()" , oDlg,{|| oBrowse:GoDown(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 160, 102, "GoTop()" , oDlg,{|| oBrowse:GoTop(),oBrowse:setFocus()}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F.)
        TButton():New( 160, 152, "GoBottom()", oDlg,{|| oBrowse:GoBottom(),oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
        TButton():New( 172, 002, "Linha atual", oDlg,{|| alert(oBrowse:nAt) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 172, 052, "Nr Linhas", oDlg,{|| alert(oBrowse:nLen) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 172, 102, "Linhas visiveis", oDlg,{|| alert(oBrowse:nRowCount()) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
        TButton():New( 172, 152, "Alias", oDlg,{|| alert(oBrowse:cAlias) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
        DbCloseArea()
    ACTIVATE DIALOG oDlg CENTERED
RETURN