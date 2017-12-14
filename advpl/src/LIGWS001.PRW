#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVSWEBSRV.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIGWS001  ºAutor Daniel Gouvea           Data ³ 13/02/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³WS para gravar dados do cliente                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIGUE TELECOM                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

WSSERVICE LIGWS001 Description "WS Cadastro Cliente"

WSDATA CPESSOA  AS STRING
WSDATA CCGC		AS STRING
WSDATA CNOME	AS STRING
WSDATA CFANTAS  AS STRING
WSDATA CEMAIL   AS STRING
WSDATA CESTADO  AS STRING
WSDATA CCEP		AS STRING
WSDATA CEND     AS STRING
WSDATA CCOMPLE  AS STRING
WSDATA CBAIRRO  AS STRING
WSDATA CCODMUN  AS STRING
WSDATA CMUN	    AS STRING
WSDATA CDDD     AS STRING
WSDATA CTEL     AS STRING
WSDATA CDDDC    AS STRING
WSDATA CCEL     AS STRING
WSDATA CDTNASC  AS STRING
WSDATA CINSCR   AS STRING
WSDATA CRG		AS STRING
WSDATA CCONTAT  AS STRING
WSDATA CCPFCON  AS STRING
WSDATA CTIPO    AS STRING
WSDATA COK      AS STRING


WSMETHOD LIGWS1GR DESCRIPTION "Grava Dados Do Cliente" 

ENDWSSERVICE


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIGWS1GR  ºAutor Daniel Gouvea         º Data ³ 13/02/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava dados Cliente                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ligue                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

WSMETHOD LIGWS1GR WSRECEIVE CPESSOA,CCGC,CNOME,CFANTAS,CEMAIL,CESTADO,CCEP,CEND,CCOMPLE,CBAIRRO,CCODMUN,CMUN,CDDD,CTEL,CDDDC,CCEL,CDTNASC,CINSCR,CRG,CCONTAT,CCPFCON,CTIPO WSSEND COK WSSERVICE LIGWS001

LOCAL NCAMPOS := 0
LOCAL CCAMPO  := ""
LOCAL ACAMPOS := {}
LOCAL NCONT   := 0

RpcSetEnv("01","LG01",,,'FRT','Inicializacao',{"SA1"})

::cOk := "OK"

CONOUT("ENTROU LIGWS1GR ."+CCGC+"."+TIME())

DBSELECTAREA("SA1")
DBSETORDER(3)
dbgotop()
IF DBSEEK(xFilial()+ALLTRIM(CCGC))
	_ERRO := "JA EXISTE O CPF/CNPJ "+CCGC
	CONOUT(_ERRO)
	::cOk := _ERRO
ELSE
	RECLOCK("SA1",.T.)
	SA1->A1_FILIAL := XFILIAL("SA1")
	SA1->A1_COD    := SUBSTR(CCGC,1,9)
	IF LEN(ALLTRIM(CCGC))==11
		SA1->A1_LOJA   := "001"
	ELSE
		SA1->A1_LOJA   := SUBSTR(CCGC,10,3)
	ENDIF 
	SA1->A1_PESSOA   :=  CPESSOA  
	SA1->A1_CGC 	 :=  CCGC		
	SA1->A1_NOME 	 :=  CNOME	
	SA1->A1_NREDUZ 	 :=  CFANTAS    
	SA1->A1_EMAIL    :=  CEMAIL   
	SA1->A1_EST 	 :=  CESTADO  
	SA1->A1_CEP 	 :=  CCEP		
	SA1->A1_END 	 :=  CEND     
	SA1->A1_COMPLEM  :=  CCOMPLE  
	SA1->A1_BAIRRO   :=  CBAIRRO  
	SA1->A1_COD_MUN  :=  CCODMUN  
	SA1->A1_MUN 	 :=  CMUN	    
	SA1->A1_DDD      :=  CDDD     
	SA1->A1_TEL 	 :=  CTEL     
	SA1->A1_UDDDCEL  :=  CDDDC    
	SA1->A1_CEL      :=  CCEL     
	SA1->A1_DTNASC   :=  CTOD(CDTNASC)  
	SA1->A1_INSCR    :=  CINSCR   
	SA1->A1_PFISICA  :=  CRG
	SA1->A1_PAIS     := "105"		
	SA1->A1_CONTATO  :=  CCONTAT  
	SA1->A1_UCGCTIT  :=  CCPFCON  
	SA1->A1_TIPO     :=  CTIPO       
	MSUNLOCK()
	
	DBSELECTAREA("AGA")
	DBSETORDER(2)
	DBSEEK(XFILIAL()+"999999",.T.)
	DBSKIP(-1)
	_COD := SOMA1(AGA->AGA_CODIGO)
	RECLOCK("AGA",.T.)
	AGA->AGA_FILIAL := XFILIAL("AGA")
	AGA->AGA_CODIGO := _COD
	AGA->AGA_ENTIDA := "SA1"
	AGA->AGA_CODENT := SA1->A1_COD+SA1->A1_LOJA
	AGA->AGA_TIPO   := "2"
	AGA->AGA_PADRAO := "1"
	AGA->AGA_END    := SA1->A1_END
	AGA->AGA_CEP    := SA1->A1_CEP
	AGA->AGA_BAIRRO := SA1->A1_BAIRRO
	AGA->AGA_MUNDES := SA1->A1_MUN
	AGA->AGA_EST    := SA1->A1_EST
	AGA->AGA_MUN    := SA1->A1_COD_MUN
	AGA->AGA_PAIS   := SA1->A1_PAIS
	MSUNLOCK()
	
	DBSELECTAREA("AGB")
	DBSETORDER(2)
	DBSEEK(XFILIAL()+"999999",.T.)
	DBSKIP(-1)
	_COD := SOMA1(AGB->AGB_CODIGO)
	RECLOCK("AGB",.T.)
	AGB->AGB_FILIAL := XFILIAL()
	AGB->AGB_CODIGO := _COD
	AGB->AGB_ENTIDA := "SA1"
	AGB->AGB_CODENT := SA1->A1_COD+SA1->A1_LOJA
	AGB->AGB_TIPO   := "2"
	AGB->AGB_PADRAO := "1"
	AGB->AGB_DDD    := SA1->A1_DDD
	AGB->AGB_TELEFO := SA1->A1_TEL	
	msunlock()
	
ENDIF

RETURN .T. 