#include 'protheus.ch'
#include 'parmtype.ch'

user function LGDAOAGB()	
return

/*
	@Author: nakao 
	Descrição: Cadastro de telefone(AGB)
	PROCESSO:
	-REMOÇÃO DE ESPAÇOS EM BRANCO NAS BORDAS DE TODOS OS CAMPOS
	-UPPERCASE EM VARIAVEIS
	-REMOÇÃO DE POSSIVEIS MASCARAS DE CAMPO(RETIRA-SE TRAÇOS E PONTOS DE CAMPOS COMO CPF,POR EXEMPLO)
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, RETORNE 0
	-CADASTRO
	in: Todas as variaveis especificadas nos parametros.
	out: cod AGB ou 0 em caso de falha
*/
user function DAgbCad(filial, entidade, codEnt, tipo, padrao, ddd, telefone, dddi, tipo2, complemento, foneTitular, cpfcnpjTit, codAgb,cdCCenter)
	/*Trim em todas as variaveis de entrada*/
	filial := ALLTRIM(filial)
	entidade := ALLTRIM(entidade)
	codEnd := ALLTRIM(codEnt)
	tipo := ALLTRIM(tipo)
	padrao:= ALLTRIM(padrao)
	ddd := ALLTRIM(ddd)
	telefone := ALLTRIM(telefone)
	dddi := ALLTRIM(dddi)
	tipo2 := ALLTRIM(tipo2)
	cdCCenter := ALLTRIM(cdCCenter)
	complemento := ALLTRIM(complemento)
	foneTitular:=ALLTRIM(foneTitular)
	cpfcnpjTit := ALLTRIM(cpfcnpjTit)
	
	//Desmascara os campos necessarios(Retira pontos e traços, caso existam)
	telefone := u_LGFTUMSK(telefone)
	foneTitular := u_LGFTUMSK(foneTitular)
	cpfcnpjTit := u_LGFTUMSK(cpfcnpjTit)
	
	exceptionList := {}
	exceptionList := u_DAgbVld(entidade, codEnt, tipo, padrao,ddd,telefone)
	if len(exceptionList)>0
		return "0"
	endif
	if codAgb = nil .OR. codAgb==""
		codAgb := GetSXENum("AGB","AGB_CODIGO") //Pega o proximo codigo disponivel de Agb
		ConfirmSx8()
	endif	
	/*Cadastro*/
	RECLOCK("AGB",.T.)			
	AGB->AGB_FILIAL := filial
	AGB->AGB_CODIGO := codAgb        
	AGB->AGB_ENTIDA := entidade						
	AGB->AGB_CODENT := codEnt		
	AGB->AGB_TIPO   := tipo			
	AGB->AGB_PADRAO := padrao		
	AGB->AGB_DDD    := ddd		
	AGB->AGB_TELEFO := telefone
	AGB->AGB_DDI    := dddi			
	AGB->AGB_UTIPO2 := tipo2
	AGB->AGB_COMP   := complemento		
	AGB->AGB_UTITUL := foneTitular
	AGB->AGB_UCGC   := cpfcnpjTit
	AGB->AGB_UCALLC := cdCCenter	
	MSUNLOCK()	
return codAgb        

user function DAgbList()
return

/*
	@Author: nakao 
	Descrição: Alteração de telefone(AGB)
	PROCESSO:
	-REMOÇÃO DE ESPAÇOS EM BRANCO NAS BORDAS DE TODOS OS CAMPOS.
	-UPPERCASE EM VARIAVEIS.
	-REMOÇÃO DE POSSIVEIS MASCARAS DE CAMPO(RETIRA-SE TRAÇOS E PONTOS DE CAMPOS COMO CPF,POR EXEMPLO).
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, RETORNE 0.
	-DbSeek no cod agb passado por parametro, se nao encontrar retorne 0.
	-Operação de UPDATE na tabela.
	-Retorne o codAgb.
	in: Todas as variaveis especificadas nos parametros.
	out: cod AGB ou 0 em caso de falha.
*/
user function DAgbAlter(filial, entidade, codEnt, tipo, padrao, ddd, telefone, dddi, tipo2, complemento, foneTitular, cpfcnpjTit, codAgb,cdCCenter)
	filial := ALLTRIM(filial)
	entidade := ALLTRIM(entidade)
	codEnd := ALLTRIM(codEnt)
	tipo := ALLTRIM(tipo)
	padrao:= ALLTRIM(padrao)
	ddd := ALLTRIM(ddd)
	telefone := ALLTRIM(telefone)
	dddi := ALLTRIM(dddi)
	tipo2 := ALLTRIM(tipo2)
	complemento := ALLTRIM(complemento)
	foneTitular:=ALLTRIM(foneTitular)
	cpfcnpjTit := ALLTRIM(cpfcnpjTit)
	codAgb := ALLTRIM(codAgb)
	
	//Desmascara os campos necessarios(Retira pontos e traços, caso existam)
	telefone := u_LGFTUMSK(telefone)
	foneTitular := u_LGFTUMSK(foneTitular)
	cpfcnpjTit := u_LGFTUMSK(cpfcnpjTit)
	cdCCenter := ALLTRIM(cdCCenter)
	exceptionList := {}
	exceptionList := u_DAgbVld(entidade, codEnt, tipo, padrao, ddd,telefone)
	if len(exceptionList)>0 .OR. codAgb==""
		return "0"
	endif
	_area := getarea()
	dbSelectArea("AGB")
	dbSetOrder(2)//Filial+codigo
	if dbSeek(xFILIAL("AGB")+codAgb)
		RECLOCK("AGB",.F.)			
		AGB->AGB_FILIAL := filial
		AGB->AGB_CODIGO := codAgb        
		AGB->AGB_ENTIDA := entidade						
		AGB->AGB_CODENT := codEnt		
		AGB->AGB_TIPO   := tipo			
		AGB->AGB_PADRAO := padrao		
		AGB->AGB_DDD    := ddd		
		AGB->AGB_TELEFO := telefone
		AGB->AGB_DDI    := dddi			
		AGB->AGB_UTIPO2 := tipo2
		AGB->AGB_COMP   := complemento		
		AGB->AGB_UTITUL := foneTitular
		AGB->AGB_UCGC   := cpfcnpjTit
		AGB->AGB_UCALLC := cdCCenter
		MSUNLOCK()	
	else
		return "0"
	endif	
	restarea(_area)
return codAgb

user function DAgbFind()
return

/*
	@Author: nakao 
	Descrição: Validação de telefone(AGB)
	PROCESSO:
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, ADICIONE A LISTA PARA RETORNAR
	in: Todas as variaveis especificadas nos parametros.
	out: lista de strings, cada string representa o campo que faltou
*/
user function DAgbVld(entidade, codEnt, tipo, padrao, ddd,telefone)
	entidade := ALLTRIM(entidade)
	codEnt := ALLTRIM(codEnt)
	tipo := ALLTRIM(tipo)
	padrao := ALLTRIM(padrao)
	ddd := ALLTRIM(ddd)
	telefone := ALLTRIM(telefone)
	exceptionList := {}
	if((entidade = nil .OR. entidade==""), aAdd(exceptionList, "entidade"), .F.)
	if((codEnt = nil .OR. codEnt==""), aAdd(exceptionList, "Cd Entidade"), .F.)
	if((tipo = nil .OR. tipo==""), aAdd(exceptionList, "tipo"), .F.)
	if((padrao = nil .OR. padrao==""), aAdd(exceptionList, "padrão"), .F.)	
	if((telefone = nil .OR. telefone==""), aAdd(exceptionList, "telefone"), .F.)
	if((ddd = nil .OR. ddd==""), aAdd(exceptionList, "DDD"), .F.)		
	if(len(exceptionList)>0)
		CONOUT("PROBLEMA DE VALIDACAO NO TELEFONE, CAMPOS:")
		for i:=1 to len(exceptionList)
			CONOUT(exceptionList[i])
		next
	endif	
return exceptionList