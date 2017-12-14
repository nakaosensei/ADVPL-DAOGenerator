#include 'protheus.ch'
#include 'parmtype.ch'

//@author: nakao / nakaosensei@gmail.com
user function LGDAOGENERATOR()	
return

user function GENCADSCRIPT(tabela,prefixo,campos,dateFields,descFields,cpfFields,validateFields,numericFields)
	Local script       := ""
	Local _aCampos     := StrTokArr(campos,",")
	Local _aVariables  := u_addUOnStartToFields(StrTokArr(campos,","))
	Local _aDate       := u_addUOnStartToFields(StrTokArr(dateFields,","))
	Local _aDesc       := u_addUOnStartToFields(StrTokArr(descFields,","))
	Local _aCpf        := u_addUOnStartToFields(StrTokArr(cpfFields,","))
	Local _aNumeric    := u_addUOnStartToFields(StrTokArr(numericFields,","))
	Local _aValidate   := u_addUOnStartToFields(StrTokArr(validateFields,","))
	Local _aNotDateNum := u_addUOnStartToFields(StrTokArr(campos,","))
	Local _aNotNum     := u_addUOnStartToFields(StrTokArr(campos,","))
	
return

user function addUOnStartToFields(stringArray)
	for i:=1 to len(stringArray)
		if ALLTRIM(stringArray[i])<>""
			stringArray[i] := "U"+stringArray[i]
		endif
	next
return stringArray

user function trimAll(stringArray)
	for i:=1 to len(stringArray)
		if ALLTRIM(stringArray[i])<>""
			stringArray[i] := ALLTRIM(stringArray[i])
		endif
	next
return