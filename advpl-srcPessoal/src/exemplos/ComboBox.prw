#include 'protheus.ch'
#include 'parmtype.ch'

user function ComboBox()
	Local aItems:= {'Users','Hello World','TLINLAYE'}
    DEFINE DIALOG oDlg TITLE "Exemplo TComboBox" FROM 180,180 TO 550,700 PIXEL
        // Usando New
        private cCombo1:= aItems[1]
        oCombo1 := TComboBox():New(02,02,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems,100,20,oDlg,,{|cCombo1|u_CAMNK(cCombo1)},,,,.T.,,,,,,,,,'cCombo1')
       
    ACTIVATE DIALOG oDlg CENTERED
return

user function CAMNK(combo)
	opt:=combo:nAt
	MsgAlert(opt)
	if(opt=1)
		u_TCBROWSE()
	else 
		if(opt=2)
			MsgAlert("Hello World")
		else
			if(opt=3)
				u_TLINLAYE()
			endif
		endif
	endif
return 