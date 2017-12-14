#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
user function MA030TOK()
	dbSelectArea("SA1")	
	//A condicional abaixo valido o email, e garante que se a pessoa for fisica, o rg deve ser preenchido, e se for juridica, a inscr.estadual
	if u_SA1TE(M->A1_EMAIL,M->A1_PESSOA,M->A1_PFISICA,M->A1_INSCR) = .F.
		return .F.
	endif
return .T.

user function SA1TE(email,pessoa,rg,iEstadual)
//Fun��o de tratamento de erros na hora da inclus�o de um cliente
//Caso haja algum problema, a fun��o printa os problemas com um alert e retorna false, caso tudo corra bem
//retorna true
	exceptions := {}
	if(u_LGVEML(email) == "")
		aAdd(exceptions,"O email � invalido")		
	endif
	if(ALLTRIM(pessoa)=="F" .AND. ALLTRIM(rg)=="")
		aAdd(exceptions,"Toda pessoa f�sica deve ter o RG preenchido.")
	endif
	if(ALLTRIM(pessoa)=="J" .AND. ALLTRIM(iEstadual)=="")
		aAdd(exceptions,"Toda pessoa juridica deve ter Insc. Estadual.")
	endif
	
	if(len(exceptions)>=1)
		out := "A inser��o do cliente falhou pois:"
		for i:=1 to len(exceptions)
			out+=CVALTOCHAR(i)+"- "+exceptions[i]
		next
		MsgAlert(out)
		return .F.
	endif
return .T.
