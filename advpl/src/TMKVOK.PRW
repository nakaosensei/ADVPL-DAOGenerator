#include "protheus.ch"

/*
TMKVOK - NO FINAL DO TELEVENDAS
AUTOR  - DANIEL GOUVEA
DATA   - 29/07/14
*/

user function TMKVOK(_cAtend)
Local _area := getarea()

if alltrim(funname())=="LIGCAL02"
	reclock("ADE",.f.)
	if ADE->ADE_USITUA=="3"
		ADE->ADE_USITUA := "4"
	else
		ADE->ADE_USITUA := "2"
	endif
	msunlock()
endif                        

restarea(_area)
return .t.