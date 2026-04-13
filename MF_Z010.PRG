*********************************************************************
****  Sistema......: MF-Minha Fazenda                            ****
****  Programa.....: MF_Z010.PRG                                 ****
****  Finalidade...: Cadastros Diversos                          ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************
#include "TBrowse.ch"
#include "inkey.ch"

*****************
function sc_PASTO
*****************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "C"+chr(162)+"digo.......:"
@ 05,01 say "Pasto/Piquete:"

return .t.

******************
function INC_PASTO
******************

do while .t.

   sc_PASTO()
   
   select PASTO
   ordsetfocus("SINC001")
   go bottom

   WCODIGO = CODIGO + 1

   setcolor(COR_TEXT)
   @ 03,16 say strzero(WCODIGO,3)

   WNOME = space(30)
   
   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,16 get WNOME valid ! empty(WNOME)
      read_f()

      if empty(WNOME) .or. lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
 
         select PASTO
         ordsetfocus("SINC001")
         go bottom

         WCODIGO = CODIGO + 1
 
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

         replace CODIGO with WCODIGO
         grava()

         save_PASTO()

         exit

      endif

    enddo
 
enddo

return .t.

******************
function ALT_PASTO
******************

do while .t.

   WCODIGO = 0

   sc_PASTO()

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,16 get WCODIGO picture "@Z 999" 
   read_f()

   if empty(WCODIGO) .or. lastkey() = 27
      return .t.
   endif

   select PASTO
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de pasto/piquete n"+chr(132)+"o cadastrado!",0)
      loop
   endif

   WNOME = NOME    

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,16 get WNOME valid ! empty(WNOME)
      read_f()

      if empty(WNOME) .or. lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select PASTO
         save_PASTO()
         exit
      endif

    enddo
 
enddo

return .t.

******************
function CON_PASTO
******************
LOCAL WCOR := setcolor()
LOCAL WOPC := 5

do while .t.

   sc_PASTO()
     
   SOMBRA(09,14,17,67,8)

   setcolor(COR_CONS)
   @ 08,12 clear to 16,66
   @ 08,12 to 16,66 

   @ 09,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 10,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 11,14 say "Consulta a partir do c"+chr(162)+"digo do pasto............[3]"
   @ 12,14 say "Consulta a partir do nome do pasto/piquete......[4]"
   @ 13,14 say "Retorno ao menu principal.......................[5]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 15,63 get WOPC picture "9" range 1,5
   read_f()

   if WOPC == 5 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_PASTO()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select PASTO
      ordsetfocus("SINC001")
      go top
   elseif WOPC == 2   
      select PASTO
      ordsetfocus("SINC001")
      go bottom

      if eof()
         skip -1 
      endif 

   elseif WOPC == 3   

      do while .t.

         WCODIGO = 0
  
         @ 03,16 get WCODIGO picture "@Z 999"
         read_f()
 
         if empty(WCODIGO) .or. lastkey() = 27
            WTRAVA = .t.
            exit
         endif
   
         select PASTO
         ordsetfocus("SINC001")
         seek WCODIGO

         if ! found()
            MENSAGEM("AVISO!;C"+chr(162)+"digo de pasto n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC = 4

      WNOME = space(30)

      @ 05,16 get WNOME                           
      read_f()           

      if ! empty(WNOME) .or. lastkey() <> 27

         select PASTO
         ordsetfocus("SINC002")
         seek upper(WNOME)
        
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   do while .t.

      setcolor(COR_TEXT)
      @ 07,00 clear to 22,79
      @ 24,00 clear to 24,79
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo   PgUp-Anterior   T-Total de Animais   ESC-FIM")

      @ 03,16 say strzero(CODIGO,3)
      @ 05,16 say NOME   

      inkey(0)

      if lastkey() = 03
         skip +1
         if eof()
            skip -1
         endif
      elseif lastkey() = 18
         skip -1
      elseif lastkey() = 27
         exit
      elseif lastkey() == 84 .or. lastkey() == 116 // Tt
         totalDeAnimaisNoPasto(CODIGO)             // MF_Z022.PRG
      endif

   enddo

enddo

return .t.

******************
function EXC_PASTO
******************

do while .t.

   sc_PASTO()

   WCODIGO = 0
  
   @ 03,16 get WCODIGO picture "@Z 999"
   read_f()
 
   if empty(WCODIGO) .or. lastkey() = 27
      return .t.
   endif
   
   select PASTO
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de pasto/piquete n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   @ 03,16 say strzero(CODIGO,3)
   @ 05,16 say NOME   
   
   if CONFIRMA(24,"Excluir esse pasto/piquete...(S/N)?","N") = "S"
 
      select PASTO
 
      if ! reglock()
         loop
      endif
       
      replace CODIGO with 0,;
              NOME   with space(30)
             
      delete
      grava()

   endif 

enddo

return .t.

*******************
function save_PASTO
*******************

if ! reglock()
   return .t.
endif

replace NOME with WNOME
   
grava()

return .t.

****************
function sc_LOTE
****************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "C"+chr(162)+"digo......:"
@ 05,01 say "Lote........:"

return .t.

*****************
function INC_LOTE
*****************

do while .t.

   sc_LOTE()
   
   select LOTE
   ordsetfocus("SINC001")
   go bottom

   WCODIGO = CODIGO + 1

   setcolor(COR_TEXT)
   @ 03,15 say strzero(WCODIGO,3)

   WNOME = space(30)
   
   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,15 get WNOME valid ! empty(WNOME)
      read_f()

      if empty(WNOME) .or. lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
 
         select LOTE
         ordsetfocus("SINC001")
         go bottom

         WCODIGO = CODIGO + 1
 
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

         replace CODIGO with WCODIGO
         grava()

         save_LOTE()

         exit

      endif

    enddo
 
enddo

return .t.

*****************
function ALT_LOTE
*****************

do while .t.

   WCODIGO = 0

   sc_LOTE()

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,15 get WCODIGO picture "@Z 999" 
   read_f()

   if empty(WCODIGO) .or. lastkey() = 27
      return .t.
   endif

   select LOTE
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de lote n"+chr(132)+"o cadastrado!",0)
      loop
   endif

   WNOME = NOME    

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,15 get WNOME valid ! empty(WNOME)
      read_f()

      if empty(WNOME) .or. lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select LOTE
         save_LOTE()
         exit
      endif

    enddo
 
enddo

return .t.

*****************
function CON_LOTE
*****************
LOCAL WCOR := setcolor()
LOCAL WOPC := 3

do while .t.

   sc_LOTE()
     
   SOMBRA(09,14,17,67,8)

   setcolor(COR_CONS)
   @ 08,12 clear to 16,66
   @ 08,12 to 16,66 

   @ 09,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 10,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 11,14 say "Consulta a partir do c"+chr(162)+"digo do pasto............[3]"
   @ 12,14 say "Consulta a partir do nome do pasto..............[4]"
   @ 13,14 say "Retorno ao menu principal.......................[5]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 15,63 get WOPC picture "9" range 1,5
   read_f()

   if WOPC == 5 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_LOTE()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC = 1
      select LOTE
      ordsetfocus("SINC001")
      go top 

   elseif WOPC == 2
      select LOTE
      ordsetfocus("SINC001")
      go bottom 

      if eof()
         skip -1 
         loop
      endif 

   elseif WOPC == 3
      do while .t.

         WCODIGO = 0
  
         @ 03,15 get WCODIGO picture "@Z 999"
         read_f()
 
         if empty(WCODIGO) .or. lastkey() = 27
            WTRAVA = .t.
            exit
         endif
   
         select LOTE
         ordsetfocus("SINC001")
         seek WCODIGO

         if ! found()
            MENSAGEM("AVISO!;C"+chr(162)+"digo de lote n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC = 4

      WNOME = space(30)

      @ 05,15 get WNOME                           
      read_f()           

      if ! empty(WNOME) .or. lastkey() <> 27

         select LOTE
         ordsetfocus("SINC002")
         seek upper(WNOME)
        
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   do while .t.

      setcolor(COR_TEXT)
      @ 07,00 clear to 22,79
      @ 24,00 clear to 24,79
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo   PgUp-Anterior   T-Total de Animais   ESC-FIM")

      select LOTE

      @ 03,15 say strzero(CODIGO,3)
      @ 05,15 say NOME   

      inkey(0)

      if lastkey() = 03
         skip +1
         if eof()
            skip -1
         endif
      elseif lastkey() = 18
         skip -1
      elseif lastkey() = 27
         exit
      elseif lastkey() == 84 .or. lastkey() == 116 // Tt
         totalDeAnimaisNoLote(CODIGO)              // MF_Z022.PRG
      endif

   enddo

enddo

return .t.

*****************
function EXC_LOTE
*****************

do while .t.

   sc_LOTE()

   WCODIGO = 0
  
   @ 03,15 get WCODIGO picture "@Z 999"
   read_f()
 
   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif
   
   select LOTE
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de lote n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   @ 03,15 say strzero(CODIGO,3)
   @ 05,15 say NOME   

   if CONFIRMA(24,"Excluir esse lote...(S/N)?","N") = "S"
 
      select LOTE
 
      if ! reglock()
         loop
      endif
       
      replace CODIGO with 0,;
              NOME   with space(30)
             
      delete
      grava()

   endif 

enddo

return .t.

******************
function save_LOTE
******************

if ! reglock()
   return .t.
endif

replace NOME with WNOME
 
grava()
       
return .t.

****************
function sc_RACA
****************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "C"+chr(162)+"digo......:"
@ 05,01 say "Ra"+chr(135)+"a........:"

return .t.

*****************
function INC_RACA
*****************

do while .t.

   sc_RACA()
   
   select RACA
   ordsetfocus("SINC001")
   go bottom

   WCODIGO = CODIGO + 1

   setcolor(COR_TEXT)
   @ 03,15 say strzero(WCODIGO,3)

   WNOME = space(30)
   
   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,15 get WNOME valid ! empty(WNOME)
      read_f()

      if empty(WNOME) .or. lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
 
         select RACA 
         ordsetfocus("SINC001")
         go bottom

         WCODIGO = CODIGO + 1
 
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

         replace CODIGO with WCODIGO
         grava()

         save_RACA()

         exit

      endif

    enddo
 
enddo

return .t.

*****************
function ALT_RACA
*****************

do while .t.

   WCODIGO = 0

   sc_RACA()

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,15 get WCODIGO picture "@Z 999" 
   read_f()

   if empty(WCODIGO) .or. lastkey() = 27
      return .t.
   endif

   select RACA
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de ra"+chr(135)+"a n"+chr(132)+"o cadastrado!",0)
      loop
   endif

   WNOME = NOME    

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,15 get WNOME valid ! empty(WNOME)
      read_f()

      if empty(WNOME) .or. lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select RACA
         save_RACA()
         exit
      endif

    enddo
 
enddo

return .t.

*****************
function CON_RACA
*****************
LOCAL WCOR := setcolor()
LOCAL WOPC := 3

do while .t.

   sc_RACA()
     
   SOMBRA(09,14,17,67,8)

   setcolor(COR_CONS)
   @ 08,12 clear to 16,66
   @ 08,12 to 16,66 

   @ 09,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 10,14 say "Consulta a partir do finao do arquivo...........[2]"
   @ 11,14 say "Consulta a partir do c"+chr(162)+"digo do pasto............[3]"
   @ 12,14 say "Consulta a partir do nome do pasto..............[4]"
   @ 13,14 say "Retorno ao menu principal.......................[5]"

   setcolor("W/N,W/N,,,W/N")
   @ 14,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 14,63 get WOPC picture "9" range 1,5
   read_f()

   if WOPC == 5 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_RACA()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select RACA
      ordsetfocus("SINC001")
      go top

   elseif WOPC == 2   
      select RACA
      ordsetfocus("SINC001")
      go bottom

      if eof() 
         skip -1
         loop
      endif 

   elseif WOPC == 3   

      do while .t.

         WCODIGO = 0
  
         @ 03,15 get WCODIGO picture "@Z 999"
         read_f()
 
         if empty(WCODIGO) .or. lastkey() = 27
            WTRAVA = .t.
            exit
         endif
   
         select RACA
         ordsetfocus("SINC001")
         seek WCODIGO

         if ! found()
            MENSAGEM("AVISO!;C"+chr(162)+"digo de ra"+chr(135)+"a n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC == 4

      WNOME = space(30)

      @ 05,15 get WNOME                           
      read_f()           

      if ! empty(WNOME) .or. lastkey() <> 27

         select RACA 
         ordsetfocus("SINC002")
         seek upper(WNOME)
        
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   do while .t.

      setcolor(COR_TEXT)
      @ 07,00 clear to 22,79
      @ 24,00 clear to 24,79
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo   PgUp-Anterior   T-Total de Animais   ESC-FIM")

      @ 03,15 say strzero(CODIGO,3)
      @ 05,15 say NOME   

      inkey(0)

      if lastkey() = 03
         skip +1
         if eof()
            skip -1
         endif
      elseif lastkey() = 18
         skip -1
      elseif lastkey() = 27
         exit
      elseif lastkey() == 84 .or. lastkey() == 116 // Tt
         totalDeAnimaisPorRaca(CODIGO)   
      endif

   enddo

enddo

return .t.

*****************
function EXC_RACA
*****************

do while .t.

   sc_RACA()

   WCODIGO = 0
  
   @ 03,15 get WCODIGO picture "@Z 999"
   read_f()
 
   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif
   
   select RACA
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de ra"+chr(135)+"a n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   @ 03,15 say strzero(CODIGO,3)
   @ 05,15 say NOME   

   if CONFIRMA(24,"Excluir essa ra"+chr(135)+"a...(S/N)?","N") = "S"
 
      select RACA
 
      if ! reglock()
         loop
      endif
       
      replace CODIGO with 0,;
              NOME   with space(30)
             
      delete
      grava()

   endif 

enddo

return .t.

******************
function save_RACA 
******************

if ! reglock()
   return .t.
endif

replace NOME with WNOME

grava()
       
return .t.

******************
function SC_VACINA
******************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "C"+chr(162)+"digo....:"
@ 05,01 say "Vacina....:" 
@ 07,01 say "Frequ"+chr(136)+"ncia:"

return .t.

*******************
function INC_VACINA
*******************

do while .t. 
   
   sc_VACINA()

   WCODIGO   = 0
   WNOME     = space(30)
   WFREQUENC = 0

   select VACINA
   ordsetfocus('SINC001')
   go bottom

   WCODIGO = CODIGO + 1

   @ 03,13 say strzero(WCODIGO,3)
   
   do while .t. 

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,13 get WNOME     valid ! empty(WNOME)     
      @ 07,13 get WFREQUENC picture "@R@E 9999 dias" 
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"

         select VACINA
         ordsetfocus('SINC001')
         go bottom

         WCODIGO = CODIGO + 1

         @ 03,13 say strzero(WCODIGO,3)
         
         set deleted off
         go top
         if deleted()
            if ! reglock()
               loop
            endif
            recall
         else
            if ! inc_REG()
               loop
            endif
         endif
         set deleted on

         save_VACINA()

         exit 
      endif

    enddo

enddo

return .t.

*******************
function ALT_VACINA
*******************

do while .t. 

   sc_VACINA()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,13 get WCODIGO picture "@Z 999" 
   read_f()
   @ 03,13 say strzero(WCODIGO,3)

   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif

   select VACINA
   ordsetfocus('SINC001')
   seek WCODIGO

   if ! found()
       MENSAGEM("AVISO!;C"+chr(162)+"digo de vacina n"+chr(132)+"o cadastrado!",0)
       loop
   endif

   WNOME     = NOME     
   WFREQUENC = FREQUENC

   do while .t.

      @ 05,13 get WNOME 
      @ 07,13 get WFREQUENC picture "@R@E 9999 dias" 
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"
         save_VACINA()
         exit
      endif

   enddo

enddo

return .t.

*******************
function CON_VACINA
*******************
LOCAL WCOR := setcolor()
LOCAL WOPC := 3

do while .t.

   sc_VACINA()
     
   SOMBRA(09,14,17,67,8)

   setcolor(COR_CONS)
   @ 08,12 clear to 16,66
   @ 08,12 to 16,66 

   @ 09,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 10,14 say "Consulta a partir do finao do arquivo...........[2]"
   @ 11,14 say "Consulta a partir do c"+chr(162)+"digo da vacina...........[3]"
   @ 12,14 say "Consulta a partir do nome da vacina.............[4]"
   @ 13,14 say "Retorno ao menu principal.......................[5]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 15,63 get WOPC picture "9" range 1,5
   read_f()

   if WOPC == 5 .or. lastkey() = 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_VACINA()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select VACINA 
      ordsetfocus("SINC001")
      go top

   elseif WOPC == 2      
      select VACINA 
      ordsetfocus("SINC001")
      go bottom

      if eof()
         skip -1
      endif 

   elseif WOPC == 3      

      do while .t.

         WCODIGO = 0
  
         @ 03,13 get WCODIGO picture "@Z 999"
         read_f()
 
         if empty(WCODIGO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select VACINA 
         ordsetfocus("SINC001")
         seek WCODIGO

         if ! found()
            MENSAGEM("AVISO!;C"+chr(162)+"digo de vacina n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC == 4

      WNOME = space(30)

      @ 05,13 get WNOME                           
      read_f()           

      if ! empty(WNOME) .or. lastkey() <> 27

         select VACINA 
         ordsetfocus("SINC002")
         seek upper(WNOME)
        
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   sc_VACINA()    

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo    PgUp-Anterior    ESC-FIM")

      @ 03,13 say strzero(CODIGO,3)
      @ 05,13 say NOME   
      @ 07,13 say FREQUENC picture "@R@E 9999 dias" 

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

*******************
function EXC_VACINA
*******************

do while .t.

   sc_VACINA()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,13 get WCODIGO picture "@Z 999"
   read_f()
 
   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif
   
   select VACINA
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de vacina n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   setcolor(COR_TEXT)

   @ 03,13 say strzero(CODIGO,3)
   @ 05,13 say NOME   
   @ 07,13 say FREQUENC picture "@R@E 9999 dias" 

   if CONFIRMA(24,"Excluir essa ra"+chr(135)+"a...(S/N)?","N") = "S"
 
      select VACINA
 
      if ! reglock()
         loop
      endif
       
      replace CODIGO   with 0,;
              NOME     with space(30),;
              FREQUENC with 0
      delete
      grava()

   endif 

enddo

return .t.

********************
function SAVE_VACINA
********************

if ! reglock()
   return .f.
endif
   
replace CODIGO   with WCODIGO,;    
        NOME     with WNOME,;
        FREQUENC with WFREQUENC 
  
grava()

return .t.

*******************
function SC_SINTOMA
*******************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "C"+chr(162)+"digo...:"
@ 05,01 say "Sintoma/Doen"+chr(135)+"a:" 

return .t.

********************
function INC_SINTOMA
********************

do while .t. 
   
   sc_SINTOMA()

   WCODIGO = 0
   WNOME   = space(30)
  
   select SINTOMA
   ordsetfocus('SINC001')
   go bottom

   WCODIGO = CODIGO + 1

   @ 03,17 say strzero(WCODIGO,3)
   
   do while .t. 

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,17 get WNOME valid ! empty(WNOME)     
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"

         select SINTOMA
         ordsetfocus('SINC001')
         go bottom

         WCODIGO = CODIGO + 1

         @ 03,12 say strzero(WCODIGO,3)
         
         set deleted off
         go top
         if deleted()
            if ! reglock()
               loop
            endif
            recall
         else
            if ! inc_REG()
               loop
            endif
         endif
         set deleted on

         save_SINTOMA()

         exit 
      endif

    enddo

enddo

return .t.

********************
function ALT_SINTOMA
********************

do while .t. 

   sc_SINTOMA()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,17 get WCODIGO picture "@Z 999" 
   read_f()
   @ 03,17 say strzero(WCODIGO,3)

   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif

   select SINTOMA
   ordsetfocus('SINC001')
   seek WCODIGO

   if ! found()
       MENSAGEM("AVISO!;C"+chr(162)+"digo de sintoma/doen"+chr(135)+"a n"+chr(132)+"o cadastrado!",0)
       loop
   endif

   WNOME = NOME     

   do while .t.

      @ 05,17 get WNOME 
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"
         save_SINTOMA()
         exit
      endif

   enddo

enddo

return .t.

********************
function CON_SINTOMA
********************
LOCAL WCOR := setcolor()
LOCAL WOPC := 3

do while .t.

   sc_SINTOMA()
     
   SOMBRA(09,14,17,67,8)

   setcolor(COR_CONS)
   @ 08,12 clear to 16,66
   @ 08,12 to 16,66 

   @ 09,14 say "Consulta a partir do inicio do arquivo..........[1]"   
   @ 10,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 11,14 say "Consulta a partir do c"+chr(162)+"digo.....................[3]"
   @ 12,14 say "Consulta a partir da descri"+chr(135)+chr(132)+"o sintoma/doen"+chr(135)+"a...[4]"
   @ 13,14 say "Retorno ao menu principal.......................[5]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 15,63 get WOPC picture "9" range 1,5
   read_f()

   if WOPC == 5 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_SINTOMA()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select SINTOMA 
      ordsetfocus("SINC001")
      go top 

   elseif WOPC == 2
      select SINTOMA 
      ordsetfocus("SINC001")
      go bottom

      if eof()
         skip -1 
      endif 

   elseif WOPC == 3

      do while .t.

         WCODIGO = 0
  
         @ 03,12 get WCODIGO picture "@Z 999"
         read_f()
 
         if empty(WCODIGO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select SINTOMA 
         ordsetfocus("SINC001")
         seek WCODIGO

         if ! found()
             MENSAGEM("AVISO!;C"+chr(162)+"digo de sintoma/doen"+chr(135)+"a n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC == 2

      WNOME = space(30)

      @ 05,12 get WNOME                           
      read_f()           

      if ! empty(WNOME) .or. lastkey() <> 27

         select SINTOMA 
         ordsetfocus("SINC002")
         seek upper(WNOME)
        
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   sc_SINTOMA()    

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo    PgUp-Anterior    ESC-FIM")

      @ 03,12 say strzero(CODIGO,3)
      @ 05,12 say NOME   
     
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

********************
function EXC_SINTOMA
********************

do while .t.

   sc_SINTOMA()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,12 get WCODIGO picture "@Z 999"
   read_f()
 
   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif
   
   select SINTOMA
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
       MENSAGEM("AVISO!;C"+chr(162)+"digo de sintoma/doen"+chr(135)+"a n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   setcolor(COR_TEXT)

   @ 03,12 say strzero(CODIGO,3)
   @ 05,12 say NOME   
   
   if CONFIRMA(24,"Excluir esse c"+chr(162)+"digo...(S/N)?","N") = "S"
 
      select SINTOMA
 
      if ! reglock()
         loop
      endif
       
      replace CODIGO with 0,;
              NOME   with space(30)
      delete
      grava()

   endif 

enddo

return .t.

*********************
function SAVE_SINTOMA
*********************

if ! reglock()
   return .f.
endif
   
replace CODIGO with WCODIGO,;    
        NOME   with WNOME
  
grava()

return .t.


*********************
function SC_CATEGORIA
*********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "C"+chr(162)+"digo...:"
@ 05,01 say "Categoria:" 

return .t.

**********************
function INC_CATEGORIA
**********************

do while .t. 
   
   SC_CATEGORIA()

   WCODIGO = 0
   WNOME   = space(30)
  
   select CATEG
   ordsetfocus('SINC001')
   go bottom

   WCODIGO = CODIGO + 1

   @ 03,12 say strzero(WCODIGO,3)
   
   do while .t. 

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,12 get WNOME valid ! empty(WNOME)     
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"

         select CATEG
         ordsetfocus('SINC001')
         go bottom

         WCODIGO = CODIGO + 1

         @ 03,12 say strzero(WCODIGO,3)
         
         set deleted off
         go top
         if deleted()
            if ! reglock()
               loop
            endif
            recall
         else
            if ! inc_REG()
               loop
            endif
         endif
         set deleted on

         save_CATEGORIA()

         exit 
      endif

    enddo

enddo

return .t.

**********************
function ALT_CATEGORIA
**********************

do while .t. 

   SC_CATEGORIA()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,12 get WCODIGO picture "@Z 999" 
   read_f()
   @ 03,12 say strzero(WCODIGO,3)

   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif

   select CATEG
   ordsetfocus('SINC001')
   seek WCODIGO

   if ! found()
       MENSAGEM("AVISO!;C"+chr(162)+"digo categoria n"+chr(132)+"o cadastrado!",0)
       loop
   endif

   WNOME = NOME     

   do while .t.

      @ 05,12 get WNOME 
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"
         save_CATEGORIA()
         exit
      endif

   enddo

enddo

return .t.

**********************
function CON_CATEGORIA
**********************
LOCAL WCOR := setcolor()
LOCAL WOPC := 3

do while .t.

   SC_CATEGORIA()
     
   SOMBRA(10,14,16,67,8)

   setcolor(COR_CONS)
   @ 09,12 clear to 15,66
   @ 09,12 to 15,66 

   @ 09,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 10,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 11,14 say "Consulta a partir do c"+chr(162)+"digo.....................[3]"
   @ 12,14 say "Consulta a partir da descri"+chr(135)+chr(132)+"o da categoria.....[4]"
   @ 13,14 say "Retorno ao menu principal.......................[5]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 15,63 get WOPC picture "9" range 1,5
   read_f()

   if WOPC == 5 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   SC_CATEGORIA()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select CATEG 
      ordsetfocus("SINC001")
      go top

   elseif WOPC == 2
      select CATEG 
      ordsetfocus("SINC001")
      go bottom

      if eof() 
         skip -1 
      endif 

   elseif WOPC == 3

      do while .t.

         WCODIGO = 0
  
         @ 03,12 get WCODIGO picture "@Z 999"
         read_f()
 
         if empty(WCODIGO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select CATEG 
         ordsetfocus("SINC001")
         seek WCODIGO

         if ! found()
            MENSAGEM("AVISO!;C"+chr(162)+"digo categoria n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC == 4

      WNOME = space(30)

      @ 05,12 get WNOME                           
      read_f()           

      if ! empty(WNOME) .or. lastkey() <> 27

         select CATEG 
         ordsetfocus("SINC002")
         seek upper(WNOME)
        
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   SC_CATEGORIA()    

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo    PgUp-Anterior    ESC-FIM")

      @ 03,12 say strzero(CODIGO,3)
      @ 05,12 say NOME   
     
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
function EXC_CATEGORIA
**********************

do while .t.

   SC_CATEGORIA()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,12 get WCODIGO picture "@Z 999"
   read_f()
 
   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif
   
   select CATEG
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de categoria n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   setcolor(COR_TEXT)

   @ 03,12 say strzero(CODIGO,3)
   @ 05,12 say NOME   
   
   if CONFIRMA(24,"Excluir esse c"+chr(162)+"digo...(S/N)?","N") = "S"
 
      select CATEG
 
      if ! reglock()
         loop
      endif
       
      replace CODIGO with 0,;
              NOME   with space(30)
             
      delete
      grava()

   endif 

enddo

return .t.

***********************
function SAVE_CATEGORIA
***********************

if ! reglock()
   return .f.
endif
   
replace CODIGO with WCODIGO,;    
        NOME   with WNOME
  
grava()

return .t.


*******************
function SC_GRUPO_P
*******************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "C"+chr(162)+"digo...:"
@ 05,01 say "Grupo....:" 

return .t.

********************
function INC_GRUPO_P
********************

do while .t. 
   
   SC_GRUPO_P()

   WCODIGO   = 0
   WNOME     = space(30)
  
   select GRUPO_P
   ordsetfocus('SINC001')
   go bottom

   WCODIGO = CODIGO + 1

   @ 03,12 say strzero(WCODIGO,3)
   
   do while .t. 

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,12 get WNOME valid ! empty(WNOME)     
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"

         select GRUPO_P
         ordsetfocus('SINC001')
         go bottom

         WCODIGO = CODIGO + 1

         @ 03,12 say strzero(WCODIGO,3)
         
         set deleted off
         go top
         if deleted()
            if ! reglock()
               loop
            endif
            recall
         else
            if ! inc_REG()
               loop
            endif
         endif
         set deleted on

         save_GRUPO_P()

         exit 
      endif

    enddo

enddo

return .t.

********************
function ALT_GRUPO_P
********************

do while .t. 

   SC_GRUPO_P()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,12 get WCODIGO picture "@Z 999" 
   read_f()
   @ 03,12 say strzero(WCODIGO,3)

   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif

   select GRUPO_P
   ordsetfocus('SINC001')
   seek WCODIGO

   if ! found()
       MENSAGEM("AVISO!;C"+chr(162)+"digo de grupo n"+chr(132)+"o cadastrado!",0)
       loop
   endif

   WNOME = NOME     

   do while .t.

      @ 05,12 get WNOME 
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"
         save_GRUPO_P()
         exit
      endif

   enddo

enddo

return .t.

********************
function CON_GRUPO_P
********************
LOCAL WCOR := setcolor()
LOCAL WOPC := 3

do while .t.

   SC_GRUPO_P()
     
   SOMBRA(10,14,16,67,8)

   setcolor(COR_CONS)
   @ 09,12 clear to 15,66
   @ 09,12 to 15,66 

   @ 09,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 10,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 11,14 say "Consulta a partir do c"+chr(162)+"digo.....................[1]"
   @ 12,14 say "Consulta a partir da descri"+chr(135)+chr(132)+"o da categoria.....[2]"
   @ 13,14 say "Retorno ao menu principal.......................[3]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 15,63 get WOPC picture "9" range 1,4
   read_f()

   if WOPC == 5 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   SC_GRUPO_P()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select GRUPO_P 
      ordsetfocus("SINC001")
      go top

   elseif WOPC == 2   
      select GRUPO_P 
      ordsetfocus("SINC001")
      go bottom

      if eof() 
         skip -1 
      endif 

   elseif WOPC == 3
      do while .t.

         WCODIGO = 0
  
         @ 03,12 get WCODIGO picture "@Z 999"
         read_f()
 
         if empty(WCODIGO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select GRUPO_P 
         ordsetfocus("SINC001")
         seek WCODIGO

         if ! found()
            MENSAGEM("AVISO!;C"+chr(162)+"digo de grupo n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC == 4

      WNOME = space(30)

      @ 05,12 get WNOME                           
      read_f()           

      if ! empty(WNOME) .or. lastkey() <> 27

         select GRUPO_P 
         ordsetfocus("SINC002")
         seek upper(WNOME)
        
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   SC_GRUPO_P()    

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo   PgUp-Anterior   T-Total de Animais   ESC-FIM")

      @ 03,12 say strzero(CODIGO,3)
      @ 05,12 say NOME   
     
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
      elseif lastkey() == 84 .or. lastkey() == 116 // Tt
         totalDeAnimaisPorGrupo(CODIGO)            // MF_Z022.PRG 
      endif

   enddo

enddo

return .t.


********************
function EXC_GRUPO_P
********************

do while .t.

   SC_GRUPO_P()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,12 get WCODIGO picture "@Z 999"
   read_f()
 
   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif
   
   select GRUPO_P
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo grupo de n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   setcolor(COR_TEXT)

   @ 03,12 say strzero(CODIGO,3)
   @ 05,12 say NOME   
   
   if CONFIRMA(24,"Excluir esse c"+chr(162)+"digo...(S/N)?","N") = "S"
 
      select GRUPO_P
 
      if ! reglock()
         loop
      endif
       
      replace CODIGO with 0,;
              NOME   with space(30)
             
      delete
      grava()

   endif 

enddo

return .t.

*********************
function SAVE_GRUPO_P
*********************

if ! reglock()
   return .f.
endif
   
replace CODIGO with WCODIGO,;    
        NOME   with WNOME
  
grava()

return .t.


*******************
function SC_SUB_GRP
*******************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "C"+chr(162)+"digo...:"
@ 05,01 say "Sub-Grupo:" 

return .t.

********************
function INC_SUB_GRP
********************

do while .t. 
   
   SC_SUB_GRP()

   WCODIGO   = 0
   WNOME     = space(30)
  
   select SUB_GRP
   ordsetfocus('SINC001')
   go bottom

   WCODIGO = CODIGO + 1

   @ 03,12 say strzero(WCODIGO,3)
   
   do while .t. 

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,12 get WNOME valid ! empty(WNOME)     
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"

         select SUB_GRP
         ordsetfocus('SINC001')
         go bottom

         WCODIGO = CODIGO + 1

         @ 03,12 say strzero(WCODIGO,3)
         
         set deleted off
         go top
         if deleted()
            if ! reglock()
               loop
            endif
            recall
         else
            if ! inc_REG()
               loop
            endif
         endif
         set deleted on

         save_SUB_GRP()

         exit 
      endif

    enddo

enddo

return .t.

********************
function ALT_SUB_GRP
********************

do while .t. 

   SC_SUB_GRP()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,12 get WCODIGO picture "@Z 999" 
   read_f()
   @ 03,12 say strzero(WCODIGO,3)

   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif

   select SUB_GRP
   ordsetfocus('SINC001')
   seek WCODIGO

   if ! found()
       MENSAGEM("AVISO!;C"+chr(162)+"digo n"+chr(132)+"o cadastrado!",0)
       loop
   endif

   WNOME = NOME     

   do while .t.

      @ 05,12 get WNOME 
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"
         save_SUB_GRP()
         exit
      endif

   enddo

enddo

return .t.

********************
function CON_SUB_GRP
********************
LOCAL WCOR := setcolor()
LOCAL WOPC := 3

do while .t.

   SC_SUB_GRP()
     
   SOMBRA(10,14,16,67,8)

   setcolor(COR_CONS)
   @ 09,12 clear to 15,66
   @ 09,12 to 15,66 

   @ 10,14 say "Consulta a partir do c"+chr(162)+"digo.....................[1]"
   @ 11,14 say "Consulta a partir da descri"+chr(135)+chr(132)+"o da categoria.....[2]"
   @ 12,14 say "Retorno ao menu principal.......................[3]"

   setcolor("W/N,W/N,,,W/N")
   @ 14,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 14,63 get WOPC picture "9" range 1,3
   read_f()

   if WOPC == 3 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   SC_SUB_GRP()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC = 1

      do while .t.

         WCODIGO = 0
  
         @ 03,12 get WCODIGO picture "@Z 999"
         read_f()
 
         if empty(WCODIGO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select SUB_GRP 
         ordsetfocus("SINC001")
         seek WCODIGO

         if ! found()
            MENSAGEM("AVISO!;C"+chr(162)+"digo n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC = 2

      WNOME = space(30)

      @ 05,12 get WNOME                           
      read_f()           

      if ! empty(WNOME) .or. lastkey() <> 27

         select SUB_GRP 
         ordsetfocus("SINC002")
         seek upper(WNOME)
        
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   SC_SUB_GRP()    

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo   PgUp-Anterior   T-Total Animais   ESC-FIM")

      @ 03,12 say strzero(CODIGO,3)
      @ 05,12 say NOME   
     
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
      elseif lastkey() == 84 .or. lastkey() == 116 // Tt
         totalDeAnimaisPorSubGrupo(CODIGO)      
      endif

   enddo

enddo

return .t.


**********************************************
function totalDeAnimaisPorSubGrupo(WSUB_GRUPO)
**********************************************
LOCAL WAREA := ALIAS()
LOCAL WCOR  := setcolor()

**************************************************************************************** cria a tabela temporaria
  
WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
WCMP  := {"BRINCO", "SEXO", "PELAGEM", "IDADE", "RACA"}                   
WTPO  := {"C"     , "C"   , "C"      , "C"    , "C"   }
WTMO  := {15      , 05    , 20       , 20     , 30    }
WDEC  := {00      , 00    , 00       , 00     , 00    }
    
WIDX1 := "BRINCO"
WIDX2 := ""
WIDX3 := ""
    
cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
*****************************************************************************************************************  

setcolor(COR_DEST)

WTOTAL_F = 0
WTOTAL_M = 0 

select SUB_GRP
ordsetfocus("SINC001")
seek WSUB_GRUPO

if found()
   det_SUB_GRUPO = NOME
else
   det_SUB_GRUPO = "NAO CADASTRADO"
endif

select PLANTEL
ordsetfocus("SINC001")
go top

do while ! eof()

   if GRUPO <> WGRUPO
      skip +1
      loop
   endif

   if ! empty(SAIDA)
      skip +1
      loop
   endif

   if SEXO == "F"
      WTOTAL_F++
      det_SEXO = "Femea"
   else
      WTOTAL_M++
      det_SEXO = "Macho"
   endif

   det_BRINCO  = BRINCO
   det_PELAGEM = if(empty(PELAGEM),"-",alltrim(PELAGEM))
   det_COD     = RACA

   if ! empty(NASC)
      det_IDADE = transform(round(((DATE() - NASC) / 30),1),"@R@E 999.9 meses")
   else
      det_IDADE = "Nasc. nao definido"
   endif

   select RACA
   ordsetfocus("SINC001")
   seek det_COD

   if found()
      det_RACA = NOME 
   else
      det_RACA = "NAO CADASTRADA"
   endif

   select TMP
   dbappend()
   replace BRINCO  with det_BRINCO,;
           SEXO    with det_SEXO,;
           RACA    with det_RACA,;
           PELAGEM with det_PELAGEM,;
           IDADE   with det_IDADE           

   select PLANTEL
   skip +1

enddo

select TMP
ordsetfocus("SINC001")
go top

BRW_HELP(alltrim(det_SUB_GRUPO)+"|M: "+str(WTOTAL_M,3)+"|F:"+str(WTOTAL_F,3),.t., {;
{"BRINCO" ,"@!","Brinco"         },;
{"SEXO"   ,""  ,"Sexo"           },;
{"PELAGEM",""  ,"Pelagem"        },;
{"IDADE"  ,""  ,"Idade"          },;
{"RACA"   ,""  ,"Ra"+chr(135)+"a"}})
 
@ 24,00 clear to 24,79
if CONFIRMA(24,"Imprimir rela"+chr(135)+chr(132)+"o de animais do sub-grupo...(S/N)?","N") == "S"
   // print_ANIMAIS_SUB_GRUPO(det_GRUPO, WTOTAL_M, WTOTAL_F)
endif

exclui_TMP("201", WARQ+".DBF" , WARQ+".CDX" )

select &WAREA 

setcolor(WCOR)

keyboard ""

return .t.


********************
function EXC_SUB_GRP
********************

do while .t.

   SC_SUB_GRP()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,12 get WCODIGO picture "@Z 999"
   read_f()
 
   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif
   
   select SUB_GRP
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   setcolor(COR_TEXT)

   @ 03,12 say strzero(CODIGO,3)
   @ 05,12 say NOME   
   
   if CONFIRMA(24,"Excluir esse c"+chr(162)+"digo...(S/N)?","N") = "S"
 
      select SUB_GRP
 
      if ! reglock()
         loop
      endif
       
      replace CODIGO with 0,;
              NOME   with space(30)
             
      delete
      grava()

   endif 

enddo

return .t.

*********************
function SAVE_SUB_GRP
*********************

if ! reglock()
   return .f.
endif
   
replace CODIGO with WCODIGO,;    
        NOME   with WNOME
  
grava()

return .t.



*******************
function SC_PENDENC
*******************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "C"+chr(162)+"digo...:"
@ 05,01 say "Pend"+chr(136)+"ncia:" 

return .t.

********************
function INC_PENDENC
********************

do while .t. 
   
   SC_PENDENC()

   WCODIGO   = 0
   WNOME     = space(30)
  
   select PENDENC
   ordsetfocus('SINC001')
   go bottom

   WCODIGO = CODIGO + 1

   @ 03,12 say strzero(WCODIGO,3)
   
   do while .t. 

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,12 get WNOME valid ! empty(WNOME)     
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"

         select PENDENC
         ordsetfocus('SINC001')
         go bottom

         WCODIGO = CODIGO + 1

         @ 03,12 say strzero(WCODIGO,3)
         
         set deleted off
         go top
         if deleted()
            if ! reglock()
               loop
            endif
            recall
         else
            if ! inc_REG()
               loop
            endif
         endif
         set deleted on

         save_PENDENC()

         exit 
      endif

    enddo

enddo

return .t.

********************
function ALT_PENDENC
********************

do while .t. 

   SC_PENDENC()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,12 get WCODIGO picture "@Z 999" 
   read_f()
   @ 03,12 say strzero(WCODIGO,3)

   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif

   select PENDENC
   ordsetfocus('SINC001')
   seek WCODIGO

   if ! found()
       MENSAGEM("AVISO!;C"+chr(162)+"digo n"+chr(132)+"o cadastrado!",0)
       loop
   endif

   WNOME = NOME     

   do while .t.

      @ 05,12 get WNOME 
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if confirma(24,"Dados corretos...(S/N)?","S") == "S"
         save_PENDENC()
         exit
      endif

   enddo

enddo

return .t.

********************
function CON_PENDENC
********************
LOCAL WCOR := setcolor()
LOCAL WOPC := 3

do while .t.

   SC_PENDENC()
     
   SOMBRA(10,14,16,67,8)

   setcolor(COR_CONS)
   @ 09,12 clear to 15,66
   @ 09,12 to 15,66 

   @ 10,14 say "Consulta a partir do c"+chr(162)+"digo.....................[1]"
   @ 11,14 say "Consulta a partir da descri"+chr(135)+chr(132)+"o da pend"+chr(136)+"ncia.....[2]"
   @ 12,14 say "Retorno ao menu principal.......................[3]"

   setcolor("W/N,W/N,,,W/N")
   @ 14,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 14,63 get WOPC picture "9" range 1,3
   read_f()

   if WOPC == 3 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   SC_PENDENC()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC = 1

      do while .t.

         WCODIGO = 0
  
         @ 03,12 get WCODIGO picture "@Z 999"
         read_f()
 
         if empty(WCODIGO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select PENDENC 
         ordsetfocus("SINC001")
         seek WCODIGO

         if ! found()
            MENSAGEM("AVISO!;C"+chr(162)+"digo n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC = 2

      WNOME = space(30)

      @ 05,12 get WNOME                           
      read_f()           

      if ! empty(WNOME) .or. lastkey() <> 27

         select PENDENC 
         ordsetfocus("SINC002")
         seek upper(WNOME)
        
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   SC_PENDENC()    

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo   PgUp-Anterior   T-Total Animais   ESC-FIM")

      @ 03,12 say strzero(CODIGO,3)
      @ 05,12 say NOME   
     
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
      elseif lastkey() == 84 .or. lastkey() == 116 // Tt
         totalDeAnimaisPorPendencia(CODIGO)      
      endif

   enddo

enddo

return .t.


********************************************
function totalDeAnimaisPorPendencia(WCODIGO)
********************************************
LOCAL WAREA := ALIAS()
LOCAL WCOR  := setcolor()

**************************************************************************************** cria a tabela temporaria
  
WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
WCMP  := {"BRINCO", "SEXO", "PELAGEM", "IDADE", "RACA"}                   
WTPO  := {"C"     , "C"   , "C"      , "C"    , "C"   }
WTMO  := {15      , 05    , 20       , 20     , 30    }
WDEC  := {00      , 00    , 00       , 00     , 00    }
    
WIDX1 := "BRINCO"
WIDX2 := ""
WIDX3 := ""
    
cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
*****************************************************************************************************************  

setcolor(COR_DEST)

WTOTAL_F = 0
WTOTAL_M = 0 

select PENDENC
ordsetfocus("SINC001")
seek WCODIGO

if found()
   det_PENDENC = NOME
else
   det_PENDENC = "NAO CADASTRADO"
endif

select PLANTEL
ordsetfocus("SINC001")
go top

do while ! eof()

   if PENDENC <> WPENDENC
      skip +1
      loop
   endif

   if ! empty(SAIDA)
      skip +1
      loop
   endif

   if SEXO == "F"
      WTOTAL_F++
      det_SEXO = "Femea"
   else
      WTOTAL_M++
      det_SEXO = "Macho"
   endif

   det_BRINCO  = BRINCO
   det_PELAGEM = if(empty(PELAGEM),"-",alltrim(PELAGEM))
   det_COD     = RACA

   if ! empty(NASC)
      det_IDADE = transform(round(((DATE() - NASC) / 30),1),"@R@E 999.9 meses")
   else
      det_IDADE = "Nasc. nao definido"
   endif

   select RACA
   ordsetfocus("SINC001")
   seek det_COD

   if found()
      det_RACA = NOME 
   else
      det_RACA = "NAO CADASTRADA"
   endif

   select TMP
   dbappend()
   replace BRINCO  with det_BRINCO,;
           SEXO    with det_SEXO,;
           RACA    with det_RACA,;
           PELAGEM with det_PELAGEM,;
           IDADE   with det_IDADE           

   select PLANTEL
   skip +1

enddo

select TMP
ordsetfocus("SINC001")
go top

BRW_HELP(alltrim(det_PENDENC)+"|M: "+str(WTOTAL_M,3)+"|F:"+str(WTOTAL_F,3),.t., {;
{"BRINCO" ,"@!","Brinco"         },;
{"SEXO"   ,""  ,"Sexo"           },;
{"PELAGEM",""  ,"Pelagem"        },;
{"IDADE"  ,""  ,"Idade"          },;
{"RACA"   ,""  ,"Ra"+chr(135)+"a"}})
 
@ 24,00 clear to 24,79
if CONFIRMA(24,"Imprimir rela"+chr(135)+chr(132)+"o de animais por pend"+chr(136)+"ncia...(S/N)?","N") == "S"
   // print_ANIMAIS_PENDENCIA(det_PENDENC, WTOTAL_M, WTOTAL_F)
endif

exclui_TMP("201", WARQ+".DBF" , WARQ+".CDX" )

select &WAREA 

setcolor(WCOR)

keyboard ""

return .t.


********************
function EXC_PENDENC
********************

do while .t.

   SC_PENDENC()

   WCODIGO = 0
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,12 get WCODIGO picture "@Z 999"
   read_f()
 
   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif
   
   select PENDENC
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   setcolor(COR_TEXT)

   @ 03,12 say strzero(CODIGO,3)
   @ 05,12 say NOME   
   
   if CONFIRMA(24,"Excluir esse c"+chr(162)+"digo...(S/N)?","N") = "S"
 
      select PENDENC
 
      if ! reglock()
         loop
      endif
       
      replace CODIGO with 0,;
              NOME   with space(30)
             
      delete
      grava()

   endif 

enddo

return .t.

*********************
function SAVE_PENDENC
*********************

if ! reglock()
   return .f.
endif
   
replace CODIGO with WCODIGO,;    
        NOME   with WNOME
  
grava()

return .t.


*****************
function sc_CUSTO
*****************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "C"+chr(162)+"digo..............:"
@ 05,01 say "Centro Custo........:"
@ 07,01 say "Compoe Custo Engorda?"

return .t.

******************
function INC_CUSTO
******************

do while .t.

   sc_CUSTO()
   
   select CUSTO
   ordsetfocus("SINC001")
   go bottom

   WCODIGO = CODIGO + 1

   setcolor(COR_TEXT)
   @ 03,23 say strzero(WCODIGO,3)

   WNOME = space(30)
   WCCE  = "N"
   
   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,23 get WNOME            valid ! empty(WNOME)
      @ 07,23 get WCCE picture "!" valid WCCE $ "S-N"
      read_f()

      if empty(WNOME) .or. lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
 
         select CUSTO
         ordsetfocus("SINC001")
         go bottom

         WCODIGO = CODIGO + 1
 
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

         replace CODIGO with WCODIGO
         grava()

         save_CUSTO()

         exit

      endif

    enddo
 
enddo

return .t.

******************
function ALT_CUSTO
******************

do while .t.

   WCODIGO = 0

   sc_CUSTO()

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,23 get WCODIGO picture "@Z 999" 
   read_f()

   if empty(WCODIGO) .or. lastkey() = 27
      return .t.
   endif

   select CUSTO
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo centro de custo n"+chr(132)+"o cadastrado!",0)
      loop
   endif

   WNOME = NOME    
   WCCE  = CCE  

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,23 get WNOME            valid ! empty(WNOME)
      @ 07,23 get WCCE picture "!" valid WCCE $ "S-N"
      read_f()

      if empty(WNOME) .or. lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select CUSTO
         save_CUSTO()
         exit
      endif

    enddo
 
enddo

return .t.

******************
function CON_CUSTO
******************
LOCAL WCOR := setcolor()
LOCAL WOPC := 3

do while .t.

   sc_CUSTO()
     
   SOMBRA(10,14,16,67,8)

   setcolor(COR_CONS)
   @ 09,12 clear to 15,66
   @ 09,12 to 15,66 

   @ 10,14 say "Consulta a partir do c"+chr(162)+"digo do pasto............[1]"
   @ 11,14 say "Consulta a partir do nome do pasto..............[2]"
   @ 12,14 say "Retorno ao menu principal.......................[3]"

   setcolor("W/N,W/N,,,W/N")
   @ 14,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 14,63 get WOPC picture "9" range 1,3
   read_f()

   if WOPC = 3 .or. lastkey() = 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_CUSTO()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC = 1

      do while .t.

         WCODIGO = 0
  
         @ 03,23 get WCODIGO picture "@Z 999"
         read_f()
 
         if empty(WCODIGO) .or. lastkey() = 27
            WTRAVA = .t.
            exit
         endif
   
         select CUSTO
         ordsetfocus("SINC001")
         seek WCODIGO

         if ! found()
            MENSAGEM("AVISO!;C"+chr(162)+"digo de centro de custo n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC = 2

      WNOME = space(30)

      @ 05,23 get WNOME                           
      read_f()           

      if ! empty(WNOME) .or. lastkey() <> 27

         select CUSTO
         ordsetfocus("SINC002")
         seek upper(WNOME)
        
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo   PgUp-Anterior   ESC-FIM")

      select CUSTO

      @ 03,23 say strzero(CODIGO,3)
      @ 05,23 say NOME   
      @ 07,23 say if(CCE == "S","Sim","N"+chr(132)+"o")

      inkey(0)

      if lastkey() = 03
         skip +1
         if eof()
            skip -1
         endif
      elseif lastkey() = 18
         skip -1
      elseif lastkey() = 27
         exit
      endif

   enddo

enddo

return .t.

******************
function EXC_CUSTO
******************

do while .t.

   sc_CUSTO()

   WCODIGO = 0
  
   @ 03,23 get WCODIGO picture "@Z 999"
   read_f()
 
   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif
   
   select CUSTO
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de centro de custo n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   @ 03,23 say strzero(CODIGO,3)
   @ 05,23 say NOME   
   @ 07,23 say if(CCE == "S","Sim","N"+chr(132)+"o")

   if CONFIRMA(24,"Excluir esse centro de custo...(S/N)?","N") = "S"
 
      select CUSTO
 
      if ! reglock()
         loop
      endif
       
      replace CODIGO with 0,;
              NOME   with space(30),;
              CCE    with space(01)
             
      delete
      grava()

   endif 

enddo

return .t.

*******************
function save_CUSTO
*******************

if ! reglock()
   return .t.
endif

replace NOME with WNOME,;
        CCE  with WCCE 
 
grava()
       
return .t.

*****************
function sc_GRUPO
*****************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "C"+chr(162)+"digo..:"
@ 05,01 say "Grupo...:"

return .t.

******************
function INC_GRUPO
******************

do while .t.

   sc_GRUPO()
   
   select GRUPO
   ordsetfocus("SINC001")
   go bottom

   WCODIGO = strzero(val(CODIGO) + 1,3)

   setcolor(COR_TEXT)
   @ 03,11 say WCODIGO

   WGRUPO = space(30)
   
   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,11 get WGRUPO valid ! empty(WGRUPO)
      read_f()

      if empty(WGRUPO) .or. lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
 
         select GRUPO
         ordsetfocus("SINC001")
         go bottom

          WCODIGO = strzero(val(CODIGO) + 1,3)
 
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

         replace CODIGO with WCODIGO
         grava()

         save_GRUPO()

         exit

      endif

    enddo
 
enddo

return .t.

******************
function ALT_GRUPO
******************

do while .t.

   WCODIGO = space(03)

   sc_GRUPO()

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,11 get WCODIGO picture "999" 
   read_f()

   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif

   WCODIGO = strzero(val(WCODIGO),3)
   @ 03,11 get WCODIGO picture "999"

   select GRUPO
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de grupo n"+chr(132)+"o cadastrado!",0)
      loop
   endif

   WGRUPO = GRUPO

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,11 get WGRUPO valid ! empty(WGRUPO)
      read_f()

      if empty(WGRUPO) .or. lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select GRUPO
         save_GRUPO()
         exit
      endif

    enddo
 
enddo

return .t.

******************
function CON_GRUPO
******************
LOCAL WCOR := setcolor()
LOCAL WOPC 

do while .t.

   WOPC = 5

   sc_GRUPO()
     
   SOMBRA(09,14,17,67,8)

   setcolor(COR_CONS)
   @ 08,12 clear to 16,66
   @ 08,12 to 16,66 

   @ 09,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 10,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 11,14 say "Consulta a partir do c"+chr(162)+"digo do grupo............[3]"
   @ 12,14 say "Consulta a partir do nome do grupo..............[4]"
   @ 13,14 say "Retorno ao menu principal.......................[5]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 15,63 get WOPC picture "9" range 1,5
   read_f()

   if WOPC == 5 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_GRUPO()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC = 1
      select GRUPO
      ordsetfocus("SINC001")
      go top

   elseif WOPC = 2
      select GRUPO
      ordsetfocus("SINC002")
      go bottom

      if eof()
         skip -1
         loop
      endif

   elseif WOPC = 3

      do while .t.

         WCODIGO = space(03)
  
         @ 03,11 get WCODIGO picture "999"
         read_f()
 
         if empty(WCODIGO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select GRUPO
         ordsetfocus("SINC001")
         seek WCODIGO

         if ! found()
            MENSAGEM("AVISO!;C"+chr(162)+"digo de grupo n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC = 2

      WGRUPO = space(30)

      @ 05,11 get WGRUPO                           
      read_f()           

      if ! empty(WGRUPO) .or. lastkey() <> 27

         select GRUPO
         ordsetfocus("SINC002")
         seek upper(WGRUPO)
        
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo   PgUp-Anterior   ESC-FIM")

      @ 03,11 say CODIGO
      @ 05,11 say GRUPO  

      inkey(0)

      if lastkey() = 03
         skip +1
         if eof()
            skip -1
         endif
      elseif lastkey() = 18
         skip -1
      elseif lastkey() = 27
         exit
      endif

   enddo

enddo

return .t.

******************
function EXC_GRUPO
******************

do while .t.

   sc_GRUPO()

   WCODIGO = space(03)
  
   @ 03,11 get WCODIGO picture "999"
   read_f()
 
   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif
   
   select GRUPO
   ordsetfocus("SINC001")
   seek WCODIGO

   if ! found()
      MENSAGEM("AVISO!;C"+chr(162)+"digo de grupo n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   @ 03,11 say CODIGO
   @ 05,11 say GRUPO 
   
   if CONFIRMA(24,"Excluir esse grupo...(S/N)?","N") = "S"
 
      select GRUPO
 
      if ! reglock()
         loop
      endif
       
      replace CODIGO with space(03),;
              GRUPO  with space(30)
             
      delete
      grava()

   endif 

enddo

return .t.

*******************
function save_GRUPO
*******************

if ! reglock()
   return .t.
endif

replace GRUPO with WGRUPO
   
grava()

return .t.


******************
function SC_FORNEC
******************

setcolor(COR_TEXT)
@ 00,00 clear to 22,79
@ 24,00 clear to 24,79

setcolor(COR_CONS)
@ 00,00 clear to 00,79
@ 00,27 say "CADASTRO DE FORNECEDORES"

setcolor(COR_getA)
@ 01,01 to 01,78
@ 01,59 say " Dados do fornecedor"

setcolor(COR_TEXT)

@ 02,01 say "C"+chr(162)+"digo........:"
@ 02,63 say "Desde.:"
@ 03,01 say "Fornecedor....:"
@ 04,01 say "Endere"+chr(135)+"o......:"
@ 04,63 say "N"+chr(163)+"mero: "
@ 05,01 say "Bairro........:"
@ 06,01 say "Cidade........:"
@ 07,01 say "UF............:"
@ 08,01 say "CEP...........:"
@ 09,01 say "CNPJ/CPF......:"
@ 10,01 say "Insc.Estadual.:"
@ 11,01 say "Telefone......:"
@ 12,01 say "Fax...........:"
@ 13,01 say "Contato.......:"
@ 14,01 say "E-mail........:"

setcolor(COR_getA)
@ 15,01 to 15,78
@ 15,59 say " Dados para dep"+chr(162)+"sito"

setcolor(COR_TEXT)

@ 16,01 say "Banco.........:"
@ 17,01 say "Conta Corrente:"
@ 18,01 say "Ag"+chr(136)+"ncia.......:"

setcolor(COR_getA)
@ 19,01 to 19,78
@ 19,67 say " Observa"+chr(135)+chr(148)+"es"

setcolor(COR_TEXT)

return .t.


*******************
function INC_FORNEC
*******************
LOCAL WBOX := savescreen(00,00,24,79)

do while .t. 

    SC_FORNEC()

    select FORNEC
    ordsetfocus("SINC001")
    go bottom

    WCODIGO = CODIGO + 1

    setcolor(COR_TEXT)
    @ 02,17 say strzero(WCODIGO,6)              

    WDESDE    = left(upper(MES(month(DATE()))),3)+str(year(DATE()),4)
    WFORNEC   = space(40)  
    WENDERECO = space(35)    
    WNUMERO   = space(06)
    WBAIRRO   = space(20)
    WCIDADE   = space(20)
    WUF       = space(02)
    WCEP      = space(08)
    WTEL      = space(35)
    WFAX      = space(35)
    WCNPJ     = space(14)        
    WINSCEST  = space(20)
    WE_MAIL   = space(35)
    WBANCO    = space(16)
    WCONTA    = space(12)
    WAGENCIA  = space(15)
    WCONTATO  = space(40) 
    WOBS_1    = space(78)
    WOBS_2    = space(78)
    WOBS_3    = space(78)

    do while .t.

        setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

        @ 02,71 get WDESDE   picture "@R !!!/9999"
        @ 03,17 get WFORNEC     
        @ 04,17 get WENDERECO           
        @ 04,71 get WNUMERO                               
        @ 05,17 get WBAIRRO       
        @ 06,17 get WCIDADE        
        @ 07,17 get WUF      picture "!!"
        @ 08,17 get WCEP     picture "@R 99999-999"
        @ 09,17 get WCNPJ    picture "@R 99999999999999"  
        @ 10,17 get WINSCEST    
        @ 11,17 get WTEL        
        @ 12,17 get WFAX        
        @ 13,17 get WCONTATO
        @ 14,17 get WE_MAIL

        @ 16,17 get WBANCO 
        @ 17,17 get WCONTA
        @ 18,17 get WAGENCIA

        @ 20,01 get WOBS_1      
        @ 21,01 get WOBS_2      
        @ 22,01 get WOBS_3      
        read_f()

        if empty(WFORNEC) .or. lastkey() = 27
           restscreen(00,00,24,79,WBOX)
           return .t.
        endif

        if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"

           do while .t.

               select FORNEC
               ordsetfocus("SINC001")
               go bottom

               WCODIGO = CODIGO + 1

               seek WCODIGO

               if found()
                  loop
               endif 
 
           exit
           enddo

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
           set deleted On

           replace CODIGO with WCODIGO

           save_FORNEC()

           grava()

           setcolor(COR_TEXT+"*")
           @ 02,17 say strzero(WCODIGO,6)
           setcolor(COR_TEXT)

           inkey(3)

           exit

        endif

    enddo

enddo

return .t.


*******************
function ALT_FORNEC
*******************
LOCAL WBOX := savescreen(00,00,24,79)

do while .t.
 
    SC_FORNEC()

    WCODIGO = 0        
  
    setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

    @ 02,17 get WCODIGO picture "@Z 999999"
    read_f()
    @ 02,17 say strzero(WCODIGO,6)

    if empty(WCODIGO) .or. lastkey() = 27
       restscreen(00,00,24,79,WBOX)
       return .t.
    endif
 
    select FORNEC
    ordsetfocus("SINC001")
    seek WCODIGO    

    if ! found()
       mensagem2("AVISO!;C"+chr(162)+"digo de fornecedor n"+chr(132)+"o cadastrado!",0)
       loop
    endif  

    WDESDE    = DESDE      
    WFORNEC   = FORNEC     
    WENDERECO = ENDERECO   
    WNUMERO   = NUMERO
    WBAIRRO   = BAIRRO     
    WCIDADE   = CIDADE     
    WUF       = UF         
    WCEP      = CEP        
    WTEL      = TEL        
    WFAX      = FAX        
    WCNPJ     = CNPJ       
    WINSCEST  = INSCEST    
    WE_MAIL   = E_MAIL
    WCONTATO  = CONTATO
    WBANCO    = BANCO      
    WCONTA    = CONTA      
    WAGENCIA  = AGENCIA    
    WOBS_1    = OBS_1      
    WOBS_2    = OBS_2      
    WOBS_3    = OBS_3      

    do while .t.

        setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

        @ 02,71 get WDESDE   picture "@R !!!/9999"
        @ 03,17 get WFORNEC     
        @ 04,17 get WENDERECO           
        @ 04,71 get WNUMERO                               
        @ 05,17 get WBAIRRO       
        @ 06,17 get WCIDADE        
        @ 07,17 get WUF      picture "!!"
        @ 08,17 get WCEP     picture "@R 99999-999"
        @ 09,17 get WCNPJ    picture "@R 99999999999999"  
        @ 10,17 get WINSCEST    
        @ 11,17 get WTEL        
        @ 12,17 get WFAX        
        @ 13,17 get WCONTATO
        @ 14,17 get WE_MAIL

        @ 16,17 get WBANCO 
        @ 17,17 get WCONTA
        @ 18,17 get WAGENCIA

        @ 20,01 get WOBS_1      
        @ 21,01 get WOBS_2      
        @ 22,01 get WOBS_3      
        read_f()

        if lastkey() = 27
           restscreen(00,00,24,79,WBOX)
           return .t.
        endif

        if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"

           select FORNEC

           if ! reglock()
              loop
           endif
           
           save_FORNEC()

           grava()

           exit

        endif

    enddo

enddo

return .t.


*******************
function CON_FORNEC
*******************
LOCAL WBOX := savescreen(00,00,24,79)
LOCAL WCOR := setcolor()

do while .t.

    WOPC  = 3
    TRAVA = .F.

    SC_FORNEC()

    SOMBRA(10,14,16,67,8)

    setcolor(COR_CONS)
    @ 09,12 clear to 15,66
    @ 09,12 to 15,66 

    @ 10,14 say "Consulta a partir do c"+chr(162)+"digo do fornecedor.......[1]"
    @ 11,14 say "Consulta a partir do nome do fornecedor.........[2]"
    @ 12,14 say "Retorno ao menu principal.......................[3]"

    setcolor("W/N,W+/N,,W/N")
    @ 14,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
    @ 14,63 get WOPC picture "9" range 1,3
    read_f()

    if WOPC = 3 .or. lastkey() == 27
       restscreen(00,00,24,79,WBOX)
       setcolor(WCOR)
       return .t.
    endif

    SC_FORNEC()

    if WOPC = 1

       do while .t.

           WCODIGO = 0

           setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

           @ 02,17 get WCODIGO picture "@Z 999999"
           read_f()

           if ! empty(WCODIGO) .or. lastkey() <> 27

              select FORNEC
              ordsetfocus("SINC001")
              seek WCODIGO

              if ! found()
                 mensagem2("AVISO!;C"+chr(162)+"digo de fornecedor n"+chr(132)+"o cadastrado!",0)
                 loop
              endif

           else
              TRAVA = .t.
           endif

       exit
       enddo

   elseif WOPC = 2

      WFORNEC = space(40)

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
 
      @ 03,17 get WFORNEC
      read_f()

      if ! empty(WFORNEC) .or. lastkey() <> 27

         select FORNEC
         ordsetfocus("SINC002")
         seek upper(WFORNEC)
         
         if eof()
            skip -1
         endif

      else
         TRAVA = .t.
      endif

   endif

   if TRAVA
      loop
   endif

   do while .t.                      

       setcolor(COR_TEXT)
       CENTRO(24,"PgDw-Pr"+chr(162)+"ximo   PgUp-Anterior   ESC-Retornar")

       @ 02,17 say strzero(CODIGO,6)
       @ 02,71 say DESDE   picture "@R !!!/9999"
       @ 03,17 say FORNEC     
       @ 04,17 say ENDERECO           
       @ 04,71 say NUMERO                               
       @ 05,17 say BAIRRO       
       @ 06,17 say CIDADE        
       @ 07,17 say UF      picture "!!"
       @ 08,17 say CEP     picture "@R 99999-999"

       if len(alltrim(CNPJ)) > 11
          @ 09,17 say space(18)
          @ 09,17 say CNPJ picture "@R 99.999.999/9999-99" 
       else
          @ 09,17 say space(18)
          @ 09,17 say CNPJ picture "@R 999.999.999-99" 
       endif

       @ 10,17 say INSCEST    
       @ 11,17 say TEL        
       @ 12,17 say FAX        
       @ 13,17 say CONTATO
       @ 14,17 say E_MAIL

       @ 16,17 say BANCO 
       @ 17,17 say CONTA
       @ 18,17 say AGENCIA

       @ 20,01 say OBS_1      
       @ 21,01 say OBS_2      
       @ 22,01 say OBS_3      

       inkey(0)

       if lastkey() == 3
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


*******************
function EXC_FORNEC
*******************
LOCAL WBOX := savescreen(00,00,24,79)

do while .t. 

    WCODIGO = 0        
  
    SC_FORNEC()

    setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

    @ 02,17 get WCODIGO picture "@Z 999999"
    read_f()

    if empty(WCODIGO) .or. lastkey() = 27
       restscreen(00,00,24,79,WBOX)
       return .t.
    endif
 
    select FORNEC
    ordsetfocus("SINC001")
    seek WCODIGO    

    if ! found()
       mensagem2("AVISO!;C"+chr(162)+"digo de fornecedor n"+chr(132)+"o cadastrado!",0)
       loop
    endif 

    @ 02,17 say strzero(CODIGO,6)
    @ 02,71 say DESDE   picture "@R !!!/9999"
    @ 03,17 say FORNEC     
    @ 04,17 say ENDERECO           
    @ 04,71 say NUMERO                               
    @ 05,17 say BAIRRO       
    @ 06,17 say CIDADE        
    @ 07,17 say UF      picture "!!"
    @ 08,17 say CEP     picture "@R 99999-999"

    if len(alltrim(CNPJ)) > 11
       @ 09,17 say space(18)
       @ 09,17 say CNPJ picture "@R 99.999.999/9999-99" 
    else
       @ 09,17 say space(18)
       @ 09,17 say CNPJ picture "@R 999.999.999-99" 
    endif

    @ 10,17 say INSCEST    
    @ 11,17 say TEL        
    @ 12,17 say FAX        
    @ 13,17 say CONTATO 
    @ 14,17 say E_MAIL

    @ 16,17 say BANCO 
    @ 17,17 say CONTA
    @ 18,17 say AGENCIA

    @ 20,01 say OBS_1      
    @ 21,01 say OBS_2      
    @ 22,01 say OBS_3      

    if CONFIRMA(24,"Excluir esse fornecedor...(S/N)?","N") == "S"

       select FORNEC

       if ! reglock()
          loop
       endif

       replace CODIGO   with 0,;
               DESDE    with space(07),; 
               FORNEC   with space(40),; 
               ENDERECO with space(35),; 
               NUMERO   with space(06),; 
               BAIRRO   with space(20),; 
               CIDADE   with space(20),; 
               UF       with space(02),; 
               CEP      with space(08),; 
               TEL      with space(35),; 
               FAX      with space(35),; 
               CNPJ     with space(14),; 
               INSCEST  with space(20),; 
               CONTATO  with space(40),; 
               E_MAIL   with space(35),; 
               BANCO    with space(16),; 
               CONTA    with space(12),; 
               AGENCIA  with space(15),; 
               OBS_1    with space(78),; 
               OBS_2    with space(78),; 
               OBS_3    with space(78) 

       delete
       grava()

    endif

enddo

return .t.


********************
function save_FORNEC
********************

replace DESDE    with WDESDE,;
        FORNEC   with WFORNEC,;
        ENDERECO with WENDERECO,;
        NUMERO   with WNUMERO,;
        BAIRRO   with WBAIRRO,;
        CIDADE   with WCIDADE,;
        UF       with WUF,;
        CEP      with WCEP,;
        TEL      with WTEL,;
        FAX      with WFAX,;
        CNPJ     with WCNPJ,;
        INSCEST  with WINSCEST,;
        CONTATO  with WCONTATO,;
        E_MAIL   with WE_MAIL,;
        BANCO    with WBANCO,;
        CONTA    with WCONTA,;
        AGENCIA  with WAGENCIA,;
        OBS_1    with WOBS_1,;
        OBS_2    with WOBS_2,;
        OBS_3    with WOBS_3   

return .t.


**************************
function dados_INDICADORES
**************************

return .t.


**********************
function dados_FAZENDA
**********************

return .t.

