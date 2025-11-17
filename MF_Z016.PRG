*********************************************************************
****  Sistema......: SINCON-Sistema Integrado de Controle        ****
****  Programa.....: MF_Z014.PRG                                 ****
****  Finalidade...: Cadastros de Vacinação do Plantel           ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************
#include "TBrowse.ch"
#include "inkey.ch"

*********************
function sc_VACINACAO
*********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "Sequ"+chr(136)+"ncia.:"
@ 05,01 say "Brinco....:"
@ 07,01 say "Data......:"
@ 09,01 say "Vacina....:    -"
@ 11,01 say "Pr"+chr(162)+"xima...:"
@ 13,01 say "Observa"+chr(135)+chr(132)+"o:"

return .t.

**********************
function INC_VACINACAO
**********************

do while .t.

   sc_VACINACAO()
   
   select VACINA_P
   ordsetfocus("SINC001")
   go bottom

   WSEQ = SEQ + 1

   setcolor(COR_TEXT)
   @ 03,13 say strzero(WSEQ,6)

   WBRINCO  = space(08) 
   WDATA    = ctod(space(08))
   WVACINA  = 0
   WPROXIMA = ctod(space(08))
   WOBS1    = space(60)

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,13 get WBRINCO    picture "99999999" valid busca5_BRINCO()
      @ 07,13 get WDATA
      @ 09,13 get WVACINA    picture "@Z 999"   valid busca5_VACINA()
      @ 13,13 get WOBS1   
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
 
         select VACINA_P
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

         save_VACINACAO("INC")

         exit

      endif

    enddo
 
enddo

return .t.

**********************
function busca5_BRINCO
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

**********************
function busca5_VACINA
**********************

if lastkey() == 27
   return .t.
endif

if empty(WVACINA)
   help_VACINA()
   return .f.
endif

select VACINA
ordsetfocus("SINC001")
seek WVACINA 

if ! found()
   mensagem("AVISO!;C"+chr(162)+"digo de vacina n"+chr(132)+"o cadastrada.")
   return .f.
endif

@ 09,17 say NOME 

WPROXIMA = WDATA + FREQUENC
@ 11,13 say WPROXIMA

return .t.


**********************
function ALT_VACINACAO
**********************

do while .t.

   WSEQ = 0

   sc_VACINACAO()

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,13 get WSEQ picture "@Z 999999" 
   read_f()
   @ 03,13 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select VACINA_P
   ordsetfocus("SINC001")
   seek WSEQ 

   if ! found()
      MENSAGEM("AVISO!;Sequ"+chr(136)+"ncia de vacina"+chr(135)+chr(132)+"o n"+chr(132)+"o cadastrada!",0)
      loop
   endif

   WBRINCO  = BRINCO 
   WDATA    = DATA
   WVACINA  = VACINA
   WPROXIMA = PROXIMA  
   WOBS1    = OBS1
   
   select VACINA  
   ordsetfocus("SINC001")
   seek WVACINA 

   if found()
      @ 09,17 say NOME 
   endif

   @ 11,13 say WPROXIMA

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
       
      @ 05,13 get WBRINCO    picture "99999999" valid busca5_BRINCO()
      @ 07,13 get WDATA
      @ 09,13 get WVACINA    picture "@Z 999"   valid busca5_VACINA()
      @ 13,13 get WOBS1   
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select VACINA_P
         save_VACINACAO("ALT")
         exit
      endif

    enddo
 
enddo

return .t.

**********************
function CON_VACINACAO
**********************
LOCAL WCOR := setcolor()
LOCAL WOPC 

do while .t.
   
   WOPC = 6

   sc_VACINACAO()
     
   SOMBRA(08,14,17,67,8)

   setcolor(COR_CONS)
   @ 07,12 clear to 16,66
   @ 07,12 to 16,66 

   @ 08,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 09,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 10,14 say "Consulta a partir da sequ"+chr(136)+"ncia de controle......[3]"
   @ 11,14 say "Consulta a partir do n"+chr(163)+"mero do brinco...........[4]"
   @ 12,14 say "Consulta a partir da data de vacina"+chr(135)+chr(132)+"o..........[5]"
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

   sc_VACINACAO()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select VACINA_P
      ordsetfocus("SINC001")
      go top 

   elseif WOPC == 2   
      select VACINA_P
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
   
         select VACINA_P
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

         select VACINA_P
         ordsetfocus("SINC002")
         seek WBRINCO
          
         if ! found()
            MENSAGEM("AVISO!;N"+chr(132)+"o houve vacina"+chr(135)+chr(132)+"o para o brinco informado!",0)
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

         select VACINA_P
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
      @ 05,13 say BRINCO picture "99999999" 
      @ 07,13 say DATA
      @ 09,13 say VACINA picture "999" 
      @ 11,13 say PROXIMA
      @ 13,13 say OBS1   
     
      WVACINA = VACINA 

      select VACINA  
      ordsetfocus("SINC001")
      seek WVACINA 

      if found()
         @ 09,17 say NOME 
      else
         @ 09,17 say space(30)
         @ 09,17 say "NAO CADASTRADA"
      endif

      select VACINA_P

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


**********************
function EXC_VACINACAO
**********************

do while .t.

   sc_VACINACAO()

   WSEQ = 0
  
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,13 get WSEQ picture "@Z 999999" 
   read_f()
   @ 03,13 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select VACINA_P
   ordsetfocus("SINC001")
   seek WSEQ 

   if ! found()
      MENSAGEM("AVISO!;Sequ"+chr(136)+"ncia de controle n"+chr(132)+"o cadastrada!",0)
      loop
   endif

   @ 03,13 say strzero(SEQ,6)
   @ 05,13 say BRINCO picture "99999999" 
   @ 07,13 say DATA
   @ 09,13 say VACINA picture "999" 
   @ 11,13 say PROXIMA
   @ 13,13 say OBS1   
     
   WVACINA = VACINA 

   select VACINA  
   ordsetfocus("SINC001")
   seek WVACINA 

   if found()
      @ 09,17 say NOME 
   else
      @ 09,17 say space(30)
      @ 09,17 say "NAO CADASTRADA"
   endif

   select VACINA_P

   if CONFIRMA(24,"Excluir essa vacina"+chr(135)+chr(132)+"o...(S/N)?","N") = "S"
 
      select VACINA_P
 
      if ! reglock()
         loop
      endif
       
      replace SEQ       with 0,;
              DATA      with ctod(space(08)),;
              BRINCO    with space(08),;
              VACINA    with 0,;
              PROXIMA  with ctod(space(08)),;
              OBS1      with space(60),;
              USER_INC  with space(20),;
              DATE_INC  with ctod(space(08)),;
              TIME_INC  with space(08),;
              USER_ALT  with space(20),;
              DATE_ALT  with ctod(space(08)),;
              TIME_ALT  with space(08)
      delete
      grava()

   endif 

enddo

return .t.

*******************************
function save_VACINACAO(MODULO)
*******************************

if ! reglock()
   return .t.
endif

replace SEQ     with WSEQ,;
        DATA    with WDATA,;
        BRINCO  with WBRINCO,;
        VACINA  with WVACINA,;
        PROXIMA with WPROXIMA,;
        OBS1    with WOBS1
        
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
