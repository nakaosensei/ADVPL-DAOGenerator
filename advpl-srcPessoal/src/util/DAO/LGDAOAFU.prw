#include 'protheus.ch'
#include 'parmtype.ch'

//ATENCAO: ESSA TABELA CONTEM OS SEGUINTES CAMPOS NUMERICOS: HQUANT,UPERC,CUSTO1,CUSTO2,CUSTO3,CUSTO4,CUSTO5, esses campos devem ser passados como tipo numerico ou nulo
//Para facilitar a sua vida como programador, troque a ordem dos parametros da funcao, coloque todos os parametros que voce vai usar na sua atividade primeiro, deixando os campos numericos para o final, depois dos numericos deixe na assinatura da funcao todos os campos que voce nao ira usar agora.
//Tome cuidado com os campos de MEMO, voce tera que identificar manualmente qual o campo de memo adequado para usar a funcao MSMM.		
user function DAFUCad(UFILIAL,UPROJET,UREVISA,UTAREFA,UDATA,UHORAI,UHORAF,URECURS,UOBS,UCOD,ULOCAL,UHQUANT,UUPERC,UCUSTO1,UPREREC,UNUMSEQ,UCODMEM,UCUSTO2,UCUSTO3,UCUSTO4,UCUSTO5,UTPREAL,UDOCUME,UITEM,UID,UTPHORA)
	if(UFILIAL = nil, "", UFILIAL)
	if(UPROJET = nil, "", UPROJET)
	if(UREVISA = nil, "", UREVISA)
	if(UTAREFA = nil, "", UTAREFA)
	if(URECURS = nil, "", URECURS)
	if(UDATA   = nil, "", UDATA)
	if(UHORAI  = nil, "", UHORAI)
	if(UHORAF  = nil, "", UHORAF)
	if(UNUMSEQ = nil, "", UNUMSEQ)
	if(UCOD    = nil, "", UCOD)
	if(ULOCAL  = nil, "", ULOCAL)	
	if(UCODMEM = nil, "", UCODMEM)
	if(UTPREAL = nil, "", UTPREAL)
	if(UDOCUME = nil, "", UDOCUME)
	if(UPREREC = nil, "", UPREREC)
	if(UITEM   = nil, "", UITEM)
	if(UID     = nil, "", UID)
	if(UTPHORA = nil, "", UTPHORA)

	UFILIAL := ALLTRIM(UFILIAL)
	UPROJET := ALLTRIM(UPROJET)
	UREVISA := ALLTRIM(UREVISA)
	UTAREFA := ALLTRIM(UTAREFA)
	URECURS := ALLTRIM(URECURS)
	UDATA := ALLTRIM(UDATA)
	UHORAI := ALLTRIM(UHORAI)
	UHORAF := ALLTRIM(UHORAF)
	UNUMSEQ := ALLTRIM(UNUMSEQ)
	UCOD := ALLTRIM(UCOD)
	ULOCAL := ALLTRIM(ULOCAL)	
	UCODMEM := ALLTRIM(UCODMEM)
	UTPREAL := ALLTRIM(UTPREAL)
	UDOCUME := ALLTRIM(UDOCUME)
	UPREREC := ALLTRIM(UPREREC)
	UITEM := ALLTRIM(UITEM)
	UID := ALLTRIM(UID)
	UTPHORA := ALLTRIM(UTPHORA)

	exceptionList := {}
	exceptionList := u_DAFUVld(UFILIAL,UPROJET,UREVISA,UTAREFA,URECURS,UDATA)
	if len(exceptionList)>0
		CONOUT("PROBLEMA DE VALIDACAO NA TABELA AFU")
		return "0"
	endif
	
	UDATA := u_strToDate(UDATA) //Funcao de conversao avancada no LIGDFILTER.prw
	UFILIAL := if(UFILIAL == "", nil, UFILIAL)
	UPROJET := if(UPROJET == "", nil, UPROJET)
	UREVISA := if(UREVISA == "", nil, UREVISA)
	UTAREFA := if(UTAREFA == "", nil, UTAREFA)
	URECURS := if(URECURS == "", nil, URECURS)
	UHORAI := if(UHORAI == "", nil, UHORAI)
	UHORAF := if(UHORAF == "", nil, UHORAF)
	UNUMSEQ := if(UNUMSEQ == "", nil, UNUMSEQ)
	UCOD := if(UCOD == "", nil, UCOD)
	ULOCAL := if(ULOCAL == "", nil, ULOCAL)
	UCODMEM := if(UCODMEM == "", nil, UCODMEM)
	UTPREAL := if(UTPREAL == "", nil, UTPREAL)
	UDOCUME := if(UDOCUME == "", nil, UDOCUME)
	UPREREC := if(UPREREC == "", nil, UPREREC)
	UITEM := if(UITEM == "", nil, UITEM)
	UID := if(UID == "", nil, UID)
	UTPHORA := if(UTPHORA == "", nil, UTPHORA)
	
	DBSELECTAREA("AFU")
	RECLOCK("AFU",.T.)	
	AFU->AFU_FILIAL := UFILIAL
	AFU->AFU_PROJET := UPROJET
	AFU->AFU_REVISA := UREVISA
	AFU->AFU_TAREFA := UTAREFA	
	AFU->AFU_DATA := UDATA
	AFU->AFU_HORAI := UHORAI
	AFU->AFU_HORAF := UHORAF
	AFU->AFU_HQUANT := UHQUANT
	AFU->AFU_RECURS := URECURS
	AFU->AFU_PREREC := UPREREC
	AFU->AFU_CUSTO1 := UCUSTO1
	AFU->AFU_CODMEM := MSMM(,35,,UOBS,1,,,"AFU","AFU_CODMEM")	
	//AFU->AFU_UPERC := UUPERC
	AFU->AFU_NUMSEQ := UNUMSEQ
	//AFU->AFU_COD := UCOD
	//AFU->AFU_LOCAL := ULOCAL		
	AFU->AFU_CUSTO2 := UCUSTO2
	AFU->AFU_CUSTO3 := UCUSTO3
	AFU->AFU_CUSTO4 := UCUSTO4
	AFU->AFU_CUSTO5 := UCUSTO5
	AFU->AFU_TPREAL := UTPREAL
	AFU->AFU_DOCUME := UDOCUME	
	AFU->AFU_ITEM := UITEM
	AFU->AFU_ID := UID
	AFU->AFU_TPHORA := UTPHORA	
	MSUNLOCK()
		
	nkQuery := "UPDATE "+RetSqlName("AFU")+" SET AFU_CTRRVS = '"+u_findLastCtrvs(UFILIAL,UPROJET,UREVISA,UTAREFA,URECURS)+"'"
	if(ULOCAL <> nil)
		nkQuery := nkQuery + ",AFU_LOCAL = '"+ULOCAL+"'"
	endif
	if(UCOD <> nil)
		nkQuery := nkQuery + ",AFU_COD = '"+UCOD+"'"
	endif
	if(UUPERC <> nil)
		nkQuery := nkQuery + ",AFU_UPERC = "+CVALTOCHAR(UUPERC)+""
	endif
	nkQuery := nkQuery+" WHERE AFU_FILIAL='"+UFILIAL+"' AND AFU_PROJET='"+UPROJET+"' AND AFU_REVISA='"+UREVISA+"' AND AFU_TAREFA='"+UTAREFA+"' AND AFU_RECURS='"+URECURS+"' AND AFU_DATA='"+ DTOS(UDATA)+"' AND AFU_CTRRVS <> '1' AND AFU_CTRRVS <> '2';"
	TcSqlExec(nkQuery)	
	CONOUT(nkQuery)	
	TcSqlExec(nkQuery)	
return 

//ATENCAO: ESSA TABELA CONTEM OS SEGUINTES CAMPOS NUMERICOS: HQUANT,UPERC,CUSTO1,CUSTO2,CUSTO3,CUSTO4,CUSTO5, esses campos devem ser passados como tipo numerico ou nulo
//Para facilitar a sua vida como programador, troque a ordem dos parametros da funcao, coloque todos os parametros que voce vai usar na sua atividade primeiro, deixando os campos numericos para o final, depois dos numericos deixe na assinatura da funcao todos os campos que voce nao ira usar agora.
//Tome cuidado com os campos de MEMO, voce tera que identificar manualmente qual o campo de memo adequado para usar a funcao MSMM, voce tambem tera que adicionar a ordem e chave de busca no dbSeek.
user function DAFUAlter(FILIAL,PROJET,REVISA,TAREFA,DATAP,HORAI,HORAF,HQUANT,RECURS,PREREC,CUSTO1,OBS,UPERC,NUMSEQ,COD,LOCALP,CODMEM,CUSTO2,CUSTO3,CUSTO4,CUSTO5,TPREAL,DOCUME,ITEM,ID,TPHORA)
	if(UFILIAL = nil, "", UFILIAL)
	if(UPROJET = nil, "", UPROJET)
	if(UREVISA = nil, "", UREVISA)
	if(UTAREFA = nil, "", UTAREFA)
	if(URECURS = nil, "", URECURS)
	if(UDATA = nil, "", UDATA)
	if(UHORAI = nil, "", UHORAI)
	if(UHORAF = nil, "", UHORAF)
	if(UNUMSEQ = nil, "", UNUMSEQ)
	if(UCOD = nil, "", UCOD)
	if(ULOCAL = nil, "", ULOCAL)
	if(UCODMEM = nil, "", UCODMEM)
	if(UTPREAL = nil, "", UTPREAL)
	if(UDOCUME = nil, "", UDOCUME)
	if(UPREREC = nil, "", UPREREC)
	if(UITEM = nil, "", UITEM)
	if(UID = nil, "", UID)
	if(UTPHORA = nil, "", UTPHORA)

	UFILIAL := ALLTRIM(UFILIAL)
	UPROJET := ALLTRIM(UPROJET)
	UREVISA := ALLTRIM(UREVISA)
	UTAREFA := ALLTRIM(UTAREFA)
	URECURS := ALLTRIM(URECURS)
	UDATA := ALLTRIM(UDATA)
	UHORAI := ALLTRIM(UHORAI)
	UHORAF := ALLTRIM(UHORAF)
	UNUMSEQ := ALLTRIM(UNUMSEQ)
	UCOD := ALLTRIM(UCOD)
	ULOCAL := ALLTRIM(ULOCAL)
	UCODMEM := ALLTRIM(UCODMEM)
	UTPREAL := ALLTRIM(UTPREAL)
	UDOCUME := ALLTRIM(UDOCUME)
	UPREREC := ALLTRIM(UPREREC)
	UITEM := ALLTRIM(UITEM)
	UID := ALLTRIM(UID)
	UTPHORA := ALLTRIM(UTPHORA)

	exceptionList := {}
	exceptionList := u_DAFUVld(UFILIAL,UPROJET,UREVISA,UTAREFA,URECURS,UDATA)
	if len(exceptionList)>0
		CONOUT("PROBLEMA DE VALIDACAO NA TABELA AFU")
		return "0"
	endif

	UDATA := u_strToDate(UDATA) //Funcao de conversao avancada no LIGDFILTER.prw

	UFILIAL := if(UFILIAL == "", nil, UFILIAL)
	UPROJET := if(UPROJET == "", nil, UPROJET)
	UREVISA := if(UREVISA == "", nil, UREVISA)
	UTAREFA := if(UTAREFA == "", nil, UTAREFA)
	URECURS := if(URECURS == "", nil, URECURS)
	UHORAI := if(UHORAI == "", nil, UHORAI)
	UHORAF := if(UHORAF == "", nil, UHORAF)
	UNUMSEQ := if(UNUMSEQ == "", nil, UNUMSEQ)
	UCOD := if(UCOD == "", nil, UCOD)
	ULOCAL := if(ULOCAL == "", nil, ULOCAL)
	UCODMEM := if(UCODMEM == "", nil, UCODMEM)
	UTPREAL := if(UTPREAL == "", nil, UTPREAL)
	UDOCUME := if(UDOCUME == "", nil, UDOCUME)
	UPREREC := if(UPREREC == "", nil, UPREREC)
	UITEM := if(UITEM == "", nil, UITEM)
	UID := if(UID == "", nil, UID)
	UTPHORA := if(UTPHORA == "", nil, UTPHORA)
	
	DBSELECTAREA("AFU")
	DBSETORDER(INSIRA_MANUALMENTE)
	IF DBSEEK(INSIRA_MANUALMENTE)
		RECLOCK("AFU",.F.)
		AFU->AFU_FILIAL := FILIAL
		AFU->AFU_PROJET := PROJET
		AFU->AFU_REVISA := REVISA
		AFU->AFU_TAREFA := TAREFA
		AFU->AFU_RECURS := RECURS
		AFU->AFU_DATA := DATAP
		AFU->AFU_HORAI := HORAI
		AFU->AFU_HORAF := HORAF
		AFU->AFU_HQUANT := HQUANT
		AFU->AFU_UPERC := UPERC
		AFU->AFU_NUMSEQ := NUMSEQ
		AFU->AFU_COD := COD
		AFU->AFU_LOCAL := LOCALP		
		AFU->AFU_CODMEM := MSMM(,35,,OBS,1,,,"AFU","AFU_CODMEM")
		AFU->AFU_CUSTO1 := CUSTO1
		AFU->AFU_CUSTO2 := CUSTO2
		AFU->AFU_CUSTO3 := CUSTO3
		AFU->AFU_CUSTO4 := CUSTO4
		AFU->AFU_CUSTO5 := CUSTO5
		AFU->AFU_TPREAL := TPREAL
		AFU->AFU_DOCUME := DOCUME
		AFU->AFU_PREREC := AFU_PREREC
		AFU->AFU_ITEM := ITEM
		AFU->AFU_ID := ID
		AFU->AFU_TPHORA := TPHORA
		MSUNLOCK()
	endif
return 


user function DAFUVld(FILIAL,PROJET,REVISA,TAREFA,RECURS,DATAP)
	exceptionList := {}
	FILIAL := ALLTRIM(FILIAL)
	PROJET := ALLTRIM(PROJET)
	REVISA := ALLTRIM(REVISA)
	TAREFA := ALLTRIM(TAREFA)
	RECURS := ALLTRIM(RECURS)
	DATAP := ALLTRIM(DATAP)

	if((FILIAL = nil .or. FILIAL==""), aAdd(exceptionList,"FILIAL"), .F.)
	if((PROJET = nil .or. PROJET==""), aAdd(exceptionList,"PROJET"), .F.)
	if((REVISA = nil .or. REVISA==""), aAdd(exceptionList,"REVISA"), .F.)
	if((TAREFA = nil .or. TAREFA==""), aAdd(exceptionList,"TAREFA"), .F.)
	if((RECURS = nil .or. RECURS==""), aAdd(exceptionList,"RECURS"), .F.)
	if((DATAP = nil .or. DATAP==""), aAdd(exceptionList,"DATA"), .F.)

	if(len(exceptionList)>0)
		CONOUT("PROBLEMA DE VALIDACAO NA TABELA AFU, CAMPOS:")
		for i:=1 to len(exceptionList)
		 	CONOUT(exceptionList[i])
		next        
	endif	
return exceptionList

user function findLastCtrvs(UFILIAL,UPROJET,UREVISA,UTAREFA,URECURS)
	nkQuery := "SELECT AFU_CTRRVS FROM "+RetSqlName("AFU")
	nkQuery := nkQuery+" WHERE AFU_FILIAL='"+UFILIAL+"' AND AFU_PROJET='"+UPROJET+"' AND AFU_REVISA='"+UREVISA+"' AND AFU_TAREFA='"+UTAREFA+"' AND AFU_RECURS='"+URECURS+"' AND AFU_CTRRVS <> '' ORDER BY AFU_DATA DESC;"
	CONOUT(nkQuery)
	cAliasNk := GetNextAlias()
	nkQuery := ChangeQuery(nkQuery)	 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,nkQuery),cAliasNk,.T.,.T.)
	nkCtrvs := (cAliasNk)->AFU_CTRRVS //Quantidade em estoque do armazem do produto em quatao
	if(nkCtrvs <> nil .and. ALLTRIM(nkCtrvs)<>"")
		return nkCtrvs
	endif	
return '1'

