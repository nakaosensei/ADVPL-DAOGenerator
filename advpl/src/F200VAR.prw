#include "protheus.ch

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F200VAR   �Autor  �Daniel Gouvea       � Data �  10/28/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. no retorno do arquivo CNAB                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ligue                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function F200VAR()
Local _aValores    := Paramixb[1] // aValores := ( { cNumTit, dBaixa, cTipo, cNossoNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc, dCred, cOcorr, xBuffer })
Local _area := getarea()
Local _aSE1 := SE1->(getarea())
                                 
dbselectarea("SE1")
dbsetorder(16)//E1_FILIAL+E1_IDCNAB
if SE1->(DbSeek(xFilial("SE1")+_aValores[1]))
	if nValRec > 0
		IF nValRec>SE1->E1_SALDO
			nJuros := nValRec - SE1->E1_SALDO
		endif
	endif
endif
               
restarea(_aSE1)
restarea(_area)
return .t.