#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³LIGFIN05  ºAUTOR  ³ROBSON ADRIANO      º DATA ³  27/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³CALCULAR MULTA SOBRE OS ITENS DO CONTRATO PARA CANCELAMENTO º±±
±±º          ³			                        								º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ LIG                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍroÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   

User Function LIGFIN09(pNumCtr,pValidade)
Local _area 	:= 	getarea()
Local _total	:=	0
dbselectarea("ADB")
dbsetorder(1)
if dbseek(xFilial()+ADA->ADA_NUMCTR)
	while !eof() .and. xFilial()+ADA->ADA_NUMCTR==ADB->ADB_FILIAL+ADB->ADB_NUMCTR
		IF EMPTY(ADB->ADB_UDTFIM) //.OR. ADB->ADB_UDTFIM < DDATABASE
			IF !EMPTY(ADB->ADB_UDTINI)
				dtFinal 		:= MonthSum(ADB->ADB_UDTINI,pValidade - ADB->ADB_UMESIN)
				diasTotais 	:= DateDiffDay(dtFinal,ADB->ADB_UDTINI)
				diasRestant 	:= DateDiffDay(dtFinal,DDatabase)
				
				IF diasRestant > 0
				
					_cItemCtr := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + ADB->ADB_CODPRO, "B1_UITCONT")
					IF (_cItemCtr = 'S')			
						_perc := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + ADB->ADB_CODPRO, "B1_UPC01")
					
						_total += (ADB->ADB_TOTAL / 30) * diasRestant / 2 * (_perc/100)	
					ENDIF		
				ENDIF
			ENDIF
		ENDIF	
		
		dbselectarea("ADB")
		dbskip()
	enddo
endif

restarea(_area)
Return ROUND(_total,2)
