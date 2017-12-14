#Include 'Protheus.ch'

//Realizar Ajuste IGPM
User Function LIGFAT12()
	Private oDlg
	Private oButton1
	Private oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
	Private oGet1
	Private cGet1 := SPACE(20)
	Private oSay1
										
	DEFINE MSDIALOG oDlg TITLE "Informa a Base de Calculo para ajustes" FROM 000, 000  TO 190, 400 COLORS 0, 16777215 PIXEL
		@ 008, 004 SAY oSay1 PROMPT "Favor informar o valor a ser ajustado:" SIZE 185, 014 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
		@ 024, 005 MSGET oGet1 VAR cGet1 SIZE 075, 010 OF oDlg COLORS 0, 16777215 PIXEL PICTURE "@E 99.9999"
		@ 062, 101 BUTTON oButton1 PROMPT "Cancelar" action oDlg:end() SIZE 037, 012 OF oDlg PIXEL
		@ 062, 151 BUTTON oButton2 PROMPT "OK" action FAT12A() SIZE 037, 012 OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg			
Return


STATIC Function FAT12A()
IF !EMPTY (cGet1) .AND. VAL(cGet1) > 0
	_nAjuste := VAL(cGet1)/100 + 1
	PROCESSA({||FAT121()})
	
	oDlg:end()
	MSGINFO("Rotina Executada")
ELSE
	MSGINFO("Numero inv�lido")
ENDIF	
return

STATIC FUNCTION FAT121() //PROCESSAMENTO DOS CONTRATOS
***************************************
LOCAL _NQTREGUA := 0
LOCAL _DTATUAL := DDATABASE

DBSELECTAREA("ADA")
DBSETORDER(1)
DBGOTOP()
WHILE !EOF()
	IF ADA->ADA_ULIBER=="S"//LIB FINANCEIRO
		_NQTREGUA++
	ENDIF
	DBSKIP()
ENDDO

PROCREGUA(_NQTREGUA)

DBSELECTAREA("ADA")
DBSETORDER(1)                          
DBGOTOP()                             
WHILE !EOF()        
	          
	IF ADA->ADA_ULIBER=="S" //LIB FINANCEIRO
		INCPROC("Processando...")
		                     
		_AITENS := {}
		_APDEMO	:= {}
		_ANFGER	:= {}
		_LCONSOK:= .F.              
		
		IF ADA->ADA_UTIPO == 'F' .AND. (ADA->ADA_MSBLQL!="1" .OR. (ADA->ADA_MSBLQL=="1" .AND. ADA->ADA_UDTFEC<=ADA->ADA_UDTBLQ))
			
			//INICIO - PRODUTOS CONTRATO
			DBSELECTAREA("ADB")
			DBSETORDER(1)
			DBGOTOP()
			IF DBSEEK(XFILIAL("ADB")+ADA->ADA_NUMCTR)
				WHILE !EOF() .AND. ADB->ADB_FILIAL+ADB->ADB_NUMCTR==ADA->ADA_FILIAL+ADA->ADA_NUMCTR
					_nVlAjuste := 0	
					
					DBSELECTAREA("SB1")
					DBSETORDER(1)
					IF DBSEEK(XFILIAL("SB1")+ADB->ADB_CODPRO)
						IF SB1->B1_UITCONT == "S" .AND. EMPTY(ADB->ADB_UDTFIM) .AND. !EMPTY(ADB->ADB_UDTINI) 
							IF ADB->ADB_UDTINI < _DTATUAL
								_DTCOMP := ADB->ADB_UDTINI
								_nDifMes =	 DateDiffMonth(_DTATUAL, _DTCOMP)
								
								IF !EMPTY(ADB->ADB_UDTAJU) .AND. _nDifMes <= 24
									_DTCOMP := ADB->ADB_UDTAJU	
									_nDifMes =	 DateDiffMonth(_DTATUAL, _DTCOMP)
								ENDIF						
								
								IF _nDifMes > 12 .AND. _nDifMes <= 24
									_nVlAjuste := ROUND(ADB->ADB_PRCVEN * _nAjuste,2) 
								ENDIF
								
								IF _nDifMes = 25
									IF SB1->B1_PRV1 > 0
										IF ADB->ADB_PRCVEN < SB1->B1_PRV1	 
											_nVlAjuste := SB1->B1_PRV1
										ENDIF
									/*ELSE
										_nVlAjuste := ROUND(ADB->ADB_PRCVEN * _nAjuste,2) */
									ENDIF
								ENDIF
								 
								IF _nVlAjuste > 0 
									RECLOCK("ADB",.F.)
									  ADB->ADB_PRCVEN	:= _nVlAjuste 
									  ADB->ADB_TOTAL	:= _nVlAjuste * ADB->ADB_QUANT
									  ADB->ADB_UDTAJU := DDATABASE
									MSUNLOCK()
								ENDIF
							ENDIF
						ENDIF	 
					ENDIF //IF DO SB1
					
					DBSELECTAREA("ADB")
					DBSKIP()
				ENDDO
			
				DBSELECTAREA("ADA")
 
 				/*			 
				RECLOCK("ADA",.F.)            ?
					ADA->ADA_UDTAJU := DDATABASE
				MSUNLOCK()*/
			ENDIF							
			
			
		ENDIF
	ENDIF
	                                
	DBSELECTAREA("ADA")
	DBSKIP() 
ENDDO 
RETURN
 