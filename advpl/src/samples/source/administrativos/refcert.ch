#ifdef SPANISH
	#define STR0001 "Certificado de retencion"
	#define STR0002 "Esta rutina rehara los numeros de certificados grabados en la tabla de Ordenes de Pago (SEK) con tamano superior a 12 caracteres y actualizarlos en el campo EK_NROCERT."
	#define STR0003 "OK"
	#define STR0004 "Anula"
	#define STR0005 "Espere, procesando..."
#else
	#ifdef ENGLISH
		#define STR0001 "Withholding Certificate"
		#define STR0002 "This routine generates certificate numbers again, which were saved in Payment Order table (SEK) with size larger than 12 characters and updates them in the field EK_NROCERT."
		#define STR0003 "OK"
		#define STR0004 "Cancel"
		#define STR0005 "Please, wait. Processing..."
	#else
		Static STR0001 := "Certificado de retenção"
		Static STR0002 := "Esta rotina irá refazer os números de certificados gravados na tabela de Ordens de Pago (SEK) com tamanho superior a 12 caracteres e atualizá-los no campo EK_NROCERT."
		Static STR0003 := "OK"
		Static STR0004 := "Cancela"
		Static STR0005 := "Aguarde, processando..."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Certificado de retenção"
			STR0002 := "Esta rotina irá refazer os números de certificados gravados na tabela de Ordens de Pago (SEK) com tamanho superior a 12 caracteres e atualizá-los no campo EK_NROCERT."
			STR0003 := "OK"
			STR0004 := "Cancela"
			STR0005 := "Aguarde, processando..."
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Certificado de retenção"
			STR0002 := "Esta rotina irá refazer os números de certificados gravados na tabela de Ordens de Pago (SEK) com tamanho superior a 12 caracteres e atualizá-los no campo EK_NROCERT."
			STR0003 := "OK"
			STR0004 := "Cancela"
			STR0005 := "Aguarde, processando..."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
