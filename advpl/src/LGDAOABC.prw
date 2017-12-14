#include 'protheus.ch'
#include 'parmtype.ch'

user function LGDAOABC()	
return

/*
	@Author: nakao 
	Descrição: Cadastro de despesas(ABC)
	PROCESSO:
	-REMOÇÃO DE ESPAÇOS EM BRANCO NAS BORDAS DE TODOS OS CAMPOS
	-UPPERCASE EM VARIAVEIS
	-REMOÇÃO DE POSSIVEIS MASCARAS DE CAMPO(RETIRA-SE TRAÇOS E PONTOS DE CAMPOS COMO CPF,POR EXEMPLO)
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, caso exista retorne 0
	-CADASTRO
	in: Todas as variaveis especificadas nos parametros.
	out: codigo da entidade ou 0 em caso de falha 
*/
user function DABCCad(filial,numOS,nkseq,item,subOS,cdPro,descricao,qtde,vlUnit,valor,cdServico,armazem,cdAtendt,custo,prefixo,numero,parcela,tipo,fornecedor,lojForn,contrato,codGrpo)
	filial := if(filial = nil, xFilial("ABC"), filial)
	numOS := if(numOS = nil, "", numOS)
	item := if(item = nil, "", item)
	nkseq := if(nkseq = nil, "", nkseq)
	cdPro := if(cdPro = nil, "", cdPro)
	descricao := if(descricao = nil, "", descricao)
	cdServico := if(cdServico = nil, "", cdServico)
	armazem := if(armazem = nil, "", armazem)
	cdAtendt := if(cdAtendt = nil, "", cdAtendt)
	nkseq := if(nkseq = nil, "", nkseq)
	prefixo := if(prefixo = nil, "", prefixo)
	numero := if(numero = nil, "", numero)
	parcela := if(parcela = nil, "", parcela)
	subOS := if(subOS = nil, "", subOS)
	tipo := if(tipo = nil, "", tipo)
	fornecedor := if(fornecedor = nil, "", fornecedor)
	lojForn := if(lojForn = nil, "", lojForn)
	contrato := if(contrato = nil, "", contrato)
	codGrpo := if(codGrpo = nil, "", codGrpo)
	
	nkseq := ALLTRIM(nkseq)
	filial := ALLTRIM(filial)
	numOS := ALLTRIM(numOS)
	item := ALLTRIM(item)
	cdPro := ALLTRIM(cdPro)
	descricao := ALLTRIM(descricao)
	cdServico := ALLTRIM(cdServico)
	armazem := ALLTRIM(armazem)	
	descricao := UPPER(descricao)	
	
	//Validar Campos    
    exceptionList := {}
    exceptionList := u_DABCVld(filial,numOS,cdAtendt,cdPro,qtde)   
        
    if len(exceptionList)>0
    	CONOUT("PROBLEMA DE VALIDAÇÃO NA INSERÇÃO DA DESPESA")
    	return "0"
    endif   
        
    //Passou da etapa de validacao  
    //Cadastro     
    DBSELECTAREA("ABC")
    RECLOCK("ABC",.T.)  
    ABC->ABC_FILIAL := filial       
    ABC->ABC_NUMOS  :=  numOS     
    ABC->ABC_CODTEC := cdAtendt
	ABC->ABC_SEQ := nkseq
	ABC->ABC_ITEM := item
	ABC->ABC_CODPRO := cdPro
	ABC->ABC_DESCRI := descricao
	ABC->ABC_QUANT := qtde
	ABC->ABC_SUBOS := subOS
	ABC->ABC_VLUNIT := vlUnit
	ABC->ABC_CUSTO := custo
	ABC->ABC_VALOR := valor
	ABC->ABC_CODSER := cdServico
	ABC->ABC_UARMAZ := armazem
	MSUNLOCK()	        
return filial+numOS+cdAtendt+nkseq+item

user function DABCList()
return

/*
	@Author: nakao 
	Descrição: Alteração Atendimento OS(ABC)
	PROCESSO:
	-REMOÇÃO DE ESPAÇOS EM BRANCO NAS BORDAS DE TODOS OS CAMPOS
	-UPPERCASE EM VARIAVEIS
	-REMOÇÃO DE POSSIVEIS MASCARAS DE CAMPO(RETIRA-SE TRAÇOS E PONTOS DE CAMPOS COMO CPF,POR EXEMPLO)
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, caso exista retorne 0
	-DBSEEK COM BASE NO CGC, CASO NAO ENCONTRE RETORNE 0
	-UPDATE
	in: Todas as variaveis especificadas nos parametros.
	out: codigo ou 0 em caso de falha */
user function DABCAlter(filial,numOS,seq,item,subOS,cdPro,descricao,qtde,vlUnit,valor,cdServico,armazem,cdAtendt,custo,prefixo,numero,parcela,tipo,fornecedor,lojForn,contrato,codGrpo)
	filial := if(filial = nil, xFilial("ABC"), filial)
	numOS := if(numOS = nil, "", numOS)
	item := if(item = nil, "", item)
	nkseq := if(nkseq = nil, "", nkseq)
	cdPro := if(cdPro = nil, "", cdPro)
	descricao := if(descricao = nil, "", descricao)
	cdServico := if(cdServico = nil, "", cdServico)
	armazem := if(armazem = nil, "", armazem)
	cdAtendt := if(cdAtendt = nil, "", cdAtendt)
	nkseq := if(nkseq = nil, "", nkseq)
	prefixo := if(prefixo = nil, "", prefixo)
	numero := if(numero = nil, "", numero)
	parcela := if(parcela = nil, "", parcela)
	subOS := if(subOS = nil, "", subOS)
	tipo := if(tipo = nil, "", tipo)
	fornecedor := if(fornecedor = nil, "", fornecedor)
	lojForn := if(lojForn = nil, "", lojForn)
	contrato := if(contrato = nil, "", contrato)
	codGrpo := if(codGrpo = nil, "", codGrpo)
	
	nkseq := ALLTRIM(nkseq)
	filial := ALLTRIM(filial)
	numOS := ALLTRIM(numOS)
	item := ALLTRIM(item)
	cdPro := ALLTRIM(cdPro)
	descricao := ALLTRIM(descricao)
	cdServico := ALLTRIM(cdServico)
	armazem := ALLTRIM(armazem)	
	descricao := UPPER(descricao)	
	
	
	//Validar Campos    
    exceptionList := {}
    exceptionList := u_DABCVld(filial,numOS,cdAtendt,cdPro,qtde)
    
    
    qtde   := VAL(STRTRAN(qtde,",","."))
    vlUnit := VAL(STRTRAN(vlUnit,",",".")) 
    valor  := VAL(STRTRAN(valor,",","."))
        
    if len(exceptionList)>0
    	CONOUT("PROBLEMA DE VALIDAÇÃO NA INSERÇÃO DA DESPESA")
    	return "0"
    endif   
    
    //Passou da etapa de validacao  
    //Alteracao
    dbSelectArea("ABC")
    dbSetOrder(1)
    if(dbSeek(filial+numOS+cdAtendt+seq+item))
    	DBSELECTAREA("ABC")
	    RECLOCK("ABC",.F.)         
	    ABC->ABC_NUMOS  :=  numOS         
	    ABC->ABC_CODTEC := cdAtendt
		ABC->ABC_SEQ :=  seq
		ABC->ABC_ITEM := item
		ABC->ABC_CODPRO := cdPro
		ABC->ABC_DESCRI := descricao
		ABC->ABC_QUANT := qtde
		ABC->ABC_VLUNIT := vlUnit
		ABC->ABC_VALOR := valor
		ABC->ABC_CUSTO := custo
		ABC->ABC_CODSER := cdServico		
		ABC->ABC_UARMAZ := armazem
		MSUNLOCK()	        
    else
    	return "0"
    endif
return filial+numOS+cdAtendt+seq+item

user function DABCNextSubOS(filial, numOS, codTec)
	cAliasABC := GetNextAlias()
	codTec := ALLTRIM(codTec)
	numOS := ALLTRIM(numOS)
	filial := ALLTRIM(filial)
	cQuery := "SELECT MAX(ABC_SUBOS) AS ABC_SUBOS FROM "+RetSqlName("ABC")+" ABC WHERE ABC.ABC_FILIAL='"+filial+"' AND ABC.ABC_CODTEC='" +codTec+"' AND ABC.ABC_NUMOS='" +numOS+"' AND ABC.D_E_L_E_T_<>'*'"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasABC,.T.,.T.)
	strSq := (cAliasABC)->ABC_SUBOS	
	if strSq <> nil .AND. ALLTRIM(strSq)<>""
		seque := VAL(strSq)+1
		if(seque<=9)
			strSq := "0"+CVALTOCHAR(seque)
		else
			strSq := CVALTOCHAR(seque)
		endif
		return strSq
	endif
return "01"

user function DABCFind()
	
return

/*
	@Author: nakao 
	Descrição: Validação de OS(ABC)
	PROCESSO:
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, ADICIONE A LISTA PARA RETORNAR
	in: Todas as variaveis especificadas nos parametros.
	out: lista de strings, cada string representa o campo que faltou
*/
user function DABCVld(filial,numOS,cdAtendt,cdPro,qtde)
	exceptionList := {}
	filial := ALLTRIM(filial)
	numOS := ALLTRIM(numOS)
	cdAtendt := ALLTRIM(cdAtendt)
	cdPro := ALLTRIM(cdPro)
	
	if((filial = nil .or. filial==""), aAdd(exceptionList,"filial"), .F.)
	if((numOS = nil .or. numOS==""), aAdd(exceptionList,"numOS"), .F.)
	if((cdAtendt = nil .or. cdAtendt==""), aAdd(exceptionList,"cdAtendt"), .F.)
	if((cdPro = nil .or. cdPro==""), aAdd(exceptionList,"cdPro"), .F.)
	if((qtde = nil .or. qtde=0), aAdd(exceptionList,"qtde"), .F.)
		
	if(len(exceptionList)>0)
		CONOUT("PROBLEMA DE VALIDACAO NA DESPESA, CAMPOS:")
		for i:=1 to len(exceptionList)
			CONOUT(exceptionList[i])
		next
	endif	
return exceptionList