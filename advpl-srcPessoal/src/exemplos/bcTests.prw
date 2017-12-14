#include 'protheus.ch'
#include 'parmtype.ch'
//O intuito deste código é realizar diversos testes utilizando blocos de código
user function bcTests()
	x:=10
	y:={}
	aAdd(y,{1,"Nakao"})
	aAdd(y,{2,"Testerson"})
	aAdd(y,{3,"Macarrao"})
	
	bloc1:={|x|u_chngThs(@x)}
	bloc2:={||chngThs2(x,y,nome)}
	MsgAlert(x)
	
	DEFINE DIALOG oDlg TITLE "Exemplo TCBrowse" FROM 180,180 TO 550,700 PIXEL
	aBrowse := { {.T.,'CLIENTE 001','RUA CLIENTE 001',111.11},{.F.,'CLIENTE 002','RUA CLIENTE 002',222.22},{.T.,'CLIENTE 003','RUA CLIENTE 003',333.33} } 
return

user function chngThs(x)
	//X deve ser passado por referencia
	x++
	x++
return 

user function chngThs2(x,y,nome)
	//Y deve ser passado por referencia
	aAdd(y,{x,nome})
return

user function 

