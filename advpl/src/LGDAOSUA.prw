#include 'protheus.ch'
#include 'parmtype.ch'

user function LGDAOSUA()
	
return

/*
	@Author: nakao 
	Descrição: Cadastro de Orçamento Televendas(SUA)
	PROCESSO:
	-REMOÇÃO DE ESPAÇOS EM BRANCO NAS BORDAS DE TODOS OS CAMPOS
	-UPPERCASE EM VARIAVEIS
	-REMOÇÃO DE POSSIVEIS MASCARAS DE CAMPO(RETIRA-SE TRAÇOS E PONTOS DE CAMPOS COMO CPF,POR EXEMPLO)
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, caso exista retorne 0
	-CADASTRO
	in: Todas as variaveis especificadas nos parametros.
	out: codSua ou 0 em caso de falha */
user function DSuaCad(filial,codCli, lojCli, operador, cndPg, operacao, midia, vendedor, tmk, codlig, estado, dtVld, moeda, tpCarga, tpCli, uTipo, upraz, uvctr, uEstado, diaFechamento, status, emissao, fim, diasDat, horasDat, valorBruto, valorMerc, valorLiq, codSua)

return 

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
user function DSuaAlter()
	
return 

user function DSuaFind()
	
return

/*
	@Author: nakao 
	Descrição: Validação de cliente(SA1)
	PROCESSO:
	-PROCURA POR CAMPOS OBRIGATORIOS VAZIOS, CASO ALGUM EXISTA, ADICIONE A LISTA PARA RETORNAR
	in: Todas as variaveis especificadas nos parametros.
	out: lista de strings, cada string representa o campo que faltou
*/
user function DSuaVld()
	
	tipo := ALLTRIM(tipo)
	exceptionList := {}
    if((CCGC = nil .OR. CCGC==""), aAdd(exceptionList, "cpf/cnpj"), .F.)
   
    if cdMun=="" .AND. munDes==""
		aAdd(exceptionList,"cd Municipio")
		aAdd(exceptionList,"Descricao Municipio")		
	endif	
	if(len(exceptionList)>0)
		CONOUT("PROBLEMA DE VALIDACAO NO CLIENTE, CAMPOS:, dtNasc:"+DTOC(dtNasc))
		for i:=1 to len(exceptionList)
			CONOUT(exceptionList[i])
		next
	endif	
return exceptionList