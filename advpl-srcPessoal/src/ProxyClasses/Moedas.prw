#include "protheus.ch"

/* -------------------------------------------------------------------
Função U_MOEDAS
Autor Júlio Wittwer
Data 28/03/2015
Descrição Fonte de exemplo consumingo um Web Service publico
 de fator de conversão de moedas, utilizando a 
 geração de classe Client de Web Services do AdvPL
Url http://www.webservicex.net/CurrencyConvertor.asmx?WSDL
------------------------------------------------------------------- */
User Function Moedas()
	Local oWS	
	// Cria a instância da classe client
	oWs := WSCurrencyConvertor():New()
	
	// Alimenta as propriedades de envio 
	oWS:oWSFromCurrency:Value := 'BRL' // Real ( Brasil )
	oWS:oWSToCurrency:Value := 'USD' // United States Dollar
	
	// Habilita informações de debug no log de console
	WSDLDbgLevel(3)
	
	// Chama o método do Web Service
	If oWs:ConversionRate()
	 // Retorno .T. , solicitação enviada e recebida com sucesso
	 MsgStop("Fator de conversão: "+cValToChar(oWS:nConversionRateResult),"Requisição Ok")
	 MsgStop("Por exemplo, 100 reais compram "+cValToChar(100 * oWS:nConversionRateResult )+" Dólares Americanos.")
	Else
	 // Retorno .F., recupera e mostra string com detalhes do erro 
	 MsgStop(GetWSCError(),"Erro de Processamento")
	Endif

Return