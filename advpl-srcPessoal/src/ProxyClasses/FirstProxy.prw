#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://www.webservicex.net/CurrencyConvertor.asmx?WSDL
Gerado em        03/18/17 10:42:39
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _DXVXNQU ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCurrencyConvertor
------------------------------------------------------------------------------- */

WSCLIENT WSCurrencyConvertor

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ConversionRate

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSFromCurrency           AS CurrencyConvertor_Currency       
	WSDATA   oWSToCurrency             AS CurrencyConvertor_Currency      
	WSDATA   nConversionRateResult     AS double

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCurrencyConvertor
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20161027] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCurrencyConvertor
	::oWSFromCurrency    := CurrencyConvertor_CURRENCY():New()
	::oWSToCurrency      := CurrencyConvertor_CURRENCY():New()
Return

WSMETHOD RESET WSCLIENT WSCurrencyConvertor
	::oWSFromCurrency    := NIL 
	::oWSToCurrency      := NIL 
	::nConversionRateResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCurrencyConvertor
Local oClone := WSCurrencyConvertor():New()
	oClone:_URL          := ::_URL 
	oClone:oWSFromCurrency :=  IIF(::oWSFromCurrency = NIL , NIL ,::oWSFromCurrency:Clone() )
	oClone:oWSToCurrency :=  IIF(::oWSToCurrency = NIL , NIL ,::oWSToCurrency:Clone() )
	oClone:nConversionRateResult := ::nConversionRateResult
Return oClone

// WSDL Method ConversionRate of Service WSCurrencyConvertor

WSMETHOD ConversionRate WSSEND oWSFromCurrency,oWSToCurrency WSRECEIVE nConversionRateResult WSCLIENT WSCurrencyConvertor
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConversionRate xmlns="http://www.webserviceX.NET/">'
cSoap += WSSoapValue("FromCurrency", ::oWSFromCurrency, oWSFromCurrency , "Currency", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ToCurrency", ::oWSToCurrency, oWSToCurrency , "Currency", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ConversionRate>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.webserviceX.NET/ConversionRate",; 
	"DOCUMENT","http://www.webserviceX.NET/",,,; 
	"http://www.webservicex.net/CurrencyConvertor.asmx")

::Init()
::nConversionRateResult :=  WSAdvValue( oXmlRet,"_CONVERSIONRATERESPONSE:_CONVERSIONRATERESULT:TEXT","double",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Enumeration Currency

WSSTRUCT CurrencyConvertor_Currency
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CurrencyConvertor_Currency
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "AFA" )
	aadd(::aValueList , "ALL" )
	aadd(::aValueList , "DZD" )
	aadd(::aValueList , "ARS" )
	aadd(::aValueList , "AWG" )
	aadd(::aValueList , "AUD" )
	aadd(::aValueList , "BSD" )
	aadd(::aValueList , "BHD" )
	aadd(::aValueList , "BDT" )
	aadd(::aValueList , "BBD" )
	aadd(::aValueList , "BZD" )
	aadd(::aValueList , "BMD" )
	aadd(::aValueList , "BTN" )
	aadd(::aValueList , "BOB" )
	aadd(::aValueList , "BWP" )
	aadd(::aValueList , "BRL" )
	aadd(::aValueList , "GBP" )
	aadd(::aValueList , "BND" )
	aadd(::aValueList , "BIF" )
	aadd(::aValueList , "XOF" )
	aadd(::aValueList , "XAF" )
	aadd(::aValueList , "KHR" )
	aadd(::aValueList , "CAD" )
	aadd(::aValueList , "CVE" )
	aadd(::aValueList , "KYD" )
	aadd(::aValueList , "CLP" )
	aadd(::aValueList , "CNY" )
	aadd(::aValueList , "COP" )
	aadd(::aValueList , "KMF" )
	aadd(::aValueList , "CRC" )
	aadd(::aValueList , "HRK" )
	aadd(::aValueList , "CUP" )
	aadd(::aValueList , "CYP" )
	aadd(::aValueList , "CZK" )
	aadd(::aValueList , "DKK" )
	aadd(::aValueList , "DJF" )
	aadd(::aValueList , "DOP" )
	aadd(::aValueList , "XCD" )
	aadd(::aValueList , "EGP" )
	aadd(::aValueList , "SVC" )
	aadd(::aValueList , "EEK" )
	aadd(::aValueList , "ETB" )
	aadd(::aValueList , "EUR" )
	aadd(::aValueList , "FKP" )
	aadd(::aValueList , "GMD" )
	aadd(::aValueList , "GHC" )
	aadd(::aValueList , "GIP" )
	aadd(::aValueList , "XAU" )
	aadd(::aValueList , "GTQ" )
	aadd(::aValueList , "GNF" )
	aadd(::aValueList , "GYD" )
	aadd(::aValueList , "HTG" )
	aadd(::aValueList , "HNL" )
	aadd(::aValueList , "HKD" )
	aadd(::aValueList , "HUF" )
	aadd(::aValueList , "ISK" )
	aadd(::aValueList , "INR" )
	aadd(::aValueList , "IDR" )
	aadd(::aValueList , "IQD" )
	aadd(::aValueList , "ILS" )
	aadd(::aValueList , "JMD" )
	aadd(::aValueList , "JPY" )
	aadd(::aValueList , "JOD" )
	aadd(::aValueList , "KZT" )
	aadd(::aValueList , "KES" )
	aadd(::aValueList , "KRW" )
	aadd(::aValueList , "KWD" )
	aadd(::aValueList , "LAK" )
	aadd(::aValueList , "LVL" )
	aadd(::aValueList , "LBP" )
	aadd(::aValueList , "LSL" )
	aadd(::aValueList , "LRD" )
	aadd(::aValueList , "LYD" )
	aadd(::aValueList , "LTL" )
	aadd(::aValueList , "MOP" )
	aadd(::aValueList , "MKD" )
	aadd(::aValueList , "MGF" )
	aadd(::aValueList , "MWK" )
	aadd(::aValueList , "MYR" )
	aadd(::aValueList , "MVR" )
	aadd(::aValueList , "MTL" )
	aadd(::aValueList , "MRO" )
	aadd(::aValueList , "MUR" )
	aadd(::aValueList , "MXN" )
	aadd(::aValueList , "MDL" )
	aadd(::aValueList , "MNT" )
	aadd(::aValueList , "MAD" )
	aadd(::aValueList , "MZM" )
	aadd(::aValueList , "MMK" )
	aadd(::aValueList , "NAD" )
	aadd(::aValueList , "NPR" )
	aadd(::aValueList , "ANG" )
	aadd(::aValueList , "NZD" )
	aadd(::aValueList , "NIO" )
	aadd(::aValueList , "NGN" )
	aadd(::aValueList , "KPW" )
	aadd(::aValueList , "NOK" )
	aadd(::aValueList , "OMR" )
	aadd(::aValueList , "XPF" )
	aadd(::aValueList , "PKR" )
	aadd(::aValueList , "XPD" )
	aadd(::aValueList , "PAB" )
	aadd(::aValueList , "PGK" )
	aadd(::aValueList , "PYG" )
	aadd(::aValueList , "PEN" )
	aadd(::aValueList , "PHP" )
	aadd(::aValueList , "XPT" )
	aadd(::aValueList , "PLN" )
	aadd(::aValueList , "QAR" )
	aadd(::aValueList , "ROL" )
	aadd(::aValueList , "RUB" )
	aadd(::aValueList , "WST" )
	aadd(::aValueList , "STD" )
	aadd(::aValueList , "SAR" )
	aadd(::aValueList , "SCR" )
	aadd(::aValueList , "SLL" )
	aadd(::aValueList , "XAG" )
	aadd(::aValueList , "SGD" )
	aadd(::aValueList , "SKK" )
	aadd(::aValueList , "SIT" )
	aadd(::aValueList , "SBD" )
	aadd(::aValueList , "SOS" )
	aadd(::aValueList , "ZAR" )
	aadd(::aValueList , "LKR" )
	aadd(::aValueList , "SHP" )
	aadd(::aValueList , "SDD" )
	aadd(::aValueList , "SRG" )
	aadd(::aValueList , "SZL" )
	aadd(::aValueList , "SEK" )
	aadd(::aValueList , "CHF" )
	aadd(::aValueList , "SYP" )
	aadd(::aValueList , "TWD" )
	aadd(::aValueList , "TZS" )
	aadd(::aValueList , "THB" )
	aadd(::aValueList , "TOP" )
	aadd(::aValueList , "TTD" )
	aadd(::aValueList , "TND" )
	aadd(::aValueList , "TRL" )
	aadd(::aValueList , "USD" )
	aadd(::aValueList , "AED" )
	aadd(::aValueList , "UGX" )
	aadd(::aValueList , "UAH" )
	aadd(::aValueList , "UYU" )
	aadd(::aValueList , "VUV" )
	aadd(::aValueList , "VEB" )
	aadd(::aValueList , "VND" )
	aadd(::aValueList , "YER" )
	aadd(::aValueList , "YUM" )
	aadd(::aValueList , "ZMK" )
	aadd(::aValueList , "ZWD" )
	aadd(::aValueList , "TRY" )
Return Self

WSMETHOD SOAPSEND WSCLIENT CurrencyConvertor_Currency
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CurrencyConvertor_Currency
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT CurrencyConvertor_Currency
Local oClone := CurrencyConvertor_Currency():New()
	oClone:Value := ::Value
Return oClone


