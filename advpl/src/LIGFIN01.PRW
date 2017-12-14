#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³LIGFIN01 ºAUTOR  ³CASSIUS CARLOS MARTINS ºDATA ³ 16/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³ ROTINA QUE DEFINE A REGRA PARA GERACAO DO PREFIXO DAS CR   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ LIGUE                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                  
USER FUNCTION LIGFIN01(_CFIL,_CSER)
************************************  
	LOCAL _CPREF := ""
	Local _modo  := ALLTRIM(GETMV("MV_UMODOPR"))


	IF _modo=="1" //MODO NOVO
		dbselectarea("SZ9")
		dbsetorder(1)//Z9_FILIAL+Z9_CODFIL+Z9_SERIE
		if dbseek(xFilial()+_CFIL+_CSER)
			_CPREF := SZ9->Z9_PREFIXO
		else
			dbselectarea("SZ9")
			dbsetorder(2)//Z9_FILIAL+Z9_PREFIXO
			dbseek(xFilial()+"ZZZ",.T.)
			dbskip(-1)
			_CPREF := SOMA1(SZ9->Z9_PREFIXO)
			reclock("SZ9",.t.)
			SZ9->Z9_FILIAL  := xFilial("SZ9")
			SZ9->Z9_CODFIL  := _CFIL
			SZ9->Z9_SERIE   := _CSER
			SZ9->Z9_PREFIXO := _CPREF
			MSUNLOCK()
		
		endif
	ELSE
		_CFIL := ALLTRIM(_CFIL)
		_CSER := ALLTRIM(_CSER)
	 
		_CPREF := SUBSTR(_CFIL,2,1)
		_CPREF += SUBSTR(_CFIL,4,1)
		IF SUBSTR(_CSER,1,1)=="C" //_CSER=="21"
			_CPREF += "C" //QDO NF 21 - NF DE COMUNICACAO
		ELSEIF SUBSTR(_CSER,1,1)=="D" //_CSER=="22" //QDO NF 22 - NF DE TELECOMUNICACAO
			_CPREF += "T"
		ELSE
			_CPREF += SUBSTR(_CSER,1,1)
		ENDIF
	ENDIF

RETURN(_CPREF)

USER FUNCTION TESTED01()

	WFPREPENV("01","FB01")
	DBSELECTAREA("SX5")
	SET FILTER TO X5_TABELA=="01"
	DBGOTOP()
	WHILE !EOF()
		DBSELECTAREA("SZ9")
		DBSETORDER(1)//Z9_FILIAL+Z9_CODFIL+Z9_SERIE
		IF !DBSEEK(XFILIAL()+xFilial("SF2")+ALLTRIM(SX5->X5_CHAVE))
			dbselectarea("SZ9")
			dbsetorder(2)//Z9_FILIAL+Z9_PREFIXO
			dbseek(xFilial()+"ZZZ",.T.)
			dbskip(-1)
			_CPREF := SOMA1(SZ9->Z9_PREFIXO)
			reclock("SZ9",.t.)
			SZ9->Z9_FILIAL  := xFilial("SZ9")
			SZ9->Z9_CODFIL  := xFilial("SF2")
			SZ9->Z9_SERIE   := ALLTRIM(SX5->X5_CHAVE)
			SZ9->Z9_PREFIXO := _CPREF
			MSUNLOCK()
		ENDIF
		DBSELECTAREA("SX5")
		DBSKIP()
	ENDDO
	SET FILTER TO

RETURN