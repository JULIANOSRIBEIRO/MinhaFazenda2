*********************************************************************
****  Sistema......: SINCON-Sistema Integrado de Controle        ****
****  Programa.....: MF_Z017.PRG                                 ****
****  Finalidade...: Cadastro de Anamnese (Sintoma/Tratamento)   ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************
#include "TBrowse.ch"
#include "inkey.ch"

********************
function sc_ANAMNESE
********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "Sequ"+chr(136)+"ncia.:"
@ 05,01 say "Brinco....:"
@ 07,01 say "Data......:"
@ 09,01 say "Descri"+chr(135)+chr(132)+"o.:    -"
@ 11,01 say "Tratamento:"

return .t.

*********************
function INC_ANAMNESE
*********************

do while .t.

   sc_ANAMNESE()
   
   select REPRODUCAO               
   ordsetfocus("SINC001")
   go bottom

   WSEQ = SEQ + 1

   setcolor(COR_TEXT)
   @ 03,13 say strzero(WSEQ,6)

   WBRINCO   = space(08) 
   WDATA     = ctod(space(08))
   WCOD_SINT = 0
   WTRAT1    = space(60)
   WTRAT2    = space(60)
   WTRAT3    = space(60)
   WTRAT4    = space(60)

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 05,13 get WBRINCO    picture "99999999" valid busca5_BRINCO()
      @ 07,13 get WDATA
      @ 09,13 get WCOD_SINT  picture "@Z 999"   valid busca_SINTOMA()
      @ 11,13 get WTRAT1
      @ 12,13 get WTRAT2
      @ 13,13 get WTRAT3
      @ 14,13 get WTRAT4
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
 
         select ANAMNESE
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

         save_ANAMNESE("INC")

         exit

      endif

    enddo
 
enddo

return .t.

**********************
function busca_SINTOMA
**********************

if lastkey() == 27
   return .t.
endif

if empty(WCOD_SINT)
   help_SINTOMA()
   select SINTOMA
   WCOD_SINT = CODIGO
   return .f.
endif

select SINTOMA
ordsetfocus("SINC001")
seek WCOD_SINT 

if ! found()
   mensagem("AVISO!;C"+chr(162)+"digo de sintoma/doen"+chr(135)+"a n"+chr(132)+"o cadastrado.")
   return .f.
endif

@ 09,17 say NOME 

return .t.


*********************
function ALT_ANAMNESE
*********************

do while .t.

   WSEQ = 0

   sc_ANAMNESE()

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,13 get WSEQ picture "@Z 999999" 
   read_f()
   @ 03,13 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select ANAMNESE
   ordsetfocus("SINC001")
   seek WSEQ 

   if ! found()
      MENSAGEM("AVISO!;Sequ"+chr(136)+"ncia de controle n"+chr(132)+"o cadastrada!",0)
      loop
   endif

   WBRINCO   = BRINCO 
   WDATA     = DATA
   WCOD_SINT = COD_SINT
   WTRAT1    = TRAT1
   WTRAT2    = TRAT2
   WTRAT3    = TRAT3
   WTRAT4    = TRAT4
   
   select SINTOMA  
   ordsetfocus("SINC001")
   seek WCOD_SINT

   if found()
      @ 09,17 say NOME 
   endif

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
       
      @ 05,13 get WBRINCO    picture "99999999" valid busca5_BRINCO()
      @ 07,13 get WDATA
      @ 09,13 get WCOD_SINT  picture "@Z 999"   valid busca_SINTOMA()
      @ 11,13 get WTRAT1
      @ 12,13 get WTRAT2
      @ 13,13 get WTRAT3
      @ 14,13 get WTRAT4
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select ANAMNESE
         save_ANAMNESE("ALT")
         exit
      endif

    enddo
 
enddo

return .t.

*********************
function CON_ANAMNESE
*********************
LOCAL WCOR := setcolor()
LOCAL WOPC  

do while .t.
   
   WOPC = 6

   sc_ANAMNESE()
     
   SOMBRA(08,09,17,72,8)

   setcolor(COR_CONS)
   @ 07,07 clear to 16,71
   @ 07,07 to 16,71 

   @ 08,09 say "Consulta a partir do inicio do arquivo....................[1]"
   @ 09,09 say "Consulta a partir do final do arquivo.....................[2]"
   @ 10,09 say "Consulta a partir da sequ"+chr(136)+"ncia de controle................[3]"
   @ 11,09 say "Consulta a partir do n"+chr(163)+"mero do brinco.....................[4]"
   @ 12,09 say "Consulta a partir da data do sintoma cl"+chr(161)+"nico/tratamento...[5]"
   @ 13,09 say "Retorno ao menu principal.................................[6]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,09 say "Escolha sua op"+chr(135)+chr(132)+"o.........................................[ ]"
   @ 15,68 get WOPC picture "9" range 1,6
   read_f()

   if WOPC == 6 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_ANAMNESE()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select ANAMNESE
      ordsetfocus("SINC001")
      go top

   elseif WOPC == 2
      select ANAMNESE
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
   
         select ANAMNESE
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

         select ANAMNESE
         ordsetfocus("SINC002")
         seek WBRINCO
          
         if ! found()
            MENSAGEM("AVISO!;N"+chr(132)+"o houve sintoma cl"+chr(161)+"nico/tratamento para o brinco informado!",0)
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

         select ANAMNESE
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
      @ 05,13 say BRINCO   picture "99999999" 
      @ 07,13 say DATA
      @ 09,13 say COD_SINT picture "999" 
      @ 11,13 say TRAT1   
      @ 11,13 say TRAT2   
      @ 11,13 say TRAT3   
      @ 11,13 say TRAT4   

      WCOD_SINT = COD_SINT 

      select SINTOMA  
      ordsetfocus("SINC001")
      seek WCOD_SINT 

      if found()
         @ 09,17 say NOME 
      else
         @ 09,17 say space(30)
         @ 09,17 say "NAO CADASTRADO"
      endif

      select ANAMNESE

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


*********************
function EXC_ANAMNESE
*********************

do while .t.

   sc_ANAMNESE()

   WSEQ = 0
  
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,13 get WSEQ picture "@Z 999999" 
   read_f()
   @ 03,13 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select ANAMNESE
   ordsetfocus("SINC001")
   seek WSEQ 

   if ! found()
      MENSAGEM("AVISO!;Sequ"+chr(136)+"ncia de controle n"+chr(132)+"o cadastrada!",0)
      loop
   endif
  
   @ 03,13 say strzero(SEQ,6)
   @ 05,13 say BRINCO   picture "99999999" 
   @ 07,13 say DATA
   @ 09,13 say COD_SINT picture "999" 
   @ 11,13 say TRAT1   
   @ 11,13 say TRAT2   
   @ 11,13 say TRAT3   
   @ 11,13 say TRAT4   

   WCOD_SINT = COD_SINT 

   select SINTOMA  
   ordsetfocus("SINC001")
   seek WCOD_SINT 

   if found()
      @ 09,17 say NOME 
   else
      @ 09,17 say space(30)
      @ 09,17 say "NAO CADASTRADO"
   endif

   select ANAMNESE

   if CONFIRMA(24,"Excluir esse sintoma cl"+chr(161)+"nico/tratamento...(S/N)?","N") = "S"
 
      select ANAMNESE
 
      if ! reglock()
         loop
      endif
       
      replace SEQ       with 0,;
              DATA      with ctod(space(08)),;
              BRINCO    with space(08),;
              COD_SINT  with 0,;
              TRAT1     with space(60),;
              TRAT2     with space(60),;
              TRAT3     with space(60),;
              TRAT4     with space(60),;
              USER_INC  with space(20),;
              DATE_INC  with ctod(space(08)),;
              TIME_INC  with space(08),;
              USER_ALT  with space(20),;
              DATE_ALT  with ctod(space(08)),;
              TIME_ALT  with space(08),;
              USER_CAN  with space(20),;
              DATE_CAN  with ctod(space(08)),;
              TIME_CAN  with space(08),;
              USER_EXC  with space(20),;
              DATE_EXC  with ctod(space(08)),;
              TIME_EXC  with space(08),;
              USER_BX   with space(20),;
              DATE_BX   with ctod(space(08)),;
              TIME_BX   with space(08)
      delete
      grava()

   endif 

enddo

return .t.

******************************
function save_ANAMNESE(MODULO)
******************************

if ! reglock()
   return .t.
endif

replace SEQ      with WSEQ,;
        DATA     with WDATA,;
        BRINCO   with WBRINCO,;
        COD_SINT with WCOD_SINT,;
        TRAT1    with WTRAT1,;
        TRAT2    with WTRAT2,;
        TRAT3    with WTRAT3,;
        TRAT4    with WTRAT4
        
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
