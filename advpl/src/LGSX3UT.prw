#include 'protheus.ch'
#include 'parmtype.ch'
/*
@author: nakao
*/
user function LGSX3UT()	
return

//LIGUE GET ASSUNTO: Essa função retorna a descrição de um assunto de OS
user function LGGAST2(codAsst)
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	SX3->(DbSeek("AB6_USITU1"))
	conds := StrTokArr(SX3->X3_CBOX, ";")
	tmp := {}
	for i := 1 to len(conds)
		tmp := StrTokArr(conds[i], "=")
		if(ALLTRIM(tmp[1]) == codAsst)
			return tmp[2]
		endif
	next
return

// PRINTA TODOS OS CAMPOS DE UMA TABELA NO ARQUIVO CONSOLE.LOG
//IN:  NOME DE UMA TABELA, EX: "AB6", u_LGGTALLFIELDS("AB6")
//OUT: NOMES DE TODOS OS CAMPOS SAO PRINTADOS NO CONSOLE.LOG, SEPARADOS POR VIRGULA
//EX: AB6_FILIAL, AB6_NUMOS, ...
user function LGGTALLFIELDS(nmTabela)
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbSeek(nmTabela))
	out := ""
	while !EOF() .AND. ALLTRIM(SX3->X3_ARQUIVO)==nmTabela
		out+=ALLTRIM(X3_CAMPO)+","
		DBSKIP()
	enddo	
	MsgAlert(out)
return out

// PRINTA TODOS OS CAMPOS DE DATA DE UMA TABELA NO ARQUIVO CONSOLE.LOG
//IN:  NOME DE UMA TABELA, EX: "AB6", u_LGGTDTFIELDS("AB6")
//OUT: NOMES DE TODOS OS CAMPOS DATE SAO PRINTADOS NO CONSOLE.LOG, SEPARADOS POR VIRGULA
user function LGGTDTFIELDS(nmTabela)
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbSeek(nmTabela))
	out := ""
	while !EOF() .AND. ALLTRIM(SX3->X3_ARQUIVO)==nmTabela
		if ALLTRIM(X3_TIPO)=="D"
			out+=ALLTRIM(X3_CAMPO)+","
		endif		
		DBSKIP()
	enddo	
	MsgAlert(out)
return out

// PRINTA TODOS OS CAMPOS DO TIPO MEMO DE UMA TABELA NO ARQUIVO CONSOLE.LOG
//IN:  NOME DE UMA TABELA, EX: "AB6", u_LGGTMMFIELDS("AB6")
//OUT: NOMES DE TODOS OS CAMPOS DO TIPO MEMO SAO PRINTADOS NO CONSOLE.LOG, SEPARADOS POR VIRGULA
user function LGGTMMFIELDS(nmTabela)
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbSeek(nmTabela))
	out := ""
	while !EOF() .AND. ALLTRIM(SX3->X3_ARQUIVO)==nmTabela
		if ALLTRIM(X3_TIPO)=="M"
			out+=ALLTRIM(X3_CAMPO)+","
		endif		
		DBSKIP()
	enddo	
	MsgAlert(out)
return out

// PRINTA TODOS OS CAMPOS OBRIGATORIOS DE UMA TABELA NO ARQUIVO CONSOLE.LOG
//IN:  NOME DE UMA TABELA, EX: "AB6", u_LGGTOBRIGATORIOSFIELDS("AB6")
//OUT: NOMES DE TODOS OS CAMPOS OBRIGATORIOS SAO PRINTADOS NO CONSOLE.LOG, SEPARADOS POR VIRGULA
user function LGGTOBRIGATORIOSFIELDS(nmTabela)
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbSeek(nmTabela))
	out := ""
	while !EOF() .AND. ALLTRIM(SX3->X3_ARQUIVO)==nmTabela
		if ALLTRIM(X3_OBRIGAT)<>""
			out+=ALLTRIM(X3_CAMPO)+","
		endif		
		DBSKIP()
	enddo	
	MsgAlert(out)
return out

//PRINTA TODOS OS CAMPOS, EM SEGUIDA DOS DO TIPO DATE, EM SEGUIDA DOS MEMOS, E POR ULTIMO OS OBRIGATORIOS DE UMA TABELA
//ex: u_LGGTFIELDS("AB6")
user function LGGTFIELDS(tabela)
	CONOUT("TODOS OS CAMPOS:")
	CONOUT(u_LGGTALLFIELDS(tabela))
	CONOUT("CAMPOS DO TIPO DATE")
	CONOUT(u_LGGTDTFIELDS(tabela))
	CONOUT("CAMPOS DO TIPO MEMO")
	CONOUT(u_LGGTMMFIELDS(tabela))
	CONOUT("CAMPOS OBRIGATORIOS")
	CONOUT(u_LGGTOBRIGATORIOSFIELDS(tabela))
return


