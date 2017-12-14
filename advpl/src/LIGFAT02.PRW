#INCLUDE "RWMAKE.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "FWPrintSetup.ch"
#include "ap5mail.ch"
#INCLUDE "RPTDEF.CH"

/*                                                           
DESCRIÇÃO: FUNÇÃO PRA IMPRIMIR O DEMONSTRATIVO E O BOLETO
AUTOR:     DANIEL GOUVEA
DATA:      21/05/2014
CLIENTE:   LIGUE TELECOM      

PARAMETROS
_PPREF 	: PREFIXO SE1
_PNUM	: NUMERO SE1
_PPARC	: PARCELA SE1
_PTIPO	: TIPO SE1
_CCLIENTE : CLIENTE SE1
_CLOJA	: LOJA SE1
_ATITULOS : RELACAO DE TITULOS QUE DEVE SER IMPRESSO
_CPATH	: DIRETORIO ONDE DEVE SER GERADO O ARQUIVO PDF
_lview	: FAZ OU NAO O PREVIEW NO FIM DA IMPRESSAO (.T./F.)
*/

User function LIGFAT02(_PPREF, _PNUM, _PPARC, _PTIPO, _CCLIENTE, _CLOJA, _ATITULOS, _CPATH, _LVIEW)                   
Private _par1 := _PPREF                                                        
Private _titulos := _ATITULOS 
Private _caminho := _CPATH 
Private _view := _LVIEW

IF TYPE("_titulos")=="U"
	_ATITULOS := {}
ENDIF          

IF TYPE('_par1')=="U"
	_PPREF 	:= SE1->E1_PREFIXO
	_PNUM	:= SE1->E1_NUM
	_PPARC	:= SE1->E1_PARCELA
	_PTIPO	:= SE1->E1_TIPO 
	_CCLIENTE := SE1->E1_CLIENTE
	_CLOJA  := SE1->E1_LOJA  
ENDIF                        

IF TYPE("_titulos")=="U"
	AADD(_ATITULOS,{_PPREF, _PNUM, _PPARC, _PTIPO, _CCLIENTE, _CLOJA})
ENDIF
                          
IF TYPE("_caminho")=="U"                   
	_caminho := gettemppath()
ENDIF

IF TYPE("_view")=="U"
	_LVIEW := .T.
ENDIF
	
_nome := _CCLIENTE+_CLOJA+"_"+_PPREF+_PNUM+_PPARC+_PTIPO
oPrint:= FWMSPrinter():New(_nome,6,.t.,_caminho,.T.,,,,,,,_LVIEW)
	
oPrint:SetPortrait()	// ou SetLandscape()
oPrint:SetMargin(1,1,1,1)
oPrint:cPathPDF := _caminho

FOR _I:=1 TO LEN(_ATITULOS)

	oPrint:StartPage()

	_PPREF := _ATITULOS[_I,1]
	_PNUM  := _ATITULOS[_I,2]
	_PPARC := _ATITULOS[_I,3]
	_PTIPO := _ATITULOS[_I,4]
	_CCLIENTE := _ATITULOS[_I,5]
	_CLOJA := _ATITULOS[_I,6]
	
	dbselectarea("SE1")
	dbsetorder(1)//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	if dbseek(XFILIAL("SE1")+_PPREF+PADR(_PNUM,9)+_PPARC+_PTIPO+_CCLIENTE+_CLOJA)
		dbselectarea("SA1")
		dbsetorder(1)
	    if dbseek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
			dbselectarea("ADA")
			dbsetorder(1)//ADA_FILIAL+ADA_NUMCTR
			if dbseek(xFilial()+LEFT(SE1->E1_NUM,6))
				dbselectarea("SZ1")
				dbsetorder(1)//Z1_FILIAL+Z1_PREFIXO+Z1_NUM+Z1_PARCELA+Z1_TIPO+Z1_CATEG+Z1_COD
				if dbseek(xFilial()+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
					_dadosbanco := alltrim(getmv("MV_UBCOBOL"))
					_banco      := substr(_dadosbanco,1,3)
					_agencia    := substr(_dadosbanco,4,5)
					_conta      := substr(_dadosbanco,9,10)
					_subconta   := substr(_dadosbanco,19,3)
					dbselectarea("SA6")
					dbsetorder(1)//A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
					if dbseek(xFilial()+_banco+_agencia+_conta)
						dbselectarea("SEE")
						dbsetorder(1)
						if dbseek(xFilial()+_banco+_agencia+_conta+_subconta)
							IF SE1->E1_PORTADO == SEE->EE_CODIGO .AND. SE1->E1_AGEDEP == SEE->EE_AGENCIA .AND. SE1->E1_CONTA == SEE->EE_CONTA
								LIGFAT02()
							ENDIF
						endif
					endif
					
				endif
			endif 
		ENDIF
	endif                                                
	
	oPrint:EndPage()
	
NEXT _I                                                  

oPrint:Print()

RETURN

STATIC FUNCTION LIGFAT02()
//                                      TAM   BOLD        SUB   ITA
//                           1         2 3    4   5 6 7 8 9 10  11
Local oFont9  := TFont():New("Arial", ,9 , ,.F., , , , , ,.F.,.F.)
Local oFont9b := TFont():New("Arial", ,9 , ,.T., , , , , ,.F.,.F.)
Local oFont10 := TFont():New("Arial", ,10, ,.F., , , , , ,.F.,.F.)
Local oFont10b:= TFont():New("Arial", ,10, ,.T., , , , , ,.F.,.F.)
Local oFont11 := TFont():New("Arial", ,11, ,.F., , , , , ,.F.,.F.)
Local oFont11b:= TFont():New("Arial", ,11, ,.T., , , , , ,.F.,.F.)
Local oFont12 := TFont():New("Arial", ,12, ,.F., , , , , ,.F.,.F.)
Local oFont12b:= TFont():New("Arial", ,12, ,.T., , , , , ,.F.,.F.)
Local oFont14 := TFont():New("Arial", ,14, ,.F., , , , , ,.F.,.F.)
Local oFont14b:= TFont():New("Arial", ,14, ,.T., , , , , ,.F.,.F.)

	nLin := 80  
	
	_dVencto := IIF(SE1->E1_VENCTO>DDATABASE,SE1->E1_VENCTO,DDATABASE)   
	
	oPrint:say(nLin,900,"DETALHAMENTO DA FATURA",oFont14b )
	
	//oPrint:SayBitmap(nLin,100,"logo.bmp",nLin+195.2,50+199.2)
	
	//oPrint:Box( nLin-30, 1680, nLin+10+(28*3), 2300)
	oPrint:say(nLin,1700,"Ligue Telecom",oFont10 )
	nLin+=28
	oPrint:say(nLin,1700,"Rua Mato Grosso, 1780 - CENTRO (44) 3810-0000",oFont9 )
	nLin+=28
	oPrint:say(nLin,1700,"CEP 873000-400 - Campo Mourão/PR",oFont9 )
	nLin+=28
	oPrint:say(nLin,1700,"financeiro@liguetelecom.com.br - www.liguetelecom.com.br",oFont9 )
	nLin+=30
	
	//_lin3 := "CEP "+TRANSFORM(SA1->A1_CEP,PESQPICT("SA1","A1_CEP"))+" "+ALLTRIM(SA1->A1_MUN)+"/"+ALLTRIM(SA1->A1_EST)
	_lin3 := "CEP "+TRANSFORM(ADA->ADA_UCEP,PESQPICT("ADA","ADA_UCEP"))+" "+ALLTRIM(ADA->ADA_UMUN)+"/"+ALLTRIM(ADA->ADA_UEST)
	
	
	_a := len(ALLTRIM(SA1->A1_NOME))
	//_b := len(ALLTRIM(SA1->A1_END)) 
	_cEND := ALLTRIM(ADA->ADA_UEND) + ", N " + ALLTRIM(ADA->ADA_UNUM)
	_cBairro := ALLTRIM(ADA->ADA_UBAIRR)	
	
	if empty(ALLTRIM(ADA->ADA_UEND)) //TRECHO PRA PEGAR DO SA1 SE NO ADA ESTIVER VAZIO
		_cEND := ALLTRIM(SA1->A1_END)  
		_lin3 := "CEP "+TRANSFORM(SA1->A1_CEP,PESQPICT("SA1","A1_CEP"))+" "+ALLTRIM(SA1->A1_MUN)+"/"+ALLTRIM(SA1->A1_EST)
		_cBairro := alltrim(SA1->A1_BAIRRO)
	endif	
	
	if !empty(ALLTRIM(ADA->ADA_UIDAGA)) //TRECHO PRA PEGAR DO SA1 SE NO ADA ESTIVER VAZIO
		dbselectarea("AGA")
		dbsetorder(2) //AGA_FILIAL+AGA_ENTIDA+AGA_CODENT
		if dbseek(xFilial()+ADA->ADA_UIDAGA)
			_cEND := ALLTRIM(AGA->AGA_END)
			_lin3 := "CEP "+TRANSFORM(AGA->AGA_CEP,PESQPICT("SA1","A1_CEP"))+" "+ALLTRIM(AGA->AGA_MUNDES)+"/"+ALLTRIM(AGA->AGA_EST) 		
			_cBairro := alltrim(AGA->AGA_BAIRRO)		
		endif
	endif
	
	_b := len(ALLTRIM(_cEND))
	_a := max(_a,_b)
	_b := len(_lin3)
	_a := max(_a,_b)
	
	oPrint:Box(nLin-30,635, nLin+15+(35*3), 635+25*_a)
	oPrint:say(nLin ,650,ALLTRIM(SA1->A1_NOME),oFont11 )
	//oPrint:say(nLin+35 ,650,ALLTRIM(SA1->A1_END),oFont11 )
   //	oPrint:say(nLin+70 ,650,ALLTRIM(SA1->A1_BAIRRO),oFont11 )
	oPrint:say(nLin+35 ,650,SUBSTR(_cEND,1,50),oFont11 )
	oPrint:say(nLin+70 ,650,ALLTRIM(SUBSTR(_cEND,51,50))+" "+_cBairro,oFont11 )
	oPrint:say(nLin+105 ,650,_lin3,oFont11 )	
	
	oPrint:Box(nLin, 1700, nLin+10+115, 2280)
	oPrint:say(nLin+35 ,1720,"Data de Vencimento",oFont9 )
	oPrint:say(nLin+35 ,1970,"Total a Pagar",oFont9 )
	oPrint:line(nLin,1950,nLin+10+115,1950)
	oPrint:say(nLin+80 ,1720,DTOC(_dVencto),oFont11 )
	oPrint:say(nLin+80 ,1970,"R$ "+TRANSFORM(SE1->E1_VALOR,PESQPICT("SE1","E1_VALOR")),oFont11 )
	
	nLin+=140 //4 linhas 
	
	oPrint:line(370,150,370,2300)
	nLin := 20000
	nCol := -1000
	_nTot := 0
	while !eof() .and. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==;
		SZ1->Z1_FILIAL+SZ1->Z1_PREFIXO+SZ1->Z1_NUM+SZ1->Z1_PARCELA+SZ1->Z1_TIPO
		
		FAT02A()
		
		_cat := SZ1->Z1_CATEG
		oPrint:say(nLin ,130+nCol,POSICIONE("SBM",1,XFILIAL("SBM")+SZ1->Z1_CATEG,"BM_DESC"),oFont12 )
		nLin+=40
		_nTotParc := 0
		while !eof() .and. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==;
			SZ1->Z1_FILIAL+SZ1->Z1_PREFIXO+SZ1->Z1_NUM+SZ1->Z1_PARCELA+SZ1->Z1_TIPO .and. _cat==SZ1->Z1_CATEG
			
			FAT02A()
			
			oPrint:say(nLin ,150+nCol,ALLTRIM(SZ1->Z1_DESC),oFont10)
			oPrint:say(nLin ,600+nCol,TRANSFORM(SZ1->Z1_QUANT,PESQPICT("SZ1","Z1_QUANT")),oFont9)
			oPrint:say(nLin ,725+nCol,TRANSFORM(SZ1->Z1_VALOR,PESQPICT("SZ1","Z1_VALOR")),oFont9)
			oPrint:say(nLin ,850+nCol,TRANSFORM(SZ1->Z1_TOTAL,PESQPICT("SZ1","Z1_TOTAL")),oFont9)
			nLin+=40
			_nTot += SZ1->Z1_TOTAL
			_nTotParc += SZ1->Z1_TOTAL
					
			dbselectarea("SZ1")
			dbskip()
		enddo		
		oPrint:say(nLin ,850+nCol,TRANSFORM(_nTotParc,PESQPICT("SZ1","Z1_TOTAL")),oFont9)
		oPrint:line(nLin+10,130+nCol,nLin+10,1000+nCol)	
		nLin += 40
		dbselectarea("SZ1")
	enddo			
	nLin+=20	
	oPrint:say(nLin ,150+nCol,"TOTAL .................................................. ",oFont11b)
	oPrint:say(nLin ,850+nCol,ALLTRIM(TRANSFORM(_nTot,PESQPICT("SZ1","Z1_TOTAL"))),oFont11b)
	
		
	oPrint:line(1670,150,1670,2300)
	nLin := 1700
	oPrint:say(nLin ,150,oemtoansi("O detalhamento da fatura encontra-se disponível no portal do cliente. As notas fiscais e os boletos correspondentes à prestação do serviço estão disponíveis para download no portal do cliente. Para acessar "),oFont9)
	nLin += 30
	oPrint:say(nLin ,150,oemtoansi("o Portal do Cliente: http://portal.liguetelecom.com.br/"),oFont9)
	nLin += 30
	oPrint:say(nLin ,150,oemtoansi("Para se cadastrar clique em 'Ainda não é cadastrado' e insira os dados do contratante dos serviços. No campo código do cliente, utilize o numero chave: ")+ALLTRIM(ADA->ADA_UNRCOB),oFont9)
	nLin += 40
	oPrint:say(nLin ,150,oemtoansi("Após 10(dez) dias vencido, implicará no corte imediato do serviço de INTERNET e 30 (trinta) dias para o serviço de TELEFONE."),oFont9)
	nLin += 30
	oPrint:say(nLin ,150,oemtoansi("Informamos que após o bloqueio, para a religação dos serviços de INTERNET/TELEFONE será cobrado uma taxa de R$ 29,90 na próxima fatura, com um prazo de até 24 (vinte e quatro) horas. Para religação"),oFont9)
	nLin += 30
	oPrint:say(nLin ,150,oemtoansi("emergencial, no prazo de até 1(uma) hora, a taxa será de 49,90. "),oFont9)
	nLin += 40
	oPrint:say(nLin ,150,oemtoansi("Para maiores informações sobre sua fatura entre em contato pelo email: financeiro@liguetelecom.com.br ou pelo telefone: (44) 3810-0000 e tecle a opção 4 para falar com o setor financeiro."),oFont9)
	
	
	oPrint:line(1920,150,1920,2300)
	
	IF GETMV("MV_UDTCART") > SE1->E1_EMISSAO
		_cart := "06" 
		_cFatorVcto := "0000"
	ELSE
		_cart := "09"  		
		_cFatorVcto := Str((_dVencto - Ctod("07/10/1997")),4)
	ENDIF
	
	_nValorTit  := SE1->E1_SALDO  
	IF ddatabase>SE1->E1_VENCREA
		_nValorTit += NOROUND(SE1->E1_SALDO*(2/100),2) //2% DE MULTA
		_nValorTit += ROUND(SE1->E1_SALDO*(ddatabase-SE1->E1_VENCREA)*SE1->E1_PORCJUR/100,2) //JUROS 1% AO DIA
	ENDIF
	if EMPTY(SE1->E1_NUMBCO)
		cNossoNum := StrZero(Val(SEE->EE_FAXATU)+1,11,0)
		RecLock("SEE",.F.)
		SEE->EE_FAXATU := cNossoNum
		MsUnlock()
	else
		cNossoNum := SUBSTR(SE1->E1_NUMBCO,3,11)
	endif
		
		_auxValor :=_nValorTit*100		
		_cCodBar  := SA6->A6_COD+'9'+_cFatorVcto+STRZERO(_auxValor,10)		
		cDgV      := NNDgV(ALLTRIM(SEE->EE_CODCART) + cNossoNum) // DIGITO EM MODULO 11
		_cCodBar  += STRZERO(val(ALLTRIM(SA6->A6_AGENCIA)),4)+_cart+cNossoNum
		_cCodBar  += STRZERO(val(ALLTRIM(SA6->A6_NUMCON)),7)+'0' 
		
		_cCodBar  := SUBSTR(_cCodBar,1,4) + BarraDgV(_cCodBar) + SUBSTR(_cCodBar,5,44)
		
		_cLinhaD  := montalinha(_cCodBar)
		
		// composição campo livre bradesco
		// 20 a 23 - 04 - Agencia cedente (sem dv, completar com zeros a esquerda se necessário)
		// 24 a 25 - 02 - Carteira
		// 26 a 36 - 11 - nosso numero sem dv
		// 37 a 43 - 07 - conta do cedente (sem dv, completar com zeros a esquerda se necessário)
		// 44 a 44 - 01 - zero    
		_numbco := _cart+right(cNossoNum,11)+NNDgV(_cart+cNossoNum)
		RecLock("SE1",.F.)
		SE1->E1_NUMBCO  := _numbco
		SE1->E1_UCODBAR := _cCodBar
		SE1->E1_ULINDIG := _cLinhaD
		SE1->E1_PORTADO := SA6->A6_COD
		SE1->E1_AGEDEP  := SA6->A6_AGENCIA
		SE1->E1_CONTA   := SA6->A6_NUMCON
		SE1->E1_IDCNAB  := right(_numbco,9)
		msunlock()
		
	aBolText := {"","","","","",""}
	_n := 1    
	aBolText[_n] := "EVITE A SUSPENSÃO DO SERVIÇO PAGANDO SEU BOLETO EM DIA."  
	_n++  
	aBolText[_n] := "APÓS VENCIMENTO MULTA DE 2% E JUROS DE 1% AO MÊS."  
	_n++
	aBolText[_n] := ""  
	_n++
  /*	if SE1->E1_PORCJUR>0
		aBolText[_n] := "Aceitar pagamento após o vencimento da fatura."
		_n++
	endif
	if !empty(SEE->EE_UMSG1)
		aBolText[_n] := alltrim(SEE->EE_UMSG1)
		_n++
	endif
	if !empty(SEE->EE_UMSG2)
		aBolText[_n] := alltrim(SEE->EE_UMSG2)
		_n++
	endif     */
	
	aDadosTit := {}
	aadd(aDadosTit,AllTrim(SE1->E1_NUM)+"-"+AllTrim(SE1->E1_PARCELA))	// [1] Número do título
	aadd(aDadosTit,ConvDT4(SE1->E1_EMISSAO)) 							// [2] Data da emissão do título
	aadd(aDadosTit,ConvDT4(DDATABASE))				  					// [3] Data da emissão do boleto
	aadd(aDadosTit,ConvDT4(_dVencto))							  	// [4] Data do vencimento
	aadd(aDadosTit,_nValorTit)											// [5] Valor do título	
	aadd(aDadosTit,alltrim(SE1->E1_NUMBCO)) 							// [6] Nosso número
	aadd(aDadosTit,SE1->E1_PREFIXO)										// [7] Prefixo
	aadd(aDadosTit,SE1->E1_TIPO)
	
	cLogoBco := "bradesco.bmp"

	nRow3 := 0 //-180
	oPrint:line(nRow3+2000,100,nRow3+2000,2300)
	oPrint:line(nRow3+2000,500,nRow3+1920, 500)
	oPrint:line(nRow3+2000,710,nRow3+1920, 710)
	
	oPrint:SayBitmap(nRow3+1935,0100,cLogoBco,188,63)

	oPrint:say(nRow3+1975,513,SA6->A6_COD+"-"+SA6->A6_UDGCOD,oFont14b )	// 	[1]Numero do Banco
	oPrint:say(nRow3+1975,755,ALLTRIM(SE1->E1_ULINDIG),oFont14b)			//	Linha Digitavel do Codigo de Barras
	                                                                                                       
	oPrint:line(nRow3+2060,100,nRow3+2060,2300 )
	oPrint:line(nRow3+2120,100,nRow3+2120,2300 )
	oPrint:line(nRow3+2180,100,nRow3+2180,2300 )
	oPrint:line(nRow3+2240,100,nRow3+2240,2300 )
	
	oPrint:line(nRow3+2120,500 ,nRow3+2240,500 )
	oPrint:line(nRow3+2180,750 ,nRow3+2240,750 )
	oPrint:line(nRow3+2180,1000,nRow3+2240,1000)
	oPrint:line(nRow3+2120,1300,nRow3+2180,1300)
	oPrint:line(nRow3+2120,1480,nRow3+2240,1480)
	
	oPrint:say(nRow3+2030,100 ,"Local de Pagamento",oFont9)
	oPrint:say(nRow3+2052,100 ,"PAGÁVEL PREFERENCIALMENTE NA REDE BRADESCO OU BRADESCO EXPRESSO",oFont9)
	
	oPrint:say(nRow3+2030,1810,"Vencimento",oFont9)
	cString := aDadosTit[4]
	nCol	:= 1810+(374-(len(cString)*22))
	oPrint:say(nRow3+2050,nCol,cString,oFont11)
	
	oPrint:say(nRow3+2080,100 ,"Beneficiário",oFont9)
	oPrint:say(nRow3+2107,100 ,"LIGUE TELECOMUNICAÇÕES LTDA - CNPJ : 10.442.435/0001-40 - ENDEREÇO: RUA MATO GROSSO, 1780 - CAMPO MOURÃO - PR",oFont9) //Nome + CNPJ
	
	oPrint:say(nRow3+2080,1810,"Agência/Código Beneficiário",oFont9)
	cString := STRZERO(VAL(Alltrim(SEE->EE_AGENCIA)),5)+"-"+SEE->EE_DVAGE+"/"+STRZERO(VAL(ALLTRIM(SA6->A6_NUMCON)),7)+"-"+ALLTRIM(SA6->A6_DVCTA)
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:say(nRow3+2105,nCol,cString ,oFont11)
	
	
	oPrint:say(nRow3+2140,100 ,"Data do Documento",oFont9)
	oPrint:say(nRow3+2165,100, aDadosTit[2], oFont10)
	
	oPrint:say(nRow3+2140,505 ,"Nro.Documento",oFont9)
	oPrint:say(nRow3+2165,605 ,aDadosTit[7]+"-"+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
	
	oPrint:say(nRow3+2140,1005,"Espécie Doc.",oFont9)
	oPrint:say(nRow3+2165,1050,"DM",oFont10) //Tipo do Titulo
	
	oPrint:say(nRow3+2140,1305,"Aceite",oFont9)
	oPrint:say(nRow3+2165,1400,"N",oFont10)
	
	oPrint:say(nRow3+2140,1485,"Data do Processamento",oFont9)
	oPrint:say(nRow3+2165,1550,aDadosTit[3],oFont10) // Data impressao
	
	oPrint:say(nRow3+2140,1810,"Nosso Número",oFont9)
	cString := Alltrim(aDadosTit[6])
	oPrint:say(nRow3+2165,nCol,substr(cString,2,1)+"/"+substr(cString,3,11)+"-"+substr(cString,14,1),oFont11)
	
	oPrint:say(nRow3+2200,100 ,"Uso do Banco"                                   ,oFont9)

	oPrint:say(nRow3+2200,505 ,"Carteira"                                       ,oFont9)
	oPrint:say(nRow3+2225,555 ,_cart                       	,oFont10)
	
	oPrint:say(nRow3+2200,755 ,"Espécie"                                        ,oFont9)
	oPrint:say(nRow3+2225,805 ,"R$"                                             ,oFont10)
	
	oPrint:say(nRow3+2200,1005,"Quantidade"                                     ,oFont9)
	
	oPrint:say(nRow3+2200,1485,"Valor"                                          ,oFont9)
	
	oPrint:say(nRow3+2200,1810,"Valor do Documento"                          	,oFont9)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:say(nRow3+2225,nCol,cString,oFont11)
	
	
	oPrint:say(nRow3+2260,100 ,"Instruções (Texto de responsabilidade do cedente)",oFont9)
	oPrint:say(nRow3+2320,100 ,(aBolText[1]),oFont9)
	oPrint:say(nRow3+2380,100 ,(aBolText[2]),oFont9)
	oPrint:say(nRow3+2440,100 ,(aBolText[3]),oFont9)
	oPrint:say(nRow3+2500,100 ,(aBolText[4]),oFont9)
	oPrint:say(nRow3+2560,100 ,(aBolText[5]),oFont9)
	
	oPrint:say(nRow3+2260,1810,"(-)Desconto/Abatimento"                         ,oFont9)
	oPrint:say(nRow3+2320,1810,"(-)Outras Deduções"                             ,oFont9)
	oPrint:say(nRow3+2380,1810,"(+)Mora/Multa"                                  ,oFont9)
	oPrint:say(nRow3+2440,1810,"(+)Outros Acréscimos"                           ,oFont9)
	oPrint:say(nRow3+2500,1810,"(=)Valor Cobrado"                               ,oFont9)
	
	oPrint:say(nRow3+2560,100 ,"Pagador"                                         ,oFont9)
	oPrint:say(nRow3+2580,400 ,AllTrim(SA1->A1_NOME)+" ("+AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA+")"             ,oFont10)
	
	if SA1->A1_PESSOA = "J"
		oPrint:say(nRow3+2580,1750,"CNPJ: "+TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:say(nRow3+2580,1750,"CPF: "+TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf
	
	oPrint:say(nRow3+2630,400 ,AllTrim(SA1->A1_END)+" -"+AllTrim(SA1->A1_BAIRRO)     ,oFont10)
	oPrint:say(nRow3+2680,400 ,SA1->A1_CEP+"    "+SA1->A1_MUN+" - "+SA1->A1_EST,oFont10) // CEP+Cidade+Estado
	//oPrint:Say(nRow3+2836,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)
	
	oPrint:say(nRow3+2720,100 ,"Sacador/Avalista"                               ,oFont9)
	oPrint:say(nRow3+2720,1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont9)
	
	oPrint:line(nRow3+2000,1800,nRow3+2540,1800 )
	oPrint:line(nRow3+2300,1800,nRow3+2300,2300 )
	oPrint:line(nRow3+2360,1800,nRow3+2360,2300 )
	oPrint:line(nRow3+2420,1800,nRow3+2420,2300 )
	oPrint:line(nRow3+2480,1800,nRow3+2480,2300 )
	oPrint:line(nRow3+2540,100 ,nRow3+2540,2300 )
	
	oPrint:line(nRow3+2700,100,nRow3+2700,2300  )
	
	oPrint:Code128c(nRow3+2950, 100, SE1->E1_UCODBAR, 47)
//	cRecicle := "recicle.bmp"
//	oPrint:SayBitmap(nRow3+2750,2000,cRecicle,168,195)
	
return

STATIC FUNCTION FAT02A()
Local oFont10 := TFont():New("Arial", ,10, ,.F., , , , , ,.F.,.F.)
Local oFont11 := TFont():New("Arial", ,11, ,.F., , , , , ,.F.,.F.)

	if nLin>1700
			nLin := 400
			nCol+=1000
			oPrint:say(nLin ,300+nCol,"DETALHAMENTO DOS SERVIÇOS COBRADOS",oFont11 )  
			  
		//	cBanner := "banner.jpg"
		//	oPrint:SayBitmap(nLin,1100,cBanner,1048,1205)
			
			nLin+=35
			dbselectarea("SZ1")
			oPrint:say(nLin ,150+nCol,"Descrição",oFont10)
			oPrint:say(nLin ,650+nCol,"Quant",oFont10)
			oPrint:say(nLin ,775+nCol,"Valor",oFont10)
			oPrint:say(nLin ,900+nCol,"Total",oFont10)
			nLin+=40		
   endif
RETURN

static function NNDgV(_cNNum)

_nDgV := ''
	nCont   := 0
	nPeso   := 2
	cBoleta := _cNNum
	_nDgV   := ''
	
	For i := 13 To 1 Step -1
		nCont := nCont + (Val(SUBSTR(cBoleta,i,1))) * nPeso
		nPeso += 1
		If nPeso == 8
			nPeso := 2
		Endif
	Next
	nResto := (nCont % 11)
	Do Case
		Case nResto == 1
			_nDgV := "P"
		Case nResto == 0
			_nDgV := "0"
		OtherWise
			nResto := (11 - nResto)
			_nDgV := AllTrim(Str(nResto))
	EndCase
	
Return(_nDgV)

//Calculo do Digito do Codigo de Barras
Static Function BarraDgV(_cCodB)

cDV_BARRA := ''

nCont := 0
nPeso := 2
For i := 43 To 1 Step -1
	nCont := nCont + (Val(SUBSTR(_cCodB,i,1)) * nPeso )
	nPeso := nPeso + 1
	If nPeso == 10
		nPeso := 2
	Endif
Next
nResto  := (nCont % 11 )
nResult := (11 - nResto)
Do Case
	Case nResult == 10 .or. nResult == 11
		cDV_BARRA := "1"
	OtherWise
		cDV_BARRA := Str(nResult,1)
EndCase


Return(cDV_BARRA)

Static Function MontaLinha(_cCodB)
_cLineDig   := ""
_cPedaco    := ""

//Primeiro Campo
//Codigo do Banco + Moeda + 5 primeiras posições do campo livre do Cod Barras
_cPedaco := Substr(_cCodB,01,03) + Substr(_cCodB,04,01) + Substr(_cCodB,20,5)
_cLineDig := Substr(_cCodB,1,3)+Substr(_cCodB,4,1)+Substr(_cCodB,20,1)+"."+;
Substr(_cCodB,21,4) + dvMod10(_cPedaco) + Space(2)

//Segundo Campo
_cPedaco  := Substr(_cCodB,25,10)
_cLineDig += Substr(_cPedaco,1,5)+"."+Substr(_cPedaco,6,5)+;
dvMod10(_cPedaco) + Space(2)

//Terceiro Campo
_cPedaco  := Substr(_cCodB,35,10)
_cLineDig += + Substr(_cPedaco,1,5)+"."+Substr(_cPedaco,6,5)+;
dvMod10(_cPedaco) + Space(2)

//Quarto Campo
_cLineDig += Substr(_cCodB,05,01) + Space(2)

//Quinto Campo
_cLineDig  += Substr(_cCodB,06,04) + Substr(_cCodB,10,10)

Return(_cLineDig)

static function dvMod10(_cdata)

LOCAL L,D,P := 0
LOCAL B     := .F.

L := Len(_cdata)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(_cdata, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End

Return(STRZERO(D,1,0))

Static Function ConvDT4(_cDT)

_cDT := DTOS(_cDT)

Return(substr(_cDT,7,2)+'/'+substr(_cDT,5,2)+'/'+substr(_cDT,1,4))