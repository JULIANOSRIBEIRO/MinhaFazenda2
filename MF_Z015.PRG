*********************************************************************
****  Sistema......: SINCON-Sistema Integrado de Controle        ****
****  Programa.....: MF_Z014.PRG                                 ****
****  Finalidade...: Cadastros de Saida do Plantel               ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************
#include "TBrowse.ch"
#include "inkey.ch"

*************************
function sc_SAIDA_PLANTEL
*************************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "Sequ"+chr(136)+"ncia.:"
@ 05,01 say "Brinco....:"
@ 07,01 say "Saida.....:"
@ 09,01 say "Motivo....:"
@ 11,01 say "N.Fiscal..:"
@ 13,01 say "Valor.....:"
@ 15,01 say "Observa"+chr(135)+chr(132)+"o:"

return .t.

**************************
function INC_SAIDA_PLANTEL
**************************

do while .t.

   sc_SAIDA_PLANTEL()
   
   select SAIDA_P
   ordsetfocus("SINC001")
   go bottom

   WSEQ = SEQ + 1

   setcolor(COR_TEXT)
   @ 03,13 say strzero(WSEQ,6)

   WBRINCO = space(08) 
   WDATA   = DATE()
   WMOTIVO = space(15)
   WNF     = space(09)
   WVALOR  = 0 
   WOBS1   = space(60)

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,13 get WBRINCO  picture "99999999" valid busca4_BRINCO()
      @ 07,13 get WDATA
       
      @ 09,13,15,29 get WMOTIVO;   
      LISTBOX {"Venda          ", "Transferencia  ", "Morte          ", "Outros         "};
      DROPDOWN SCROLLBAR;
      COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
      MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar os motivos v"+chr(160)+"lidos."; 
      VALID ! empty(WMOTIVO)

      @ 11,13 get WNF      picture "999999999"
      @ 13,13 get WVALOR   picture "@R@E 999,999.99"
      @ 15,13 get WOBS1   
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if empty(WMOTIVO)
         loop
      endif  

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
 
         select SAIDA_P
         ordsetfocus("SINC001")
         go bottom

         WSEQ = SEQ + 1
 
         set deleted off
         go top
         if deleted()
            if ! reglock()
               loop
            endif
            recall
         else
            if ! iSEQUENCIAL()
               loop
            endif
         endif
         set deleted on

         replace SEQ with WSEQ
         grava()

         save_SAIDA_PLANTEL("INC")

         atualiza_SAIDA_PLANTEL()

         exit

      endif

    enddo
 
enddo

return .t.

**********************
function busca4_BRINCO
**********************

if lastkey() == 27
   return .t.
endif

if empty(WBRINCO)
   help_BRINCO()
   return .f.
endif

select PLANTEL
ordsetfocus("SINC001")
seek WBRINCO

if ! found()
   mensagem("AVISO!;N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado no plantel.")
   return .f.
endif

return .t.

*******************************
function atualiza_SAIDA_PLANTEL
*******************************
LOCAL WAREA := alias()

select PLANTEL
ordsetfocus("SINC001")
seek WBRINCO

if found()
   if reglock()
      replace MOTIVO with WMOTIVO,;
              SAIDA  with WDATA
      grava()
   else
      mensagem("AVISO!;Saida de plantel n"+chr(132)+"o efetuada. Refa"+chr(135)+"a o processo.")   
   endif
endif

select &WAREA

return .t.


**************************
function ALT_SAIDA_PLANTEL
**************************

do while .t.

   WSEQ = 0

   sc_SAIDA_PLANTEL()

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,13 get WSEQ picture "@Z 999999" 
   read_f()
   @ 03,13 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select SAIDA_P
   ordsetfocus("SINC001")
   seek WSEQ 

   if ! found()
      MENSAGEM("AVISO!;Sequ"+chr(136)+"ncia de saida de plantel n"+chr(132)+"o cadastrada!",0)
      loop
   endif

   WBRINCO = BRINCO 
   WDATA   = DATA
   WMOTIVO = MOTIVO 
   WNF     = NF
   WVALOR  = VALOR 
   WOBS1   = OBS1
   
   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,13 get WBRINCO  picture "99999999" valid busca4_BRINCO()
      @ 07,13 get WDATA
       
      @ 09,13,14,29 get WMOTIVO;   
      LISTBOX {"Venda          ", "Transferencia  ", "Morte          ", "Outros         "};
      DROPDOWN SCROLLBAR;
      COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
      MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar os motivos v"+chr(160)+"lidos."; 
      VALID ! empty(WMOTIVO)

      @ 11,13 get WNF      picture "999999999"
      @ 13,13 get WVALOR   picture "@R@E 999,999.99"
      @ 15,13 get WOBS1   
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select SAIDA_P
         save_SAIDA_PLANTEL("ALT")
         atualiza_SAIDA_PLANTEL()
         exit
      endif

    enddo
 
enddo

return .t.

**************************
function CON_SAIDA_PLANTEL
**************************
LOCAL WCOR := setcolor()
LOCAL WOPC 

do while .t.
   
   WOPC = 6

   sc_SAIDA_PLANTEL()
     
   SOMBRA(08,14,17,67,8)

   setcolor(COR_CONS)
   @ 07,12 clear to 16,66
   @ 07,12 to 16,66 

   @ 08,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 09,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 10,14 say "Consulta a partir da sequ"+chr(136)+"ncia de controle......[3]"
   @ 11,14 say "Consulta a partir do n"+chr(163)+"mero do brinco...........[4]"
   @ 12,14 say "Consulta a partir da data de saida do plantel...[5]"
   @ 13,14 say "Retorno ao menu principal.......................[6]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 15,63 get WOPC picture "9" range 1,6
   read_f()

   if WOPC == 6 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_SAIDA_PLANTEL()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select SAIDA_P
      ordsetfocus("SINC001")
      go top 

   elseif WOPC == 2
      select SAIDA_P
      ordsetfocus("SINC001")
      go bottom

      if eof()
         skip -1
      endif 

   elseif WOPC == 3

      do while .t.

         WSEQ = 0
  
         @ 03,13 get WSEQ picture "@Z 999999"
         read_f()
 
         if empty(WSEQ) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select SAIDA_P
         ordsetfocus("SINC001")
         seek WSEQ 

         if ! found()
            MENSAGEM("AVISO!;Sequ"+chr(136)+"ncia de controle n"+chr(132)+"o cadastrada!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC == 4

      do while .t.

         WBRINCO = space(08)

         @ 05,13 get WBRINCO picture "99999999" valid busca3_BRINCO()                      
         read_f()           
  
         if empty(WBRINCO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select SAIDA_P
         ordsetfocus("SINC002")
         seek WBRINCO
          
         if ! found()
            MENSAGEM("AVISO!;N"+chr(132)+"o houve saida de plantel para o brinco informado!",0)
            loop
         endif

      exit 
      enddo

   elseif WOPC == 5
 
      do while .t.

         WDATA = DATE()
         
         @ 07,13 get WDATA
         read_f()           
  
         if empty(WDATA) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select SAIDA_P
         ordsetfocus("SINC003")
         seek WDATA  
          
         if eof()
            skip -1
         endif 

      exit 
      enddo

   endif

   if WTRAVA
      loop
   endif

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo   PgUp-Anterior   ESC-FIM")

      @ 03,13 say strzero(SEQ,6)
      @ 05,13 say BRINCO  picture "99999999" 
      @ 07,13 say DATA
      @ 09,13 say MOTIVO 
      @ 11,13 say NF      picture "999999999"
      @ 13,13 say VALOR   picture "@R@E 999,999.99"
      @ 15,13 say OBS1   
     
      inkey(0)

      if lastkey() == 03
         skip +1
         if eof()
            skip -1
         endif
      elseif lastkey() == 18
         skip -1
      elseif lastkey() == 27
         exit
      endif

   enddo

enddo

return .t.


**************************
function EXC_SAIDA_PLANTEL
**************************

do while .t.

   sc_SAIDA_PLANTEL()

   WSEQ = 0
  
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,13 get WSEQ picture "@Z 999999" 
   read_f()
   @ 03,13 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select SAIDA_P
   ordsetfocus("SINC001")
   seek WSEQ 

   if ! found()
      MENSAGEM("AVISO!;Sequ"+chr(136)+"ncia de saida de plantel n"+chr(132)+"o cadastrada!",0)
      loop
   endif

   WBRINCO = BRINCO 
   WDATA   = DATA
   WMOTIVO = MOTIVO 
   WOBS1   = OBS1

   select PLANTEL
   ordsetfocus("SINC001")
   seek WBRINCO

   if ! found()   
      mensagem("AVISO!;O brinco dessa saida de plantel n"+chr(132)+"o foi encontrado no plantel.")
   endif

   select SAIDA_P

   @ 03,13 say strzero(SEQ,6)
   @ 05,13 say BRINCO  picture "99999999" 
   @ 07,13 say DATA
   @ 11,13 say NF      picture "999999999"
   @ 13,13 say VALOR   picture "@R@E 999,999.99"
   @ 15,13 say OBS1   
  
   if CONFIRMA(24,"Excluir essa saida de plantel...(S/N)?","N") = "S"
 
      select SAIDA_P
 
      if ! reglock()
         loop
      endif
       
      replace SEQ      with 0,;
              DATA     with ctod(space(08)),;
              BRINCO   with space(08),;
              MOTIVO   with space(15),;
              NF       with space(09),;
              VALOR    with 0,;
              OBS1     with space(60),;
              USER_INC with space(20),;
              DATE_INC with ctod(space(08)),;
              TIME_INC with space(08),;
              USER_ALT with space(20),;
              DATE_ALT with ctod(space(08)),;
              TIME_ALT with space(08)
      delete
      grava()

   endif 

enddo

return .t.

***********************************
function save_SAIDA_PLANTEL(MODULO)
***********************************

if ! reglock()
   return .t.
endif

replace SEQ    with WSEQ,;
        DATA   with WDATA,;
        BRINCO with WBRINCO,;
        MOTIVO with WMOTIVO,;
        NF     with WNF,;
        VALOR  with WVALOR,;
        OBS1   with WOBS1
        
if MODULO == "INC" 
   replace USER_INC with WPUSUARIO,;
           DATE_INC with DATE(),;
           TIME_INC with TIME()

elseif MODULO == "ALT"
   replace USER_ALT with WPUSUARIO,;
           DATE_ALT with DATE(),;
           TIME_ALT with TIME()
endif  

grava()

return .t.
