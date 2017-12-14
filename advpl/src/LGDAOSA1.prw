#include 'protheus.ch'
#include 'parmtype.ch'

user function LIGDAOSA1()	
return
/*
	@Author: nakao 
	Descrição: Cadastro de cliente(SA1)
	PROCESSO:
	-REMOÇÃO DE ESPAÇOS EM BRANCO NAS BORDAS DE TODOS OS CAMPOS
	-UPPERCASE EM VARIAVEIS
	-REMOÇÃO DE POSSIVEIS MASCARAS DE CAMPO(RETIRA-SE TRAÇOS E PONTOS DE CAMPOS COMO CPF,POR EXEMPLO)
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, caso exista retorne 0
	-CADASTRO
	in: Todas as variaveis especificadas nos parametros.
	out: CodCli+LojCli ou 0 em caso de falha 
*/
user function DSa1Cad(filial, CCGC, pessoa, nome, fantasia, email, estado, cep, endereco, complemento, bairro, cdMun, munDes, ddd, telefone, dddCel, celular, dataNasc, inscricao, rg, pais, contato, cpfContato, tipo, cdNaturza)
	//Trim nos campos
	filial := ALLTRIM(filial)
	CCGC := ALLTRIM(CCGC)
	pessoa := ALLTRIM(pessoa)
	nome := ALLTRIM(nome)
	fantasia:=ALLTRIM(fantasia)
	email := ALLTRIM(email)
	estado := ALLTRIM(estado)
	cep := ALLTRIM(cep)
	endereco := ALLTRIM(endereco)
	complemento:= ALLTRIM(complemento)
	bairro := ALLTRIM(bairro)
	cdMun := ALLTRIM(cdMun)
	munDes := ALLTRIM(munDes)
	ddd:=ALLTRIM(ddd)
	telefone := ALLTRIM(telefone)
	dddCel := ALLTRIM(dddCel)
	celular := ALLTRIM(celular)
	dataNasc := ALLTRIM(dataNasc)
	inscricao := ALLTRIM(inscricao)
	cdNaturza := ALLTRIM(cdNaturza)
	rg := ALLTRIM(rg)
	pais:=ALLTRIM(pais)
	contato:=ALLTRIM(contato)
	cpfContato:=ALLTRIM(cpfContato)
	tipo:=ALLTRIM(tipo)
	
	//Passa alguns campos para maisculo
	munDes := UPPER(munDes)
	endereco := UPPER(endereco)
	estado := UPPER(estado)
	bairro := UPPER(bairro)
	nome := UPPER(nome)
	complemento := UPPER(complemento)	
	
    //Desmascarar campos - Retirar pontos e traços
    CCGC := u_LGFTUMSK(CCGC)
    rg := u_LGFTUMSK(rg)
    cpfContato := u_LGFTUMSK(cpfContato)
    cep := u_LGFTUMSK(cep)
    telefone := u_LGFTUMSK(telefone)
    celular := u_LGFTUMSK(celular)
    inscricao := u_LGFTUMSK(inscricao)
    dataNasc := if((VALTYPE(dataNasc)=="C"), CTOD(dataNasc), dataNasc)
    //Validar Campos    
    exceptionList := {}
    exceptionList := u_DSa1Vld(CCGC, nome, endereco, bairro, estado, email, cdMun, munDes, cep, ddd, telefone, dddCel, celular, cdNaturza, pais, dataNasc, tipo, pessoa)
    if len(exceptionList)>0
    	CONOUT("PROBLEMA DE VALIDAÇÃO NA INSERÇÃO DO CLIENTE")
    	return "0"
    endif 
    if cdMun==""
    	dbSelectArea("CC2")
		dbSetOrder(4)//Filial + Estado + Descrição do municipio
		if dbSeek(xFilial("CC2")+estado+munDes) = .F.
			CONOUT("CLIENTE NAO CADASTRADO POIS NAO FOI ENCONTRADA UMA O CODIGO DA CIDADE(CC2) PARA O ESTADO:"+estado+" E PARA A CIDADE:"+cidade)
			//return "0"
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
	CONOUT("DAOSA1, ANTES DO CADASTRO:")
	CONOUT("filial:" + ALLTRIM(filial) + "  CCGC:" + ALLTRIM(CCGC) + "  pessoa:" + ALLTRIM(pessoa) + "  nome:" + ALLTRIM(nome) + "  fantasia:" + ALLTRIM(fantasia) + "  email:" + ALLTRIM(email) + "  estado:" + ALLTRIM( estado) + "  cep:" + ALLTRIM( cep) + "  endereco:" + ALLTRIM( endereco) + "  complemento:" + ALLTRIM( complemento) + "  bairro:" + ALLTRIM( bairro) + "  cdMun:" + ALLTRIM( cdMun) + "  munDes:" + ALLTRIM( munDes) + "  ddd:" + ALLTRIM( ddd) + "  telefone:" + ALLTRIM( telefone) + "  dddCel:" + ALLTRIM( dddCel) + "  celular:" + ALLTRIM( celular) + "  dataNasc:" + ALLTRIM( dataNasc) + "  inscricao:" + ALLTRIM( inscricao) + "  rg:" + ALLTRIM( rg) + "  pais:" + ALLTRIM( pais) + "  contato:" + ALLTRIM( contato) + "  cpfContato:" + ALLTRIM( cpfContato) + "  tipo:" + ALLTRIM( tipo) + "  cdNaturza:" + ALLTRIM( cdNaturza))
    //Cadastro do cliente
    DBSELECTAREA("SA1")
    RECLOCK("SA1",.T.)                
	SA1->A1_FILIAL := filial
	SA1->A1_COD    := SUBSTR(CCGC,1,9)
	IF LEN(CCGC)=11
		SA1->A1_LOJA   := "001"
	ELSE
		CONOUT("LOJA CNPJ "+SUBSTR(CCGC,10,3))
		SA1->A1_LOJA   := SUBSTR(CCGC,10,3)
	ENDIF 
	SA1->A1_PESSOA   :=  pessoa
	SA1->A1_CGC 	 :=  CCGC		
	SA1->A1_NOME 	 :=  nome	
	SA1->A1_NREDUZ 	 :=  fantasia   
	SA1->A1_EMAIL    :=  email
	SA1->A1_EST 	 :=  estado  
	SA1->A1_CEP 	 :=  cep	
	SA1->A1_END 	 :=  endereco     
	SA1->A1_COMPLEM  :=  complemento  
	SA1->A1_BAIRRO   :=  bairro  
	SA1->A1_COD_MUN  :=  cdMun  
	SA1->A1_MUN 	 :=  munDes    
	SA1->A1_DDD      :=  ddd
	SA1->A1_DDI      :=  "55"   
	SA1->A1_TEL 	 :=  telefone   
	SA1->A1_UDDDCEL  :=  dddCel 
	SA1->A1_CEL      :=  celular   
	SA1->A1_DTNASC   :=  dataNasc
	SA1->A1_INSCR    :=  inscricao
	SA1->A1_PFISICA  :=  rg
	SA1->A1_PAIS     :=  pais		
	SA1->A1_CONTATO  :=  contato  
	SA1->A1_UCGCTIT  :=  cpfContato  
	SA1->A1_TIPO     :=  tipo  
	SA1->A1_NATUREZ  := cdNaturza
	MSUNLOCK()	        
return SA1->A1_COD+SA1->A1_LOJA

user function DSa1List()
return

/*
	@Author: nakao 
	Descrição: Alteração cliente(SA1)
	PROCESSO:
	-REMOÇÃO DE ESPAÇOS EM BRANCO NAS BORDAS DE TODOS OS CAMPOS
	-UPPERCASE EM VARIAVEIS
	-REMOÇÃO DE POSSIVEIS MASCARAS DE CAMPO(RETIRA-SE TRAÇOS E PONTOS DE CAMPOS COMO CPF,POR EXEMPLO)
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, caso exista retorne 0
	-DBSEEK COM BASE NO CGC, CASO NAO ENCONTRE RETORNE 0
	-UPDATE
	in: Todas as variaveis especificadas nos parametros.
	out: CodCli+LojCli ou 0 em caso de falha */
user function DSa1Alter(filial, CCGC, pessoa, nome, fantasia, email, estado, cep, endereco, complemento, bairro, cdMun, munDes, ddd, telefone, dddCel, celular, dataNasc, inscricao, rg, pais, contato, cpfContato, tipo, cdNaturza)
	//Trim nos campos
	filial := ALLTRIM(filial)
	CCGC := ALLTRIM(CCGC)
	pessoa := ALLTRIM(pessoa)
	nome := ALLTRIM(nome)
	fantasia:=ALLTRIM(fantasia)
	email := ALLTRIM(email)
	estado := ALLTRIM(estado)
	cep := ALLTRIM(cep)
	endereco := ALLTRIM(endereco)
	complemento:= ALLTRIM(complemento)
	bairro := ALLTRIM(bairro)
	cdMun := ALLTRIM(cdMun)
	munDes := ALLTRIM(munDes)
	ddd:=ALLTRIM(ddd)
	telefone := ALLTRIM(telefone)
	dddCel := ALLTRIM(dddCel)
	celular := ALLTRIM(celular)
	dataNasc := ALLTRIM(dataNasc)
	inscricao := ALLTRIM(inscricao)
	rg := ALLTRIM(rg)
	pais:=ALLTRIM(pais)
	contato:=ALLTRIM(contato)
	cpfContato:=ALLTRIM(cpfContato)
	cdNaturza:=ALLTRIM(cdNaturza)
	tipo:=ALLTRIM(tipo)
	
	//Passa alguns campos para maisculo
	munDes := UPPER(munDes)
	endereco := UPPER(endereco)
	estado := UPPER(estado)
	bairro := UPPER(bairro)
	nome := UPPER(nome)
	complemento := UPPER(complemento)	
	
    //Desmascarar campos - Retirar pontos e traços
    CCGC := u_LGFTUMSK(CCGC)
    rg := u_LGFTUMSK(rg)
    cpfContato := u_LGFTUMSK(cpfContato)
    cep := u_LGFTUMSK(cep)
    telefone := u_LGFTUMSK(telefone)
    celular := u_LGFTUMSK(celular)
    inscricao := u_LGFTUMSK(inscricao)
    CONOUT("ANTES DA CONVERSAO "+dataNasc)
    dataNasc := if((VALTYPE(dataNasc)=="C"), CTOD(dataNasc), dataNasc)
    CONOUT("TIPO DA DATA: "+VALTYPE(dataNasc) + DTOC(dataNasc))
    
    //Validar Campos    
    exceptionList := {}
    exceptionList := u_DSa1Vld(CCGC, nome, endereco, bairro, estado, email, cdMun, munDes, cep, ddd, telefone, dddCel, celular, cdNaturza, pais, dataNasc, tipo, pessoa)
    if len(exceptionList)>0
    	CONOUT("PROBLEMA DE VALIDAÇÃO NA ALTERAÇÃO DO CLIENTE")    	
    	return "0"
    endif   
    if cdMun==""
		dbSelectArea("CC2")
		dbSetOrder(4)//Filial + Estado + Descrição do municipio
		if dbSeek(xFilial("CC2")+estado+munDes) = .F.
			CONOUT("CLIENTE NAO CADASTRADO POIS NAO FOI ENCONTRADA UMA O CODIGO DA CIDADE(CC2) PARA O ESTADO:"+estado+" E PARA A CIDADE:"+cidade)
			//return "0"
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
	DBSELECTAREA("SA1")
	dbSetOrder(3)//Filial + CGC
	if dbSeek(xFilial("SA1")+CCGC)
		RECLOCK("SA1",.F.)                
		SA1->A1_FILIAL := filial
		SA1->A1_COD    := SUBSTR(CCGC,1,9)
		IF LEN(CCGC)=11
			SA1->A1_LOJA   := "001"
		ELSE
			SA1->A1_LOJA   := SUBSTR(CCGC,10,3)
		ENDIF 
		SA1->A1_PESSOA   :=  pessoa
		SA1->A1_CGC 	 :=  CCGC		
		SA1->A1_NOME 	 :=  nome	
		SA1->A1_NREDUZ 	 :=  fantasia   
		SA1->A1_EMAIL    :=  email
		SA1->A1_EST 	 :=  estado  
		SA1->A1_CEP 	 :=  cep	
		SA1->A1_END 	 :=  endereco     
		SA1->A1_COMPLEM  :=  complemento  
		SA1->A1_BAIRRO   :=  bairro  
		SA1->A1_COD_MUN  :=  cdMun  
		SA1->A1_MUN 	 :=  munDes    
		SA1->A1_DDD      :=  ddd   
		SA1->A1_TEL 	 :=  telefone   
		SA1->A1_UDDDCEL  :=  dddCel 
		SA1->A1_CEL      :=  celular   
		SA1->A1_DTNASC   :=  dataNasc
		SA1->A1_INSCR    :=  inscricao
		SA1->A1_PFISICA  :=  rg
		SA1->A1_PAIS     :=  pais		
		SA1->A1_DDI     :=  "55"
		SA1->A1_CONTATO  :=  contato  
		SA1->A1_UCGCTIT  :=  cpfContato  
		SA1->A1_TIPO     :=  tipo
		SA1->A1_NATUREZ := cdNaturza  
		MSUNLOCK()	        
	else 
		return "0"
	endif    
return SA1->A1_COD+SA1->A1_LOJA

user function DSa1Find()
	
return

/*
	@Author: nakao 
	Descrição: Validação de cliente(SA1)
	PROCESSO:
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, ADICIONE A LISTA PARA RETORNAR
	in: Todas as variaveis especificadas nos parametros.
	out: lista de strings, cada string representa o campo que faltou
*/
user function DSa1Vld(CCGC, nome, endereco, bairro, estado, email, cdMun, munDes, cep, ddd, tel, dddcel, cel, codNat, pais, dtNasc, tipo, pessoa)
	CCGC := ALLTRIM(CCGC)
	nome := ALLTRIM(nome)
	endereco := ALLTRIM(endereco)
	bairro := ALLTRIM(bairro)
	estado := ALLTRIM(estado)
	email := ALLTRIM(email)
	cdMun := ALLTRIM(cdMun)
	munDes := ALLTRIM(munDes)
	cep := ALLTRIM(cep)
	ddd := ALLTRIM(ddd)
	tel := ALLTRIM(tel)
	dddcel := ALLTRIM(dddcel)
	cel := ALLTRIM(cel)
	codNat := ALLTRIM(codNat)
	pais := ALLTRIM(pais)
	dtNasc := ALLTRIM(dtNasc)
	tipo := ALLTRIM(tipo)
	pessoa := ALLTRIM(pessoa)
	pessoa := UPPER(pessoa)
	
	exceptionList := {}
    if((CCGC = nil .OR. CCGC=="" .OR. len(CCGC)<11), aAdd(exceptionList, "cpf/cnpj"), .F.)
    if((nome = nil .OR. nome==""), aAdd(exceptionList, "nome"), .F.)
    if((codNat = nil .OR. codNat==""), aAdd(exceptionList, "natureza"), .F.)
    if((pais = nil .OR. pais==""), aAdd(exceptionList, "pais"), .F.)
    if((dtNasc= nil ), aAdd(exceptionList, "Data de Nascimento"), .F.)
    if((tipo = nil .OR. tipo==""), aAdd(exceptionList, "tipo do cliente"), .F.)
    if((u_LGVEML(email)==""), aAdd(exceptionList, "email"), .F.)
    if((pessoa = nil .OR. pessoa=="" .OR. (pessoa<>"F" .and. pessoa<>"J")), aAdd(exceptionList, "pessoa(F ou J)"), .F.)
    if cdMun=="" .AND. munDes==""
		aAdd(exceptionList,"cd Municipio")
		aAdd(exceptionList,"Descricao Municipio")		
	endif	
	if(len(exceptionList)>0)
		CONOUT("PROBLEMA DE VALIDACAO NO CLIENTE, CAMPOS:")
		for i:=1 to len(exceptionList)
			CONOUT(exceptionList[i])
		next
	endif	
return exceptionList