#include 'protheus.ch'
#include 'parmtype.ch'

user function LGDAOAGA()	
return

/*
	@Author: nakao 
	Descrição: Cadastro de endereço(AGA)
	PROCESSO:
	-REMOÇÃO DE ESPAÇOS EM BRANCO NAS BORDAS DE TODOS OS CAMPOS
	-UPPERCASE EM VARIAVEIS
	-REMOÇÃO DE POSSIVEIS MASCARAS DE CAMPO(RETIRA-SE TRAÇOS E PONTOS DE CAMPOS COMO CPF,POR EXEMPLO)
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, RETORNA 0  E NAO CADASTRA
	-CADASTRO
	in: Todas as variaveis especificadas nos parametros.
	out: O codigo de AGA cadastrado ou 0 em caso de falha
*/
user function DAgaCad(filial, entidade, codEntida, tipo, padrao, endereco, cep, bairro, cdMun, munDes, estado, pais, complemento,peTipo2,codAga)
	/*Trim em todas as variaveis de entrada*/
	filial := ALLTRIM(filial)
	entidade := ALLTRIM(entidade)
	codEntida := ALLTRIM(codEntida)
	tipo:= ALLTRIM(tipo)
	padrao := ALLTRIM(padrao)
	endereco := ALLTRIM(endereco)
	cep := ALLTRIM(cep)
	bairro := ALLTRIM(bairro)
	cdMun := ALLTRIM(cdMun)
	munDes := ALLTRIM(munDes)
	estado := ALLTRIM(estado)
	pais := ALLTRIM(pais)	
	peTipo2 := ALLTRIM(peTipo2)
	munDes := UPPER(munDes)
	estado := UPPER(estado)
	peTipo2 := UPPER(peTipo2)
	bairro := UPPER(bairro)
	complemento := ALLTRIM(complemento)
	//Desmascara o cep(Tira o traço, cada exista)
	cep := u_LGFTUMSK(cep)
	
	exceptionList := u_DAgaVld(entidade,codEntida,estado,tipo,padrao,bairro,cdMun,munDes, peTipo2)
	if len(exceptionList)>0
		return "0"
	endif
	
	//Se cd mun é vazio, veja se existe na base um municipio com a descricao igual a de entrada, se existir, pegue o cod do municipio, se nao o ccadastro falha
	if cdMun==""
		dbSelectArea("CC2")
		dbSetOrder(4)//Filial + Estado + Descrição do municipio
		if dbSeek(xFilial("CC2")+estado+munDes) = .F.		
			return "0"
		else
			cdMun := CC2->CC2_CODMUN
		endif
	elseif munDes==""
		dbSelectArea("CC2")
		dbSetOrder(3)//Filial+codmun
		if dbSeek(xFilial("CC2")+cdMun) = .F.			
		else
			munDes := CC2->CC2_MUN
		endif
	endif
	//Se faltou algum campo, retorne a lista de campos não preenchidos e o codigo 0, indicando que o cadastro falhou
	if(codAga = nil .OR. codAga=="")
		codAga := GetSXENum("AGA","AGA_CODIGO")//Pega o proximo codigo disponivel de AGA
		ConfirmSx8()
	endif			
	DBSELECTAREA("AGA")
	RECLOCK("AGA",.T.)
	AGA->AGA_FILIAL := filial
	AGA->AGA_CODIGO := codAga
	AGA->AGA_ENTIDA := entidade
	AGA->AGA_CODENT := codEntida
	AGA->AGA_TIPO   := tipo
	AGA->AGA_PADRAO := padrao
	AGA->AGA_END    := endereco
	AGA->AGA_CEP    := cep
	AGA->AGA_BAIRRO := bairro
	AGA->AGA_MUNDES := munDes
	AGA->AGA_EST    := estado
	AGA->AGA_MUN    := cdMun 
	AGA->AGA_COMP   := complemento
	AGA->AGA_UTIPO2 := peTipo2
	AGA->AGA_PAIS   := pais	
	MSUNLOCK()
return codAga

user function DAgaList()
return

/*
	@Author: nakao 
	Descrição: Alteração de endereço(AGA)
	PROCESSO:
	-REMOÇÃO DE ESPAÇOS EM BRANCO NAS BORDAS DE TODOS OS CAMPOS
	-UPPERCASE EM VARIAVEIS
	-REMOÇÃO DE POSSIVEIS MASCARAS DE CAMPO(RETIRA-SE TRAÇOS E PONTOS DE CAMPOS COMO CPF,POR EXEMPLO)
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA ou o codAga não tenha sido passado, RETORNA 0  E NAO ATUALIZA
	-PROCURA-SE UM REGISTRO COM O CODAGA EM QUESTÃO COM DBSEEK, SE NAO EXISTIR RETORNE 0
	-UPDATE NO REGISTRO
	in: Todas as variaveis especificadas nos parametros.
	out: O codigo de AGA atualizado ou 0 em caso de falha
*/
user function DAgaAlter(filial, entidade, codEntida, tipo, padrao, endereco, cep, bairro, cdMun, munDes, estado, pais, complemento, peTipo2,codAga)
	/*Trim em todas as variaveis de entrada*/
	filial := ALLTRIM(filial)
	entidade := ALLTRIM(entidade)
	codEntida := ALLTRIM(codEntida)
	tipo:= ALLTRIM(tipo)
	padrao := ALLTRIM(padrao)
	endereco := ALLTRIM(endereco)
	cep := ALLTRIM(cep)
	bairro := ALLTRIM(bairro)
	cdMun := ALLTRIM(cdMun)
	munDes := ALLTRIM(munDes)
	estado := ALLTRIM(estado)
	pais := ALLTRIM(pais)	
	codAga := ALLTRIM(codAga)
	munDes := UPPER(munDes)
	estado := UPPER(estado)
	bairro := UPPER(bairro)
	peTipo2 := ALLTRIM(peTipo2)
	complemento := ALLTRIM(complemento)
	//Desmascara o cep(Tira o traço, cada exista)
	cep := u_LGFTUMSK(cep)
		
	exceptionList := u_DAgaVld(entidade,codEntida,estado,tipo,padrao,bairro,cdMun,munDes,peTipo2)
	if len(exceptionList)>0 .OR. codAga==""
		return "0"
	endif
	
	
	if cdMun==""
		dbSelectArea("CC2")
		dbSetOrder(4)//Filial + Estado + Descrição do municipio
		if dbSeek(xFilial("CC2")+estado+munDes) = .F.	
			return "0"
		else
			cdMun := CC2->CC2_CODMUN
		endif
	elseif munDes==""
		dbSelectArea("CC2")
		dbSetOrder(3)//Filial+codmun
		if dbSeek(xFilial("CC2")+cdMun) = .F.			
		else
			munDes := CC2->CC2_MUN
		endif
	endif
	//Se faltou algum campo, retorne a lista de campos não preenchidos e o codigo 0, indicando que o cadastro falhou
	_area := getArea()
	dbSelectArea("AGA")
	dbSetOrder(2)//Filial+codigo
	if dbSeek(xFILIAL("AGA")+codAga)
		RECLOCK("AGA",.F.)
		AGA->AGA_FILIAL := filial
		AGA->AGA_CODIGO := codAga
		AGA->AGA_ENTIDA := entidade
		AGA->AGA_CODENT := codEntida
		AGA->AGA_TIPO   := tipo
		AGA->AGA_PADRAO := padrao
		AGA->AGA_END    := endereco
		AGA->AGA_CEP    := cep
		AGA->AGA_BAIRRO := bairro
		AGA->AGA_MUNDES := munDes
		AGA->AGA_COMP   := complemento
		AGA->AGA_UTIPO2 := peTipo2
		AGA->AGA_EST    := estado
		AGA->AGA_MUN    := cdMun 
		AGA->AGA_PAIS   := pais
		MSUNLOCK()
	else
		return "0"
	endif	
	restarea(_area)
return codAga

user function DAgaFind()
return

/*
	@Author: nakao 
	Descrição: Validação de endereço(AGA)
	PROCESSO:
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, ADICIONE A LISTA PARA RETORNAR
	in: Todas as variaveis especificadas nos parametros.
	out: lista de strings, cada string representa o campo que faltou
*/
user function DAgaVld(entidade,codEntida,estado,tipo,padrao,bairro,cdMun,munDes,peTipo2)
	entidade := ALLTRIM(entidade)
	codEntida := ALLTRIM(codEntida)
	estado := ALLTRIM(estado)
	tipop := ALLTRIM(tipo)
	padrao := ALLTRIM(padrao)

	exceptionList := {}
	if((entidade == nil .OR. entidade==""), aAdd(exceptionList, "entidade"), .F.)
	if((codEntida == nil .OR. codEntida==""), aAdd(exceptionList, "Cd Entidade"), .F.)
	if((estado == nil .OR. estado==""), aAdd(exceptionList, "estado"), .F.)
	if((tipo == nil .OR. tipo==""), aAdd(exceptionList, "tipo"), .F.)		
	if((padrao == nil .OR. padrao==""), aAdd(exceptionList, "padrão"), .F.)	
	if((peTipo2 == nil .OR. peTipo2==""), aAdd(exceptionList, "tipo 2(Instacao, Cobranca ou Instalacao/Cobranca)"), .F.)	
	if((bairro == nil .OR. bairro==""), aAdd(exceptionList, "bairro"), .F.)	
	if (cdMun=="" .AND. munDes=="")
		aAdd(exceptionList,"cd Municipio")
		aAdd(exceptionList,"Descricao Municipio")		
	endif
	if(len(exceptionList)>0)
		CONOUT("PROBLEMA DE VALIDACAO NO ENDERECO, CAMPOS:")
		for i:=1 to len(exceptionList)
			CONOUT(exceptionList[i])
		next
	endif	
return exceptionList