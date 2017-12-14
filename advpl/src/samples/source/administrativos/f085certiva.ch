#ifdef SPANISH
	#define STR0001 "Certificado de Retenção"
	#define STR0002 "de"
	#define STR0003 "Timbrado: "
	#define STR0004 "Valido até: "
	#define STR0005 "RUC"
	#define STR0006 "COMPROVANTE DE RETENÇÃO"
	#define STR0007 "Data:"
	#define STR0008 "Nome ou Razão Social do Sujeito Retido:"
	#define STR0009 "RUC o Cedula de Identidade Nº"
	#define STR0010 "Tipo e Número"
	#define STR0011 "Valor sem IVA"
	#define STR0012 "IVA Incluso"
	#define STR0013 "Valor Total"
	#define STR0014 "% Ret. IVA"
	#define STR0015 "IVA Retido"
	#define STR0016 "Total Geral"
#else
	#ifdef ENGLISH
		#define STR0001 "Certificado de Retenção"
		#define STR0002 "de"
		#define STR0003 "Timbrado: "
		#define STR0004 "Valido até: "
		#define STR0005 "RUC"
		#define STR0006 "COMPROVANTE DE RETENÇÃO"
		#define STR0007 "Data:"
		#define STR0008 "Nome ou Razão Social do Sujeito Retido:"
		#define STR0009 "RUC o Cedula de Identidade Nº"
		#define STR0010 "Tipo e Número"
		#define STR0011 "Valor sem IVA"
		#define STR0012 "IVA Incluso"
		#define STR0013 "Valor Total"
		#define STR0014 "% Ret. IVA"
		#define STR0015 "IVA Retido"
		#define STR0016 "Total Geral"
	#else
		Static STR0001 := "Certificado de Retenção"
		Static STR0002 := "de"
		Static STR0003 := "Timbrado: "
		Static STR0004 := "Valido até: "
		Static STR0005 := "RUC"
		Static STR0006 := "COMPROVANTE DE RETENÇÃO"
		Static STR0007 := "Data:"
		Static STR0008 := "Nome ou Razão Social do Sujeito Retido:"
		Static STR0009 := "RUC o Cedula de Identidade Nº"
		Static STR0010 := "Tipo e Número"
		Static STR0011 := "Valor sem IVA"
		Static STR0012 := "IVA Incluso"
		Static STR0013 := "Valor Total"
		Static STR0014 := "% Ret. IVA"
		Static STR0015 := "IVA Retido"
		Static STR0016 := "Total Geral"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Certificado de Retenção"
			STR0002 := "de"
			STR0003 := "Timbrado: "
			STR0004 := "Valido até: "
			STR0005 := "RUC"
			STR0006 := "COMPROVANTE DE RETENÇÃO"
			STR0007 := "Data:"
			STR0008 := "Nome ou Razão Social do Sujeito Retido:"
			STR0009 := "RUC o Cedula de Identidade Nº"
			STR0010 := "Tipo e Número"
			STR0011 := "Valor sem IVA"
			STR0012 := "IVA Incluso"
			STR0013 := "Valor Total"
			STR0014 := "% Ret. IVA"
			STR0015 := "IVA Retido"
			STR0016 := "Total Geral"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Certificado de Retenção"
			STR0002 := "de"
			STR0003 := "Timbrado: "
			STR0004 := "Valido até: "
			STR0005 := "RUC"
			STR0006 := "COMPROVANTE DE RETENÇÃO"
			STR0007 := "Data:"
			STR0008 := "Nome ou Razão Social do Sujeito Retido:"
			STR0009 := "RUC o Cedula de Identidade Nº"
			STR0010 := "Tipo e Número"
			STR0011 := "Valor sem IVA"
			STR0012 := "IVA Incluso"
			STR0013 := "Valor Total"
			STR0014 := "% Ret. IVA"
			STR0015 := "IVA Retido"
			STR0016 := "Total Geral"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
