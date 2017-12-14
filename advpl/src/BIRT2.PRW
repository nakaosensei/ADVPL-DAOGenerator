#Include 'Protheus.ch'
#Include 'tdsbirt.ch'
 
User Function BIRT2()
 
Local oReport
 
DEFINE REPORT oReport NAME outro TITLE "Teste de Report" 
 
ACTIVATE REPORT oReport LAYOUT outro FORMAT HTML
 
Return