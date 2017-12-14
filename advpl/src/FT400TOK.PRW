#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FT400TOK  ºAutor  ³CASSIUS C MARTINS   º Data ³  06/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE EXECUTADO PARA VALIDAR DADOS DO CONTRATO DE PARCERIA    º±±
±±º          ³ FATA400                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIGUE                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION FT400TOK()
***********************************  
LOCAL _AREA 	:= GETAREA() 
LOCAL _PDTINI   := ASCAN(AHEADER,{|X|ALLTRIM(X[2])=="ADB_UDTINI"})
LOCAL _PDTFIM   := ASCAN(AHEADER,{|X|ALLTRIM(X[2])=="ADB_UDTFIM"})

IF M->ADA_ULIBER!=ADA->ADA_ULIBER .AND. M->ADA_ULIBER=="S" .AND. EMPTY(M->ADA_UDTLIB)
	M->ADA_UDTLIB := DATE()
ENDIF

IF M->ADA_MSBLQL!=ADA->ADA_MSBLQL

	IF !MSGYESNO("Deseja realmente alterar a situação do contrato ?")
		RETURN(.F.)
	ELSE
		IF M->ADA_MSBLQL=="1" .AND. EMPTY(M->ADA_UDTBLQ)
			M->ADA_UDTBLQ := DATE() 
			
			FOR I:=1 TO LEN(ACOLS)
				ACOLS[I,_PDTFIM] := DATE()
			NEXT I
		ENDIF
		
		IF M->ADA_MSBLQL!="1" .AND. !EMPTY(M->ADA_UDTBLQ)
			M->ADA_UDTBLQ := STOD("")
			
			FOR I:=1 TO LEN(ACOLS)
				ACOLS[I,_PDTINI] := DATE() 
				ACOLS[I,_PDTFIM] := STOD("")
			NEXT I
		ENDIF
	ENDIF

ENDIF

RESTAREA(_AREA)
RETURN(.T.)
