#include 'protheus.ch'
#include 'parmtype.ch'

user function LIGDFILTER()
	
return

//Essa função retira a mascara de um CPF ou CNPJ
//ex:
//in: 085.533.599-80 out:08553359980
user function LGFTUMSK(cpfcnpj)
	cpfcnpj := StrTran( cpfcnpj, ".", "" ) 
	cpfcnpj := StrTran( cpfcnpj, "-", "" ) 
	cpfcnpj := StrTran( cpfcnpj, "/", "" ) 
return cpfcnpj