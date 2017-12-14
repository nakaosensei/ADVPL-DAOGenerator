#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"

//RELATORIO PREVIEW DE CONSUMO SOBRE PRODUTOS
User Function LIGFAT11()
************************************
Local nOrdem                        // publica variavel
Private cDirDocs := MsDocPath()     // priva variavel com o caminho do arquivo temporario na rotina
Private cNomeArq := CriaTrab(,.F.)
PRIVATE _CPERG		:= "FAT11A"
PRIVATE _NTTITEM	:= 0
PRIVATE _NTTDEMO	:= 0
PRIVATE _CDIRPDF	:= "\PDF"
PRIVATE _LCONSOK	:= .F.

VALIDPERG()
IF !PERGUNTE(_CPERG)
	RETURN
ENDIF        

_DDTINI  := MV_PAR01
_DDTFIM  := MV_PAR02
_CPRODUTO := MV_PAR03

//DEFINE DIALOG oMainWnd TITLE "Exemplo TMSPrinter" FROM 180,180 TO 550,700 PIXEL

PROCESSA({||FAT011()})

//Activate Dialog oMainWnd Centered
RETURN


STATIC FUNCTION FAT011() //PROCESSAMENTO DOS CONTRATOS
LOCAL _NQTREGUA := 0
LOCAL _TOTALFAT := 0
Local aCabec := {}
Local aDados := {}

aCabec := {"Yate","Contrato","Nome", "Num Cobrança","Plano" ,"Valor Plano","Dt Bloqueio","Consumo","Vend1","Vend2","Ini. Vig"}

_CQUERY := " SELECT ADA.ADA_NUMCTR, ADA.ADA_UNRCOB, ADA.ADA_UDTBLQ, ADB.ADB_PRCVEN, ADB.ADB_DESPRO, ADB.ADB_UVEND1, ADB.ADB_UVEND2, ADB.ADB_UDTINI, ADB.ADB_UDTFIM"
_CQUERY += " ,ADA.ADA_UTIPO, ADA.ADA_UDTFEC, ADA.ADA_UIDYAT, SA1.A1_NOME"
//_CQUERY += " ADA.ADA_MSBLQL, ADA.ADA_UDTFEC"
_CQUERY += " FROM "+RETSQLNAME("ADA")+" ADA, "+RETSQLNAME("ADB")+" ADB," +RETSQLNAME("SA1")+" SA1"
_CQUERY += " WHERE ADB.ADB_CODPRO = '" + MV_PAR03 + "'"                                                                       
_CQUERY += " AND ADA.ADA_NUMCTR = ADB.ADB_NUMCTR "                                                                                                                      
_CQUERY += " AND ADA.ADA_CODCLI = SA1.A1_COD "                                                                                                                      
_CQUERY += " AND ADA.ADA_LOJCLI = SA1.A1_LOJA "                                                                                                                      
_CQUERY += " AND ADA.ADA_ULIBER = 'S' "                                                                                       
_CQUERY += " AND ADA.D_E_L_E_T_=' ' "                                           
_CQUERY += " AND ADB.D_E_L_E_T_=' ' "                                                                                  
_CQUERY += " ORDER BY CAST(ADA.ADA_UIDYAT AS INT), ADA.ADA_NUMCTR"   
                                                                            
_CQUERY := CHANGEQUERY(_CQUERY)
                  
TCQUERY _CQUERY NEW ALIAS "TADA"                                             // executa a query e coloca a resposta em um alias

DBSELECTAREA("TADA")
DBGOTOP()
WHILE !EOF()
		_NQTREGUA++
	DBSKIP()
ENDDO

PROCREGUA(_NQTREGUA)



DBSELECTAREA("TADA")
DBGOTOP()
WHILE !EOF()
	
		INCPROC("Processando...")
		_NVLEXT := 0
		//IF (ADA->ADA_MSBLQL!="1" .OR. (ADA->ADA_MSBLQL=="1" .AND. ADA->ADA_UDTFEC<=ADA->ADA_UDTBLQ)) .AND. ADA->ADA_NUMCTR>=_CCTRINI .AND. ADA->ADA_NUMCTR<=_CCTRFIM .AND. ADA->ADA_VEND1>=MV_PAR03 .AND. ADA->ADA_VEND1<=MV_PAR04 .AND. ADA->ADA_UTIPO = MV_PAR09
	

			_CNRCOB	   := TADA->ADA_UNRCOB							
			
			IF TADA->ADA_UTIPO=="F" //FTTH						
				_AREAADA   := TADA->(GETAREA())
				_NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
				_NCONNPTG  := TCLINK("POSTGRES/PostGreLigue","10.0.1.98",7890) //CONECTA AO POSTGRES
										
				_CQUERY := " SELECT SUM(CDR.VALOR) TOTAL "
				_CQUERY += " FROM TELEFONIA.CDR CDR "
				_CQUERY += " WHERE CDR.ACCOUNTCODE = '"+_CNRCOB+"' "
				_CQUERY += " AND CDR.DATA >= '"+DTOC(_DDTINI)+"' "
									
				IF !EMPTY(TADA->ADA_UDTBLQ) .AND. STOD(TADA->ADA_UDTBLQ) < _DDTFIM
					_CQUERY += " AND CDR.DATA <= '"+ DTOC(STOD(TADA->ADA_UDTBLQ) +1) +"' "
				ELSE
					_CQUERY += " AND CDR.DATA <= '"+DTOC(_DDTFIM + 1)+"' "
				ENDIF				
				//	_CQUERY += " AND CDR.DATA < '"+DTOC(DDATABASE)+"' " //ATE DIA ANTERIOR
									
				IF SELECT("TRB0")!=0
					TRB0->(DBCLOSEAREA())
				ENDIF
				TCQUERY _CQUERY NEW ALIAS "TRB0"
				_NVLEXT := TRB0->TOTAL
									
				TRB0->(DBCLOSEAREA())
									
				TCUNLINK(_NCONNPTG)  //FECHA CONEXAO POSTGRES
				TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
									
				RESTAREA(_AREAADA)
												
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
			
	IF	(EMPTY(TADA->ADB_UDTFIM) .OR. STOD(TADA->ADB_UDTFIM) >= _DDTINI) .AND. !EMPTY(TADA->ADB_UDTINI) .AND. STOD(TADA->ADB_UDTINI) <= _DDTFIM 
		AAdd(aDados, {TADA->ADA_UIDYAT,TADA->ADA_NUMCTR,TADA->A1_NOME, TADA->ADA_UNRCOB,TADA->ADB_DESPRO, TADA->ADB_PRCVEN, TADA->ADA_UDTBLQ, _NVLEXT, TADA->ADB_UVEND1, TADA->ADB_UVEND2 ,STOD(TADA->ADB_UDTINI) })   
	ENDIF     
	          
	DBSELECTAREA("TADA")
	DBSKIP()
ENDDO

If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel não instalado!")
	Return
EndIf
 
DlgToExcel({ {"ARRAY", "Exportacao para o Excel", aCabec, aDados} })

IF SELECT ("TADA") > 0                                                                                                                                                                                                                          // para saber se nao esta em branco
   TADA->(DBCLOSEAREA())                                                       // se esta em branco sai da rotina
ENDIF                                                                           // fecha o loop

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
AADD(AREGS,{_CPERG,"03","PRODUTO       ?","","","MV_CH03","C",15,0,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})

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

STATIC FUNCTION EXPEXCEL(AREA)
Local cPath    := AllTrim(GetTempPath())
Local oExcelApp
Local cArquivo := cNomeArq

If ! ApOleClient( "MsExcel" )
   MsgStop("MsExcel nao instalado")
   Return Nil      
EndIf

dbSelectArea(AREA)              

X := cDirDocs+"\"+cArquivo+".DBF"
COPY TO &X VIA "DBFCDXADS"
CpyS2T( cDirDocs+"\"+cArquivo+".DBF" , cPath, .T. )

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo+".DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)
Return