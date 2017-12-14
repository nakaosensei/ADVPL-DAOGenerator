#Include 'Protheus.ch'
#include "rwmake.ch"

User Function LIGCAL06(_cNumCtr, _cPrazo, _cDtRenov, _cVendedor, _cNumAte)
Local _area := getarea()
Local _aADA := ADA->(getarea())
Local _aADB := ADB->(getarea())
Local _AITENS 	:= {}
Local cItemNovo := "00" 

dbselectarea("ADA")
dbsetorder(1)
DBGoTop()
if dbseek(xFilial()+ _cNumCtr)
	RECLOCK("ADA",.F.)
		ADA->ADA_UVALI := _cPrazo 
	MSUNLOCK()	
endif

dbselectarea("ADB")
dbsetorder(1)
DBGoTop()
if dbseek(xFilial()+ _cNumCtr)
	while !eof() .and. xFilial() + _cNumCtr == ADB->ADB_FILIAL+ADB->ADB_NUMCTR
			RECLOCK("ADB",.F.)
				ADB->ADB_UDTFIM := _cDtRenov 
			MSUNLOCK()	
			cItemNovo := soma1(cItemNovo)
			
			//			 	1				2				3			  4				5				  6				7				8				9				  10				11
			AADD(_AITENS,{ADB->ADB_CODPRO, ADB->ADB_DESPRO, ADB->ADB_UM, ADB->ADB_QUANT, ADB->ADB_PRCVEN, ADB->ADB_TOTAL, ADB->ADB_TES, ADB->ADB_LOCAL, ADB->ADB_CODCLI, ADB->ADB_LOJCLI, ADB->ADB_UMESIN})						
		dbselectarea("ADB")
		dbskip()
	enddo
endif

FOR _I:=1 TO LEN(_AITENS)
			cItemNovo := soma1(cItemNovo)
			reclock("ADB",.t.)
			ADB->ADB_FILIAL 	:= 	xFilial("SUB")
			ADB->ADB_NUMCTR 	:= 	_cNumCtr
			ADB->ADB_ITEM   	:= 	cItemNovo
			ADB->ADB_CODPRO 	:=	_AITENS[_I,1]
			ADB->ADB_DESPRO 	:= 	_AITENS[_I,2]
			ADB->ADB_UM     	:= 	_AITENS[_I,3]
			ADB->ADB_QUANT  	:=	_AITENS[_I,4]
			ADB->ADB_PRCVEN 	:= 	_AITENS[_I,5]
			ADB->ADB_TOTAL  	:= 	_AITENS[_I,6]
			ADB->ADB_TES    	:= 	_AITENS[_I,7]
			ADB->ADB_LOCAL  	:= 	_AITENS[_I,8]
			ADB->ADB_CODCLI 	:= 	_AITENS[_I,9]
			ADB->ADB_LOJCLI 	:=	_AITENS[_I,10]    
			
			IF _AITENS[_I,11] > 0 
				ADB->ADB_UDTINI 	:= MonthSum(_cDtRenov,_AITENS[_I,11])
				ADB->ADB_UMESIN := _AITENS[_I,11]
			ELSE
				ADB->ADB_UDTINI 	:= _cDtRenov
			ENDIF		
			
			ADB->ADB_UVEND1  	:= _cVendedor
			ADB->ADB_UVEND2 	:= POSICIONE("SA3",1,XFILIAL("SA3")+_cVendedor,"A3_SUPER")
			ADB->ADB_UNUMAT		:= 	_cNumAte
			msunlock()
NEXT _I

restarea(_aADB)
restarea(_aADA)
restarea(_area)
Return
