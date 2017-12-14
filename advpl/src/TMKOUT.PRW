#include "rwmake.ch"
USER FUNCTION TMKOUT(lMsg,nOpc)

	Local lRet := .T.
	Local _area := getarea()

	Public _lFechou := .T.

//PRECISA DESSA PERGUNTA PORQUE USA NO LIGCAL02
	if funname()=="LIGCAL02"
		if !msgyesno("Fechar sem salvar?")
			_lFechou := .F.
			lRet := .f.                   
		else
			lMsg := .F.
		endif
	endif

	restarea(_area)
return lRet