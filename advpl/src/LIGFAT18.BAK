#include 'protheus.ch'
#include 'parmtype.ch'


/*
CONSULTA PARA VERIFICAR CONTRATOS QUE FORAM FATURADOS E TEM ITENS EM ABERTO
*/
user function LIGFAT18()
************************************

PRIVATE _CPERG		:= "FAT18A"

VALIDPERG()
IF !PERGUNTE(_CPERG)
	RETURN
ENDIF        

_DDTINI  := MV_PAR01
_DDTFIM  := MV_PAR02
_CPRODUTO := MV_PAR03

//DEFINE DIALOG oMainWnd TITLE "Exemplo TMSPrinter" FROM 180,180 TO 550,700 PIXEL

PROCESSA({||FAT018()})	
return

STATIC FUNCTION FAT018() //PROCESSAMENTO DOS CONTRATOS
LOCAL _NQTREGUA := 0
LOCAL _TOTALFAT := 0
Local aCabec 	:= {"ADB_NUMCTR","ADB_ITEM","ADB_CODPRO","ADB_DESPRO","ADB_QUANT","ADB_PRCVEN","ADB_TOTAL","ADB_UDTINI"}
Local aDados  := {}  
Local aSizeCol 	:= {10,10,20,50,10,10,10,20}                                                                                             

DBSELECTAREA("ADA")
DBGOTOP()
WHILE !EOF()
	 _NQTREGUA++
	DBSKIP()
ENDDO

PROCREGUA(_NQTREGUA)

DBSELECTAREA("ADA")
DBGOTOP()
WHILE !EOF()
	IF ADA->ADA_ULIBER=="S" //LIB FINANCEIRO
		INCPROC("Processando...")
		
		_AITENS := {}
		_APDEMO	:= {}
		_ANFGER	:= {}
		_LCONSOK:= .F.
		
		IF ADA->ADA_UDTFEC>=_DDTINI .AND. ADA->ADA_UDTFEC<=_DDTFIM	
			//INICIO - PRODUTOS CONTRATO
			DBSELECTAREA("ADB")
			DBSETORDER(1)
			DBGOTOP()
			IF DBSEEK(XFILIAL("ADB")+ADA->ADA_NUMCTR)
				WHILE !EOF() .AND. ADB->ADB_FILIAL+ADB->ADB_NUMCTR==ADA->ADA_FILIAL+ADA->ADA_NUMCTR		
					
					IF EMPTY(ADB->ADB_UDTINI)
						AAdd(aDados, {ADB_NUMCTR,ADB_ITEM,ADB_CODPRO,ADB_DESPRO,ADB_QUANT,ADB_PRCVEN, ADB_TOTAL,ADB_UDTINI})   
					ENDIF
					
					DBSELECTAREA("ADB")
					DBSKIP()
				ENDDO
				
				//FIM - PRODUTOS CONTRATO
			ENDIF //IF DO ADB	
		ENDIF 	    
	ENDIF  
	     
	DBSELECTAREA("ADA")
	DBSKIP()
ENDDO

IF msgyesno("Deseja abrir em Tela?") 		
	U_FAT018A(aCabec,aSizeCol,aDados)
ENDIF

If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel não instalado!")
	Return
EndIf
DlgToExcel({ {"ARRAY", "Exportacao para o Excel", aCabec, aDados} })

RETURN


USER FUNCTION FAT018A(aCabec,aSizeCol,aDados)
Local aList := {}
 
    DEFINE DIALOG oDlg TITLE "Exemplo TCBrowse" FROM 180,180 TO 550,700 PIXEL
 
        // Vetor com elementos do Browse
//        aBrowse := { {.T.,'CLIENTE 001','RUA CLIENTE 001',111.11},;
//                     {.F.,'CLIENTE 002','RUA CLIENTE 002',222.22},;
//                     {.T.,'CLIENTE 003','RUA CLIENTE 003',333.33} }
 
        // Cria Browse
        oBrowse := TCBrowse():New( 01 , 01, 260, 156,, aDados ,aSizeCol, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
 
        // Seta vetor para a browse
        oBrowse:SetArray(aDados)
 
        // Monta a linha a ser exibina no Browse
        oBrowse:bLine := {||{ 	 aDados[oBrowse:nAt,01],;
                                 aDados[oBrowse:nAt,02],;
                                 aDados[oBrowse:nAt,03],;
                                 aDados[oBrowse:nAt,04],;
                                 aDados[oBrowse:nAt,05],;
                                 Transform(aDados[oBrowse:nAT,06],'@E 99,999,999,999.99'),; 
                                 Transform(aDados[oBrowse:nAT,07],'@E 99,999,999,999.99'),; 
                                 aDados[oBrowse:nAt,08]}}

 
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
 
    ACTIVATE DIALOG oDlg CENTERED
RETURN

STATIC FUNCTION VALIDPERG
*********************************
_SALIAS := ALIAS()
AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
_CPERG := PADR(_CPERG,10)

//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG

AADD(AREGS,{_CPERG,"01","Data Inicio  ?  "," ?"," ?","MV_CH01","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"02","Data Fim ?  "," ?"," ?","MV_CH02","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(AREGS,{_CPERG,"03","PRODUTO       ?","","","MV_CH03","C",15,0,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})

FOR I:=1 TO LEN(AREGS)
	IF !DBSEEK(_CPERG+AREGS[I,2])
		RECLOCK("SX1",.T.)
		FOR J:=1 TO FCOUNT()
			IF J <= LEN(AREGS[I])
				FIELDPUT(J,AREGS[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
DBSELECTAREA(_SALIAS)
RETURN