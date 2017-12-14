#include "protheus.ch"

/* -------------------------------------------------------------------
Fun��o U_MOEDAS
Autor J�lio Wittwer
Data 28/03/2015
Descri��o Fonte de exemplo consumingo um Web Service publico
 de fator de convers�o de moedas, utilizando a 
 gera��o de classe Client de Web Services do AdvPL
Url http://www.webservicex.net/CurrencyConvertor.asmx?WSDL
------------------------------------------------------------------- */
User Function Moedas()
	Local oWS	
	// Cria a inst�ncia da classe client
	oWs := WSCurrencyConvertor():New()
	
	// Alimenta as propriedades de envio 
	oWS:oWSFromCurrency:Value := 'BRL' // Real ( Brasil )
	oWS:oWSToCurrency:Value := 'USD' // United States Dollar
	
	// Habilita informa��es de debug no log de console
	WSDLDbgLevel(3)
	
	// Chama o m�todo do Web Service
	If oWs:ConversionRate()
	 // Retorno .T. , solicita��o enviada e recebida com sucesso
	 MsgStop("Fator de convers�o: "+cValToChar(oWS:nConversionRateResult),"Requisi��o Ok")
	 MsgStop("Por exemplo, 100 reais compram "+cValToChar(100 * oWS:nConversionRateResult )+" D�lares Americanos.")
	Else
	 // Retorno .F., recupera e mostra string com detalhes do erro 
	 MsgStop(GetWSCError(),"Erro de Processamento")
	Endif

Return