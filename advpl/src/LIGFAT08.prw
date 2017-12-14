#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
// RELATORIO PREVIEW DE FATURAMENTO LIGUE TELECOM.
User Function LIGFAT08()

************************************
PRIVATE _CFILOLD  	:= CFILANT
PRIVATE _CPERG		:= "FAT08A"
PRIVATE _CNOTAS 	:= ""
PRIVATE _AITENS 	:= {} //{1-EMP/FIL, 2-SERIE, 3-PRODUTO, 4-QUANTIDADE, 5-PRECO UNITARIO, 6-VL TOTAL, 7-TES, 8-NUM PED}
PRIVATE _ANFGER 	:= {} //{1-EMP/FIL, 2-SERIE, 3-NOTA, 4-CLIENTE, 5-LOJA, 6-COND, 7-EMISSAO, 8-PREF, 9-VALOR, 10-CONTRATO}
PRIVATE _APDEMO		:= {} //{1-PRODUTO, 2-QUANT, 3-VL UNITARIO, 4-VL TOTAL}
PRIVATE _ATITULOS	:= {} //{1-PREF, 2-NUM, 3-PARC, 4-TIPO, 5-CLIENTE, 6-LOJA}
PRIVATE _NTTITEM	:= 0
PRIVATE _NTTDEMO	:= 0
PRIVATE _CIMPRUNI	:= "S" //S=SIM, N=NAO (IMPRIME TODOS BOLETOS EM UNICO ARQUIVO ?)
PRIVATE _CDIRPDF	:= "\PDF"
PRIVATE _LCONSOK	:= .F.
PRIVATE _CPROEXTRA	:= " "
Private	OFONT1      := TFONT():NEW( "ARIAL",,07,,.T.,,,,,.F.)
Private	OFONT2      := TFONT():NEW( "ARIAL",,06,,.F.,,,,,.F.)
Private	nLin		:= 0100		// Linha que o sistema esta imprimindo.

VALIDPERG()
IF !PERGUNTE(_CPERG)
	RETURN
ENDIF        

_CCTRINI  := MV_PAR02
_CCTRFIM  := MV_PAR03

PROCESSA({||FAT011()})

RETURN


STATIC FUNCTION FAT011() //PROCESSAMENTO DOS CONTRATOS
***************************************
LOCAL _NQTREGUA := 0
LOCAL _TOTALFAT := 0

oPrint := TMSPrinter():New("Relat�rio de Notas/Contas a Receber")// Monta objeto para impress�o

//oPrint:SetPortrait()// Define orienta��o da p�gina para Retrato, pode ser usado oPrint:SetLandscape para Paisagem
oPrint:SetLandscape() 

oPrint:Setup()// Mostra janela de configura��o de impress�o

oPrint:StartPage()// Inicia p�gina

oPrint:setPaperSize( DMPAPER_A4 )
// Insere Linhas
oPrint:Box(0050,0050,3300,2380) //Area total

//���������������������������������Ŀ
//�Imprime o cabecalho da empresa. !�
//�����������������������������������

	nLin := 0080 //Lista Parametros

	oPrint:Say(nLin,0100,"Relat�rio de Preview do Faturamento",oFont1)
	oPrint:Say(nLin,1200,"Parametros",oFont1)
	nLin += 080
	oPrint:Say(nLin,1200,_CCTRINI,oFont2)
	oPrint:Say(nLin,1450,_CCTRINI,oFont2)
/*	oPrint:Say(nLin,1750,Transform(MV_PAR03,"@E",),oFont2)
	oPrint:Say(nLin,2000,Transform(MV_PAR04,"@E",),oFont2)*/
	
	nLin += 100



DBSELECTAREA("ADA")
DBSETORDER(1)
DBGOTOP()
WHILE !EOF()
	IF ADA->ADA_ULIBER=="S"//LIB FINANCEIRO
		_NQTREGUA++
	ENDIF
	DBSKIP()
ENDDO

PROCREGUA(_NQTREGUA)

DBSELECTAREA("ADA")
DBSETORDER(1)
DBGOTOP()
WHILE !EOF()
	
	IF ADA->ADA_ULIBER=="S" //LIB FINANCEIRO
		INCPROC("Processando...")
		
		_AITENS := {}
		_APDEMO	:= {}
		_ANFGER	:= {}
		_LCONSOK:= .F.
		
		//IF (ADA->ADA_MSBLQL!="1" .OR. (ADA->ADA_MSBLQL=="1" .AND. ADA->ADA_UDTFEC<=ADA->ADA_UDTBLQ)) .AND. ADA->ADA_NUMCTR>=_CCTRINI .AND. ADA->ADA_NUMCTR<=_CCTRFIM .AND. ADA->ADA_VEND1>=MV_PAR03 .AND. ADA->ADA_VEND1<=MV_PAR04 .AND. ADA->ADA_UTIPO = MV_PAR09
		IF (ADA->ADA_MSBLQL!="1" .OR. (ADA->ADA_MSBLQL=="1" .AND. ADA->ADA_UDTFEC<=ADA->ADA_UDTBLQ)) .AND. ADA->ADA_NUMCTR>=_CCTRINI .AND. ADA->ADA_NUMCTR<=_CCTRFIM	
			//INICIO - PRODUTOS CONTRATO
			DBSELECTAREA("ADB")
			DBSETORDER(1)
			DBGOTOP()
			IF DBSEEK(XFILIAL("ADB")+ADA->ADA_NUMCTR)
				WHILE !EOF() .AND. ADB->ADB_FILIAL+ADB->ADB_NUMCTR==ADA->ADA_FILIAL+ADA->ADA_NUMCTR
					DBSELECTAREA("SB1")
					DBSETORDER(1)
					IF DBSEEK(XFILIAL("SB1")+ADB->ADB_CODPRO)
						
						IF EMPTY(ADA->ADA_UDTFEC)
							if month(ddatabase)==1
								_CDTULFEC := stod(strzero(year(ddatabase)-1,4)+"12"+strzero(day(ddatabase)-1,2))
							else
								_CDTULFEC := stod(strzero(year(ddatabase),4)+strzero(month(ddatabase)-1,2)+strzero(day(ddatabase)-1,2))
							endif
						else
							_CDTULFEC  := ADA->ADA_UDTFEC
						endif
						
						_NVLITEM := 0
						_NVLITEM  := FAT01E(_CDTULFEC, ADB->ADB_UDTINI, ADB->ADB_UDTFIM, ADB->ADB_TOTAL)					
						FAT01H(ADB->ADB_CODPRO,ADB->ADB_UDTINI, ADB->ADB_UDTFIM, ADB->ADB_QUANT, _NVLITEM)		
						
						//INICIO - CONSUMO EXTRA  - VERIFICADO PARA CADA ITEM DO CONTRATO
						IF !EMPTY(SB1->B1_UPRDEXT) .AND. !_LCONSOK
							
							_LCONSOK   := .T.
							
							_CPROEXTRA := SB1->B1_UPRDEXT
							_CTESEXTRA := GETMV("MV_UTESEXT")
							_CNRCOB	   := ADA->ADA_UNRCOB
							
							_CDTBLQCTR := DTOC(ADA->ADA_UDTBLQ)
							
							IF ADA->ADA_UTIPO=="F" //FTTH
								
								_AREAADA   := ADA->(GETAREA())
								_AREAADB   := ADB->(GETAREA())
								_NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
								_NCONNPTG  := TCLINK("POSTGRES/PostGreLigue","10.0.1.98",7890) //CONECTA AO POSTGRES
								
								_CQUERY := " SELECT SUM(CDR.TOTAL) TOTAL "
								_CQUERY += " FROM TELEFONIA.CDR CDR "
								_CQUERY += " WHERE CDR.ACCOUNTCODE = '"+_CNRCOB+"' "
								IF ADA->ADA_UDTBLQ>_CDTULFEC
									_CQUERY += " AND CDR.DATA >= '"+_CDTBLQCTR+"' "
								ELSE
									_CQUERY += " AND CDR.DATA >= '"+DTOC(_CDTULFEC)+"' "
								ENDIF
								_CQUERY += " AND CDR.DATA < '"+DTOC(DDATABASE)+"' " //ATE DIA ANTERIOR
								IF SELECT("TRB0")!=0
									TRB0->(DBCLOSEAREA())
								ENDIF
								TCQUERY _CQUERY NEW ALIAS "TRB0"
								_NVLEXT := TRB0->TOTAL
								
								TRB0->(DBCLOSEAREA())
								
								TCUNLINK(_NCONNPTG)  //FECHA CONEXAO POSTGRES
								TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
								
								RESTAREA(_AREAADA)
								RESTAREA(_AREAADB)
								
							ELSE
								
								_NVLFRANQ  := ADB->ADB_TOTAL
								_AREAADA   := ADA->(GETAREA())
								_AREAADB   := ADB->(GETAREA())
								_NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
								_NCONNMYS  := TCLINK("MYSQL/MySqlLigue","10.0.1.98",7890) //CONECTA AO MYSQL
								
								IF ADA->ADA_UDTBLQ>_CDTULFEC
									_CDTDE := YEAR2STR(CTOD(_CDTBLQCTR))
									_CDTDE += "-"
									_CDTDE += MONTH2STR(CTOD(_CDTBLQCTR))
									_CDTDE += "-"
									_CDTDE += DAY2STR(CTOD(_CDTBLQCTR))
								ELSE
									_CDTDE := YEAR2STR(_CDTULFEC)
									_CDTDE += "-"
									_CDTDE += MONTH2STR(_CDTULFEC)
									_CDTDE += "-"
									_CDTDE += DAY2STR(_CDTULFEC)
								ENDIF
								
								_CDTATE := YEAR2STR(DDATABASE)
								_CDTATE += "-"
								_CDTATE += MONTH2STR(DDATABASE)
								_CDTATE += "-"
								_CDTATE += DAY2STR(DDATABASE)
								
								_CQUERY := " SELECT SUM(C.COST) TOTAL "
								_CQUERY += " FROM CALLS C, CLIENTSSHARED CLI "
								_CQUERY += " WHERE C.ID_CLIENT = CLI.ID_CLIENT "
								_CQUERY += " AND CLI.ID_INTEGRADOR = "+_CNRCOB
								IF !EMPTY(STOD(STRTRAN(_CDTDE,"-","")))
									_CQUERY += " AND C.CALL_START >= '"+_CDTDE+"' "
								ENDIF
								_CQUERY += " AND C.CALL_START < '"+_CDTATE+"' " //ATE DIA ANTERIOR
								IF SELECT("TRB0")!=0
									TRB0->(DBCLOSEAREA())
								ENDIF
								TCQUERY _CQUERY NEW ALIAS "TRB0"
								
								IF _NVLFRANQ>=TRB0->TOTAL
									_NVLEXT := 0
								ELSE
									_NVLEXT := TRB0->TOTAL-_NVLFRANQ
								ENDIF
								
								TRB0->(DBCLOSEAREA())
								
								TCUNLINK(_NCONNMYS)  //FECHA CONEXAO MYSQL
								TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
								
								RESTAREA(_AREAADA)
								RESTAREA(_AREAADB)
								
							ENDIF
							
							DBSELECTAREA("SB1")
							DBSETORDER(1)
							IF DBSEEK(XFILIAL("SB1")+_CPROEXTRA)
								
								_NVLTOTAL := ROUND((_NVLEXT*SB1->B1_UPC01)/100,2)
								_NVLUNIT  := _NVLTOTAL
								
								IF _NVLTOTAL > 0
									AADD(_AITENS,{SB1->B1_UEMP01, SB1->B1_USER01, SB1->B1_COD, 1, _NVLUNIT, _NVLTOTAL, _CTESEXTRA, " "})
								ENDIF
								
								IF !EMPTY(SB1->B1_UPROD02)
									_NVLTOTAL := ROUND((_NVLEXT*SB1->B1_UPC02)/100,2)
									_NVLUNIT  := ROUND(_NVLTOTAL/ADB->ADB_QUANT,4)
									
									AADD(_AITENS,{SB1->B1_UEMP02, SB1->B1_USER02, SB1->B1_UPROD02, 1, _NVLUNIT, _NVLTOTAL, _CTESEXTRA, " "})
								ENDIF
								
								AADD(_APDEMO,{SB1->B1_COD, 1, _NVLUNIT, _NVLTOTAL,SB1->B1_DESC,"",""})
							ENDIF
						ENDIF
						//FIM - CONSUMO EXTRA
					ENDIF //IF DO SB1
					DBSELECTAREA("ADB")
					DBSKIP()
				ENDDO
				
				//FIM - PRODUTOS CONTRATO
			ENDIF //IF DO ADB
			//INICIO - SERVICOS EXTRA - FIELD SERVICE SEM VINCULO COM CONTRATOS - SE GEROU SZ2 ENTAO VEIO DO TV CASO CONTRATO EH SERVICO AVULSO
			_CQUERY := " SELECT ABA.*, AA5.AA5_TES, AA5.AA5_PRCCLI, AA5.AA5_DESCRI "
			_CQUERY += " FROM "+RETSQLNAME("ABA")+" ABA "
			_CQUERY += " INNER JOIN "+RETSQLNAME("AB6")+" AB6 ON AB6.AB6_FILIAL=ABA.ABA_FILIAL AND AB6.AB6_NUMOS=SUBSTRING(ABA.ABA_NUMOS,1,6) AND AB6.AB6_STATUS<>'A' AND AB6.D_E_L_E_T_=' ' "
			_CQUERY += " INNER JOIN "+RETSQLNAME("AB9")+" AB9 ON ABA.ABA_FILIAL=AB9.AB9_FILIAL AND AB9.AB9_NUMOS=ABA.ABA_NUMOS "
			_CQUERY += " INNER JOIN "+RETSQLNAME("AA5")+" AA5 ON ABA.ABA_CODSER=AA5.AA5_CODSER AND AA5.AA5_PRCCLI>0 AND AA5.D_E_L_E_T_=' ' "
			_CQUERY += " WHERE AB9.D_E_L_E_T_=' ' "
			_CQUERY += " AND AB9.AB9_DTFIM >= '"+DTOS(_CDTULFEC)+"' "
			_CQUERY += " AND AB9.AB9_DTFIM <= '"+DTOS(DDATABASE)+"' "
			_CQUERY += " AND AB6.AB6_CODCLI = '"+ADA->ADA_CODCLI+"' "
			_CQUERY += " AND AB6.AB6_LOJA = '"+ADA->ADA_LOJCLI+"' "
			_CQUERY += " AND ABA.ABA_UTOTAL > 0 "
			_CQUERY += " AND AB6.AB6_UNUMCT = '"+ADA->ADA_NUMCTR+"' "
			_CQUERY += " AND ABA.D_E_L_E_T_ = ' ' "
			_CQUERY += " AND NOT EXISTS(SELECT Z2.Z2_NUMOS "
			_CQUERY += "                FROM "+RETSQLNAME("SZ2")+" Z2 "
			_CQUERY += "                WHERE Z2.Z2_FILIAL = '"+XFILIAL("SZ2")+"' "
			_CQUERY += "                AND Z2.Z2_NUMOS = SUBSTRING(ABA.ABA_NUMOS,1,6) "
			_CQUERY += "                AND Z2.D_E_L_E_T_ = ' ') "
			_CQUERY += " ORDER BY ABA.ABA_FILIAL, ABA.ABA_NUMOS "
			_CQUERY := CHANGEQUERY(_CQUERY)
			IF SELECT("TRAB8")!=0
				TRAB8->(DBCLOSEAREA())
			ENDIF
			TCQUERY _CQUERY NEW ALIAS "TRAB8"
			DBSELECTAREA("TRAB8")
			DBGOTOP()
			WHILE !EOF()
			
				_NVLITEM  := ROUND((TRAB8->ABA_UTOTAL*TRAB8->AA5_PRCCLI)/100,2) //SOMENTE PERCENTUAL FATURADO PARA O CLIENTE - AA5_PRCCLI
				FAT01H(TRAB8->ABA_CODPRO,,,TRAB8->ABA_QUANT, _NVLITEM)		
			
				DBSELECTAREA("TRAB8")
				DBSKIP()
			ENDDO
			TRAB8->(DBCLOSEAREA())
			//FIM - SERVICOS EXTRA - FIELD SERVICE E/OU PEDIDOS PENDENTES
			
			_NTTDESC := 0
			
			//VERIFICA COBRAN�A ADICIONAIS DO FATURAMENTO, EX: RELIGAMENTOS DE SERVI�O, RESSARCIMENTO, DESCONTO
			DBSELECTAREA("SZ5")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SZ5")+ADA->ADA_NUMCTR)
				WHILE !EOF() .AND. SZ5->Z5_FILIAL+SZ5->Z5_NUMCTR == XFILIAL("SZ5")+ ADA->ADA_NUMCTR
					IF SZ5->Z5_QTDCOB > 0
					
						IF Z5_TIPO = '1' // TIPO DE DESCONTO
							_NTTDESC += Z5_TOTAL
						ELSE
							FAT01H(SZ5->Z5_PRODNF, MonthSub(ddatabase,1),ddatabase, SZ5->Z5_QUANT, SZ5->Z5_TOTAL)
						ENDIF																												
					ENDIF	
					
				DBSELECTAREA("SZ5")
				DBSKIP()
				ENDDO
			ENDIF			
			
			
			//INICIO - RETIRAR DIFERENCA DE VALOR (FATURAMENTO X CONTRATO)
			_NTTITEM := 0
			_NTTDEMO := 0
			
			FOR _I:=1 TO LEN(_AITENS)
				_NTTITEM += _AITENS[_I,6] //PEGAR TOTAL QUE VAI PARO OS DOS PEDIDOS DE VENDA
			NEXT _I
			
			FOR _I:=1 TO LEN(_APDEMO)
				_NTTDEMO += _APDEMO[_I,4] //PEGAR O TOTAL QUE VAI PARA GERAR FATURA
			NEXT _I
			
			IF _NTTITEM!=_NTTDEMO .AND. LEN(_AITENS)>0
				_LDIFOK	:= .F.
				_NVLDIF := _NTTDEMO-_NTTITEM
				
				_NTENT := 0 //FORCA TIRAR DIF DE ALGUM PRODUTO COM QUANTIDADE IGUAL A 1 (UM) PARA NAO CORRER RISCO DE NOVA DIFERENCA
				WHILE !_LDIFOK .AND. LEN(_AITENS)>_NTENT
					_NP := LEN(_AITENS)-_NTENT
					IF _AITENS[_NP,4]==1 .AND. ALLTRIM(_AITENS[_NP,3])!=_CPROEXTRA .AND. EMPTY(_AITENS[_NP,8])
						_AITENS[_NP,5] := _AITENS[_NP,5]+_NVLDIF
						_AITENS[_NP,6] := _AITENS[_NP,6]+_NVLDIF
						_LDIFOK := .T.
					ELSE
						_NTENT++
					ENDIF
				ENDDO
				
				IF !_LDIFOK //SE NAO AJUSTAR VIA REGRAS ANTERIORES TIRA DO ULTIMO
					_NP := LEN(_AITENS)
					_AITENS[_NP,5] := _AITENS[_NP,5]+_NVLDIF
					_AITENS[_NP,6] := _AITENS[_NP,6]+_NVLDIF
					_LDIFOK := .T.
				ENDIF
	
			ENDIF
			//FIM - RETIRAR DIFERENCA DE VALOR (FATURAMENTO X CONTRATO)
			
			//CALCULAR EM CIMA DO VALOR J� AJUSTADO
			_NTTFATU := 0
			FOR _I:=1 TO LEN(_AITENS)
				_NTTFATU += _AITENS[_I,6] //PEGAR TOTAL QUE VAI PARA FATURA
			NEXT _I
			
			IF _NTTFATU > 0
			 	_PRCDES := 0
					IF _NTTDESC > 0
						_PRCDES := _NTTDESC * 100 / _NTTFATU
						_NTTDESC := _NTTDESC * -1
						AADD(_APDEMO,{"DESCON", 1, _NTTDESC, _NTTDESC,"DESCONTO","",""})
					ENDIF 
			ENDIF							
			
			oPrint:Say(nLin,0070,"Num Cob: "	+ ADA->ADA_UNRCOB,OFONT1)
			oPrint:Say(nLin,340,"Cod : " 		+ ADA->ADA_CODCLI,OFONT1)
			oPrint:Say(nLin,560,"Loja :" 		+ ADA->ADA_LOJCLI,OFONT1)
			oPrint:Say(nLin,690,POSICIONE( "SA1", 1, XFILIAL( "SA1" ) + ADA->ADA_CODCLI + ADA->ADA_LOJCLI, "A1_NOME"),OFONT1)
			oPrint:Say(nLin,1380,"Num CTR: "	+ ADA->ADA_NUMCTR,OFONT1)	
			oPrint:Say(nLin,1610,"Total Fatura : " + Transform(_NTTDEMO + _NTTDESC,"@E 9,999,999.99",),OFONT1)		
						
			_TOTALFAT += _NTTDEMO + _NTTDESC
			
			for n:=1 to len(_APDEMO) 
				nLin += 0030
				oPrint:Say(nLin,0070,_APDEMO[n,1],oFont2)	//PRODUTO
				oPrint:Say(nLin,0150,_APDEMO[n,5],oFont2)	//DESCRI��O
				IF !EMPTY(_APDEMO[n,6])
					oPrint:Say(nLin,950,"Ini Vig.: " +Transform(_APDEMO[n,6],"@E",),oFont2) 	//INICIO_VIG
				ENDIF
				IF !EMPTY(_APDEMO[n,7])
					oPrint:Say(nLin,1160,"Fim Vig.: " +Transform(_APDEMO[n,7],"@E",),oFont2) 	//FIM_VIG
				ENDIF
				oPrint:Say(nLin,1530,Transform(_APDEMO[n,2],"@E 9,999,999.99",),oFont2) 	//QUANT
				oPrint:Say(nLin,1630,Transform(_APDEMO[n,3],"@E 9,999,999.99",),oFont2) 	//VL_UNITARIO
				oPrint:Say(nLin,1730,Transform(_APDEMO[n,4],"@E 9,999,999.99",),oFont2) 	//VL_TOTAL		   
				   
				If nLin > 3200
					oPrint:EndPage()	
					oPrint:StartPage()// Inicia p�gina
					OPRINT:BOX(0100,0050,3300,2380)
					 
					nLin := 0080
			EndIf	
	 
			next n 
			
			nLin += 0030
		ENDIF
	ENDIF
		                      
	DBSELECTAREA("ADA")
	DBSKIP()
ENDDO

oPrint:Say(nLin,1600,"VALOR TOTAL : " + Transform(_TOTALFAT,"@E 9,999,999.99",),oFont1)
// Visualiza a impress�o
oPrint:EndPage()

// Mostra tela de visualiza��o de impress�o
oPrint:Preview()

RETURN

STATIC FUNCTION FAT01E(_PDTULTFEC, _PDTINIVIG, _PDTFIMVIG, _PVALOR) //RETORNA VALOR A SER COBRADO
*************************************************************************************************
LOCAL _NVALOR := 0

IF EMPTY(_PDTINIVIG)
	RETURN(_NVALOR)
ELSE
	_NVALOR := _PVALOR //SE O VALOR NAO ENTRAR EM NENHUMA REGRA ABAIXO SERA INTEGRAL
ENDIF

IF !EMPTY(_PDTFIMVIG) .AND. _PDTFIMVIG < DDATABASE //FAT.PARCIAL POR FIM DO PLANO   
	IF  _PDTFIMVIG > _PDTULTFEC // NAO COBRAR QUANDO FATURAMENTO FOR MAIOR QUE A FIM DE VINGENCIA 
		_NDIAS  := _PDTFIMVIG-_PDTULTFEC
		_nAuxDias := numDiaMe(iif(MONTH(DDATABASE)<>1,month(DDATABASE)-1,12))
		_NVLDIA := _PVALOR/_nAuxDias
		_NVALOR := _NVLDIA*_NDIAS
		RETURN(_NVALOR)
	ELSE
		_NVALOR := 0
		RETURN (_NVALOR)
	ENDIF
ENDIF

IF !EMPTY(_PDTINIVIG) .AND. _PDTINIVIG > _PDTULTFEC  //FAT.PARCIAL POR INICIO APOS CADASTRO CONTRATO
	_AUX := proxVenc(_PDTULTFEC)
	IF _PDTINIVIG>_AUX  //CASO PRA LINHA GRATUITA (NORMALMENTE 1 ANO)
		RETURN 0
	ENDIF
	_NDIAS  := DDATABASE-_PDTINIVIG
	_nAuxDias := numDiaMe(iif(MONTH(DDATABASE)<>1,month(DDATABASE)-1,12))
	_NVLDIA := _PVALOR/_nAuxDias
	_NVALOR := _NVLDIA*_NDIAS
	RETURN(_NVALOR)
ENDIF

RETURN(_NVALOR)

//CALCULA VALOR DOS PRODUTOS E PRODUTOS2 (FIBER) //ADICIONA ARRAY OS ITENS E DEMONSTRATIVOS
STATIC FUNCTION FAT01H(_pCodPro ,_pDtIni, _pDtFim,_pNQtde, _pNTotal) 
DBSELECTAREA("SB1")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SB1")+ _pCodPro)
						
	_NAUXPRCVEN := 0
	_NVLTOTAL := ROUND((_pNTotal*SB1->B1_UPC01)/100,2)
	_NVLUNIT  := ROUND(_NVLTOTAL/_pNQtde,2)
						
	_NAUXPRCVEN := ROUND(_NVLITEM/_pNQtde,2)
	IF _NVLTOTAL>0
		AADD(_AITENS,{SB1->B1_UEMP01, SB1->B1_USER01, SB1->B1_COD, _pNQtde, _NVLUNIT, _NVLTOTAL, ADB->ADB_TES, " "})
							
		IF !EMPTY(SB1->B1_UPROD02)
			_NVLITEM  := FAT01E(_CDTULFEC, _pDtIni, _pDtFim, _pNTotal)
			_NVLTOTAL := NOROUND((_NVLITEM*SB1->B1_UPC02)/100,2)
			_NVLUNIT  := NOROUND(_NVLTOTAL/_pNQtde,2)
			AADD(_AITENS,{SB1->B1_UEMP02, SB1->B1_USER02, SB1->B1_UPROD02, _pNQtde, _NVLUNIT, _NVLTOTAL, ADB->ADB_TES, " "})
		ENDIF
													
	ENDIF
	
	//VAI IMPRIMIR NO DEMONSTRATIVO MESMO COM VALOR ZERADO
	AADD(_APDEMO,{SB1->B1_COD, _pNQtde, _NAUXPRCVEN,_NAUXPRCVEN*_pNQtde,SB1->B1_DESC,_pDtIni,_pDtFim})
ENDIF

RETURN

STATIC FUNCTION VALIDPERG
*********************************
_SALIAS := ALIAS()
AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
_CPERG := PADR(_CPERG,10)

//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG

AADD(AREGS,{_CPERG,"01","DATA FATURAMENTO  ?  "," ?"," ?","MV_CH01","C",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"02","CONTRATO DE      ?","","","MV_CH2","C",06,0,0, "G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","ADA",""})
AADD(AREGS,{_CPERG,"03","CONTRATO ATE     ?","","","MV_CH3","C",06,0,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","ADA",""})
AADD(AREGS,{_CPERG,"04","VENDEDOR ADA DE     ?","","","MV_CH4","C",06,0,0, "G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(AREGS,{_CPERG,"05","VENDEDOR ADA ATE     ?","","","MV_CH5","C",06,0,0, "G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(AREGS,{_CPERG,"06","VENDEDOR ADB DE      ?","","","MV_CH6","C",06,0,0, "G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(AREGS,{_CPERG,"07","VENDEDOR ADB ATE     ?","","","MV_CH7","C",06,0,0, "G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(AREGS,{_CPERG,"08","PRODUTO DE      ?","","","MV_CH8","C",06,0,0, "G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
AADD(AREGS,{_CPERG,"09","PRODUTO ATE     ?","","","MV_CH9","C",06,0,0, "G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
AADD(AREGS,{_CPERG,"10","TIPO CONTRATO    ?","","","MV_CH10","C",06,0,0, "G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","",""})


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

static function proxVenc(_PDTULTFEC)
local _dRet
if month(_PDTULTFEC)==12
	_dRet := stod(CVALTOCHAR(YEAR(_PDTULTFEC)+1)+"01"+CVALTOCHAR(DAY(_PDTULTFEC)))
else
	_dRet := stod(CVALTOCHAR(YEAR(_PDTULTFEC))+STRZERO(MONTH(_PDTULTFEC)+1,2)+STRZERO(DAY(_PDTULTFEC),2))
endif

return _dRet

static function numDiaMe(_mes)
if _mes==1 .or. _mes==3 .or. _mes==5 .or. _mes==7 .or. _mes==8 .or. _mes==10 .or. _mes==12
	return 31
elseif _mes==2
	if bissexto(year(ddatabase))
		return 29
	else
		return 28
	endif
else
	return 30
endif

return 30

static Function Bissexto(nAno)
Local lRet := .F.
if ((nAno % 4)==0) .and. !((nAno % 100) == 0) .or. (nAno % 400)==0
	lRet := .T.
endif
return lRet