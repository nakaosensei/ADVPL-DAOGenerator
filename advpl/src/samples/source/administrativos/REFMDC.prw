#include "PROTHEUS.CH"
#include "REFMDC.CH"      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �REFMDC    �Autor  �TOTVS               � Data �  05/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function REFMDC()        

//STR0001 - Taxa de dif. de c�mbio a receber
//STR0002 - Esta rotina ir� refazer as taxas atualizadas de diferen�a de c�mbio a receber da moeda 01, de acordo com as taxas do dia do movimento.
//STR0003 - OK
//STR0004 - Cancelar
//STR0005 - Aguarde, processando.
//STR0006 -Registros processados:

If Aviso(STR0001,STR0002,{STR0003,STR0004},2) == 1
	Processa({|lEnd| REFMDC074(@lEnd)},STR0001,STR0005,.F.)
Endif  
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �REFMDC074 �Autor  �TOTVS               � Data �  05/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function REFMDC074()
 
Local aAreaSFR := SFR->(GetArea())
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSEL := SEL->(GetArea())
Local nReg := 0
Local nTaxa := 0
Local nTamCli := 0
 
dbSelectArea("SFR")
SFR->(dbSetOrder(3))
SFR->(dbGoTop()) 

If(SFR->(dbSeek(xFilial("SFR")+"1B")))

	While !SFR->(Eof()) .And. SFR->FR_FILIAL == xFilial("SFR") .And. FR_CARTEI == "1" .And. FR_TIPODI == "B"
	
		If SFR->FR_MOEDA = 1	
			dbSelectArea("SE1")
			SE1->(dbSetOrder(2))
			SE1->(dbGoTop()) 
		
			If (SE1->(dbSeek(xFilial("SE1")+SFR->FR_CHAVOR)))
	        
				If SE1->E1_MOEDA > 1
					nTaxa := RecMoeda(SFR->FR_DATADI,SE1->E1_MOEDA)
					
					dbSelectArea("SEL")
					SEL->(dbSetOrder(1))
					SEL->(dbGoTop())
					
					nTamCli := TamSX3("E1_CLIENTE")[1]+TamSX3("E1_LOJA")[1]
					
					If(SEL->(dbSeek(xFilial("SEL")+SFR->FR_RECIBO+"TB"+Substr(SFR->FR_CHAVOR,nTamCli+1))))
						If SEL->(EL_CLIORIG+EL_LOJORIG) == Substr(SFR->FR_CHAVOR,1,nTamCli)
							If SEL->&("EL_TXMOE0"+AllTrim(Str(SE1->E1_MOEDA))) <> nTaxa
								nTaxa := SEL->&("EL_TXMOE0"+AllTrim(Str(SE1->E1_MOEDA))) 
							Endif
						Endif
					Endif
					
					RecLock("SFR",.F.)
						Replace FR_TXATU With nTaxa
					MsUnlock()
					nReg++	
				Endif
				
			Endif
		Endif
		
		SFR->(dbSkip())
	EndDo
	Alert(STR0006+Str(nReg))  
	
	SFR->(RestArea(aAreaSFR))  
	SE1->(RestArea(aAreaSE1))
	SEL->(RestArea(aAreaSEL))
Endif
	
Return .T.