#INCLUDE "F085CERTIVA.ch"      
#INCLUDE "Protheus.ch"      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  F085CERTIVA ºAutor  ³ Ana Paula Nascimento º Data ³ 26/09/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Certificado de IVA do Paraguai							   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F085CERTIVA(aCertImp)
Local cTitulo	:= STR0001
Local aNfs	:= {}
Local cChave
Local oPrint  
Local lExiste := .F.
Local nValRet := 0 
Local nTotRet := 0  
Local aRets := {}   
Local nX := 0
Local nValMerc := 0
Local nValImp := 0
Local cFornece:=""
Local cLoja:=""
Local dEmisCert
Local cCert := ""
Local cAliq:= ""
Local cNumOp:= ""
Local cDescCon := ""
Local cConceito := ""
Local nValOP := 0
Local nBsImpo:= 0
Local nRetMes := 0
Local nRetAnt:= 0
Local nTotVMer := 0   
Local nTotImp :=0  
Local nI := 0   
Local nBasImp := 0
Local nTotBas := 0

oPrint	:= TMSPrinter():New( cTitulo )
oPrint:SetPortrait() //Retrato
//oPrint:SetLandscape() //Paisagem


DbSelectArea("SFE")
DbSetOrder(9)
DbSeek(xFilial("SFE")+aCertImp[1][1]+"I")
cFornece:=SFE->FE_FORNECE
cLoja:=SFE->FE_LOJA
dEmisCert:=SFE->FE_EMISSAO 
nValRet := SFE->FE_RETENC
cCert := SFE->FE_NROCERT
cNumOp:= SFE->FE_ORDPAGO
While SFE->(!EOF() ).and. (xFilial("SFE")+cCert+"I") ==(SFE->FE_FILIAL+SFE->FE_NROCERT+SFE->FE_TIPO)
	nTotRet += SFE->FE_RETENC 
	Aadd(aRets,{SFE->FE_NFISCAL,SFE->FE_SERIE,SFE->FE_RETENC, SFE->FE_PARCELA, SFE->FE_ALIQ})	
	SFE->(DBSKIP())
EndDo    

cNumOp := SubStr(cNumOp,1,TamSX3("EK_ORDPAGO")[1])

DbSelectArea("SEK")
DbSetOrder(1)
DbSeek(xFilial("SEK")+cNumOp+"TB")
While SEK->(!EOF() ).and. (xFilial("SEK")+cNumOp+"TB") ==(SEK->EK_FILIAL+SEK->EK_ORDPAGO+SEK->EK_TIPODOC)
	nPos:=AScan(aRets,{|x| x[1]== SEK->EK_NUM .And. x[2]==SEK->EK_PREFIXO .And. x[4]==SEK->EK_PARCELA})
	Aadd(aRets[nPos],SEK->EK_FORNECE)
	Aadd(aRets[nPos],SEK->EK_LOJA)
	nValOP := SEK->EK_VALOR
	SEK->(DBSKIP()) 
EndDo

	For nX:=1 to Len(aRets)
		
		IF aRets[nX][3] < 0
			DbSelectArea("SF2")
			DbSetOrder(1)
	   		If DbSeek(xFilial("SF2")+aRets[nX][1]+aRets[nX][2]+Iif(Len(aRets[nX])>5,aRets[nX][6]+aRets[nX][7],""))
				nValMerc:= SF2->F2_VALMERC
				nTotVMer-= nValMerc   
				
				// Verifica qual o campo de impostos que esta sendo gravado o valor do IVA na nota
	  		 	aArea:=GetArea()
	   		  	dbSelectArea("SD2")
	   			SD2->(DbSetOrder(3))
	   		 	If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
				 	aImpInf := TesImpInf(SD2->D2_TES)
		   			nPos:= Ascan(aImpInf,{|x| x[1] == "IVA"})
					nValImp:=SF2->(FieldGet(FieldPos(aImpInf[nPos][06]))) 
	  			EndIf
	  			RestArea(aArea)
				nTotImp -= nValImp
				nPos:=AScan(aRets,{|x| x[1]== SF2->F2_DOC .And. x[2]==SF2->F2_SERIE .And. x[4]==aRets[nX][4]})
				Aadd(aRets[nPos],nValMerc*-1)
				Aadd(aRets[nPos],nValImp*-1)
				aADD(aRets[nPos],SF2->F2_ESPECIE)
			EndIf
		Else
			DbSelectArea("SF1")
			DbSetOrder(1)
			If DbSeek(xFilial("SF1")+aRets[nX][1]+aRets[nX][2]+Iif(Len(aRets[nX])>5,aRets[nX][6]+aRets[nX][7],""))
				nValMerc:= SF1->F1_VALMERC 
				nTotVMer+= nValMerc
			
				// Verifica qual o campo de impostos que esta sendo gravado o valor do IVA na nota
			 	aArea:=GetArea()
		  		dbSelectArea("SD1")
	   			SD1->(DbSetOrder(1))
			 	SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			   	Do while SD1->( ! EoF() .And. xFilial("SD1") == D1_FILIAL .And. SF1->F1_DOC == D1_DOC .And. ;
								SF1->F1_SERIE == D1_SERIE .And. SF1->F1_FORNECE == D1_FORNECE .And. ;
								SF1->F1_LOJA == D1_LOJA )
				 	aImpInf := TesImpInf(SD1->D1_TES)
					For nI := 1 To Len(aImpInf) 
						If "IV"$Trim(aImpInf[nI][01])					
							nValImp += SD1->( FieldGet( FieldPos( aImpInf[nI][02] ) ) ) 
							nBasImp += SD1->( FieldGet( FieldPos( aImpInf[nI][07] ) ) )
						EndIf
					Next nI     
					SD1->( dbSkip() )										
				EndDo
				RestArea(aArea)

				nTotImp += nValImp
				nTotBas += nBasImp // Total de valor sem IVA
				nPos:=AScan(aRets,{|x| x[1]== SF1->F1_DOC .And. x[2]==SF1->F1_SERIE .And. x[4]==aRets[nX][4]})
				Aadd(aRets[nPos],nBasImp)
				Aadd(aRets[nPos],nValImp) 
				aADD(aRets[nPos],SF1->F1_ESPECIE)
			EndIf	
		EndIF
	Next nX

                              

PrintPag( oPrint,cFornece,cLoja,dEmisCert,cNumOp,cCert,nTotRet,aRets,nTotImp,nTotBas)

oPrint:Preview()





Return

Static Function PrintPag( oPrint,cFornece,cLoja,dEmisCert,cNumOp,cCert,nTotRet,aRets,nTotImp,nTotVMer)

Local oFont1	:= TFont():New("Arial",15,15,,.T.,,,,.T.,.F.)
Local oFont2	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
Local oFont3	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)
Local oFont4	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Local oFont5	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
Local Ni:= 0

dDataCert:=StrZero(Day(dEmisCert),2) + " " + STR0002 + " " + MesExtenso(Month(dEmisCert)) + " " + STR0002 + " "  + Alltrim(Str(Year(dEmisCert)))
SX5->(DbSeek(xFilial()+"12"+SM0->M0_ESTENT))
cProvEmp:=Alltrim(X5Descri())


oPrint:StartPage()

//Cabeçalho
oPrint:Box(0150,050,0450,1250)  

oPrint:Box(0150,1250,0450,2300)  

oPrint:Say(0170,0140,Alltrim(SM0->M0_NOMECOM),oFont1)
oPrint:Say(0325,0190,Alltrim(SM0->M0_ENDENT)+" - " + cProvEmp,oFont2)

oPrint:Say(0166,1550,STR0003 + cTimbrado,oFont2)
oPrint:Say(0215,1550,STR0004 + Dtoc(dDtValTim),oFont2)
oPrint:Say(0263,1550,STR0005,oFont3)
oPrint:Say(0260,1650,transf(SM0->M0_CGC,pesqpict("SA2","A2_CGC")),oFont3) 
oPrint:Say(0320,1485,STR0006,oFont3)
oPrint:Say(0390,1600,Transf(cCert,"@e 999-999-9999999") ,oFont3)



oPrint:box(0450,050,0565,2300) 	
oPrint:Say(0465,0100,STR0007,oFont4)
oPrint:Say(0465,0220,dDataCert,oFont4) 
oPrint:Line(0510,070,0510,2250)                                         

// Dados do Fornecedor
DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2") + cFornece + cLoja)  
cNome:=SA2->A2_NOME
cCUITForn:=Transf(SA2->A2_CGC,pesqpict("SA2","A2_CGC"))
cEnd := SA2->A2_END

SX5->(DbSeek(xFilial()+"12"+SA2->A2_EST))
cProvForn:=Alltrim(X5Descri())


oPrint:Say(0520,0100,STR0008,oFont4)
oPrint:Say(0520,0795,cNome,oFont4)  


oPrint:Say(0520,1440,STR0009,oFont4)
oPrint:Say(0520,1940,cCUITForn,oFont4)	


oPrint:box(0565,050,0625,0610) 
oPrint:Say(0580,0150,STR0010,oFont4)

oPrint:box(0565,0610,0625,1000)
oPrint:Say(0580,0660,STR0011,oFont4)

oPrint:box(0565,1000,0625,1400)                                    
oPrint:Say(0580,1150,STR0012,oFont4) 

oPrint:box(0565,1400,0625,1790)                                      
oPrint:Say(0580,1450,STR0013,oFont4) 

oPrint:box(0565,1790,0625,1980)   
oPrint:Say(0580,1800,STR0014,oFont4)

oPrint:box(0565,1980,0625,2300)  
oPrint:Say(0580,2095,STR0015,oFont4)

nLin:=0625

For nI:= 1 To Len(aRets)    
	
	dbSelectArea("SX5")
	If dbSeek(cFilial+"05"+aRets[nI][10])
		#IFDEF ENGLISH
			cTipoDoc:= Alltrim(X5_DESCENG)
		#ELSE
			#IFDEF SPANISH
				cTipoDoc:= Alltrim(X5_DESCSPA)
			#ELSE
				cTipoDoc:= Alltrim(X5_DESCPOR)
			#ENDIF
		#ENDIF
    EndIf
	oPrint:box(nLin,050,nLin+69,0610) 
 	oPrint:box(nLin,0610,nLin+69,1000)
 	oPrint:box(nLin,1000,nLin+69,1400)
 	oPrint:box(nLin,1400,nLin+69,1790)
 	oPrint:box(nLin,1790,nLin+69,1980)
	oPrint:box(nLin,1980,nLin+69,2300)

	oPrint:Say( nLin+10,070,Capital(SubStr(cTipoDoc,1,15)) + "-" +aRets[nI,1],oFont4) // Numero e Tipo de Titulo
	oPrint:Say( nLin+10,0630,Transform(aRets[nI,8],"@E 999,999,999.99"),oFont4)	// Valor Sem IVA
	oPrint:Say( nLin+10,0965,Transform(aRets[nI,9],"@E 999,999,999.99"),oFont4)	// Valor do IVA
	oPrint:Say( nLin+10,1365,Transform(aRets[nI,8]+aRets[nI,9],"@E 999,999,999.99"),oFont4)	// VAlor total
	oPrint:Say( nLin+10,1760,Transform(aRets[nI,5],"@E 999,999,999.99"),oFont4)	// Aliquota da retenção do IVA
	oPrint:Say( nLin+10,1990,Transform(aRets[nI,3],"@E 999,999,999.99"),oFont4)	// Valor da retenção do IVA

    nLin+=69
Next 
                                                                                
   	oPrint:box(nLin,050,nLin+69,0610) 					
 	oPrint:box(nLin,0610,nLin+69,1000) 
 	oPrint:box(nLin,1000,nLin+69,1400) 
 	oPrint:box(nLin,1400,nLin+69,1790)
 	oPrint:box(nLin,1790,nLin+69,1980) 
	oPrint:box(nLin,1980,nLin+69,2300)  
				
	oPrint:Say( nLin+10,070,STR0016,oFont5) // Serie
	oPrint:Say( nLin+10,0630,Transform(nTotVMer,"@E 999,999,999.99"),oFont5)	// Valor Sem IVA
	oPrint:Say( nLin+10,0965,Transform(nTotImp,"@E 999,999,999.99"),oFont5)	// Valor do IVA
	oPrint:Say( nLin+10,1365,Transform(nTotVMer+nTotImp,"@E 999,999,999.99"),oFont5)	// VAlor total
	oPrint:Say( nLin+10,1990,Transform(nTotRet,"@E 999,999,999.99"),oFont5)	// Valor do IVA
  
aCert:= {}
oPrint:EndPage()

Return
