#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADSZ8    � Autor � Daniel Gouvea      � Data �  19/10/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Faixas de Bonificacao                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ligue                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADSZ8
Private cCadastro := "Cadastro de Faixas de Bonificacao"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZ8"

dbSelectArea("SZ8")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return