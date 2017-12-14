#ifdef SPANISH
	#define STR0001 "Tasa de dif. de cambio por cobrar"
	#define STR0002 "Esta rutina calculara nuevamente las tasas actualizadas de diferencia de cambio por cobrar de la moneda 01, de acuerdo con las tasas del dia del movimiento."
	#define STR0003 "OK"
	#define STR0004 "Anular"
	#define STR0005 "Espere, procesando."
	#define STR0006 "Registros procesados: "
#else
	#ifdef ENGLISH
		#define STR0001 "Rate of receivable exchange difference"
		#define STR0002 "This routine will recalculate all updated rates of receivable exchange difference of corrency 01, according to the rates of the transaction day."
		#define STR0003 "OK"
		#define STR0004 "Cancel"
		#define STR0005 "Wait, processing."
		#define STR0006 "Processed record:"
	#else
		Static STR0001 := "Taxa de dif. de câmbio a receber"
		Static STR0002 := "Esta rotina irá refazer as taxas atualizadas de diferença de câmbio a receber da moeda 01, de acordo com as taxas do dia do movimento."
		Static STR0003 := "OK"
		Static STR0004 := "Cancelar"
		Static STR0005 := "Aguarde, processando."
		Static STR0006 := "Registros processados: "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Taxa de dif. de câmbio a receber"
			STR0002 := "Esta rotina irá refazer as taxas atualizadas de diferença de câmbio a receber da moeda 01, de acordo com as taxas do dia do movimento."
			STR0003 := "OK"
			STR0004 := "Cancelar"
			STR0005 := "Aguarde, processando."
			STR0006 := "Registros processados: "
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Taxa de dif. de câmbio a receber"
			STR0002 := "Esta rotina irá refazer as taxas atualizadas de diferença de câmbio a receber da moeda 01, de acordo com as taxas do dia do movimento."
			STR0003 := "OK"
			STR0004 := "Cancelar"
			STR0005 := "Aguarde, processando."
			STR0006 := "Registros processados: "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
