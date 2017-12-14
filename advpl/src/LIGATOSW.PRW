#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMVCDEF.CH'
//Tela de exibição de atendimento para uma OS
//LIG ATENDIMENTO ORDEM DE SERVIÇO WINDOW
user function LIGATOSW(nrOs)
	Local _area := getarea()
	Local _aAB6 := AB6->(getarea())
	Local _aADA := ADA->(getarea())
	dbSelectArea("AB6")
	dbSetOrder(1)
	dbSeek(xFilial("AB6")+nrOs)	
	numCtr := AB6->AB6_UNUMCT
	DEFINE MSDIALOG oDlg1 TITLE "ATENDIMENTOS DE ORDEM DE SERVIÇO" FROM 000, 000  TO 360, 1100 COLORS 0, 16777215 PIXEL
      //@ posY, posX SAY texto SIZE nLargura,nAltura UNIDADE OF oObjetoRef
		@ 001, 001 SAY "Nr OS: "+AB6->AB6_NUMOS SIZE 006, 007 OF oDlg1
		@ 001, 009 SAY "Loja: "+AB6->AB6_LOJA SIZE 006, 007 OF oDlg1
		@ 001, 017 SAY "Emissão: "+DTOC(AB6->AB6_EMISSA) SIZE 009, 007 OF oDlg1
		@ 001, 028 SAY "Assunto: "+u_LGGAST2(AB6->AB6_USITU1) SIZE 009, 007 OF oDlg1				
		@ 002, 001 SAY "Cod Cli: "+AB6->AB6_CODCLI SIZE 009, 007 OF oDlg1
		@ 002, 012 SAY "Nome: "+u_LGNMCLI(xFilial("SA1"),AB6->AB6_CODCLI,AB6->AB6_LOJA) SIZE 050, 007 OF oDlg1
		@ 003, 001 SAY "Atendente "+AB6->AB6_ATEND SIZE 009, 007 OF oDlg1
		dbSelectArea("ADA")
		dbSetOrder(1)
		dbSeek(xFilial("ADA")+numCtr)
		@ 004, 001 SAY "Consultor Contrato 1: "+ADA->ADA_VEND1+" "+u_LGNMVND(xFilial("SA3"),ADA->ADA_VEND1) SIZE 050, 007 OF oDlg1
		@ 005, 001 SAY "Consultor Contrato 2: "+ADA->ADA_VEND2+" "+u_LGNMVND(xFilial("SA3"),ADA->ADA_VEND2) SIZE 050, 007 OF oDlg1
		@ 006, 001 SAY "Consultor Contrato 3: "+ADA->ADA_VEND3+" "+u_LGNMVND(xFilial("SA3"),ADA->ADA_VEND3) SIZE 050, 007 OF oDlg1
		u_gTbAtOs(nrOS,oDlg1,001,100,175,549) //Gera uma tabela para os atendimentos da OS no dialog, está no LIGNKUT.prw
	ACTIVATE MSDIALOG oDlg1 CENTERED
	restarea(_aAB6)
	restarea(_aADA)
	restarea(_area)
return

