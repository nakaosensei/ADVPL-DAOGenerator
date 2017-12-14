#include 'protheus.ch'
#include 'parmtype.ch'

user function LGDAOSU5()	
return

/*
	@Author: nakao 
	Descrição: Cadastro de contato(SU5)
	PROCESSO:
	-REMOÇÃO DE ESPAÇOS EM BRANCO NAS BORDAS DE TODOS OS CAMPOS
	-UPPERCASE EM VARIAVEIS
	-REMOÇÃO DE POSSIVEIS MASCARAS DE CAMPO(RETIRA-SE TRAÇOS E PONTOS DE CAMPOS COMO CPF,POR EXEMPLO)
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, retorna 0
	-CADASTRO DO CONTATO
	in: Todas as variaveis especificadas nos parametros. 
	out: codigo do contato cadastrado ou "0" em caso de falha
*/
user function DSu5Cad(filial, nome,  cpf, endereco, bairro, rg, municipio, estado, cep, ddd, telefone, celular, email, dataNasc, codAga, codAgbRes, codAgbCel,codCont)
	//TRIM nos campos
	nome := ALLTRIM(nome)
	cpf := ALLTRIM(cpf)
	endereco := ALLTRIM(endereco)
	bairro := ALLTRIM(bairro)
	rg := ALLTRIM(rg)
	municipio := ALLTRIM(municipio)
	estado := ALLTRIM(estado)
	cep := ALLTRIM(cep)
	ddd := ALLTRIM(ddd)	
	telefone := ALLTRIM(telefone)
	celular := ALLTRIM(celular)
	email := ALLTRIM(email)
	dataNasc := ALLTRIM(dataNasc)	
	codCont := ALLTRIM(codCont)
	//UPPER nos campos
	nome := UPPER(nome)
	endereco := UPPER(endereco)
	bairro := UPPER(bairro)
	municipio := UPPER(municipio)
	estado := UPPER(estado)	
	//Remocao de mascara dos campos
	cpf :=  u_LGFTUMSK(cpf)
	rg :=  u_LGFTUMSK(rg)
	cep :=  u_LGFTUMSK(cep)
	telefone :=  u_LGFTUMSK(telefone)	
	celular :=  u_LGFTUMSK(celular)	
	//Validar Campos    
    exceptionList := {}	
	exceptionList := u_DSu5Vld(nome,  cpf, telefone, celular)
	if len(exceptionList)>0
		return "0"
    endif    
    if codCont = nil .OR. codCont == ""
    	codCont := GetSXENum("SU5","U5_CODCONT")//Codigo do contato	
    	ConfirmSx8()
    endif    	
	DBSELECTAREA("SU5")
	RECLOCK("SU5", .T.)
	SU5->U5_CODCONT := codCont
	SU5->U5_FILIAL := filial
	SU5->U5_CONTAT := nome
	SU5->U5_CPF    := cpf
	SU5->U5_END    := endereco
	SU5->U5_BAIRRO := bairro
	SU5->U5_RG     := rg
	SU5->U5_MUN    := municipio
	SU5->U5_EST    := estado
	SU5->U5_CEP    := cep
	SU5->U5_DDD    := ddd
	SU5->U5_FONE   := telefone
	SU5->U5_CELULAR := celular
	SU5->U5_EMAIL := email
	SU5->U5_ATIVO := "1"
	SU5->U5_CODAGA := codAga
	SU5->U5_AGBRES := codAgbRes
	SU5->U5_AGBCEL := codAgbCel
	
	MSUNLOCK()			
return codCont

user function DSu5List()
return

user function DSu5Alter(filial, nome,  cpf, endereco, bairro, rg, municipio, estado, cep, ddd, telefone, celular, email, dataNasc, codAga, codAgbRes, codAgbCel,codCont)
	nome := ALLTRIM(nome)
	cpf := ALLTRIM(cpf)
	endereco := ALLTRIM(endereco)
	bairro := ALLTRIM(bairro)
	rg := ALLTRIM(rg)
	municipio := ALLTRIM(municipio)
	estado := ALLTRIM(estado)
	cep := ALLTRIM(cep)
	ddd := ALLTRIM(ddd)	
	telefone := ALLTRIM(telefone)
	celular := ALLTRIM(celular)
	email := ALLTRIM(email)
	dataNasc := ALLTRIM(dataNasc)	
	codCont := ALLTRIM(codCont)
	//UPPER nos campos
	nome := UPPER(nome)
	endereco := UPPER(endereco)
	bairro := UPPER(bairro)
	municipio := UPPER(municipio)
	estado := UPPER(estado)	
	//Remocao de mascara dos campos
	cpf :=  u_LGFTUMSK(cpf)
	rg :=  u_LGFTUMSK(rg)
	cep :=  u_LGFTUMSK(cep)
	telefone :=  u_LGFTUMSK(telefone)	
	celular :=  u_LGFTUMSK(celular)	
	//Validar Campos    
    exceptionList := {}	
	exceptionList := u_DSu5Vld(nome,  cpf, telefone, celular)
	if len(exceptionList)>0 .OR. codCont==""
		return "0"
    endif  
    _area := getArea()
	dbSelectArea("SU5")
	dbSetOrder(1)//Filial+codCont
	if dbSeek(xFILIAL("SU5")+codCont)
		RECLOCK("SU5", .F.)
		SU5->U5_CODCONT := codCont
		SU5->U5_FILIAL := filial
		SU5->U5_CONTAT := nome
		SU5->U5_CPF    := cpf
		SU5->U5_END    := endereco
		SU5->U5_BAIRRO := bairro
		SU5->U5_RG     := rg
		SU5->U5_MUN    := municipio
		SU5->U5_EST    := estado
		SU5->U5_CEP    := cep
		SU5->U5_DDD    := ddd
		SU5->U5_FONE   := telefone
		SU5->U5_CELULAR := celular
		SU5->U5_EMAIL := email
		SU5->U5_ATIVO := "1"
		SU5->U5_CODAGA := codAga
		SU5->U5_AGBRES := codAgbRes
		SU5->U5_AGBCEL := codAgbCel
		MSUNLOCK()		
	else
		return "0"
	endif
return

user function DSu5Find()
return

/*
	@Author: nakao 
	Descrição: Validação de contato(SU5)
	PROCESSO:
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, ADICIONE A LISTA PARA RETORNAR
	in: Todas as variaveis especificadas nos parametros.
	out: lista de strings, cada string representa o campo que faltou
*/
user function DSu5Vld(nome,  cpf, telefone, celular)
	exceptionList := {}	
	nome := ALLTRIM(nome)
	cpf := ALLTRIM(cpf)
	if((nome = nil .OR. nome==""), aAdd(exceptionList, "nome"), .F.)	
	if((cpf =  nil .OR. cpf==""), aAdd(exceptionList, "cpf"), .F.)	
	/*
	if((telefone = nil .OR. telefone==""), aAdd(exceptionList, "telefone"), .F.)	
	if((celular = nil  .OR. celular==""), aAdd(exceptionList, "celular"), .F.)
	*/
	if(len(exceptionList)>0)
		CONOUT("PROBLEMA DE VALIDACAO NO CONTATO, CAMPOS:")
		for i:=1 to len(exceptionList)
			CONOUT(exceptionList[i])
		next
	endif	
return exceptionList
