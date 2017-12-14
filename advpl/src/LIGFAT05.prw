#INCLUDE "RWMAKE.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "FWPrintSetup.ch"
#include "ap5mail.ch"
#INCLUDE "RPTDEF.CH"

/*
DESCRIÇÃO: FUNÇÃO PRA IMPRIMIR AS NF DA FIBER
AUTOR:     DANIEL GOUVEA
DATA:      26/06/2014
CLIENTE:   LIGUE TELECOM
*/

User Function LIGFAT05(_filial,_doc,_serie,_cliente,_loja,_cPath,_lView)
Local _area 		:= getarea()
Local _aSF2 		:= SF2->(getarea())
Private _par1 		:= _Filial
Private _par2 		:= _Doc
Private _par3 		:= _Serie
Private _par4 		:= _Cliente
Private _par5 		:= _Loja
Private _caminho 	:= _CPATH 
Private _view    	:= _LVIEW

if type('_par1')<>"C"
	_Filial  	:= SF2->F2_FILIAL
	_Doc	  	:= SF2->F2_DOC
	_Serie   	:= SF2->F2_SERIE
	_Cliente 	:= SF2->F2_CLIENTE
	_Loja    	:= SF2->F2_LOJA
endif 

dbselectarea("SF2")
dbsetorder(1)
if dbseek(_filial+_doc+_serie+_cliente+_loja)
	//VAI ENCONTRAR O _VENC
	_CQUERY := " SELECT E1.E1_VENCTO "
	_CQUERY += " FROM "+RETSQLNAME("SE1")+" E1 "
	_CQUERY += " WHERE ((E1.E1_UFILNF1='"+SF2->F2_FILIAL+"' AND E1.E1_USERNF1='"+SF2->F2_SERIE+"' AND E1.E1_UNUMNF1='"+SF2->F2_DOC+"') "
	_CQUERY += " OR (E1.E1_UFILNF2='"+SF2->F2_FILIAL+"' AND E1.E1_USERNF2='"+SF2->F2_SERIE+"' AND E1.E1_UNUMNF2='"+SF2->F2_DOC+"') "
	_CQUERY += " OR (E1.E1_UFILNF3='"+SF2->F2_FILIAL+"' AND E1.E1_USERNF3='"+SF2->F2_SERIE+"' AND E1.E1_UNUMNF3='"+SF2->F2_DOC+"') "
	_CQUERY += " OR (E1.E1_UFILNF4='"+SF2->F2_FILIAL+"' AND E1.E1_USERNF4='"+SF2->F2_SERIE+"' AND E1.E1_UNUMNF4='"+SF2->F2_DOC+"') "
	_CQUERY += " OR (E1.E1_UFILNF5='"+SF2->F2_FILIAL+"' AND E1.E1_USERNF5='"+SF2->F2_SERIE+"' AND E1.E1_UNUMNF5='"+SF2->F2_DOC+"')) "
    _CQUERY += " AND E1.E1_CLIENTE = '"+SF2->F2_CLIENTE+ "'"   
	_CQUERY += " AND E1.E1_LOJA =  '"+SF2->F2_LOJA+"'" 
	_CQUERY += " AND E1.D_E_L_E_T_=' ' "
	TCQUERY _CQUERY NEW ALIAS "TEMP"
	dbselectarea("TEMP")
	if eof()
		alert("Houve um problema na geração do boleto aglutinado. A nota não poderá ser impressa.")
		TEMP->(dbclosearea())
	return
	endif
	_venc := TEMP->E1_VENCTO
	TEMP->(dbclosearea())
	
	dbselectarea("SA1")
	dbsetorder(1)
	if dbseek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)	
		LIGFAT05(_venc)
	endif
endif

restarea(_aSF2)
restarea(_area)
return


STATIC FUNCTION LIGFAT05()
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

	IF TYPE("_caminho")=="U"
		_caminho := gettemppath()
	ENDIF

	IF TYPE("_view")=="U"
		_view := .T.
	ENDIF

	_nome := ALLTRIM(SF2->F2_FILIAL+"_"+CVALTOCHAR(VAL(SF2->F2_DOC))+"_"+SF2->F2_SERIE)+"_"+strtran(time(),":","")
	
	oPrint:= FWMSPrinter():New(_nome,6,.t.,_caminho,.T.,,,,,,,_view)
	
	oPrint:SetPortrait()	// ou SetLandscape()
	oPrint:SetMargin(1,1,1,1)
	oPrint:cPathPDF := _caminho
	
	oPrint:StartPage()
//PRIMEIRAMENTE VAI IMPRIMIR OS CABEÇALHOS
	oPrint:Box( 90, 90, 2910, 2310)
	oPrint:SayBitmap(100,100,"logofiber.bmp",299.5,205)
	
	oPrint:say(135,700,"FIBER CONSTRUÇÃO E LOCAÇÃO DE REDES LTDA",oFont11b)
	oPrint:say(170,700,"RUA MATO GROSSO, 1780",oFont10)
	oPrint:say(200,700,"CEP 87300-400 CAMPO MOURÃO/PR - BRASIL",oFont10)
	oPrint:say(230,700,"CNPJ: 17.878.148/0001-26      I.E. ISENTO",oFont10)
	oPrint:say(260,700,"TEL + 55 44 3810-0015",oFont10)
	
	oPrint:say(300,600,"ATENDIMENTO AO CLIENTE: (44) 3810-0000",oFont14b)
	
	oPrint:say(135,1700,"FATURA LOCAÇÃO",oFont14b)
	oPrint:say(170,1700,"Número: "+SF2->F2_DOC,oFont11)
	
	oPrint:say(210,1700,"Data de Emissão "+dtoc(SF2->F2_EMISSAO),oFont11)
	oPrint:say(240,1700,"Vencimento "+dtoc(stod(_venc)),oFont11)
	oPrint:say(270,1700,"Referencia "+dtoc(stod(_venc)),oFont11)
	
	oPrint:line(320,100,320,2290,3)
	
	oPrint:say(360,0120,"CLIENTE: ",oFont10b)
	oPrint:say(360,0300,ALLTRIM(SA1->A1_NOME),oFont10)
	oPrint:say(400,0120,"ENDEREÇO: ",oFont10b)
	oPrint:say(400,0300,ALLTRIM(SA1->A1_END),oFont10)
	oPrint:say(440,0120,"BAIRRO: ",oFont10b)
	oPrint:say(440,0300,ALLTRIM(SA1->A1_BAIRRO),oFont10)
	oPrint:say(480,0120,"MUNICIPIO: ",oFont10b)
	oPrint:say(480,0300,ALLTRIM(SA1->A1_MUN),oFont10)

	oPrint:say(360,1500,"CNPJ/CPF: ",oFont10b)
	IF SA1->A1_PESSOA=="F"
		oPrint:say(360,1700,TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99"),oFont10)
	ELSE
		oPrint:say(360,1700,TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont10)
	ENDIF
	oPrint:say(400,1500,"INSC. EST.: ",oFont10b)
	oPrint:say(400,1700,SA1->A1_INSCR,oFont10)
	oPrint:say(440,1500,"CEP: ",oFont10b)
	oPrint:say(440,1700,TRANSFORM(SA1->A1_CEP,PESQPICT("SA1","A1_CEP")),oFont10)
	oPrint:say(480,1500,"ESTADO: ",oFont10b)
	oPrint:say(480,1700,SA1->A1_EST,oFont10)
	
	//oPrint:line(520,100,520,2290,3)
	
	oPrint:Box(520,0100, 2720, 2290)
	oPrint:say(550,0120,"DESCRIÇÃO",oFont10b)
	oPrint:line(520,1390,2720,1390)
	oPrint:say(550,1400,"QUANTIDADE",oFont10b)
	oPrint:line(520,1640,2720,1640)
	oPrint:say(550,1650,"VALOR UNITARIO",oFont10b)
	oPrint:line(520,1890,2720,1890)
	oPrint:say(550,1900,"VALOR TOTAL",oFont10b)
	oPrint:line(560,100,560,2290)
	
	nLine := 600
	_nTot := 0
	_msg  := ""
	
	dbselectarea("SD2")
	dbsetorder(3)//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	if dbseek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		while !eof() .and. SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA==;
					SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
				oPrint:say(nLine,0120,ALLTRIM(SD2->D2_COD)+" "+POSICIONE("SB1",1,XFILIAL("SB1")+SD2->D2_COD,"B1_DESC"),oFont11)
				oPrint:say(nLine,1400,TRANSFORM(SD2->D2_QUANT,PESQPICT("SD2","D2_QUANT")),oFont11)
				oPrint:say(nLine,1650,TRANSFORM(SD2->D2_PRCVEN,PESQPICT("SD2","D2_PRCVEN")),oFont11)	
				oPrint:say(nLine,1900,TRANSFORM(SD2->D2_TOTAL,PESQPICT("SD2","D2_TOTAL")),oFont11)
				_aux := POSICIONE("SC5",1,SD2->D2_FILIAL+SD2->D2_PEDIDO,"C5_MENNOTA")
				if !(_aux $ _msg)
					_msg += " "+_aux
				endif
				nLine+=50
				_nTot += SD2->D2_TOTAL	
			dbselectarea("SD2")
			dbskip()
		enddo
	endif
	
	oPrint:Box(2730,0100, 2900, 2290)
	oPrint:say(2760,200,"INFORMAÇÕES COMPLEMENTARES",oFont11b)
	oPrint:say(2810,250,_MSG,oFont11)
	
	oPrint:say(2760,1800,"VALOR TOTAL",oFont11b)
	oPrint:say(2810,1900,ALLTRIM(TRANSFORM(_nTot,PESQPICT("SD2","D2_TOTAL"))),oFont11)
	
	oPrint:EndPage()

	oPrint:Print()
return