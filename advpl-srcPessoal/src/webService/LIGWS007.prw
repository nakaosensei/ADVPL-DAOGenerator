#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVSWEBSRV.CH"

/*
author: @nakao
*/

WSSERVICE LIGWS007 Description "WS Apontamento"

WSDATA CPROJETO AS STRING
WSDATA CVERSAO AS STRING
WSDATA CTAREFA AS STRING
WSDATA CDATA AS STRING
WSDATA CHRINI AS STRING
WSDATA CHRFIM AS STRING
WSDATA CQTDHRS AS STRING
WSDATA CRECURSO AS STRING
WSDATA CPERCENTOCORR AS STRING
WSDATA CCUSTO AS STRING
WSDATA COBS AS STRING
WSDATA CTPMOVIMENTAC AS STRING
WSDATA CDTEMISSAO AS STRING
WSDATA ARMAZEM AS STRING
WSDATA COK           AS STRING
WSDATA _PRODUTOS     AS ILST701 OPTIONAL
WSMETHOD LIGWS7GR DESCRIPTION "WS Apontamento"

ENDWSSERVICE

WSSTRUCT LIST701
  WSDATA DATA701 AS STRING
ENDWSSTRUCT

WSSTRUCT ILST701
  WSDATA REGS701 AS ARRAY OF LIST701
ENDWSSTRUCT

WSMETHOD LIGWS7GR WSRECEIVE CPROJETO,CVERSAO,CTAREFA,CDATA,CHRINI,CHRFIM,CQTDHRS,CRECURSO,CPERCENTOCORR,CCUSTO,COBS,CTPMOVIMENTAC,CDTEMISSAO,ARMAZEM,_PRODUTOS WSSEND COK WSSERVICE LIGWS007
	//Abaixo, o mapeamento das posicoes de chegada do array _PRODUTOS
	Local pdCod     := 1    //CODPRO
	Local pdQtde    := 2    //Qtde
   	Local pdCdPro1 := ""    //Codigo do primeiro produto da lista
   	Local nkControl := 0    //Variavel de controle
   	CQTDHRS := u_hourMinuteToNum(CQTDHRS)//Funcao no LIGDFILTER.prw
   	RpcSetEnv("01","LG01",,,'FRT','Inicializacao',{"SA1"})
	::cOk := "OK"		
	CONOUT("ENTROU LIGWS007 DO NAKAO."+TIME())	
	CONOUT("VARIAVEIS QUE CHEGARAM NO CABECALHO:")
	CONOUT(" CPROJETO:" + ALLTRIM(CPROJETO) + " CVERSAO:" + ALLTRIM(CVERSAO) + " CTAREFA:" + ALLTRIM(CTAREFA) + " CDATA:" + ALLTRIM(CDATA) + " CHRINI:" + ALLTRIM(CHRINI) + " CHRFIM:" + ALLTRIM(CHRFIM) + " CQTDHRS:" + CVALTOCHAR(CQTDHRS) + " CRECURSO:" + ALLTRIM(CRECURSO) + " CPERCENTOCORR:" + ALLTRIM(CPERCENTOCORR) + " CCUSTO:" + ALLTRIM(CCUSTO) + " COBS:" + ALLTRIM(COBS) + " CTPMOVIMENTAC:" + ALLTRIM(CTPMOVIMENTAC) + " CDTEMISSAO:" + ALLTRIM(CDTEMISSAO))
	CONOUT("Produtos") 	
	CONOUT("Ordem esperada: codPro,qtde,custo")
	
	if((CPERCENTOCORR = nil .or. ALLTRIM(CPERCENTOCORR)==""), "0", CPERCENTOCORR)
	if((CCUSTO = nil .or. ALLTRIM(CCUSTO)==""), "0", CCUSTO)
	
	for j:=1 to len(::_PRODUTOS:REGS701)
		if(ALLTRIM(::_PRODUTOS:REGS701[j]:DATA701)<>"")	
			dados := StrTokArr(ALLTRIM(::_PRODUTOS:REGS701[j]:DATA701),";")
			CONOUT(::_PRODUTOS:REGS701[j]:DATA701)						
			if nkControl = 0
				pdCdPro1 := dados[pdCod]				
				nkControl := nkControl+1
			endif			
			if len( u_DSD3Vld(xFilial("SD3"), dados[pdCod] ,ARMAZEM))>0 //Chama a funcao de validação de telefone, LGDAOAGB.prw
				return .F.
			endif			
		endif
	next		
	
	res := len(u_DAFUVld(xFilial("AFU"),CPROJETO, CVERSAO, CTAREFA, CRECURSO, CDATA))	
	if res>0
		return .F.
	endif		
	
	//Passou da etapa de validacao, agora ao cadastro.	
	u_DAFUCad(xFilial("AFU"),CPROJETO,CVERSAO,CTAREFA,CDATA,CHRINI,CHRFIM,CRECURSO,COBS,pdCdPro1,ARMAZEM,CQTDHRS,VAL(CPERCENTOCORR),VAL(CCUSTO))//Cadastra o apontamento
	BEGIN TRANSACTION		
	//Geracao de despesas por rotina automatiza, MATA241	
	_aCab       := {}
	_aItem      := {}
	_atotitem   := {}
	lMsErroAuto := .f.
	lMsHelpAuto := .f.
	CONOUT(ALLTRIM(CTAREFA))
	CONOUT(ALLTRIM(CPROJETO))
	_aCab := { {"D3_TM" ,"509" , NIL},{"D3_EMISSAO" ,u_strToDate(CDATA), NIL} }
	for i := 1 to len(::_PRODUTOS:REGS701)
		if(ALLTRIM(::_PRODUTOS:REGS701[i]:DATA701)<>"")	
			dados := StrTokArr(ALLTRIM(::_PRODUTOS:REGS701[i]:DATA701),";")
			_aItem:={ {"D3_COD" ,dados[pdCod] ,NIL},{"D3_CUSTO1",},{"D3_UM" ,POSICIONE("SB1", 1, xFilial("SB1") + dados[pdCod], "B1_UM") ,NIL},{"D3_QUANT" ,VAL(dados[pdQtde]) ,NIL},{"D3_LOCAL" ,ARMAZEM ,NIL}, {"D3_PROJPMS",CPROJETO, NIL}, {"D3_TASKPMS",ALLTRIM(CTAREFA), NIL}}
			aAdd(_atotitem,_aitem)
		endif
	next
	if len(_aCab)>0 .and. len(_atotitem)>0
		lMsErroAuto := .F.
		dbselectarea("SD3")
		MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab,_atotitem,3)		
		If lMsErroAuto
			CONOUT(Mostraerro())			
			DisarmTransaction()
			CONOUT("ERRO MSEXECAUTO SD3")
			return .F.
			break
		endif
	endif	
	CONOUT("FIM LIGWS007")
	END TRANSACTION
RETURN .T.