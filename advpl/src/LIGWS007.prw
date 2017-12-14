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


WSMETHOD LIGWS7GR WSRECEIVE CPROJETO,CVERSAO,CTAREFA,CDATA,CHRINI,CHRFIM,CQTDHRS,CRECURSO,CPERCENTOCORR,CCUSTO,COBS,CTPMOVIMENTAC,CDTEMISSAO,_PRODUTOS WSSEND COK WSSERVICE LIGWS007
	//Abaixo, o mapeamento das posicoes de chegada do array _PRODUTOS
	Local pdArmazem := 1    //Armazem
   	Local pdCod     := 2    //CODPRO
   	Local pdQtde    := 3    //Qtde
   	Local pdCusto   := 4    //Custo   	 	
   	
   RpcSetEnv("01","LG01",,,'FRT','Inicializacao',{"SA1"})
	::cOk := "OK"		
	CONOUT("ENTROU LIGWS007 DO NAKAO."+TIME())	
	CONOUT("VARIAVEIS QUE CHEGARAM NO CABECALHO:")
	CONOUT(" CPROJETO:" + ALLTRIM(CPROJETO) + " CVERSAO:" + ALLTRIM(CVERSAO) + " CTAREFA:" + ALLTRIM(CTAREFA) + " CDATA:" + ALLTRIM(CDATA) + " CHRINI:" + ALLTRIM(CHRINI) + " CHRFIM:" + ALLTRIM(CHRFIM) + " CQTDHRS:" + ALLTRIM(CQTDHRS) + " CRECURSO:" + ALLTRIM(CRECURSO) + " CPERCENTOCORR:" + ALLTRIM(CPERCENTOCORR) + " CCUSTO:" + ALLTRIM(CCUSTO) + " COBS:" + ALLTRIM(COBS) + " CTPMOVIMENTAC:" + ALLTRIM(CTPMOVIMENTAC) + " CDTEMISSAO:" + ALLTRIM(CDTEMISSAO))
	CONOUT("Produtos") 	
	CONOUT("Ordem esperada: codPro,armazem,qtde,grupo,custo")	
	for j:=1 to len(::_PRODUTOS:REGS701)
		if(ALLTRIM(::_PRODUTOS:REGS701[j]:DATA701)<>"")	
			dados := StrTokArr(ALLTRIM(::_PRODUTOS:REGS701[j]:DATA701),";")
			CONOUT(::_PRODUTOS:REGS701[j]:DATA701)			
			if( len( u_DSD3Vld(xFilial("SD3"), dados[pdCod] ,dados[pdArmazem]))>0) //Chama a funcao de validação de telefone, LGDAOAGB.prw
				CONOUT("LISTA DE PRODUTOS CONTEM PELO MENOS UM REGISTRO NAO VALIDO")
				return .F.
			endif			
		endif
	next		
	
	if (len(u_DAFUVld(xFilial("AFU"),"1" ,CPROJETO, CVERSAO, CTAREFA, CRECURSO, CDATA))>0)
		return .F.
	endif
	
	//Passou da etapa de validacao, agora ao cadastro.
	BEGIN TRANSACTION
	u_DAFUCad(CPROJETO,CVERSAO,CTAREFA,CDATA,CHRINI,CHRFIM,CQTDHRS,CRECURSO,CPERCENTOCORR,CCUSTO,COBS)//Cadastra o apontamento
	//Geracao de despesas por rotina automatiza, MATA241
	_aCab       := {}
	_aItem      := {}
	_atotitem   := {}
	lMsErroAuto := .f.
	lMsHelpAuto := .f.
	_aCab := { {"D3_TM" ,"509" , NIL},{"D3_EMISSAO" ,CDATA, NIL}}
	for i := 1 to len(::_PRODUTOS:REGS701)
		dados := StrTokArr(ALLTRIM(::_PRODUTOS:REGS701[j]:DATA701),";")
		_aItem:={ {"D3_COD" ,dados[pdCod] ,NIL},{"D3_UM" ,POSICIONE("SB1", 1, xFilial("SB1") + dados[pdCod], "B1_UM") ,NIL},{"D3_QUANT" ,dados[pdQtde] ,NIL},{"D3_LOCAL" ,dados[pdArmazem] ,NIL}}
		aAdd(_atotitem,_aitem)
	next	
	if len(_aCab)>0 .and. len(_atotitem)>0
		lMsErroAuto := .F.
		dbselectarea("SD3")
		MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab,_atotitem,3)		
		If lMsErroAuto
			Mostraerro()
			DisarmTransaction()
			break
		endif
	endif	
	END TRANSACTION	
RETURN .T. 