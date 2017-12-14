#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM  ºAutor  ³Everton Forti       º Data ³  29/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE para preencher o complemento das notas fiscais importaçãoº±±
±±º          ³ 											                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ligue						                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function SD1100I()

Local aArea:=GetArea()

Private cNumDoc := Space(20)
Private cNumDi := Space(20)
Private dDataDi := Date()
Private cLocal := Space(50)
Private cUF := Space(2)
Private dDtaDes := Date()
Private oCombo
Private cCombo
Private oCombo2
Private cCombo2

	
dbselectarea("SA2")
dbsetorder(1)
dbseek(XFILIAL("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)

If SA2->A2_EST == "EX"
				cCombo := "4" //- Via de transporte internacional informada na Declaração de Importação (DI)
				aItem := {"1=Marítima","2=Fluvial","3=Lacustre","4=Aérea","5=Postal","6=Ferroviária","7=Rodoviária","8=Conduto","9=Meios próprios","10=Entrada/Saída ficta","11=Courier","12=Handcarry"} // array com os itens
			
				cCombo2 := "4" //- Forma de Importação quanto a Intermediação
				aItem2 := {"1=Importação por conta própria","2=Importação por conta e ordem","3=Importação por encomenda"} // array com os itens
			
				DEFINE MSDIALOG ODLG2 TITLE "Dados da Importaçao" FROM 0, 0 TO 400,400  PIXEL
                
                @ 010,010 SAY "Doc. Imp" OF oDlg2 Pixel
                @ 010,080 GET cNumDoc SIZE 50, 9 PICTURE "@!"OF oDlg2 Pixel
 
                @ 030,010 SAY "No. da DI/DA" OF oDlg2 Pixel
                @ 030,080 GET cNumDi SIZE 50, 9 PICTURE "@!"OF oDlg2 Pixel
                
                @ 050,010 SAY "Registro DI" OF oDlg2 Pixel
                @ 050,080 GET dDataDi SIZE 50, 9 PICTURE "@D"OF oDlg2 Pixel
                
                @ 070,010 SAY "Descr. Local" OF oDlg2 Pixel
                @ 070,080 GET cLocal SIZE 50, 9 PICTURE "@!"OF oDlg2 Pixel
                               
                @ 090,010 SAY "UF Desembara" OF oDlg2 Pixel
                @ 090,080 GET cUF SIZE 50, 9 PICTURE "@!"OF oDlg2 Pixel
                
                @ 110,010 SAY "Dt Desembara" OF oDlg2 Pixel
                @ 110,080 GET dDtaDes SIZE 50, 9 PICTURE "@D"OF oDlg2 Pixel
                
                @ 130, 010 SAY oSay2 PROMPT "Via Trasnp: " SIZE 50, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
				  @ 130, 080 ComboBox oCombo Var cCombo Items aItem Size 085,09 Of oDlg2 Pixel 
                
                @ 150, 010 SAY oSay2 PROMPT "Forma intermediação: " SIZE 50, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
				  @ 150, 080 ComboBox oCombo2 Var cCombo2 Items aItem2 Size 085,09 Of oDlg2 Pixel 
                                                          
				@ 175,080 Button "Confirma" Size 35,10 PIXEL OF oDlg2 Action ( oDlg2:End()) 
      
                ACTIVATE MSDIALOG oDlg2 CENTERED

   	 //DbSelectArea("CD5")                                                         
	//DbSetOrder(4)
   //	DbSeek(SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
  //	While !EOF() //.And. SD1->D1_FILIAL = CD5->CD5_FILIAL .AND. SD1->D1_DOC = CD5->CD5_DOC .AND. SD1->D1_SERIE = CD5->CD5_SERIE .AND. SD1->D1_FORNECE = CD5->CD5_FORNEC .AND. SD1->D1_LOJA = CD5->CD5_LOJA .AND. SD1->D1_ITEM = CD5->CD5_ITEM
	
	 Reclock("CD5",.T.)
		CD5->CD5_FILIAL:= SD1->D1_FILIAL
		CD5->CD5_ITEM:= SD1->D1_ITEM
		CD5->CD5_DOC:= SD1->D1_DOC
		CD5->CD5_SERIE:= SD1->D1_SERIE                                   	
		CD5->CD5_ESPEC:= "SPED"
		CD5->CD5_FORNEC:= SD1->D1_FORNECE
		CD5->CD5_LOJA:= SD1->D1_LOJA
		CD5->CD5_TPIMP:= "0"
		CD5->CD5_DOCIMP:= cNumDoc
		CD5->CD5_DTPCOF:= Date()
		CD5->CD5_DTPPIS:= Date()
		CD5->CD5_NDI:= cNumDi
		CD5->CD5_DTDI:= dDataDi
		CD5->CD5_LOCDES:= cLocal
		CD5->CD5_UFDES:= cUF
		CD5->CD5_DTDES:= dDtaDes  
		CD5->CD5_SQADIC:="1"
		CD5->CD5_NADIC:= "00"
		CD5->CD5_BSPIS:= IF (EMPTY(SD1->D1_BASIMP6),0.01,SD1->D1_BASIMP6)
		CD5->CD5_ALPIS:= SD1->D1_ALQIMP6
		CD5->CD5_VLPIS:= IF (EMPTY(SD1->D1_VALIMP6),0.01,SD1->D1_VALIMP6)
		CD5->CD5_BSCOF:= IF (EMPTY(SD1->D1_BASIMP5),0.01,SD1->D1_BASIMP5)
		CD5->CD5_ALCOF:= SD1->D1_ALQIMP5
		CD5->CD5_VLCOF:= IF (EMPTY(SD1->D1_VALIMP5),0.01,SD1->D1_VALIMP5)
		CD5->CD5_ACDRAW:= "1"
		CD5->CD5_LOCAL:= "0"
		CD5->CD5_CODEXP:= SD1->D1_FORNECE 
		CD5->CD5_CODFAB:=SD1->D1_FORNECE
		CD5->CD5_VTRANS:=cCombo
		CD5->CD5_INTERM:=cCombo2
		CD5->CD5_NADIC:=cvaltochar(val(SD1->D1_ITEM))
		
  //		DBSKIP
//		ENDDO

	MsUnlock("CD5")

End if
RestArea(aArea)

Return()