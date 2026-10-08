*********************************************************************
****  Sistema......: SINCON-Sistema Integrado de Controle        ****
****  Programa.....: MF_Z013.PRG                                 ****
****  Finalidade...: Cadastros de Troca de Lotes                 ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************
#include "TBrowse.ch"
#include "inkey.ch"

**********************
function sc_TROCA_LOTE
**********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "Sequ"+chr(136)+"ncia....:"
@ 05,01 say "Data.........:"
@ 07,01 say "Brinco.......:"
@ 09,01 say "Lote Atual...:    -"
@ 11,01 say "Novo Lote....:    -"
@ 13,01 say "Observa"+chr(135)+chr(132)+"o...:"

return .t.

***********************
function INC_TROCA_LOTE
***********************

do while .t.

   sc_TROCA_LOTE()
   
   select TROCA_L
   ordsetfocus("SINC001")
   go bottom

   WSEQ = SEQ + 1

   setcolor(COR_TEXT)
   @ 03,16 say strzero(WSEQ,6)

   WDATA     = DATE()
   WBRINCO   = space(08) 
   WLOTE_ANT = 0
   WLOTE_NEW = 0
   WOBS1     = space(60)

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,16 say WDATA
      @ 07,16 get WBRINCO   picture "@!"       valid busca2_BRINCO()
      @ 11,16 get WLOTE_NEW picture "@Z 999"   valid busca2_LOTE()
      @ 13,16 get WOBS1   
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
 
         select TROCA_L
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

         save_TROCA_LOTE("INC")

         atualiza_TROCA_LOTE()

         exit

      endif

    enddo
 
enddo

return .t.


**********************
function busca2_BRINCO
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

WLOTE_ANT = LOTE
@ 09,16 say WLOTE_ANT picture "999"

select LOTE
ordsetfocus("SINC001")
seek WLOTE_ANT 

if found()
   @ 09,20 say NOME
else
   @ 09,20 say space(30)
   @ 09,20 say "LOTE NAO CADASTRADO"
endif

return .t.

********************
function busca2_LOTE 
********************

if lastkey() == 27
   return .t.
endif

if empty(WLOTE_NEW)
   help_LOTE()
   select LOTE 
   WLOTE_NEW = CODIGO
endif

select LOTE
ordsetfocus("SINC001")
seek WLOTE_NEW

if ! found()
   MENSAGEM("AVISO!;C"+chr(162)+"digo de lote n"+chr(132)+"o cadastrado!",0)
   return .f.
endif

@ 11,20 say NOME

return .t.


****************************
function atualiza_TROCA_LOTE
****************************
LOCAL WAREA := alias()

select PLANTEL
ordsetfocus("SINC001")
seek WBRINCO

if found()
   if reglock()
      replace LOTE with WLOTE_NEW
      grava()
   else
      mensagem("AVISO!;Troca de lote n"+chr(132)+"o efetuado. Refa"+chr(135)+"a o processo.")   
   endif
endif

select &WAREA

return .t.


***********************
function ALT_TROCA_LOTE
***********************

do while .t.

   WSEQ = 0

   sc_TROCA_LOTE()

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,16 get WSEQ picture "@Z 999999" 
   read_f()
   @ 03,16 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select TROCA_L
   ordsetfocus("SINC001")
   seek WSEQ 

   if ! found()
      MENSAGEM("AVISO!;Sequ"+chr(136)+"ncia de troca de lote n"+chr(132)+"o cadastrada!",0)
      loop
   endif

   WDATA     = DATA
   WBRINCO   = BRINCO 
   WLOTE_ANT = LOTE_ANT 
   WLOTE_NEW = LOTE_NEW
   WOBS1     = OBS1
   
   @ 09,16 say LOTE_ANT picture "999"  

   select PLANTEL
   ordsetfocus("SINC001")
   seek WBRINCO

   if ! found()   
      mensagem("AVISO!;O brinco dessa troca de lote n"+chr(132)+"o foi encontrado no plantel.")
      loop
   endif

   if LOTE <> 0
      if LOTE <> WLOTE_NEW
         mensagem("AVISO!;O lote dessa troca n"+chr(132)+"o corresponde ao encontrado no brinco.")
         loop
      endif           
   endif

   select LOTE
   ordsetfocus("SINC001")
   seek WLOTE_ANT 

   if found()   
      @ 09,20 say NOME
   else
      @ 09,20 say space(30)
      @ 09,20 say "LOTE NAO CADASTRADO"
   endif

   seek WLOTE_NEW

   if found()   
      @ 11,20 say NOME
   else
      @ 11,20 say space(30)
      @ 11,20 say "LOTE NAO CADASTRADO"
   endif

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,16 say WDATA
      @ 07,16 get WBRINCO   picture "@!"       valid busca2_BRINCO()
      @ 11,16 get WLOTE_NEW picture "@Z 999"   valid busca2_LOTE()
      @ 13,16 get WOBS1   
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select TROCA_L
         save_TROCA_LOTE("ALT")
         atualiza_TROCA_LOTE()
         exit
      endif

    enddo
 
enddo

return .t.

***********************
function CON_TROCA_LOTE
***********************
LOCAL WCOR := setcolor()
LOCAL WOPC 

do while .t.
   
   WOPC = 6

   sc_TROCA_LOTE()
     
   SOMBRA(08,14,17,67,8)

   setcolor(COR_CONS)
   @ 07,12 clear to 16,66
   @ 07,12 to 16,66 

   @ 08,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 09,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 10,14 say "Consulta a partir da sequ"+chr(136)+"ncia de controle......[3]"
   @ 11,14 say "Consulta a partir do n"+chr(163)+"mero do brinco...........[4]"
   @ 12,14 say "Consulta a partir da data de troca do lote......[5]"
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

   sc_TROCA_LOTE()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select TROCA_L
      ordsetfocus("SINC001")
      go top 
 
   elseif WOPC == 2   
      select TROCA_L
      ordsetfocus("SINC001")
      go bottom

      if eof()
         skip -1
      endif  

   elseif WOPC == 3   

      do while .t.

         WSEQ = 0
  
         @ 03,16 get WSEQ picture "@Z 999999"
         read_f()
 
         if empty(WSEQ) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select TROCA_L
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

         @ 07,16 get WBRINCO picture "@!" valid busca2_BRINCO()                      
         read_f()           
  
         if empty(WBRINCO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select TROCA_L
         ordsetfocus("SINC002")
         seek WBRINCO
          
         if ! found()
            MENSAGEM("AVISO!;N"+chr(132)+"o houve troca de lote para o brinco informado!",0)
            loop
         endif

      exit 
      enddo

   elseif WOPC == 5
 
      do while .t.

         WDATA = DATE()
         
         @ 05,16 get WDATA
         read_f()           
  
         if empty(WDATA) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select TROCA_L
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

      @ 03,16 say strzero(SEQ,6)
      @ 05,16 say DATA
      @ 07,16 say BRINCO   picture "@!" 
      @ 09,16 say LOTE_ANT picture "999"   
      @ 11,16 say LOTE_NEW picture "999"   
      @ 13,16 say OBS1   
     
      WLOTE_ANT = LOTE_ANT
      WLOTE_NEW = LOTE_NEW
      
      select LOTE
      ordsetfocus("SINC001")
      seek WLOTE_ANT 

      if found()   
         @ 09,20 say NOME
      else
         @ 09,20 say space(30)
         @ 09,20 say "LOTE NAO CADASTRADO"
      endif

      seek WLOTE_NEW

      if found()   
         @ 11,20 say NOME
      else
         @ 11,20 say space(30)
         @ 11,20 say "LOTE NAO CADASTRADO"
      endif

      select TROCA_L

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


***********************
function EXC_TROCA_LOTE
***********************

do while .t.

   sc_TROCA_LOTE()

   WSEQ = 0
  
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,16 get WSEQ picture "@Z 999999" 
   read_f()
   @ 03,16 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select TROCA_L
   ordsetfocus("SINC001")
   seek WSEQ 

   if ! found()
      MENSAGEM("AVISO!;Sequ"+chr(136)+"ncia de troca de lote n"+chr(132)+"o cadastrada!",0)
      loop
   endif

   WDATA     = DATA
   WBRINCO   = BRINCO 
   WLOTE_ANT = LOTE_ANT 
   WLOTE_NEW = LOTE_NEW
   WOBS1     = OBS1

   select PLANTEL
   ordsetfocus("SINC001")
   seek WBRINCO

   if ! found()   
      mensagem("AVISO!;O brinco dessa troca de lote n"+chr(132)+"o foi encontrado no plantel.")
   endif

   if LOTE <> 0
      if LOTE <> WLOTE_NEW
         mensagem("AVISO!;O lote dessa troca n"+chr(132)+"o corresponde ao encontrado no brinco.")
      endif           
   endif
   
   select TROCA_L

   @ 03,16 say strzero(WSEQ,6)
   @ 05,16 say DATA
   @ 07,16 say BRINCO   picture "@!" 
   @ 09,16 say LOTE_ANT picture "999"   
   @ 11,16 say LOTE_NEW picture "999"   
   @ 13,16 say OBS1   
   
   WLOTE_ANT = LOTE_ANT
   WLOTE_NEW = LOTE_NEW
   
   select LOTE
   ordsetfocus("SINC001")
   seek WLOTE_ANT 

   if found()   
      @ 09,20 say NOME
   else
      @ 09,20 say space(30)
      @ 09,20 say "LOTE NAO CADASTRADO"
   endif

   seek WLOTE_NEW

   if found()   
      @ 11,20 say NOME
   else
      @ 11,20 say space(30)
      @ 11,20 say "LOTE NAO CADASTRADO"
   endif

   if CONFIRMA(24,"Excluir essa troca de lote...(S/N)?","N") = "S"
 
      select TROCA_L
 
      if ! reglock()
         loop
      endif
       
      replace SEQ      with 0,;
              BRINCO   with space(08),;
              DATA     with ctod(space(08)),;
              LOTE_ANT with 0,;
              LOTE_NEW with 0,;
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

********************************
function save_TROCA_LOTE(MODULO)
********************************

if ! reglock()
   return .t.
endif

replace SEQ      with WSEQ,;
        BRINCO   with WBRINCO,;
        DATA     with WDATA,;
        LOTE_ANT with WLOTE_ANT,;
        LOTE_NEW with WLOTE_NEW,;
        OBS1     with WOBS1
        
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
