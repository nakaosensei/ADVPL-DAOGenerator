#include "protheus.ch"

User Function AT450BUT()
aBotao := {} 

AAdd( aBotao, { "PRODUTO", { || U_VISUHELP() }, "Help Desk" } ) 

return aBotao

User function VISUHELP()
Local _area := getarea()
Local _aABK := ABK->(getarea())
Local nPosHelp := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "AB7_NUMHDE" })

if nPosHelp>1
	dbselectarea("ABK")
	dbsetorder(1)
	if dbseek(xFilial()+aCols[n,nPosHelp])
		AT310Visua("ABK",ABK->(recno()),2)
	endif
endif

restarea(_aABK)
restarea(_area)
return