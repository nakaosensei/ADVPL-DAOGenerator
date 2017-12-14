#ifdef SPANISH
	#define STR0001 "Ajuste de Fechas"
	#define STR0002 "IMPORTANTE:¡Haga un Backup de los datos antes de la ejecucion de esta rutina!"
	#define STR0003 "Se actualizaran los campos E5_VENCTO y E5_DTDISPO de las Reposiciones de Caja Chica, Orden de Pago y Recibos con el tipo Inmeditato que hayan sufrido modificacion en la fecha de vencimiento. "
	#define STR0004 "No existe ningun registro que necesite modificacion de fechas"
	#define STR0005 "No fue posible crear el archivo de Log"
	#define STR0006 "error numero:"
	#define STR0007 "Banco"
	#define STR0008 "Agencia"
	#define STR0009 "Cuenta"
	#define STR0010 "Tipo de Operacion"
	#define STR0011 "Historial"
	#define STR0012 "Orden/Recibo"
	#define STR0013 "Fecha Vencimiento"
	#define STR0014 "Fecha Disponibilidad"
	#define STR0015 "Fechas de Venc. y Dispo. modificados para"
	#define STR0016 "Recno"
	#define STR0017 "¡Proceso Finalizado!"
	#define STR0018 "Total de Registros Modificados:"
	#define STR0019 "Ok"
	#define STR0020 "Espere, procesando..."
	#define STR0021 "Anula"
#else
	#ifdef ENGLISH
		#define STR0001 "Ajuste de Datas"
		#define STR0002 "IMPORTANTE:Faça um Backup dos dados antes da executar essa rotina!"
		#define STR0003 "Será atualizado os campos E5_VENCTO e E5_DTDISPO das Reposições de Caixinha, Ordem de Pago e Recibos com o tipo Imeditato que tenham sofrido alteração na data de vencimento. "
		#define STR0004 "Não existe nenhum registro que seja necessário alterar as datas"
		#define STR0005 "Não foi possivel criar o arquivo de Log"
		#define STR0006 "erro número:"
		#define STR0007 "Banco"
		#define STR0008 "Agencia"
		#define STR0009 "Conta"
		#define STR0010 "Tipo de Operação"
		#define STR0011 "Histórico"
		#define STR0012 "Ordem/Recibo"
		#define STR0013 "Data Vencimento"
		#define STR0014 "Data Disponibilidade"
		#define STR0015 "Datas de Venc. e Dispo. alteradas para"
		#define STR0016 "Recno"
		#define STR0017 "Processo Finalizado!"
		#define STR0018 "Total de Registros Alterados:"
		#define STR0019 "Ok"
		#define STR0020 "Aguarde, processando..."
		#define STR0021 "Cancela"
	#else
		#define STR0001  "Ajuste de Datas"
		Static STR0002 := "IMPORTANTE:Faça um Backup dos dados antes da executar essa rotina!"
		Static STR0003 := "Será atualizado os campos E5_VENCTO e E5_DTDISPO das Reposições de Caixinha, Ordem de Pago e Recibos com o tipo Imeditato que tenham sofrido alteração na data de vencimento. "
		Static STR0004 := "Não existe nenhum registro que seja necessário alterar as datas"
		Static STR0005 := "Não foi possivel criar o arquivo de Log"
		#define STR0006  "erro número:"
		#define STR0007  "Banco"
		Static STR0008 := "Agencia"
		#define STR0009  "Conta"
		#define STR0010  "Tipo de Operação"
		#define STR0011  "Histórico"
		#define STR0012  "Ordem/Recibo"
		#define STR0013  "Data Vencimento"
		#define STR0014  "Data Disponibilidade"
		Static STR0015 := "Datas de Venc. e Dispo. alteradas para"
		#define STR0016  "Recno"
		#define STR0017  "Processo Finalizado!"
		Static STR0018 := "Total de Registros Alterados:"
		#define STR0019  "Ok"
		Static STR0020 := "Aguarde, processando..."
		#define STR0021  "Cancela"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0002 := "IMPORTANTE:Faça um Backup dos dados antes da executar este procedimento!"
			STR0003 := "Serão actualizados os campos E5_VENCTO e E5_DTDISPO das Reposições de Caixinha, Ordem de Pago e Recibos com o tipo Imeditato que tenham sofrido alteração na data de vencimento. "
			STR0004 := "Não existe nenhum registo que necessite alteração de datas"
			STR0005 := "Não foi possivel criar o ficheiro de Log"
			STR0008 := "Agência"
			STR0015 := "Datas de venc. e disp. alteradas para"
			STR0018 := "Total de registos alterados:"
			STR0020 := "Aguarde, a processar..."
		ElseIf cPaisLoc == "PTG"
			STR0002 := "IMPORTANTE:Faça um Backup dos dados antes da executar este procedimento!"
			STR0003 := "Serão actualizados os campos E5_VENCTO e E5_DTDISPO das Reposições de Caixinha, Ordem de Pago e Recibos com o tipo Imeditato que tenham sofrido alteração na data de vencimento. "
			STR0004 := "Não existe nenhum registo que necessite alteração de datas"
			STR0005 := "Não foi possivel criar o ficheiro de Log"
			STR0008 := "Agência"
			STR0015 := "Datas de venc. e disp. alteradas para"
			STR0018 := "Total de registos alterados:"
			STR0020 := "Aguarde, a processar..."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
