#include 'protheus.ch'
#include 'parmtype.ch'

/*
O código abaixo serve para retornar o codigo de atendentee 
do usuario logado, no entanto, se o usuario logado não possui
seu id de usuario vinculado ao atendente, é retornado o atendente
da OS passada por parametro.
Essa função é chamada por uma trigger de AB9_NUMOS
*/
user function AB9TRCDAT(numOSF)	
	Local numOS := SubStr( numOSF, 1, 6 ) 
	Local _area := getarea()
	Local ret:=''
	dbSelectArea("AA1")
	dbSetOrder(4)	
	if(dbSeek(xFilial("AA1")+RetCodUsr()))
		return AA1->AA1_CODTEC
	endif
	dbSelectArea("AB6")
	dbSetOrder(1)
	if(dbSeek(xFilial("AB6")+numOS))
		nomeAtend := AB6->AB6_ATEND
		dbSelectArea("AA1")
		dbSetOrder(5)
		if(dbSeek(xFilial("AA1")+nomeAtend))			
			ret := AA1->AA1_CODTEC
		endif
	endif
	restarea(_area)		
return ret