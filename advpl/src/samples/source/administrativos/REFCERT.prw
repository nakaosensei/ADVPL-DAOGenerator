#include "PROTHEUS.CH"
#include "REFCERT.CH"      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREFCERT   บAutor  ณTOTVS               บ Data ณ  21/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRefaz os n๚meros de certificado de reten็ใo da tabela SEK   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function REFCERT()        

REFEKHelp()

If Aviso(STR0001,STR0002,{STR0003,STR0004},2) == 1
	Processa({|lEnd| REFCERTEK(@lEnd)},STR0001,STR0005,.F.)
Endif  
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF085RefEK บAutor  ณTOTVS               บ Data ณ  21/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRefaz os n๚meros de certificado de reten็ใo da tabela SEK   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function REFCERTEK(lEnd)
 
Local nTamCert := TamSX3("FE_NROCERT")[1]
//Local nTamNum := 12
Local nTamNum  := TamSX3("EK_NUM")[1] 
Local aAreaSEK   := SEK->(GetArea())
Local aAreaSFE   := SFE->(GetArea()) 
Local nReg := 0

If SEK->(FieldPos("EK_NROCERT")) > 0
	dbSelectArea("SFE")
	SFE->(dbSetOrder(1))
	SFE->(dbGoTop()) 

	If SFE->(dbSeek(xFilial("SFE")))
		While !SFE->(Eof()) .And. SFE->FE_FILIAL == xFilial("SFE")
			
			If nTamCert > nTamNum .And. Len(SFE->FE_NROCERT) > nTamNum 	
				dbSelectArea("SEK")
				SEK->(dbSetOrder(1))
				                       
				If SEK->(dbSeek(xFilial("SEK")+SFE->FE_ORDPAGO+"RG"))	
					While !SEK->(Eof()) .And. SEK->EK_FILIAL == xFilial("SEK") .And. SEK->EK_ORDPAGO == SFE->FE_ORDPAGO
						Do Case
							Case SFE->FE_TIPO <> "B"
								If SEK->EK_TIPO <> "IB-" .And. SEK->EK_TIPODOC == "RG" .And. !SEK->EK_CANCEL .And.;
								   SFE->FE_RETENC == SEK->EK_VALOR .And. SFE->FE_EMISSAO == SEK->EK_EMISSAO .And. Empty(SEK->EK_NROCERT) 
									RecLock("SEK",.F.)
										SEK->EK_NROCERT := SFE->FE_NROCERT 
										nReg++ 	
									MsUnLock()
								Endif
							Case SFE->FE_TIPO == "B"
								If SEK->EK_TIPO == "IB-" .And. SEK->EK_TIPODOC == "RG" .And. SFE->FE_EST == SEK->EK_EST .And. !SEK->EK_CANCEL .And.;
								   SFE->FE_RETENC == SEK->EK_VALOR .And. SFE->FE_EMISSAO == SEK->EK_EMISSAO .And. Empty(SEK->EK_NROCERT)
									RecLock("SEK",.F.)
										SEK->EK_NROCERT := SFE->FE_NROCERT 
										nReg++ 	
									MsUnLock()
								Endif 	 	
						EndCase 
						SEK->(dbSkip())
					EndDo				
				Endif
			Else
				If SEK->(dbSeek(xFilial("SEK")+SFE->FE_ORDPAGO+"RG"))	
					While !SEK->(Eof()) .And. SEK->EK_FILIAL == xFilial("SEK")
						If SEK->EK_TIPODOC == "RG" .And. !SEK->EK_CANCEL .And. Empty(SEK->EK_NROCERT) 
							RecLock("SEK",.F.)
								SEK->EK_NROCERT := SEK->EK_NUM
							MsUnLock()	
						EndIf
					Enddo
				Endif	
			Endif
			SFE->(dbSkip())
		EndDo 
	Endif
	
	Alert("Registros Processados: "+Str(nReg))  
	
	SEK->(RestArea(aAreaSEK))  
	SFE->(RestArea(aAreaSFE))
Else
	Help("",1,"REFCERT")
Endif
	
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREFEKHelp บAutor  ณTOTVS               บ Data ณ  21/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณHelp                                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Function REFEKHelp()

Local aHelpPor := {} 
Local aHelpEng := {} 
Local aHelpSpa := {} 
      
aHelpPor := {"Nใo existe o campo EK_NROCERT."}
aHelpEng := {"The field EK_NROCERT does not exist."}
aHelpSpa := {"No existe el campo EK_NROCERT."}
PutHelp("PREFCERT",aHelpPor,aHelpEng,aHelpSpa,.T.)  
 
aHelpPor := {"Verifique a exist๊ncia do campo na ","tabela SEK e execute o update","caso necessแrio."}
aHelpEng := {"Check if the field exist on the table","SEK and execute the update","if necessary."}
aHelpSpa := {"Verifique la existencia del campo en","la tabla SEK y ejecute el update","si fuera necesario."}
PutHelp("SREFCERT",aHelpPor,aHelpEng,aHelpSpa,.T.)  

Return