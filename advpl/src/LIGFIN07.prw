#Include "PROTHEUS.ch"
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#include "TOTVS.CH"

User Function LIGFIN07()
Private	CPERG       := "LIGFIN07  "
Private	OFONT1      := TFONT():NEW( "ARIAL",,10,,.T.,,,,,.F.)
Private	OFONT2      := TFONT():NEW( "ARIAL",,07,,.F.,,,,,.F.)
Private	nLin		:= 0100		// Linha que o sistema esta imprimindo.

validperg()   //Chama perguntas
If !pergunte(cPerg,.T.)
	Return()
Endif

oPrint := TMSPrinter():New("Relatório de Notas/Contas a Receber")// Monta objeto para impressão

oPrint:SetPortrait()// Define orientação da página para Retrato, pode ser usado oPrint:SetLandscape para Paisagem

oPrint:Setup()// Mostra janela de configuração de impressão

oPrint:StartPage()// Inicia página

oPrint:setPaperSize( DMPAPER_A4 )
// Insere Linhas
oPrint:Box(0050,0050,3300,2380) //Area total

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime o cabecalho da empresa. !³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nLin := 0080 //Lista Parametros

	oPrint:Say(nLin,0100,"Relatório de Notas/Contas a Receber",oFont1)
	oPrint:Say(nLin,1200,"De",oFont1)
	oPrint:Say(nLin,1450,"Até",oFont1)
	oPrint:Say(nLin,2000,"Operador",oFont1)
	nLin += 080
	oPrint:Say(nLin,1200,MV_PAR01,oFont2)
	oPrint:Say(nLin,1450,MV_PAR02,oFont2)
	oPrint:Say(nLin,1750,DTOS(MV_PAR03),oFont2)
	oPrint:Say(nLin,2000,DTOS(MV_PAR04),oFont2)

//Lista Itens QUERY

Query()

// Visualiza a impressão
oPrint:EndPage()

// Mostra tela de visualização de impressão
oPrint:Preview()

Return


//___________________________________________________________________________________________________________________________                                                
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função com Array para Imprime Itens !³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Query()  
Local _CQUERY   := " "                   
Private nTota1 := 0
Private nTota2 := 0
Private nTota3 := 0
Private nTota4 := 0
Private nTota5 := 0
Private nCol1 := 0070
Private nCol2 := 0140
Private nCol3 := 0230
Private nCol4 := 0360
Private nCol5 := 0900
Private nCol6 := 1000
Private nCol7 := 1100
Private nCol8 := 1200
Private nCol9 := 1400
Private nCol10 := 1600
Private nCol11 := 1750
Private nCol12 := 1950
Private nCol13 := 2150
aDados	:= {}// Array
_somaQnt := 0
_somaSE1 := 0
_somaCoRSE1 := 0
_somaSaldo := 0
_somaNFSE1 := 0
_somaSF2 := 0



_CQUERY := " SELECT F2.F2_FILIAL,F2.F2_SERIE, F2.F2_DOC, E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_FILIAL, E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_TIPO, E1.E1_EMISSAO, E1.E1_BAIXA, E5.E5_DTDISPO, E1.E1_VALOR,  E1.E1_VALLIQ, E1.E1_SALDO, F2.F2_VALBRUT, "
_CQUERY += "        E1.E1_UFILNF1, E1.E1_USERNF1, E1.E1_UNUMNF1, E1.E1_UVALNF1, "
_CQUERY += "        E1.E1_UFILNF2, E1.E1_USERNF2, E1.E1_UNUMNF2, E1.E1_UVALNF2, "
_CQUERY += "        E1.E1_UFILNF3, E1.E1_USERNF3, E1.E1_UNUMNF3, E1.E1_UVALNF3, "
_CQUERY += "        E1.E1_UFILNF4, E1.E1_USERNF4, E1.E1_UNUMNF4, E1.E1_UVALNF4, "
_CQUERY += "        E1.E1_UFILNF5, E1.E1_USERNF5, E1.E1_UNUMNF5, E1.E1_UVALNF5  "
_CQUERY += " FROM "+RETSQLNAME("SE1")+" E1, "+RETSQLNAME("SF2")+" F2, "+RETSQLNAME("SE5")+" E5 "
_CQUERY += " WHERE ((E1.E1_UFILNF1=F2.F2_FILIAL AND E1.E1_USERNF1=F2.F2_SERIE AND E1.E1_UNUMNF1=F2.F2_DOC) "
_CQUERY += " OR (E1.E1_UFILNF2=F2.F2_FILIAL AND E1.E1_USERNF2=F2.F2_SERIE AND E1.E1_UNUMNF2=F2.F2_DOC) "  
_CQUERY += " OR (E1.E1_UFILNF3=F2.F2_FILIAL AND E1.E1_USERNF3=F2.F2_SERIE AND E1.E1_UNUMNF3=F2.F2_DOC) "  
_CQUERY += " OR (E1.E1_UFILNF4=F2.F2_FILIAL AND E1.E1_USERNF4=F2.F2_SERIE AND E1.E1_UNUMNF4=F2.F2_DOC) " 
_CQUERY += " OR (E1.E1_UFILNF5=F2.F2_FILIAL AND E1.E1_USERNF5=F2.F2_SERIE AND E1.E1_UNUMNF5=F2.F2_DOC)) "
_CQUERY += " AND F2.F2_FILIAL = '" + MV_PAR01 + "'"                                      
_CQUERY += " AND F2.F2_SERIE =  '" + MV_PAR02 + "'"                                     
_CQUERY += " AND E5.E5_DTDISPO >= '"+DTOS(MV_PAR03)+"'                                  
_CQUERY += " AND E5.E5_DTDISPO <= '"+DTOS(MV_PAR04)+"'                                    
_CQUERY += " AND E5.E5_NUMERO = E1.E1_NUM "                                           
_CQUERY += " AND E5.E5_PARCELA= E1.E1_PARCELA "                                           
_CQUERY += " AND E5.E5_PREFIXO= E1.E1_PREFIXO "                                                                              
_CQUERY += " AND E5.E5_TIPODOC= 'VL' "                                                                              
_CQUERY += " AND E1.D_E_L_E_T_=' ' "                                           
_CQUERY += " AND F2.D_E_L_E_T_=' ' "                                           
_CQUERY += " AND E5.D_E_L_E_T_=' ' "                                           
_CQUERY += " ORDER BY E1.E1_BAIXA, E1.E1_NUM, E1.E1_PARCELA"                                           
_CQUERY := CHANGEQUERY(_CQUERY)

IF SELECT("TEMP1")!=0
	TEMP1->(DBCLOSEAREA())
ENDIF
TCQUERY _CQUERY NEW ALIAS "TEMP1"
dbSelectArea("TEMP1") 
dbGoTop()

	nLin += 100
	oPrint:Say(nLin,nCol1,"Filial",oFont1)
	oPrint:Say(nLin,nCol2,"Serie",oFont1)
	oPrint:Say(nLin,nCol3,"Nota",oFont1)
	oPrint:Say(nLin,nCol4,"Cliente",oFont1)
	oPrint:Say(nLin,nCol5,"Pref",oFont1)
	oPrint:Say(nLin,nCol6,"Num",oFont1)
	oPrint:Say(nLin,nCol7,"Parc",oFont1)
	oPrint:Say(nLin,nCol8,"Dt.Ocor",oFont1)
	oPrint:Say(nLin,nCol9,"Dt.Cred",oFont1)
	oPrint:Say(nLin,nCol10,"VL SE1",oFont1)
	oPrint:Say(nLin,nCol11,"VL Crg. SE1",oFont1)
	oPrint:Say(nLin,nCol12,"VL NF SE1",oFont1)
	oPrint:Say(nLin,nCol13,"VL SF2",oFont1)

While ! TEMP1->(EOF())	

	_vlNfSe1 := 0
	
	IF TEMP1->E1_UFILNF1 == MV_PAR01 .AND. ALLTRIM(TEMP1->E1_UFILNF1) == ALLTRIM(MV_PAR01)
		_vlNfSe1 := E1_UVALNF1
	ENDIF
	IF TEMP1->E1_UFILNF2 == MV_PAR01 .AND. ALLTRIM(TEMP1->E1_UFILNF2) == ALLTRIM(MV_PAR01)
		_vlNfSe1 := E1_UVALNF1
	ENDIF
	IF TEMP1->E1_UFILNF3 == MV_PAR01 .AND. ALLTRIM(TEMP1->E1_UFILNF3) == ALLTRIM(MV_PAR01)
		_vlNfSe1 := E1_UVALNF1
	ENDIF
	IF TEMP1->E1_UFILNF4 == MV_PAR01 .AND. ALLTRIM(TEMP1->E1_UFILNF4) == ALLTRIM(MV_PAR01)
		_vlNfSe1 := E1_UVALNF1
	ENDIF
	IF TEMP1->E1_UFILNF5 == MV_PAR01 .AND. ALLTRIM(TEMP1->E1_UFILNF5) == ALLTRIM(MV_PAR01)
		_vlNfSe1 := E1_UVALNF1
	ENDIF

	Aadd(aDados, 	{ TEMP1->F2_FILIAL,; 
					TEMP1->F2_SERIE ,; 	
					TEMP1->F2_DOC ,; 	
					POSICIONE("SA1",1,xFilial("SA1")+	TEMP1->E1_CLIENTE+TEMP1->E1_LOJA,"A1_NOME"),; 	
					TEMP1->E1_PREFIXO ,;	
					TEMP1->E1_NUM ,;		
					TEMP1->E1_PARCELA ,;	
					TEMP1->E1_BAIXA ,;
					TEMP1->E5_DTDISPO ,;
					TEMP1->E1_VALOR ,;
					TEMP1->E1_VALLIQ,;
					_vlNfSe1 ,;
					TEMP1->F2_VALBRUT } )
   
	If nLin > 3000
	oPrint:EndPage()	
	oPrint:StartPage()// Inicia página
	nLin := 100
	EndIf

dbselectarea("TEMP1") 		
dbSkip()
enddo	
	
	nLin := 300				
	for n:=1 to len(aDados) 
	nLin += 0070
	oPrint:Say(nLin,nCol1,aDados[n,1],oFont2)	//FILIAL
	oPrint:Say(nLin,nCol2,aDados[n,2],oFont2)	//SERIE
	oPrint:Say(nLin,nCol3,aDados[n,3],oFont2) 	//PREFIXO
	oPrint:Say(nLin,nCol4,aDados[n,4],oFont2) 	//NUM TITULO 
	oPrint:Say(nLin,nCol5,aDados[n,5],oFont2) 	//PARCELA
	oPrint:Say(nLin,nCol6,aDados[n,6],oFont2) 	//PARCELA
	oPrint:Say(nLin,nCol7,aDados[n,7],oFont2) 	//PARCELA
	oPrint:Say(nLin,nCol8,Transform(Stod(aDados[n,8]),"@E",),oFont2) 	//BAIXA
	oPrint:Say(nLin,nCol9,Transform(Stod(aDados[n,9]),"@E",),oFont2) 	//E5_DTDISPO
	oPrint:Say(nLin,nCol10,Transform(aDados[n,10],"@E 9,999,999.99",),oFont2) //VALOR SE1	
	oPrint:Say(nLin,nCol11,Transform(aDados[n,11],"@E 9,999,999.99",),oFont2) //VALOR CORRIGIDO SE1
	oPrint:Say(nLin,nCol12,Transform(aDados[n,12],"@E 9,999,999.99",),oFont2) //VALOR nf SF2
	oPrint:Say(nLin,nCol13,Transform(aDados[n,13],"@E 9,999,999.99",),oFont2) //VALOR SF2
	   
	_somaQnt ++
	_somaSE1 		+= 		aDados[n,10]
	_somaCoRSE1 	+= 		aDados[n,11]
	_somaNFSE1 	+= 		aDados[n,12]
	_somaSF2 		+= 		aDados[n,13]   
	   
	   
	If nLin > 3000
	oPrint:EndPage()	
	oPrint:StartPage()// Inicia página
	OPRINT:BOX(0100,0050,3300,2380)
	nLin := 050
	oPrint:Say(nLin,nCol1,"Filial",oFont1)
	oPrint:Say(nLin,nCol2,"Serie",oFont1)
	oPrint:Say(nLin,nCol3,"Nota",oFont1)
	oPrint:Say(nLin,nCol4,"Cliente",oFont1)
	oPrint:Say(nLin,nCol5,"Pref",oFont1)
	oPrint:Say(nLin,nCol6,"Num",oFont1)
	oPrint:Say(nLin,nCol7,"Parc",oFont1)
	oPrint:Say(nLin,nCol8,"Dt.Ocor",oFont1)
	oPrint:Say(nLin,nCol9,"Dt.Cred",oFont1)
	oPrint:Say(nLin,nCol10,"VL SE1",oFont1)
	oPrint:Say(nLin,nCol11,"VL Crg. SE1",oFont1)
	oPrint:Say(nLin,nCol12,"VL NF SE1",oFont1)
	oPrint:Say(nLin,nCol13,"VL SF2",oFont1)

	nLin := 130
	EndIf	

	next n 
	
	nLin += 0070
	oPrint:line(nLin,2380,nLin+10+115,2380)
	nLin += 0070
	oPrint:Say(nLin,nCol8,"Qtde.",oFont1) 	//QNTD SE1
	oPrint:Say(nLin,nCol9,"Valor SE1",oFont1) 	//VALOR SE1
	oPrint:Say(nLin,nCol10,"Valor Cor SE1",oFont1) 	//VALOR SE1
	oPrint:Say(nLin,nCol12,"Valor NFSE1",oFont1) //VALOR nf SF2
	oPrint:Say(nLin,nCol13,"Valor SF2",oFont1) //VALOR SF2
	nLin += 0070
	oPrint:Say(nLin,nCol8,Transform(_somaQnt,"@E 9,999,999",),oFont2) 	//QNTD SE1
	oPrint:Say(nLin,nCol9,Transform(_somaSE1,"@E 9,999,999.99",),oFont2) 	//VALOR SE1
	oPrint:Say(nLin,nCol10,Transform(_somaCoRSE1,"@E 9,999,999.99",),oFont2) 	//VALOR SE1
	oPrint:Say(nLin,nCol12,Transform(_somaNFSE1,"@E 9,999,999.99",),oFont2) //VALOR nf SF2
	oPrint:Say(nLin,nCol13,Transform(_somaSF2,"@E 9,999,999.99",),oFont2) //VALOR SF2
	
DBSELECTAREA("TEMP1")
TEMP1->(DBCLOSEAREA())
Return  

Static Function ValidPerg
LOCAL _AREA := GETAREA()
LOCAL AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
CPERG 	:= PADR(CPERG,10)

AADD(AREGS,{CPERG,"01","De Filial  ?  "," ?"," ?","MV_CH01","C",04,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{CPERG,"02","De Serie ?  "," ?"," ?","MV_CH02","C",04,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{CPERG,"03","Data Inicio  ?  "," ?"," ?","MV_CH03","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{CPERG,"04","Data Fim ?  "," ?"," ?","MV_CH04","D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})


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


