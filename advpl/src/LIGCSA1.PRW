#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOPCONN.CH"
/*
	Author: @nakaosensei
	A function abaixo(LIGINCSA1()) foi criada para a utilização do ponto 
	de entrada M030INC, que permite a inclusão de eventos após o cadastro
	de um cliente, a proposta inicial foi cadastrar um contato automaticamente
	após a inserção de um cliente. Mas posteriormente mais códigos podem ser inseridos
*/
user function LIGCSA1()//Função disparada no cadastro de SA1, LIG Cadastro SA1
	dbSelectArea("SA1")	
	u_GrCont(SA1->A1_COD,SA1->A1_NOME,SA1->A1_EMAIL,SA1->A1_DDD,SA1->A1_UDDDCEL,SA1->A1_DDI,SA1->A1_TEL,SA1->A1_END,SA1->A1_BAIRRO,SA1->A1_CEP,SA1->A1_MUN,SA1->A1_EST,SA1->A1_CGC,SA1->A1_CEL,"1",SA1->A1_COD_MUN,SA1->A1_PAIS,xFilial("AGA"),SA1->A1_LOJA)
	dbCloseArea()	
return

//Gera um novo contato dado os parametros, observe que o tipo e padrao das tabelas AGA e AGB estão sendo setados de forma estática
user function GrCont(cod,nome,email,ddd,dddCel,ddi,telefone,endereco,bairro,cep,municipio,estado,cpf,celular,ativo,cdMun,pais,filial,loja)
	vld := u_CSA1TE(cod,nome,telefone,celular,filial,loja) //Validação de campos
	if(vld = .F.)
		return
	endif
	BEGIN TRANSACTION	
		codCont := GetSXENum("SU5","U5_CODCONT")
		ConfirmSx8()
		codAga := GetSXENum("AGA","AGA_CODIGO")
		ConfirmSx8() 
		codFixo := GetSXENum("AGB","AGB_CODIGO")//Codigo do telefone fixo
		ConfirmSx8()
		codCel := GetSXENum("AGB","AGB_CODIGO")//Codigo do celular
		ConfirmSx8()		
		u_GrAga(codAga,filial,"1","1",codCont,"SU5",endereco,cep,endereco,cep,bairro,municipio,cdMun,pais,estado)
		u_GrAgb(codFixo,xFilial("AGB"),"1","1",codCont,"SU5",ddi,ddd,telefone)
		u_GrAgb(codCel,xFilial("AGB"),"1","1",codCont,"SU5",ddi,dddCel,celular)
		RECLOCK("SU5", .T.)
		SU5->U5_FILIAL := xFilial("SU5")
		SU5->U5_CODCONT := codCont
		SU5->U5_CONTAT := nome
		SU5->U5_EMAIL := email
		SU5->U5_CPF := cpf
		SU5->U5_ATIVO := ativo
		SU5->U5_END := endereco
		SU5->U5_BAIRRO := bairro
		SU5->U5_MUN := municipio
		SU5->U5_EST := estado
		SU5->U5_CEP := cep
		SU5->U5_DDD := ddd
		SU5->U5_FONE := telefone
		SU5->U5_CELULAR := celular
		SU5->U5_CODAGA := codAga	
		SU5->U5_AGBRES := codFixo
		SU5->U5_AGBCEL := codCel	
		MSUNLOCK()
		u_NkUAC8(cod+loja,codCont)	
		dbCloseArea()
		dbSelectArea("SA1")
		dbSetOrder(1)		// A1_FILIAL + A1_COD + A1_LOJA
		dbSeek(filial + cod + loja)     // Busca exata	
		if FOUND()				
			RECLOCK("SA1", .F.) // Trava o registro	
			SA1->A1_CONTATO:=nome	
			MSUNLOCK()     // Destrava o registro	
		endif		
		MsgAlert("Contato associado com sucesso!")		
	END TRANSACTION	
return

//Atualiza a tabela AC8, gerando um novo registro indicando a relação entre o cliente e o contato
user function NkUAC8(codCli,codCont)
	BEGIN TRANSACTION
		dbSelectArea("AC8")
		RECLOCK("AC8", .T.)
		AC8->AC8_ENTIDA := "SA1"
		AC8->AC8_CODENT := codCli
		AC8->AC8_CODCON := codCont
		AC8->AC8_FILIAL := xFilial("AC8")
		MSUNLOCK()
		dbCloseArea()
	END TRANSACTION
return 

user function GrAga(codAga,filial,tipo,padrao,cdEnt,entidade,endereco,cep,endereco,cep,bairro,municipio,cdMun,pais,estado)
	BEGIN TRANSACTION
		dbSelectArea("AGA")		
		RECLOCK("AGA", .T.)
		AGA->AGA_TIPO := tipo
		AGA->AGA_PADRAO := padrao
		AGA->AGA_END := endereco
		AGA->AGA_CEP := cep
		AGA->AGA_BAIRRO := bairro
		AGA->AGA_MUNDES := municipio
		AGA->AGA_MUN := cdMun
		AGA->AGA_PAIS := pais
		AGA->AGA_FILIAL := filial
		AGA->AGA_EST := estado
		AGA->AGA_CODIGO := codAga
		AGA->AGA_ENTIDA := entidade
		AGA->AGA_CODENT := cdEnt
		MSUNLOCK()
		dbCloseArea()
	END TRANSACTION
return

user function GrAgb(codAgb,filial,tipo,padrao,cdEnt,entidade,ddi,ddd,telefone)
	BEGIN TRANSACTION
		dbSelectArea("AGB")		
		RECLOCK("AGB", .T.)
		AGB->AGB_FILIAL := filial
		AGB->AGB_TIPO := tipo
		AGB->AGB_PADRAO := padrao
		AGB->AGB_DDI := ddi
		AGB->AGB_DDD := ddd
		AGB->AGB_TELEFO := telefone
		AGB->AGB_CODIGO := codAgb
		AGB->AGB_ENTIDA := entidade
		AGB->AGB_CODENT := cdEnt		
		MSUNLOCK()
		dbCloseArea()
	END TRANSACTION
return

user function CSA1TE(codCli,nome,telefone,celular,filial,loja)
//Função de tratamento de erros na hora da inclusão de um contato
//Essa função é chamada para quando se gera um contato altomaticamente após
//a inserção de um cliente, ela realiza a validação para a função que efetivamente gera o contato,
//sendo esta a GrCont
//Caso haja algum problema, a função printa os problemas com um alert e retorna false, caso tudo corra bem
//retorna true
	exceptions := {}
	if(codCli = nil)
		aAdd(exceptions,"O código do cliente é nulo")		
	endif
	if(nome = nil .OR. ALLTRIM(nome)=="")
		aAdd(exceptions,"O nome do cliente é vazio.")
	endif
	if(telefone = nil .OR. ALLTRIM(telefone)=="")
		aAdd(exceptions,"O cliente não possui telefone.")
	endif
	if(celular = nil .OR. ALLTRIM(celular)=="")
		aAdd(exceptions,"O cliente não possui celular.")
	endif
	if(filial = nil .OR. ALLTRIM(filial)=="")
		aAdd(exceptions,"O cliente não possui uma filial associada.")
	endif
	if(loja = nil .OR. ALLTRIM(loja)=="")
		aAdd(exceptions,"O cliente não possui uma loja associada.")
	endif
	if(len(exceptions)>=1)
		out := "A inserção automática do contato falhou pelos seguintes motivos:"
		for i:=1 to len(exceptions)
			out+=CVALTOCHAR(i)+"- "+exceptions[i]
		next
		MsgAlert(out)
		return .F.
	endif
return .T.
