#include 'protheus.ch'
#include 'parmtype.ch'

user function LGDAOAC8()
	
return

/*
	@Author: nakao 
	Descrição: Cadastro de relação cliente/contato(AC8)
	PROCESSO:
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, RETORNE 0
	-CADASTRO
	in: Todas as variaveis especificadas nos parametros.
	out: codCli+CodCont(Concatenação string) ou 0 em caso de falha
*/
user function DAc8Cad(codCli,codCont)	
	exceptionList := {}
	exceptionList := u_DAc8Vld(codCli,codCont)
	if len(exceptionList)>0
		return "0"
	endif	
	/*Cadastro*/
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
return codCli+"-"+codCont      

user function DAc8List()
return

/*
	@Author: nakao 
	Descrição: Cadastro de relação cliente/contato(AC8)
	PROCESSO:
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, RETORNE 0
	-CADASTRO
	in: Todas as variaveis especificadas nos parametros.
	out: codCli+CodCont(Concatenação string) ou 0 em caso de falha
*/
user function DAc8Alter()
	
return codAgb

user function DAc8Find()
return

/*
	@Author: nakao 
	Descrição: Validação de telefone(AGB)
	PROCESSO:
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, ADICIONE A LISTA PARA RETORNAR
	in: Todas as variaveis especificadas nos parametros.
	out: lista de strings, cada string representa o campo que faltou
*/
user function DAc8Vld(codCli,codCont)
	exceptionList := {}
	if((codCli = nil .OR. codCli==""), aAdd(exceptionList, "Cliente"), .F.)
	if((codCont = nil .OR. codCont==""), aAdd(exceptionList, "Contato"), .F.)		
return exceptionList