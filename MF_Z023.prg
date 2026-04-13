*********************************************************************
****  Sistema......: MF-Minha Fazenda (Gerenciador)              ****
****  Versao.......: 5.0                                         ****
****  Programa.....: MFZ023.PRG                                  ****
****  Finalidade...: DADOS DE REPRODUÇÃO                         ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************

**********************
function INC_BCO_SEMEN
**********************

sc_BCO_SEMEN()
inkey(0)

return .t.


*********************
function sc_BCO_SEMEN 
*********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79 
@ 24,00 clear to 24,79 

@ 03,01 say "Lote........:"
@ 03,61 say "Data:"
@ 05,01 say "Hist"+chr(162)+"rico...:"
@ 10,01 say "Doador......:"
@ 12,01 say "(+) Qtde....:"
@ 14,01 say "(-) Baixa...:"
@ 16,01 say "(=) Saldo...:"

return .t.

**********************
function ALT_BCO_SEMEN
**********************

return .t.

**********************
function CON_BCO_SENEN 
**********************

return .t.

**********************
function EXC_BCO_SEMEN
**********************

return .t.

***********************
function INC_REPRODUCAO
***********************

SC_REPRODUCAO()
inkey(0)

return .t.


**********************
function SC_REPRODUCAO 
**********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79 
@ 24,00 clear to 24,79 

@ 02,01 say "Sequ"+CHR(136)+"ncia.:"
@ 02,61 say "Data:"      
@ 03,01 say "Brinco....:"
@ 03,61 say "Tipo:"

setcolor(COR_CONS)
@ 04,01 clear to 04,78
@ 04,01 say chr(175)+" Cobertura Natural (CN)"
setcolor(COR_TEXT)
@ 05,03 say "Touro......:"
@ 06,03 say "Comunica"+chr(135)+chr(132)+"o:"
@ 06,40 say "N"+chr(163)+"mero:"
      
setcolor(COR_CONS)
@ 07,01 clear to 07,78
@ 07,01 say chr(175)+" Insermina"+chr(135)+chr(132)+"o Artificial (IA)"
setcolor(COR_TEXT)
@ 08,03 say "Lote......:"
@ 08,30 say "Dose:" 
@ 08,55 say "M"+chr(130)+"todo:"
@ 09,03 say "Touro.....:"

setcolor(COR_CONS)
@ 10,01 clear to 10,78
@ 10,01 say chr(175)+" Transplante de Embri"+chr(132)+"o (TE)"
setcolor(COR_TEXT)
@ 11,03 say "Touro.....:"
@ 12,03 say "M"+chr(132)+"e.......:"
@ 13,03 say "Receptora.:"

setcolor(COR_CONS)
@ 14,01 clear to 14,78
CENTRO(14,"Observa"+chr(135)+chr(148)+"es")
setcolor(COR_TEXT)

setcolor(COR_CONS)
@ 20,01 clear to 20,78
CENTRO(20,"Confirmacao da Preenhez")
setcolor(COR_TEXT)

@ 21,01 say "Confirmado.?"
@ 21,61 say "Data:"
@ 22,01 say "Respons"+chr(160)+"vel:"

return .t.


***********************
function ALT_REPRODUCAO
***********************

return .t.

***********************
function CON_REPRODUCAO 
***********************

return .t.

***********************
function EXC_REPRODUCAO
***********************

return .t.

