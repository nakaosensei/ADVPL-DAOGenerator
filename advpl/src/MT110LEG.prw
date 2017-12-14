#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT110LEG()

	Local aLegend := {} //ParamIxb[1] 

	//Testo o Tipo
	IF !( ValType( aLegend ) == "A" )
		aLegend := {}
	EndIF
	
	aAdd( aLegend , { "BR_BRANCO"  , OemToAnsi( "Solicitação Pendente" ) } )
	aAdd( aLegend , { "BR_VERDE"  ,  OemToAnsi( "Solicitação Aprovada" ) } )
	aAdd( aLegend , { "BR_CINZA"  ,  OemToAnsi( "Solicitação em Cotação" ) } )
	aAdd( aLegend , { "BR_AZUL"  ,   OemToAnsi( "Solicitação em Pedido de Compra" ) } )
	aAdd( aLegend , { "BR_AMARELO" , OemToAnsi( "Solicitação Parcialmente Atendida" ) } )
	aAdd( aLegend , { "BR_LARANJA"  , OemToAnsi( "Solicitação Bloqueada" ) } )
	aAdd( aLegend , { "BR_VERMELHO"  , OemToAnsi( "Solicitação Rejeitada " ) } )
	
Return( aLegend )

