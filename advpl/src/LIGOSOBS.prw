#include 'protheus.ch'
#include 'parmtype.ch'

user function LIGOSOBS()
	ucdmemo :=	POSICIONE("AB7",1,xFilial("AB7") + AB6_NUMOS + "01","AB7_MEMO1")
	udsmemo :=	MSMM(ucdmemo,,,,3,,,"AB7","AB7_MEMO1")
	uretorno := udsmemo
	
return uretorno 