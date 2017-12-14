#include 'protheus.ch'
#include 'parmtype.ch'

user function LIGCOM01()
	
return

user function getNomeSolic(numSC)
	Local _area := getarea()
	Local _aSC1 := SC1->(getarea()) 
	Local _nomeUser := ""
	
	dbSelectArea("SC1")
	dbsetorder(1)
	dbGoTop()
		
	if dbseek(xFilial("SC1")+ numSC)
		_codUser := POSICIONE("SC1",1,xFilial("SC1")+numSC,"C1_USER")
		_nomeUser := UsrRetName(_codUser)
	endif
	
	restarea(_aSC1)
	restarea(_area)
return _nomeUser