#INCLUDE "RWMAKE.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "FWPrintSetup.ch"
#include "ap5mail.ch"
#INCLUDE "RPTDEF.CH"

/*
DESCRIÇÃO: FUNÇÃO PRA IMPRIMIR A ORDEM DE SERVIÇO
AUTOR:     DANIEL GOUVEA
DATA:      11/07/2014
CLIENTE:   LIGUE TELECOM
*/

User Function LIGTEC03()
	Local _area := getarea()
	Local _aAB6 := AB6->(getarea())
	Local _aAB7 := AB7->(getarea())
	Local _aABA := ABA->(getarea())
	Local _aSA1 := SA1->(getarea())
	Local _aAB1 := AB1->(getarea())
	Private cPerg := "LIGTEC03"

	validperg()

	IF ALLTRIM(FUNNAME())=="TECA450" .OR. ALLTRIM(FUNNAME())=="LIGTEC14" .OR. ALLTRIM(FUNNAME())=="TECA300" .OR. ALLTRIM(FUNNAME())=="AB6AB7A_MV"
		IF ALLTRIM(FUNNAME())=="TECA300"
			dbSelectArea("AB7")
			dbSetOrder(2) //B7_FILIAL+B7_NUMCHAM
			IF dbSeek(xFilial("AB7")+ AB1->AB1_NRCHAM)
				MV_TEC0301 := AB7->AB7_NUMOS
			ENDIF
		ELSE
			MV_TEC0301 := AB6->AB6_NUMOS
		ENDIF
	ELSE
		IF !pergunte(cPerg,.t.)
			return
		ENDIF
	ENDIF

	dbselectarea("AB6")
	dbsetorder(1)
	IF dbseek(xFilial()+MV_TEC0301)
		dbselectarea("SA1")
		dbsetorder(1)

		IF dbseek(xFilial()+AB6->AB6_CODCLI+AB6->AB6_LOJA)
			LIGTEC3I()
		ENDIF
	ELSE
		msginfo("Ordem de Serviço não existe.")
	ENDIF

	restarea(_aSA1)
	restarea(_aABA)
	restarea(_aAB7)
	restarea(_aAB6)
	restarea(_aAB1)
	restarea(_area)
return

static function LIGTEC3I()
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

	_nome := "OS"+ALLTRIM(AB6->AB6_NUMOS)+strtran(time(),":","")

	_caminho := gettemppath()

	oPrint:= FWMSPrinter():New(_nome,6,.t.,_caminho,.T.,,,,,,,)

	oPrint:SetPortrait()	// ou SetLandscape()
	oPrint:SetMargin(1,1,1,1)
	oPrint:cPathPDF := _caminho

	oPrint:StartPage()
	//PRIMEIRAMENTE VAI IMPRIMIR OS CABEÇALHOS
	oPrint:Box( 90, 90, 2910, 2310)
	oPrint:SayBitmap(125,120,"logo.bmp",500,138)

	oPrint:say(200,900,"ORDEM DE SERVIÇO "+AB6->AB6_NUMOS,oFont14b)

	oPrint:say(140,1800,"Rua Mato Grosso, 1780",oFont11)
	oPrint:say(170,1800,"Centro - Campo Mourão/PR",oFont11)
	oPrint:say(200,1800,"CEP 87300-400",oFont11)
	oPrint:say(230,1800,"TEL (44) 3523-8565",oFont11)

	IF AB6->AB6_ULIBOS == 'S'
		oPrint:say(300,2075,"OS : LIBERADA",oFont11)
	ENDIF

	nLin := 320

	oPrint:line(nLin,100,nLin,2290,3)
	nLin += 30

	oPrint:say(nLin,0120,"CLIENTE: ",oFont11b)
	oPrint:say(nLin,0300,ALLTRIM(SA1->A1_NOME),oFont11)
	oPrint:say(nLin,1500,"CNPJ/CPF: ",oFont11b)
	IF SA1->A1_PESSOA=="F"
		oPrint:say(nLin,1700,TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99"),oFont11)
	ELSE
		oPrint:say(nLin,1700,TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont11)
	ENDIF
	nLin += 40

	oPrint:say(nLin,0120,"ENDEREÇO: ",oFont11b)
	oPrint:say(nLin,0300,ALLTRIM(SA1->A1_END),oFont11)
	oPrint:say(nLin,1500,"EMAIL: ",oFont11b)
	oPrint:say(nLin,1700,ALLTRIM(SA1->A1_EMAIL),oFont11)
	nLin += 40

	oPrint:say(nLin,0120,"BAIRRO: ",oFont11b)
	oPrint:say(nLin,0300,ALLTRIM(SA1->A1_BAIRRO),oFont11)
	oPrint:say(nLin,1500,"FONE: ",oFont11b)
	oPrint:say(nLin,1700,ALLTRIM(SA1->A1_DDD) + " " + TRANSFORM(SA1->A1_TEL,PESQPICT("SA1","A1_TEL")),oFont11)
	nLin += 40

	oPrint:say(nLin,0120,"MUNICIPIO: ",oFont11b)
	oPrint:say(nLin,0300,ALLTRIM(SA1->A1_MUN) + " - " +  ALLTRIM(SA1->A1_EST),oFont11)
	oPrint:say(nLin,1500,"CEL: ",oFont11b)
	oPrint:say(nLin,1700,ALLTRIM(SA1->A1_UDDDCEL) + " " +ALLTRIM(SA1->A1_CEL),oFont11)
	nLin += 40

	oPrint:say(nLin,0120,"CEP: ",oFont11b)
	oPrint:say(nLin,0300,TRANSFORM(SA1->A1_CEP,PESQPICT("SA1","A1_CEP")),oFont11)
	oPrint:say(nLin,1500,"VENDEDOR: ",oFont11b)
	//oPrint:say(nLin,1700,ALLTRIM(SA1->A1_EMAIL),oFont11)
	nLin += 40

	oPrint:line(nLin,100,nLin,2290,3)
	nLin += 30

	oPrint:say(nLin,0120,"Emissão: ",oFont11b)
	oPrint:say(nLin,0300,DTOC(AB6->AB6_EMISSA),oFont11)
	oPrint:say(nLin,0600,"Atendente: ",oFont11b)
	oPrint:say(nLin,0800,AB6->AB6_ATEND,oFont11)
	oPrint:say(nLin,1300,"Status: ",oFont11b)
	oPrint:say(nLin,1400,IIF(AB6->AB6_STATUS=="E","Encerrada",IIF(AB6->AB6_STATUS=="A","Em Aberto",IIF(AB6->AB6_STATUS=="B","Atendida",""))),oFont11)
	oPrint:say(nLin,1700,FWLeUserlg("AB6_USERGI"),oFont11)

	IF !empty(AB6->AB6_UDTVIG)
		oPrint:say(nLin,1700,"Ini. Vigência: ",oFont11b)
		oPrint:say(nLin,1900,DTOC(AB6->AB6_UDTVIG),oFont11)
	ENDIF
	nLin += 40

	nLinhas := MLCount(AB6->AB6_MSG,70)
	oPrint:Say(nLin+=5,0120,("Obs: "),oFont11b)
	For nXi:= 1 To nLinhas
		cTxtLinha := MemoLine(AB6->AB6_MSG,120,nXi)
		IF ! Empty(cTxtLinha)
			oPrint:Say(nLin+=50,0300,(cTxtLinha),oFont11)
		ENDIF
	Next nXi

	//oPrint:say(nLin,0120,"Obs: ",oFont11b)
	//oPrint:say(nLin,0300,ALLTRIM(AB6->AB6_MSG),oFont11)

	nLin += 40

	//oPrint:say(nLin,0120,"Caixa: ",oFont11b)
	//oPrint:say(nLin,0300,ALLTRIM(AB6->AB6_UCAIXA),oFont11)

	IF !empty(AB6->AB6_EMISSA)

	ENDIF

	oPrint:line(nLin,100,nLin,2290,3)
	nLin+=30
	lCabIt := .f.
	dbselectarea("AB7")
	dbsetorder(1) //AB7_FILIAL+AB7_NUMOS+AB7_ITEM
	IF dbseek(xFilial()+AB6->AB6_NUMOS)
		while !eof() .and. xFilial()+AB6->AB6_NUMOS==AB7->AB7_FILIAL+AB7->AB7_NUMOS
			IF !lCabIt
				oPrint:say(nLin,0120,"Item",oFont10b)
				oPrint:say(nLin,0200,"Status",oFont10b)
				oPrint:say(nLin,0400,"Produto",oFont10b)
				oPrint:say(nLin,0950,"Serial",oFont10b)
				oPrint:say(nLin,1250,"MAC",oFont10b)
				oPrint:say(nLin,1550,"Ocorrência",oFont10b)
				oPrint:say(nLin,2100,"Helpdesk",oFont10b)

				nLin+=30
				lCabIt := .t.
			ENDIF
			oPrint:say(nLin,0120,AB7->AB7_ITEM,oFont10)
			//1=O.S.;2=Pedido Gerado;3=Em Atendimento;4=Atendido;5=Encerrado

			_nomeVendedor := u_nomeVendedor(AB7->AB7_NUMOS, AB7->AB7_CODPRO ,AB7->AB7_ITEM)
			oPrint:say(510,1700,_nomeVendedor,oFont11)

			IF AB7->AB7_TIPO=="1"
				oPrint:say(nLin,0200,"O.S.",oFont10)
			ELSEIF AB7->AB7_TIPO=="2"
				oPrint:say(nLin,0200,"Pedido Gerado",oFont10)
			ELSEIF AB7->AB7_TIPO=="3"
				oPrint:say(nLin,0200,"Em atendimento",oFont10)
			ELSEIF AB7->AB7_TIPO=="4"
				oPrint:say(nLin,0200,"Atendido",oFont10)
			ELSEIF AB7->AB7_TIPO=="5"
				oPrint:say(nLin,0200,"Encerrado",oFont10)
			ENDIF
			_PROD := SUBSTR(alltrim(AB7->AB7_CODPRO)+" "+POSICIONE("SB1",1,XFILIAL("SB1")+AB7->AB7_CODPRO,"B1_DESC"),1,40)
			oPrint:say(nLin,0400,_PROD,oFont10)
			//oPrint:say(nLin,0950,AB7->AB7_NUMSER,oFont10)
			//oPrint:say(nLin,1250,POSICIONE("AA3",1,XFILIAL("AA3")+AB7->AB7_CODCLI+AB7->AB7_LOJA+AB7->AB7_CODPRO+AB7->AB7_NUMSER,"AA3_CHAPA"),oFont10)
			oPrint:say(nLin,1550,AB7->AB7_CODPRB+" "+POSICIONE("AAG",1,xFilial("AAG")+AB7->AB7_CODPRB,"AAG_DESCRI"),oFont10)
			oPrint:say(nLin,2100,AB7->AB7_NRCHAM,oFont10)

			dbselectarea("AA3")
			dbsetorder(1) //AGA_FILIAL+AGA_ENTIDA+AGA_CODENT
			IF dbseek(XFILIAL("AA3")+AB7->AB7_CODCLI+AB7->AB7_LOJA+AB7->AB7_CODPRO+AB7->AB7_NUMSER)
				oPrint:say(nLin,0950,AA3->AA3_CHAPA,oFont10)
				oPrint:say(nLin,1250,AA3->AA3_UMAC,oFont10)

				nLin+=40
				//oPrint:say(nLin,0400,POSICIONE("AA3",1,XFILIAL("AA3")+AB7->AB7_CODCLI+AB7->AB7_LOJA+AB7->AB7_CODPRO+AB7->AB7_NUMSER,"AA3_CHAPA"),oFont10)
				//oPrint:say(nLin,0950,POSICIONE("AA3",1,XFILIAL("AA3")+AB7->AB7_CODCLI+AB7->AB7_LOJA+AB7->AB7_CODPRO+AB7->AB7_NUMSER,"AA3_UMAC"),oFont10)
				oPrint:say(nLin,1250,AA3->AA3_UCAIXA,oFont10)
				oPrint:say(nLin,1550,AA3->AA3_USPLT,oFont10)
				oPrint:say(nLin,2100,AA3->AA3_UPORTA,oFont10)

				dbselectarea("AGA")
				dbsetorder(4) //AGA_FILIAL+AGA_ENTIDA+AGA_CODENT
				IF dbseek(xFilial()+"SA1"+AA3->AA3_UIDAGA)
					nLin+=40
					oPrint:say(nLin,0120,"ENDEREÇO: " + AGA->AGA_END,oFont10)
					oPrint:say(nLin,0950,"JD: " + AGA->AGA_BAIRRO,oFont10)
					oPrint:say(nLin,1250,"CEP: " + AGA->AGA_CEP,oFont10)
					oPrint:say(nLin,1550,"MUN: " + AGA->AGA_MUNDES,oFont10)
					oPrint:say(nLin,2100,"EST: " + AGA->AGA_EST,oFont10)
				ENDIF
			ENDIF

			//			dbselectarea("AGB")
			//			dbsetorder(3) //AGB_FILIAL+AGB_ENTIDA+AGB_CODENT+AGB_PADRAO
			//			IF dbseek(xFilial()+"SA1"+AB7->AB7_CODCLI+AB7->AB7_LOJA)
			//				nLin+=40
			//				oPrint:say(nLin,0120,"TELEFONE: " + AGB->AGB_DDD +"-"+ AGB->AGB_TELEFO,oFont10)
			//				oPrint:say(nLin,0320,IIF(AGB->AGB_UTIPO2=='P',"PORTABILIDADE","NOVO") + "-" +AGB->AGB_COMP,oFont10)
			//			ENDIF

			nLinhas := MLCount(AB7->AB7_UMSG,70)
			oPrint:Say(nLin,0120,("Obs: "),oFont10)
			For nXi:= 1 To nLinhas
				cTxtLinha := MemoLine(AB7->AB7_UMSG,120,nXi)
				IF ! Empty(cTxtLinha)
					oPrint:Say(nLin+=30,130,(cTxtLinha),oFont10)
				ENDIF
			Next nXi

			dbselectarea("AB7")
			nLin+=40
			_memo := MSMM(AB7->AB7_MEMO1)
			IF !empty(_memo)
				_nLinhas := nLinha:= MLCount(_MEMO)
				for nX:=1 to _nLinhas
					_texto := ALLTRIM(Memoline(_memo,,nX))
					oPrint:Say(nLin,130,_texto, oFont10)
					nLin+=30
				next
				nLin+=60
			ENDIF

			_memo := MSMM(AB7->AB7_MEMO3)
			IF !empty(_memo)
				_nLinhas := nLinha:= MLCount(_MEMO)
				for nX:=1 to _nLinhas
					_texto := ALLTRIM(Memoline(_memo,,nX))
					oPrint:Say(nLin,130,_texto, oFont10)
					nLin+=30
				next
				nLin+=60
			ENDIF

			_nTot := 0
			dbselectarea("ABA")
			dbsetorder(3)//ABA_FILIAL+ABA_NUMOS+ABA_CODPRO
			IF dbseek(xFilial()+AB7->AB7_NUMOS+AB7->AB7_ITEM)
				//BOX PRO APONTAMENTO, ABA
				oPrint:line(nLin-30,150,nLin-30,2240,3)
				oPrint:line(nLin-30,150,nLin+30,150,3)
				oPrint:line(nLin-30,2240,nLin+30,2240,3)
				while !eof() .and. xFilial()+AB7->AB7_NUMOS+AB7->AB7_ITEM==;
				ABA->ABA_FILIAL+ABA->ABA_NUMOS
					lCabAB9 := .f.
					dbselectarea("AB9")
					dbsetorder(1)//AB9_FILIAL+AB9_NUMOS+AB9_CODTEC+AB9_SEQ
					IF dbseek(xFilial()+ABA->ABA_NUMOS+ABA->ABA_CODTEC+ABA->ABA_SEQ)
						IF !lCabAB9
							oPrint:Say(nLin,170,"Inicio:", oFont10b)
							oPrint:Say(nLin,300,DTOC(AB9->AB9_DTINI)+" "+AB9->AB9_HRINI, oFont10)
							oPrint:Say(nLin,0800,"Status:", oFont10b)
							oPrint:Say(nLin,1000,IIF(AB9->AB9_TIPO=="1","Encerrado","Em Aberto"), oFont10)
							oPrint:Say(nLin,1500,"Técnico:", oFont10b)
							oPrint:Say(nLin,1700,AB9->AB9_CODTEC+" "+POSICIONE("AA1",1,xFilial("AA1")+AB9->AB9_CODTEC,"AA1_NOMTEC"), oFont10)
							nLin+=30
							oPrint:line(nLin,150,nLin+30,150,3)
							oPrint:line(nLin,2240,nLin+30,2240,3)

							oPrint:Say(nLin,170,"Chegada:", oFont10b)
							oPrint:Say(nLin,300,DTOC(AB9->AB9_DTCHEG)+" "+AB9->AB9_HRCHEG, oFont10)
							oPrint:Say(nLin,0800,"Saida:", oFont10b)
							oPrint:Say(nLin,1000,DTOC(AB9->AB9_DTFIM)+" "+AB9->AB9_HRFIM, oFont10)
							oPrint:Say(nLin,1500,"", oFont10b)
							oPrint:Say(nLin,1700,"", oFont10)
							nLin+=30
							oPrint:line(nLin,150,nLin+30,150,3)
							oPrint:line(nLin,2240,nLin+30,2240,3)

							lCabAB9 := .T.
							oPrint:line(nLin,170,nLin,2220,3)
							nLin+=30
							oPrint:line(nLin,150,nLin+30,150,3)
							oPrint:line(nLin,2240,nLin+30,2240,3)
						ENDIF //IF do AB9
					ENDIF

					oPrint:Say(nLin,0170,"Material:", oFont10b)
					oPrint:Say(nLin,0300,ALLTRIM(ABA->ABA_CODPRO)+" "+POSICIONE("SB1",1,xFilial("SB1")+ABA->ABA_CODPRO,"B1_DESC"), oFont10)
					oPrint:Say(nLin,1000,"Quantidade:", oFont10b)
					oPrint:Say(nLin,1200,TRANSFORM(ABA->ABA_QUANT,PESQPICT("ABA","ABA_QUANT")), oFont10)
					nLin+=30
					oPrint:line(nLin,150,nLin+30,150,3)
					oPrint:line(nLin,2240,nLin+30,2240,3)

					dbselectarea("AA5")
					dbsetorder(1)
					IF dbseek(xFilial()+ABA->ABA_CODSER)
						oPrint:Say(nLin,0400,"Serviço:", oFont10b)
						oPrint:Say(nLin,0550,ALLTRIM(ABA->ABA_CODSER)+" "+AA5->AA5_DESCRI, oFont10)
						IF AA5->AA5_PRCCLI>0
							oPrint:Say(nLin,1000,"Valor unitario:", oFont10b)
							oPrint:Say(nLin,1200,TRANSFORM(ABA->ABA_UVUNIT*AA5->AA5_PRCCLI/100,PESQPICT("ABA","ABA_UVUNIT")), oFont10)
							oPrint:Say(nLin,1500,"Valor total:", oFont10b)
							oPrint:Say(nLin,1700,TRANSFORM(ABA->ABA_UTOTAL*AA5->AA5_PRCCLI/100,PESQPICT("ABA","ABA_UTOTAL")), oFont10)
							_nTot += ABA->ABA_UTOTAL*AA5->AA5_PRCCLI/100
						ENDIF
						nLin+=30
						oPrint:line(nLin,150,nLin+30,150,3)
						oPrint:line(nLin,2240,nLin+30,2240,3)
					ENDIF

					dbselectarea("ABA")
					dbskip()
				enddo

				oPrint:line(nLin+30,150,nLin+30,2240,3)
				nLin+=30
			ENDIF//IF do ABA

			nLin+=50
			IF _nTot>0
				oPrint:Say(nLin,1500,"Valor total:", oFont11)
				oPrint:Say(nLin,1700,TRANSFORM(_nTot,PESQPICT("ABA","ABA_UTOTAL")), oFont11b)
			ENDIF

			dbselectarea("AB7")
			dbskip()
		enddo
		dbselectarea("AGB")
		dbsetorder(3) //AGB_FILIAL+AGB_ENTIDA+AGB_CODENT+AGB_PADRAO
		IF dbseek(xFilial()+"SA1"+AB6->AB6_CODCLI+AB6->AB6_LOJA)
			nLin+=40
			oPrint:say(nLin,0120,"Telefone: " + AGB->AGB_DDD +"-"+ AGB->AGB_TELEFO,oFont10)
			oPrint:say(nLin,0500,IIF(AGB->AGB_UTIPO2=='P',"PORTABILIDADE","NOVO") + " - " +AGB->AGB_COMP,oFont10)
			oPrint:say(nLin,0850,"Cliente: "+ALLTRIM(AGB->AGB_UTITUL) + " - CPF/CNPJ :" + IIF (SA1->A1_PESSOA=="F",TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99"),TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99")),oFont10)
		ENDIF
	ENDIF

	oPrint:Say(1800,200,"Resolução do problema:", oFont14)

	oPrint:Say(2800,200,"Assinatura do cliente", oFont10)
	oPrint:Say(2800,1000,"Assinatura do auxiliar de suporte", oFont10)
	oPrint:Say(2800,1800,"Assinatura do instalador", oFont10)

	oPrint:EndPage()

	oPrint:Print()
return

user function nomeVendedor(_pNumOS, _pProduto, _pItem)

	Local _area := getarea()
	Local _SZ2 := SZ2->(getarea())
	Local _ADB := ADB->(getarea())
	Local _SA3 := SA3->(getarea())

	Local _nomeUser := ""

	dbselectarea("SZ2")
	dbsetorder(2)
	dbGoTop()
	//(xFilial()+ SZ2->Z2_NUMOS + SZ2->Z2_PRODUTO + SZ2->Z2_ITEMOS) index
	IF dbseek(xFilial()+ _pNumOS + _pProduto + _pItem)

		dbselectarea("SUA")
		dbsetorder(1)
		dbGoTop()
		IF dbseek(xFilial()+ SZ2->Z2_NUMATEN)
			//MSGinfo(ADB->ADB_UVEND1)
			_nomeUser := POSICIONE("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME")
			//MSGinfo(_nomeUser)
		ELSE
			dbselectarea("ADB")
			dbsetorder(1)
			dbGoTop()
			IF dbseek(xFilial()+ SZ2->Z2_NUMCTR + SZ2->Z2_ITEMCTR)
				//MSGinfo(ADB->ADB_UVEND1)
				_nomeUser := POSICIONE("SA3",1,xFilial("SA3")+ADB->ADB_UVEND1,"A3_NOME")
				//MSGinfo(_nomeUser)
			ENDIF
		ENDIF
	ENDIF

	restarea(_SZ2)
	restarea(_ADB)
	restarea(_SA3)
	restarea(_area)

return _nomeUser

STATIC FUNCTION VALIDPERG
	_SALIAS := ALIAS()
	AREGS := {}

	DBSELECTAREA("SX1")
	DBSETORDER(1)
	CPERG := PADR(CPERG,10)

	//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG
	AADD(AREGS,{CPERG,"01","Ordem de Serviço ?","","","MV_CH1","C",06,0,0, "G","","MV_TEC0301","","","","","","","","","","","","","","","","","","","","","","","","","ADA",""})

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
	DBSELECTAREA(_SALIAS)
RETURN

