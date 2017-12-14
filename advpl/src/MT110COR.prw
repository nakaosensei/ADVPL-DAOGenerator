#INCLUDE "PROTHEUS.CH"

User Function MT110COR()

	Local aCores := {}//ParamIxb[1] 

	Local nBmpPos

	//Testo o Tipo
	IF !( ValType( aCores ) == "A" )
		aCores := {}
	EndIF


	IF nToL(SC1->( FieldPos( "C1_APROV" ) ) )
	
		//C1_QUJE -> Quantidade j� pedida do material solicitado	
	
		
		aAdd( aCores , {"C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV='B'",'BR_LARANJA'})  //"Solicita��o Bloqueada"
		
		aAdd( aCores,  {"C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV='R'",'BR_VERMELHO'}) //"Solicita��o Rejeitada"
		
		aAdd( aCores,  {"C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV='L'",'ENABLE'}) //"Solicita��o Aprovada"
		
		aAdd( aCores , {"C1_QUJE > 0 .AND. EMPTY(C1_PEDIDO) .AND. EMPTY(C1_RESIDUO)",'BR_AMARELO'})  //"Solicita��o Parcialmente Atendida"
		
		aAdd( aCores , {"C1_QUJE > 0 .AND. !EMPTY(C1_PEDIDO) .AND. EMPTY(C1_RESIDUO)",'BR_AZUL'})  //"Solicita��o em Pedido de Compra"
		
		aAdd( aCores,  {"C1_QUJE==0.And.C1_COTACAO<>Space(Len(C1_COTACAO)).And. C1_IMPORT <>'S'",'BR_CINZA'}) //"Solicita��o em Cota��o"
		
		aAdd( aCores,  {"C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV $ ' ,L'.And.EMPTY(C1_RESIDUO)",'BR_BRANCO'}) //"Solicita��o Pendente"
		
	
	EndIF
	

//	nBmpPos := aScan( aCores , { |aBmp| Upper( AllTrim( aBmp[2] ) ) == "BR_AMARELO" } )
//	IF ( nBmpPos > 0 )
//		IF !( "C1_QUANT" $ aCores[ nBmpPos ][1] )
//			aCores[ nBmpPos ][1] += " .AND. C1_QUJE<>C1_QUANT" //Redefino SC Parcialmente Atendida (Tem um BUG na Logica padrao)
//		EndIF 
//	EndIF


Return( aCores )      

Static Function GetC1Status( cAlias , cResName , lArrColors )

	Local bGetColors := { || Mata110() }   
	Local bGetLegend := { || A110Legenda() }

	DEFAULT cAlias   := "SC1"

Return( StaticCall( u_mBrowseLFilter , BrwGetSLeg , @cAlias , @bGetColors , @bGetLegend , @cResName , @lArrColors ) )

