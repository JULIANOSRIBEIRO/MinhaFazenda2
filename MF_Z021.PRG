*********************************************************************
****  Sistema......: SINCON-Sistema Integrado de Controle        ****
****  Versao.......: 5.0                                         ****
****  Programa.....: MF_Z021.PRG                                 ****
****  Finalidade...: Cadastro da Fazenda / Indicadores           ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************

**********************
function dados_FAZENDA
**********************
WDIR = WDIRE_FAZ+"\FAZENDA.CFG"

if ! file(WDIR)
   CFG_NREG   = space(20)
   CFG_FAZ    = space(40)
   CFG_PROP   = space(40)
   CFG_DOC    = space(14)
   CFG_END    = space(40)
   CFG_BAIRRO = space(25)
   CFG_CIDADE = space(25)
   CFG_UF     = space(02)
   CFG_CEP    = space(08)
   CFG_CONT   = space(40)
   CFG_TEL1   = space(11)
   CFG_TEL2   = space(11)
   CFG_EMAIL  = space(50)
   CFG_SITE   = space(50)
   CFG_NRT    = space(40)
   CFG_TRT1   = space(11)
   CFG_TRT2   = space(11)
   CFG_ERT    = space(50)
 
   save all like CFG_* to &WDIR 
       
else
   restore from &WDIR additive
endif

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "N"+chr(167)+" Registro..........:"
@ 04,01 say "Nome da Propriedade..:"
@ 05,01 say "Nome do Propriet"+chr(160)+"rio.:"             
@ 06,01 say "CNPJ/CPF Propriet"+chr(160)+"rio:"             

@ 08,01 say "Endere"+chr(135)+"o.............:"
@ 09,01 say "Bairro...............:" 
@ 10,01 say "Cidade...............:" 
@ 11,01 say "Estado...............:"
@ 12,01 say "Cep..................:"

@ 14,01 say "Contato..............:"
@ 15,01 say "Telefone(s)..........:                 |"
@ 16,01 say "E-mail...............:"
@ 17,01 say "Site.................:"

@ 19,01 say "Respons"+chr(160)+"vel T"+chr(130)+"cnico..:"
@ 20,01 say "Telefone(s)..........:                 |"
@ 21,01 say "E-mail...............:"

do while .t.

   @ 03,24 get CFG_NREG   
   @ 04,24 get CFG_FAZ    valid ! empty(CFG_FAZ)
   @ 05,24 get CFG_PROP   
   @ 06,24 get CFG_DOC    picture "99999999999999"

   @ 08,24 get CFG_END    
   @ 09,24 get CFG_BAIRRO 
   @ 10,24 get CFG_CIDADE 
   @ 11,24 get CFG_UF     picture "!!"
   @ 12,24 get CFG_CEP    picture "@R 99999-999"
   
   @ 14,24 get CFG_CONT   
   @ 15,24 get CFG_TEL1   picture "@R (99) 99999-9999"
   @ 15,42 get CFG_TEL2   picture "@R (99) 99999-9999"
   @ 16,24 get CFG_EMAIL  valid formata_EMAIL(CFG_EMAIL)
   @ 17,24 get CFG_SITE   
   
   @ 19,24 get CFG_NRT    
   @ 20,24 get CFG_TRT1   picture "@R (99) 99999-9999" 
   @ 20,42 get CFG_TRT2   picture "@R (99) 99999-9999" 
   @ 21,24 get CFG_ERT    valid formata_EMAIL(CFG_ERT)
   read_f()

   if lastkey() == 27
      @ 24,00 clear to 24,79
      WDIR = WDIRE_FAZ+"\FAZENDA.CFG"
      restore from &WDIR additive      
 
      setcolor(COR_TEXT)
      @ 00,01 clear to 00,40
      @ 00,01 say alltrim(CFG_FAZ)

      return .t.
   endif

   if confirma(24,"Dados corretos...(S/N)?","S") == "S"
     @ 24,00 clear to 24,79
      WDIR = WDIRE_FAZ+"\FAZENDA.CFG"
      save all like CFG_* to &WDIR 
       
      setcolor(COR_TEXT)
      @ 00,01 clear to 00,40
      @ 00,01 say alltrim(CFG_FAZ)

      return .t.
   endif

enddo

return .t.

******************************
function formata_EMAIL(WEMAIL)
******************************

if empty(WEMAIL) .or. lastkey() == 27
   return .t.
endif

if ! empty(WEMAIL)
   if ! ("@" $ WEMAIL)
      mensagem("AVISO!;O formato do e-mail "+chr(130)+" inv"+chr(160)+"lido.") 
      return .f.
   endif 
endif

return lower(WEMAIL)

**************************
function dados_INDICADORES
**************************
WDIR2 = WDIRE_FAZ+"\INDICA.CFG"

if ! file(WDIR2)
   IND_ARROBA = 0
   IND_ABATE  = 0
   IND_GANHO  = 0
   IND_DATA   = DATE()
   save all like IND_* to &WDIR2 
else
   restore from &WDIR2 additive
endif

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "1. Custo da Arroba R$.......:"
@ 05,01 say "2. Meta de Abate............:"
@ 07,01 say "3. Meta Ganho Di"+chr(160)+"rio de Peso:"
@ 09,01 say "4. Data de Atualiza"+chr(135)+chr(132)+"o......:"

do while .t.

   @ 03,31 get IND_ARROBA picture "@R@E 999,999.99"   
   @ 05,31 get IND_ABATE  picture "@R 99 Arroba(s)"
   @ 07,31 get IND_GANHO  picture "@R@E 99999.9 Kg"   
   @ 09,31 say IND_DATA
   read_f()

   if lastkey() == 27
      return .t.
   endif

   if confirma(24,"Dados corretos...(S/N)?","S") == "S"
     @ 24,00 clear to 24,79
      WDIR2 = WDIRE_FAZ+"\INDICA.CFG"
      save all like IND_* to &WDIR2 
      return .t.
   endif

enddo

return .t.

