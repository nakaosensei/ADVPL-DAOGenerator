#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVSWEBSRV.CH"

/*
@author: Vinicius Dias, Thiago Nakao
*/

WSSERVICE LIGWS003 Description "WS Atendimento O.S Ligue"

WSDATA NUMOS	 AS STRING   //AB9_NUMOS
WSDATA CODCLI	 AS STRING	 //AB9_CODCLI
WSDATA LOJA		 AS STRING	 //AB9_LOJA
WSDATA ATENDENTE AS STRING   //AB9_CODTEC  
WSDATA DTCHEGADA AS STRING   //AB9_DTCHEG
WSDATA HRCHEGADA AS STRING   //AB9_HRCHEG
WSDATA DTSAIDA	 AS STRING   //AB9_DTSAID
WSDATA HRSAIDA	 AS STRING   //AB9_HRSAID
WSDATA DTINICIAL AS STRING   //AB9_DTINI
WSDATA HRINICIAL AS STRING   //AB9_HRINI 
WSDATA DTFINAL	 AS STRING   //AB9_DTFIM  
WSDATA HRFINAL	 AS STRING   //AB9_HRFIM  
WSDATA OCORR	 AS STRING   //AB9_CODPRB
WSDATA LAUDO     AS STRING   //AB9_SEQ 
WSDATA ACUMUL	 AS STRING	 //AB9_ACUMUL
WSDATA STATUS	 AS STRING	 //AB9_TIPO
WSDATA TRASLA	 AS STRING	 //AB9_TRASLA
WSDATA HRSFATS   AS STRING   //AB9_TOTFAT
WSDATA SEQ       AS STRING   //AB9_SEQ
WSDATA PORTA     AS STRING   //AB9_TOTFAT
WSDATA CAIXA     AS STRING   //AB9_SEQ
WSDATA COK	     AS STRING   //RETORNO
WSDATA _DATA100  AS ILST100 OPTIONAL
WSMETHOD LIGWS3GR DESCRIPTION "Grava dados Do Atendimento da O.S"

ENDWSSERVICE

WSSTRUCT LIST100
  WSDATA DATA100 AS STRING
ENDWSSTRUCT

WSSTRUCT ILST100
  WSDATA REGS100 AS ARRAY OF LIST100
ENDWSSTRUCT

WSMETHOD LIGWS3GR WSRECEIVE NUMOS,CODCLI,LOJA,ATENDENTE,DTCHEGADA,HRCHEGADA,DTSAIDA,HRSAIDA,DTINICIAL,HRINICIAL,DTFINAL,HRFINAL,OCORR,LAUDO,ACUMUL,STATUS,TRASLA,HRSFATS,SEQ,PORTA,CAIXA,_DATA100 WSSEND COK WSSERVICE LIGWS003
	//Abaixo, o mapeamento das posicoes de chegada do array _DATA100, array de despesas
	Local piProd     := 1
	Local piDescr    := 2
	Local piQtde     := 3
	Local piVlrUnit  := 4
	Local piVlrTotal := 5
	Local piServico  := 6
	Local piArmazem  := 7		
	Local seque      := 0
	Local nkSq       := ""	
	Local nkTotal    := 0
	Local nkQtde     := 0
	Local nkVlUnit   := 0
	//Abertura do ambiente em rotinas autom�ticas Ir para o final dos metaDATA100	
	RpcSetEnv("01","LG01",,,'FRT','Inicializacao',{"AB9","ABC"})
		
	NUMOS := u_LGFTUMSK(NUMOS)//Desmascara o CCGC, caso venha com tracos e/ou pontos
	NUMOS := ALLTRIM(NUMOS)
	::cOk := "OK"
	CONOUT("ENTROU LIGWS3GR ."+NUMOS+"."+TIME())		
	CONOUT("NUMOS:"+NUMOS+" CDCLI:"+CODCLI+" LOJCLI:"+LOJA+" CDATENDENTE:"+ATENDENTE+" SEQ:"+SEQ+" DTCHEG:"+DTCHEGADA+" HRCHEG:"+HRCHEGADA+" DTSAID:"+DTSAIDA+" HRSAID:"+HRSAIDA+" DTINI:"+DTINICIAL+" HRINI:"+HRINICIAL+" DTFIM:"+DTFINAL+" HRFIM:"+HRFINAL+" OCORR:"+OCORR+" LAUDO:"+LAUDO+" ACUMUL:"+ACUMUL+" STATUS:"+STATUS+" TRASLA:"+TRASLA+" TOTFAT:"+HRSFATS+" PORTA:"+PORTA+" CAIXA:"+CAIXA)
	CONOUT("Array de despesas:")
	CONOUT("Ordem esperada:cdPro,DescPro,Qtde,VlrUnit,VlrTotal,cdServico,Armazem")
	for j:=1 to len(::_DATA100:REGS100)
		if(ALLTRIM(::_DATA100:REGS100[j]:DATA100)<>"")
			dadosDsp := StrTokArr(ALLTRIM(::_DATA100:REGS100[j]:DATA100),";")
			CONOUT(::_DATA100:REGS100[j]:DATA100)	
			if( len(u_DABCVld( xFilial("ABC") ,NUMOS,ATENDENTE,dadosDsp[piProd],u_LIGVAL(dadosDsp[piQtde]) ) )>0) //Chama a fun��o de valida��o de endereco, LGDAOAGA.prw, LIGVAL esta no LIGDFILTER.prw
				CONOUT("LISTA DE DESPESAS POSSUI UMA DESPESA INVALIDA")
				return .F.
			endif		
		endif
	next		
	
	//VALIDACAO DE AB9	
	if len(u_DAB9Vld(xFilial("AB9"),NUMOS,ATENDENTE,SEQ))>0
		return .F.
	endif												
	
	//Passou da validacao, agora vai para o cadastro/anteracao
	BEGIN TRANSACTION			
		if u_DAB9Exists(xFilial("AB9"),NUMOS,ATENDENTE,SEQ)			
			CONOUT("ALTER")
			SEQUENCIA := SEQ
			u_DAB9Alter(xFilial("AB9"),NUMOS,SEQUENCIA,ATENDENTE,DTCHEGADA,DTSAIDA,HRCHEGADA,HRSAIDA,DTINICIAL,DTFINAL,HRINICIAL,HRFINAL,OCORR,LAUDO,ACUMUL,STATUS,CODCLI,LOJA,TRASLA,HRSFATS)			
		else
			CONOUT("CADASTRO")
			SEQUENCIA := SEQ
			u_DAB9Cad(xFilial("AB9"),NUMOS,SEQUENCIA,ATENDENTE,DTCHEGADA,DTSAIDA,HRCHEGADA,HRSAIDA,DTINICIAL,DTFINAL,HRINICIAL,HRFINAL,OCORR,LAUDO,ACUMUL,STATUS,CODCLI,LOJA,TRASLA,HRSFATS)
			DBSELECTAREA("AB6")
			DBSETORDER(1)
			if dbSeek(xFilial("AB6")+NUMOS)
				RECLOCK("AB6",.F.)
				AB6->AB6_UCAIXA := CAIXA
				AB6->AB6_UPORTA := PORTA
			endif			
			seque := 1
			nkSq := ""			
			for nI := 1 to Len( ::_DATA100:REGS100 )				
				if(ALLTRIM(::_DATA100:REGS100[nI]:DATA100)<>"")
					if(seque<=9)
						nkSq := "0"+CVALTOCHAR(seque)
					else
						nkSq := CVALTOCHAR(seque)
					endif
					seque := seque+1
					dadosDsp := StrTokArr(ALLTRIM(::_DATA100:REGS100[nI]:DATA100),";")
					nkTotal  := VAL(dadosDsp[piVlrTotal])
					nkQtde   := VAL(dadosDsp[piQtde])
					nkVlUnit := VAL(dadosDsp[piVlrUnit])						
					u_DABCCad("LG01",NUMOS,SEQUENCIA,nkSq,u_DABCNextSubOS("LG01",NUMOS,ATENDENTE),dadosDsp[piProd],dadosDsp[piDescr],nkQtde,nkVlUnit,nkTotal,dadosDsp[piServico],dadosDsp[piArmazem],ATENDENTE,nkTotal)									
				endif					
			next		
		endif			
		CONOUT("FIM")			
		::cOK := "OK"			
	END TRANSACTION			
RETURN .T. 