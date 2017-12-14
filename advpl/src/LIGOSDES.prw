#include 'protheus.ch'
#include 'parmtype.ch'

user function LIGOSDES()

	uocorre :=	POSICIONE("AB7",1,xFilial("AB7") + AB6_NUMOS + '01',"AB7_CODPRB")
	udescri :=	POSICIONE("AAG",1,xFilial("AAG") + uocorre,"AAG_DESCRI")

	uprod :=	POSICIONE("AB7",1,xFilial("AB7") + AB6_NUMOS + "01","AB7_CODPRO")
	udespro :=	POSICIONE("SB1",1,xFilial("SB1") + uprod,"B1_DESC")
	uretorno := alltrim(udespro) +" - " +alltrim(udescri)


return uretorno