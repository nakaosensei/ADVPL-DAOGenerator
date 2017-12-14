#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVSWEBSRV.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLIGWS002  บAutor Daniel Gouvea           Data ณ 13/02/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณWS para gravar dados do televendas                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LIGUE TELECOM                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

WSSERVICE LIGWS002 Description "WS Televendas Ligue"

WSDATA CCGCLI    AS STRING   //A1_CGC PRA PEGAR O UA_CLIENTE E UA_LOJA
WSDATA COPERADOR AS STRING   //UA_OPERADO
WSDATA CONDPG    AS STRING   //UA_CONDPG 
WSDATA CVEND	 AS STRING   //UA_VEND   
WSDATA CTIPOCON  AS STRING   //UA_UTIPO  
WSDATA CTIPOCLI  AS STRING   //UA_TIPOCLI
WSDATA COPERACAO AS STRING   //UA_OPER
WSDATA CMIDIA	 AS STRING   //UA_MIDIA
WSDATA CMKT		 AS STRING   //UA_TMK
WSDATA COCORREN  AS STRING   //UA_CODLIG 
WSDATA CPRAZO    AS STRING  //UA_UPRAZ  
WSDATA CVALIDCTR AS STRING  //UA_UVCTR  
WSDATA CDIAFECH  AS STRING  //UA_UDIAFE 
WSDATA COK	     AS STRING  //RETORNO
WSDATA _DADOS  AS ITENSLIST  OPTIONAL
WSDATA _DADOS3 AS ITENSLIST3 OPTIONAL
WSMETHOD LIGWS2GR DESCRIPTION "Grava Dados Do Televendas"

ENDWSSERVICE

WSSTRUCT LISTA
  WSDATA DADOS AS STRING
ENDWSSTRUCT

WSSTRUCT ITENSLIST
  WSDATA REGISTROS AS ARRAY OF LISTA
ENDWSSTRUCT

WSSTRUCT LISTA3
  WSDATA DADOS3 AS STRING
ENDWSSTRUCT

WSSTRUCT ITENSLIST3
  WSDATA REGISTROS3 AS ARRAY OF LISTA3
ENDWSSTRUCT
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLIGWS2GR  บAutor Daniel Gouvea         บ Data ณ 13/02/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava dados Televendas                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ligue                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

WSMETHOD LIGWS2GR WSRECEIVE CCGCLI,COPERADOR,CONDPG,CVEND,CTIPOCON,CTIPOCLI,COPERACAO,CMIDIA,CMKT,COCORREN,CPRAZO,CVALIDCTR,CDIAFECH,_DADOS,_DADOS3 WSSEND COK WSSERVICE LIGWS002
	LOCAL NCAMPOS := 0
	LOCAL CCAMPO  := ""
	LOCAL ACAMPOS := {}
	LOCAL NCONT   := 0
	//Abaixo, o mapeamento das posicoes de chegada do array _DADOS1, array de telefones
	Local ptTipo2 := 1    //Linha Nova, Telefone, Portabilide
	Local ptDDDI := 2    //DDI
	Local ptDDD  := 3    //DDD
	Local ptTel  := 4    //Telefone
	Local ptTipo := 5    //Tipo(1=Comercial;2=Residencial;3=Fax comercial;4=Fax residencial;5=Celular)                                                         )
	Local ptPadrao := 6  //Padrao(1=Sim;2=Nao)
	Local ptComp := 7    //Complemmento
	Local ptOwner := 8   //Titular da linha, nome do cliente
	Local ptCpfOw  := 9  //Cpf do titular da linha
	Local ptOp := 10     //Operacao, A=ALTERACAO, N=NOVO
	Local cdTel := 11    //Codigo do telefone quando for atualiza็ใo
		
	RpcSetEnv("01","LG01",,,'FRT','Inicializacao',{"SA1","SUA","SUB"})
	
	::cOk := "OK"
	
	CONOUT("ENTROU LIGWS2GR ."+CCGCLI+"."+TIME())
	
	PUBLIC _AALTCTR := {}
	Public _lAlteraItem := .f.
	dadosTel := {}
	BEGIN TRANSACTION
		DBSELECTAREA("SA1")
		DBSETORDER(3)
		IF DBSEEK(XFILIAL()+ALLTRIM(CCGCLI))	
			for j:=1 to len(::_dados3:Registros3)
				if(ALLTRIM(::_dados3:Registros3[j]:dados3)<>"")	
					dadosTel := StrTokArr(ALLTRIM(::_dados3:Registros3[j]:dados3),";")
					if( len( u_DAgbVld("SA1", SUBSTR(CCGCLI,1,9)+IF((len(CCGCLI)=11), "001", SUBSTR(CCGCLI,10,3)), dadosTel[ptTipo], dadosTel[ptPadrao] , dadosTel[ptDDD] ,dadosTel[ptTel]))>0) //Chama a funcao de valida็ใo de telefone, LGDAOAGB.prw
						CONOUT("LISTA DE TELEFONES CONTEM PELO MENOS UM REGISTRO NAO VALIDO")
						return .F.
					endif
				endif
			next
			
			for j:=1 to len(::_dados3:Registros3)//CADASTRA OS TELEFONES
				if(ALLTRIM(::_dados3:Registros3[j]:dados3)<>"")		
					dadosTel := StrTokArr(ALLTRIM(::_dados3:Registros3[j]:dados3),";")
					u_DAgbCad(xFilial("AGB"), "SA1", SUBSTR(CCGCLI,1,9) + IF((len(CCGCLI)=11), "001", SUBSTR(CCGCLI,10,3)), dadosTel[ptTipo],dadosTel[ptPadrao],dadosTel[ptDDD],dadosTel[ptTel],dadosTel[ptDDDI],dadosTel[ptTipo2],dadosTel[ptComp],dadosTel[ptOwner],dadosTel[ptCpfOw])//Insere os demais telefones do cliente
					CONOUT("AGB DO NAKAO"+CVALTOCHAR(j)+" "+::_dados3:Registros3[j]:dados3)	
				endif	   
			next
		
		
			if Len( ::_dados:Registros )>0
				DBSELECTAREA("SUA")
				DBSETORDER(1)
				DBSEEK(XFILIAL()+"999999",.T.)
				DBSKIP(-1)
				_NUM := SOMA1(SUA->UA_NUM)
				RECLOCK("SUA",.T.)
				SUA->UA_FILIAL  := XFILIAL()
				SUA->UA_NUM     := _NUM
				SUA->UA_CLIENTE := SA1->A1_COD
				SUA->UA_LOJA    := SA1->A1_LOJA
				SUA->UA_OPERADO := COPERADOR
				SUA->UA_CONDPG  := CONDPG
				SUA->UA_OPER    := COPERACAO
				SUA->UA_MIDIA   := CMIDIA
				SUA->UA_VEND    := CVEND
				SUA->UA_TMK     := CMKT
				SUA->UA_CODLIG  := COCORREN
				SUA->UA_ESTE    := SA1->A1_EST
				SUA->UA_DTLIM   := DATE()+10
				SUA->UA_MOEDA   := 1
				SUA->UA_TPCARGA := "2"
				SUA->UA_TIPOCLI := CTIPOCLI
				SUA->UA_UTIPO   := CTIPOCON
				SUA->UA_UPRAZ   := VAL(STRTRAN(CPRAZO,",","."))
				SUA->UA_UVCTR   := VAL(STRTRAN(CVALIDCTR,",",".")) 
				SUA->UA_UEST    := SA1->A1_EST
				SUA->UA_UDIAFE  := VAL(STRTRAN(CDIAFECH,",","."))
				SUA->UA_STATUS  := "SUP"
				SUA->UA_EMISSAO := DATE()
				SUA->UA_FIM     := TIME()
				SUA->UA_DIASDAT := CTOD("01/01/2045")-DATE() 
				SUA->UA_HORADAT := 0
				MSUNLOCK()
				//CCGCLI,COPERADOR,CONDPG,CVEND,CTIPOCON,CTIPOCLI,COPERACAO,CMIDIA,CMKT,COCORREN,CPRAZO,CVALIDCTR,CDIAFECH
				
				//1       2     3       4         5        6        7              8              9      10       11           12
				//codprod;quant;valunit;valmensal;valcheio;valdesct;quantmesesinic;quantmesescobr;codend;contrato;itemcontrato;obs;
				conout("INCLUIU SUA "+_NUM+" "+TIME())
				nTot := 0
				nDes := 0
				for nI := 1 to Len( ::_dados:Registros )
					_ITENS := StrTokArr( ::_dados:Registros[nI]:Dados, ";" )
					
					CONOUT("VAI MOSTAR O VETOR _ITENS")
					FOR I:=1 TO LEN(_ITENS)
						CONOUT("_ITENS "+CVALTOCHAR(I)+" "+_ITENS[I])
					NEXT
					dbselectarea("SB1")
					dbsetorder(1)
					if dbseek(xFilial()+alltrim(_ITENS[1]))
						DBSELECTAREA("SUB")
						RECLOCK("SUB",.T.)
						SUB->UB_FILIAL  := XFILIAL()
						SUB->UB_NUM     := _NUM
						SUB->UB_ITEM    := STRZERO(nI,2)
						SUB->UB_PRODUTO := SB1->B1_COD
						SUB->UB_QUANT   := VAL(STRTRAN(_ITENS[2],",",".")) 
						SUB->UB_VRUNIT  := VAL(STRTRAN(_ITENS[3],",","."))
						SUB->UB_VLRITEM := VAL(STRTRAN(_ITENS[4],",",".")) //*VAL(STRTRAN(_ITENS[5],",","."))
						SUB->UB_UVLCHE  := VAL(STRTRAN(_ITENS[5],",",".")) 
						SUB->UB_VALDESC := VAL(STRTRAN(_ITENS[6],",","."))            
						conout("vai preencher o UB_DESC")
						conout(VAL(STRTRAN(_ITENS[6],",",".")))
						conout(VAL(STRTRAN(_ITENS[5],",",".")))
						conout(ROUND(VAL(STRTRAN(_ITENS[6],",","."))  * 100 /VAL(STRTRAN(_ITENS[5],",",".")) ,2))
						SUB->UB_DESC    := ROUND(VAL(STRTRAN(_ITENS[6],",","."))  * 100 /VAL(STRTRAN(_ITENS[5],",",".")) ,2)
						SUB->UB_PRCTAB  := SB1->B1_PRV1 
						SUB->UB_TES     := SB1->B1_TS
						SUB->UB_CF      := POSICIONE("SF4",1,XFILIAL("SF4")+SB1->B1_TS,"F4_CF")
						SUB->UB_LOCAL   := SB1->B1_LOCPAD
						SUB->UB_UM      := SB1->B1_UM
						SUB->UB_DTENTRE := DATE()
						SUB->UB_UCTR    := ALLTRIM(_ITENS[10])
						SUB->UB_UMSG    := ALLTRIM(_ITENS[12])
						SUB->UB_UITTROC := ALLTRIM(_ITENS[11])
						SUB->UB_UMESINI := VAL(STRTRAN(_ITENS[7],",",".")) 
						SUB->UB_UMESCOB := VAL(STRTRAN(_ITENS[8],",",".")) 
						SUB->UB_UIDAGA  := ALLTRIM(_ITENS[9])
						msunlock()
						if !empty(SUB->UB_UITTROC)
							_LALTERAITEM := .t.
						endif
						CONOUT("VAI PROCURAR NO ADB")
						DBSELECTAREA("ADB")
						DBSETORDER(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
						IF DBSEEK(XFILIAL()+ALLTRIM(_ITENS[10])+ALLTRIM(_ITENS[11]))
							CONOUT("ACHOU ADB "+ADB->ADB_NUMCTR+ADB->ADB_ITEM)
							aadd(_aAltCtr,{ADB->ADB_NUMCTR,ADB->ADB_CODPRO,SB1->B1_COD,SUB->UB_QUANT,SUB->UB_VLRITEM,;
							SA1->A1_COD,SA1->A1_LOJA,SUB->UB_UMSG,ADB->ADB_ITEM,"",SUB->UB_UMESINI,SUB->UB_UMESCOB,SUB->UB_UIDAGA,;
							SUB->UB_UVLCHE,SUB->UB_VALDESC,SUB->UB_DESC})
						//aadd(_aAltCtr,{ADA->ADA_NUMCTR,ADB->ADB_CODPRO,aCols[i,_nPosPro],aCols[i,_nPosQtd],aCols[i,_nPosVlr],;
						//ADA->ADA_CODCLI,ADA->ADA_LOJCLI,aCols[i,_nPosMsg],ADB->ADB_ITEM,"",aCols[i,_nMesIn],  aCols[i,_nMesCo],aCols[i,_nIdAga],aCols[i,_nVlrChe],aCols[i,_nDesc],aCols[i,_nDescPor]})
						ENDIF
						
						nTot += VAL(STRTRAN(_ITENS[4],",","."))
						nDes += VAL(STRTRAN(_ITENS[6],",","."))
					endif
				next
				DBSELECTAREA("SUA")
				RECLOCK("SUA",.F.)
				SUA->UA_VALBRUT := nTot-nDes 
				SUA->UA_VALMERC := nTot-nDes
				SUA->UA_VLRLIQ  := nTot-nDes
				MSUNLOCK()
				::cOK := "OK"
				
				CONOUT("VAI CHAMAR O TMKVPED")
				
				Public _lAlteraItem := .f.
				Public _aAltCtr     := {}		
				
				U_TMKVPED(SUA->UA_NUM)			
			endif
		ELSE
			::cOK := "CLIENTE NAO EXISTE"
		ENDIF
	END TRANSACTION
RETURN .T. 


/*
WSSTRUCT ItSUB
     WSDATA CPRODUTO AS STRING //UB_PRODUTO
     WSDATA NQUANT   AS STRING //UB_QUANT  - NUMERICO
     WSDATA NVRUNIT  AS STRING //UB_VRUNIT - NUMERICO
     WSDATA NVDESC   AS STRING //UB_VALDESC - NUMERICO
     WSDATA NMESINI  AS STRING //UB_UMESINI - NUMERICO
     WSDATA NVRCHEIO AS STRING //UB_PRCTAB - NUMERICO 
     WSDATA NMESCOB  AS STRING //UB_UMESCOB - NUMERICO
     WSDATA CCODEND  AS STRING //UB_UIDAGA
     WSDATA CCONTRAT AS STRING //UB_UCTR
     WSDATA CITCONTR AS STRING //UB_UITTROC
     WSDATA CMSG 	 AS STRING //UB_UMSG     
ENDWSSTRUCT 

WSSTRUCT vetorItSUB
  WSDATA RetItSUB AS ARRAY OF ItSUB
ENDWSSTRUCT
*/