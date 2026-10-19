*********************************************************************
****  Sistema......: MF-Minha Fazenda (Gerenciador)              ****
****  Versao.......: 5.0                                         ****
****  Programa.....: MFZ024.PRG                                  ****
****  Finalidade...: ENTRADA/SAIDA BANCO DE SEMÊN                ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versão.......: xHARBOUR                                    ****
*********************************************************************

**********************
function sc_ENTRADA_BS
**********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79 
@ 24,00 clear to 24,79 

@ 03,01 say "Sequ"+chr(136)+"ncia:"
@ 03,65 say "Data:"
@ 05,01 say "Lote.....:"
@ 07,01 say "Doador...:"
@ 09,01 say "Hist"+chr(162)+"rico:"
@ 15,01 say "Qtde (+).:"

return .t.


***********************
function INC_ENTRADA_BS
***********************

do while .t.
  
   sc_ENTRADA_BS()

   WDATA   = date()
   WLOTE   = space(20)
   WDOADOR = space(50)
   WHIST1  = space(64)
   WHIST2  = space(64)
   WHIST3  = space(64)
   WHIST4  = space(64)
   WHIST5  = space(64)
   WQTDE   = 0

   select ENT_BS
   ordsetfocus("SINC001")
   go bottom

   WSEQ = SEQ + 1

   @ 03,12 say strzero(WSEQ,6)
  
   do while .t. 
  
      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
        
      @ 03,71 get WDATA
      
      @ 05,12 get WLOTE   picture "@!"       valid ! empty(WLOTE) .and. checkLoteNoBancoDeSemen() 
      @ 07,12 get WDOADOR picture "@!"

      @ 09,12 get WHIST1
      @ 10,12 get WHIST2    
      @ 11,12 get WHIST3
      @ 12,12 get WHIST4
      @ 13,12 get WHIST5

      @ 15,12 get WQTDE  picture "@Z 999999" valid WQTDE >= 1    
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select ENT_BS
         ordsetfocus("SINC001")
         go bottom

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

         save_ENTRADA_BS("INC")

         // efetua a entrada no estoque do banco de sêmen 

         select BCO_SEM 
         ordsetfocus("SINC001") 
         seek WLOTE

         if found()
            if reglock() 
               replace QTDE with QTDE + WQTDE
               grava()
            endif 
         else 
            if iSEQUENCIAL()
               replace LOTE     with WLOTE,;
                       DOADOR   with WDOADOR,;
                       DATA     with WDATA,;
                       HIST1    with WHIST1,;
                       HIST2    with WHIST2,;      
                       HIST3    with WHIST3,;  
                       HIST4    with WHIST4,;
                       HIST5    with WHIST5,;                
                       QTDE     with WQTDE,;  
                       USER_INC with WPUSUARIO,;
                       DATE_INC with DATE(),;
                       TIME_INC with TIME()
               grava()         
            endif 
         endif   

         exit

      endif

   enddo

enddo

return .t. 


********************************
function checkLoteNoBancoDeSemen
********************************

select BCO_SEM 
ordsetfocus("SINC001") 
seek WLOTE

if found()
   MENSAGEM("AVISO!;Lote j"+chr(160)+" cadastrado no banco de s"+chr(136)+"men.")
endif 

return .t.


***********************
function ALT_ENTRADA_BS
*********************** 

do while .t.

   sc_ENTRADA_BS()

   WSEQ = 0
    
   @ 03,12 get WSEQ picture "@Z 999999"
   read_f()
  
   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select ENT_BS
   ordsetfocus("SINC001")
   seek WSEQ

   if ! found()
      MENSAGEM("ERRO!;Sequ"+chr(136)+"ncia de entrada n"+chr(132)+"o cadastrada!",0)
      loop
   endif 

   WLOTE   = LOTE
   WDOADOR = DOADOR 
   WDATA   = DATA    
   WHIST1  = HIST1  
   WHIST2  = HIST2  
   WHIST3  = HIST3  
   WHIST4  = HIST4  
   WHIST5  = HIST5  
   WQTDE   = QTDE  

   oldLOTE = LOTE 
   oldQTDE = QTDE   

   do while .t. 

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
          
      @ 03,12 say strzero(WSEQ,6)
      @ 03,71 say WDATA

      @ 05,12 get WLOTE   picture "@!"         valid ! empty(WLOTE)   
      @ 07,12 get WDOADOR picture "@!"
      
      @ 09,12 get WHIST1
      @ 10,12 get WHIST2    
      @ 11,12 get WHIST3
      @ 12,12 get WHIST4
      @ 13,12 get WHIST5

      @ 15,12 get WQTDE   picture "@Z 999999"  valid WQTDE >= 1    
      read_f()

      if lastkey() == 27
        return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
        select ENT_BS
        save_ENTRADA_BS("ALT")

        // estorna a entrada anterior 

        select BCO_SEM 
        ordsetfocus("SINC001") 
        seek oldLOTE

        if found()
           if reglock() 
              replace QTDE with QTDE - oldQTDE
              grava()
           endif 
        endif 

        // efetua a entrada no estoque do banco de sêmen 

        select BCO_SEM 
        ordsetfocus("SINC001") 
        seek WLOTE

        if found()
           if reglock() 
              replace QTDE with QTDE + WQTDE
              grava()
           endif 
        else 
           if iSEQUENCIAL()
              replace LOTE     with WLOTE,;
                      DOADOR   with WDOADOR,;
                      DATA     with WDATA,;
                      HIST1    with WHIST1,;
                      HIST2    with WHIST2,;      
                      HIST3    with WHIST3,;  
                      HIST4    with WHIST4,;
                      HIST5    with WHIST5,;                
                      QTDE     with WQTDE,;  
                      USER_INC with WPUSUARIO,;
                      DATE_INC with DATE(),;
                      TIME_INC with TIME()
              grava()         
           endif 
        endif   

        exit
      endif
      
   enddo

enddo

return .t. 


***********************
function CON_ENTRADA_BS
***********************
LOCAL WCOR := setcolor()
LOCAL WOPC  

do while .t.

   WOPC = 6

   sc_ENTRADA_BS()

   SOMBRA(07,13,16,68,8)

   setcolor(COR_CONS)
   @ 06,11 clear to 15,67
   @ 06,11 to 15,67 

   @ 07,13 say "Consulta a partir do inicio do arquivo............[1]"
   @ 08,13 say "Consulta a partir do final do arquivo.............[2]"
   @ 09,13 say "Consulta a partir da sequ"+chr(136)+"ncia....................[3]"
   @ 10,13 say "Consulta a partir do lote.........................[4]"
   @ 11,13 say "Consulta a partir da data de entrada..............[5]"
   @ 12,13 say "Retorno ao menu principal.........................[6]"

   setcolor("W/N,W/N,,,W/N")
   @ 14,13 say "Escolha sua op"+chr(135)+chr(132)+"o.................................[ ]"
   @ 14,64 get WOPC picture "9" range 1,6
   read_f()

   if WOPC == 5 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_ENTRADA_BS()

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select ENT_BS
      ordsetfocus("SINC001")
      go top

    elseif WOPC == 2
      select ENT_BS
      ordsetfocus("SINC001")
      go bottom

      if eof()
        skip -1
      endif

    elseif WOPC == 3   

      do while .t.

         WSEQ = 0
  
         @ 03,12 get WSEQ picture "@Z 999999"       
         read_f()
 
         if empty(WSEQ) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select ENT_BS
         ordsetfocus("SINC001")
         seek WSEQ 

         if ! found()
            MENSAGEM("ERRO!;Sequ"+chr(136)+"ncia de entrada n"+chr(132)+"o cadastrada!",0)
            loop
         endif

      exit
      enddo

    elseif WOPC == 4

      do while .t.

         WLOTE = space(20)
  
         @ 05,12 get WLOTE picture "@!"       
         read_f()
 
         if empty(WLOTE) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select ENT_BS
         ordsetfocus("SINC002")
         seek WSEQ 

         if ! found()
            MENSAGEM("ERRO!;N"+chr(163)+"mero de lote n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

    elseif WOPC == 5
     
      WDATA = DATE()

      @ 03,71 get WDATA
      read_f()           
  
      if empty(WDATA) .or. lastkey() == 27
         WTRAVA = .t.
      else
         select ENT_BS
         ordsetfocus("SINC003")
         seek WDATA

         if eof()
            skip +1
         endif
      endif
 
    endif

    if WTRAVA
      loop
   endif

    do while .t.

       setcolor(COR_TEXT)
       CENTRO(24,"PgDw-Pr"+chr(162)+"ximo    PgUp-Anterior    ESC-FIM")

       @ 03,12 say strzero(SEQ,6)      
       @ 03,71 say DATA
       @ 05,12 say LOTE  picture "@!"   
       @ 07,12 say DOADOR    
       @ 09,12 say HIST1
       @ 10,12 say HIST2    
       @ 11,12 say HIST3
       @ 12,12 say HIST4
       @ 13,12 say HIST5
       @ 15,12 say QTDE  picture "@Z 999999"   
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
function EXC_ENTRADA_BS 
***********************

do while .t.

   sc_ENTRADA_BS()
   
   WSEQ = 0

   @ 03,12 get WSEQ picture "@Z 999999"     
   read_f()
   
   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select ENT_BS
   ordsetfocus("SINC001")
   seek WSEQ

   if ! found()
      MENSAGEM("ERRO!;Sequ"+chr(136)+"ncia de entrada n"+chr(132)+"o cadastrada!",0)
      return .f.
   endif 
   
   @ 03,12 say strzero(WSEQ,6)
   @ 03,71 say DATA
   @ 05,12 say LOTE   picture "@!"      
   @ 07,12 say HIST1
   @ 08,12 say HIST2    
   @ 09,12 say HIST3
   @ 10,12 say HIST4
   @ 11,12 say HIST5
   @ 13,12 say QTDE   picture "999999"   
     
   oldLOTE = LOTE 
   oldQTDE = QTDE   

   if CONFIRMA(24,"Excluir essa entrada...(S/N)?","N") = "S"
      select ENT_BS
     
      if ! reglock()
         loop
      endif

      replace SEQ      with 0,;
              LOTE     with space(20),;
              DATA     with ctod(space(08)),;
              HIST1    with space(64),;
              HIST2    with space(64),;
              HIST3    with space(64),;
              HIST4    with space(64),;
              HIST5    with space(64),;
              QTDE     with 0,;      
              USER_INC with space(20),;
              DATE_INC with ctod(space(08)),;
              TIME_INC with space(08),;
              USER_ALT with space(20),;
              DATE_ALT with ctod(space(08)),;
              TIME_ALT with space(08),;
              USER_CAN with space(20),;
              DATE_CAN with ctod(space(08)),;
              TIME_CAN with space(08),;
              USER_EXC with space(20),;
              DATE_EXC with ctod(space(08)),;
              TIME_EXC with space(08),;
              USER_BX  with space(20),;
              DATE_BX  with ctod(space(08)),;
              TIME_BX  with space(08)
     delete
     grava()

     // estorna a entrada anterior 

     select BCO_SEM 
     ordsetfocus("SINC001") 
     seek oldLOTE

     if found()
        if reglock() 
           replace QTDE with QTDE - oldQTDE
           grava()
        endif 
     endif 

   endif
 
enddo

return .t.


********************************
function save_ENTRADA_BS(MODULO)
********************************    

select ENT_BS

if ! reglock()
   return .t.
endif

replace LOTE  with WLOTE,;
        DATA  with WDATA,;
        HIST1 with WHIST1,;
        HIST2 with WHIST2,;
        HIST3 with WHIST3,;
        HIST4 with WHIST4,;
        HIST5 with WHIST5,;
        QTDE  with WQTDE      
        
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


********************
function SC_SAIDA_BS
********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79 
@ 24,00 clear to 24,79 

@ 03,01 say "Sequ"+chr(136)+"ncia:"
@ 03,65 say "Data:"
@ 05,01 say "Lote.....:"
@ 07,01 say "Doador...:"
@ 09,01 say "Hist"+chr(162)+"rico:"
@ 15,01 say "Qtde (-).:"

return .t.


*********************
function INC_SAIDA_BS
*********************

do while .t.
  
   sc_SAIDA_BS()

   WDATA   = date()
   WLOTE   = space(20)
   WDOADOR = space(50)
   WHIST1  = space(64)
   WHIST2  = space(64)
   WHIST3  = space(64)
   WHIST4  = space(64)
   WHIST5  = space(64)
   WQTDE   = 0

   select SAI_BS
   ordsetfocus("SINC001")
   go bottom

   WSEQ = SEQ + 1

   @ 03,12 say strzero(WSEQ,6)
  
   do while .t. 
  
      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
        
      @ 03,71 get WDATA
      @ 05,12 get WLOTE  picture "@!"     valid buscaBX_BS()

      @ 09,12 get WHIST1
      @ 10,12 get WHIST2    
      @ 11,12 get WHIST3
      @ 12,12 get WHIST4
      @ 13,12 get WHIST5
      
      @ 15,12 get WQTDE  picture "999999" valid checaSaldo_BS()    
      read_f()

      if lastkey() == 27
        return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select SAI_BS
         ordsetfocus("SINC001")
         go bottom

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

         save_SAIDA_BS("INC")

         // baixa a qtde da dosagem no banco de sêmen 

         select BCO_SEM 
         ordsetfocus("SINC001") 
         seek WLOTE
    
         if found()
            if reglock() 
               replace BAIXA with BAIXA + WQTDE
               grava()
            endif 
         endif 

         exit
      endif

  enddo

enddo

return .t. 


*******************
function buscaBX_BS
*******************
LOCAL WAREA := ALIAS() 

if lastkey() == 27
   return .t.
endif 

if empty(WLOTE)
   help_BCO_SEMEN()
   select BCO_SEM 
   WLOTE = LOTE
   select &WAREA 
   return .f.
endif

select BCO_SEM 
ordsetfocus("SINC001") 
seek WLOTE

if ! found()
   MENSAGEM("ERRO!;N"+chr(163)+"mero de Lote n"+chr(132)+"o cadastrado!",0)
   select &WAREA 
   return .f.
endif

WDOADOR = DOADOR 
@ 07,12 say WDOADOR 

select &WAREA 

return .t.


**********************
function checaSaldo_BS
**********************
LOCAL WAREA := ALIAS() 

select BCO_SEM 
ordsetfocus("SINC001")
seek WLOTE

if ! found()
   MENSAGEM("ERRO!;N"+chr(163)+"mero de Lote n"+chr(132)+"o cadastrado!",0)
   select &WAREA 
   return .f.
endif 

WSALDO = (QTDE - BAIXA)

if WQTDE > WSALDO
   MENSAGEM("ERRO!;A dose informada excede o saldo do do banco de s"+chr(136)+"men!",0)
   select &WAREA 
   return .f.
endif 

select &WAREA 

return .t.


*********************
function ALT_SAIDA_BS
********************* 

do while .t.

   sc_SAIDA_BS()

   WSEQ = 0
    
   @ 03,12 get WSEQ picture "@Z 999999"
   read_f()
 
   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select SAI_BS
   ordsetfocus("SINC001")
   seek WSEQ

   if ! found()
      MENSAGEM("ERRO!;Sequ"+chr(136)+"ncia de saida n"+chr(132)+"o cadastrada!",0)
      loop
   endif 

   WLOTE   = LOTE
   WDOADOR = DOADOR
   WDATA   = DATA    
   WHIST1  = HIST1  
   WHIST2  = HIST2  
   WHIST3  = HIST3  
   WHIST4  = HIST4  
   WHIST5  = HIST5  
   WQTDE   = QTDE  
   oldLOTE = LOTE 
   oldQTDE = QTDE   

   do while .t. 

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 03,12 say strzero(WSEQ,6) 
      @ 07,12 say WDOADOR 

      @ 03,71 say WDATA
      @ 05,12 get WLOTE  picture "@!"      valid ! empty(WLOTE)   

      @ 09,12 get WHIST1
      @ 10,12 get WHIST2    
      @ 11,12 get WHIST3
      @ 12,12 get WHIST4
      @ 13,12 get WHIST5

      @ 15,12 get WQTDE  picture "999999"  valid WQTDE >= 1    
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select SAI_BS
         save_SAIDA_BS("ALT")

         // estona a baixa da qtde da dosagem no banco de sêmen 

         select BCO_SEM 
         ordsetfocus("SINC001") 
         seek oldLOTE
    
         if found()
            if reglock() 
               replace BAIXA with BAIXA - oldQTDE

               if BAIXA < 0 
                  replace BAIXA with 0
               endif 
               grava()
            endif 
         endif 

         // baixa a qtde da dosagem no banco de sêmen 

         select BCO_SEM 
         ordsetfocus("SINC001") 
         seek WLOTE
    
         if found()
            if reglock() 
               replace BAIXA with BAIXA + WQTDE
               grava()
            endif 
         endif 

         exit
      endif
      
   enddo

enddo

return .t. 


*********************
function CON_SAIDA_BS
*********************
LOCAL WCOR := setcolor()
LOCAL WOPC  

do while .t.

   WOPC = 6

   sc_SAIDA_BS()

   SOMBRA(07,13,16,68,8)

   setcolor(COR_CONS)
   @ 06,11 clear to 15,67
   @ 06,11 to 15,67 

   @ 07,13 say "Consulta a partir do inicio do arquivo............[1]"
   @ 08,13 say "Consulta a partir do final do arquivo.............[2]"
   @ 09,13 say "Consulta a partir da sequ"+chr(136)+"ncia....................[3]"
   @ 10,13 say "Consulta a partir do lote.........................[4]"
   @ 11,13 say "Consulta a partir da data de saida................[5]"
   @ 12,13 say "Retorno ao menu principal.........................[6]"

   setcolor("W/N,W/N,,,W/N")
   @ 14,13 say "Escolha sua op"+chr(135)+chr(132)+"o.................................[ ]"
   @ 14,64 get WOPC picture "9" range 1,6
   read_f()

   if WOPC == 5 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_SAIDA_BS()

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select SAI_BS
      ordsetfocus("SINC001")
      go top

    elseif WOPC == 2
      select SAI_BS
      ordsetfocus("SINC001")
      go bottom

      if eof()
        skip -1
      endif

    elseif WOPC == 3   

      do while .t.

         WSEQ = 0
  
         @ 03,12 get WSEQ picture "@Z 999999"       
         read_f()
 
         if empty(WSEQ) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select SAI_BS
         ordsetfocus("SINC001")
         seek WSEQ 

         if ! found()
            MENSAGEM("ERRO!;Sequ"+chr(136)+"ncia de saida n"+chr(132)+"o cadastrada!",0)
            loop
         endif

      exit
      enddo

    elseif WOPC == 4

      do while .t.

         WLOTE = space(20)
  
         @ 05,12 get WLOTE picture "@!"       
         read_f()
 
         if empty(WLOTE) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select SAI_BS
         ordsetfocus("SINC002")
         seek WSEQ 

         if ! found()
            MENSAGEM("ERRO!;N"+chr(163)+"mero de lote n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

    elseif WOPC == 5
     
      WDATA = DATE()

      @ 03,71 get WDATA
      read_f()           
  
      if empty(WDATA) .or. lastkey() == 27
         WTRAVA = .t.
      else
         select SAI_BS
         ordsetfocus("SINC003")
         seek WDATA

         if eof()
            skip +1
         endif
      endif
 
    endif

    if WTRAVA
      loop
   endif

    do while .t.

       setcolor(COR_TEXT)
       CENTRO(24,"PgDw-Pr"+chr(162)+"ximo    PgUp-Anterior    ESC-FIM")

       @ 03,12 say strzero(SEQ,6)      
       @ 03,71 say DATA
       @ 05,12 say LOTE  picture "@!"     
       @ 07,12 say DOADOR 
       @ 09,12 say HIST1
       @ 10,12 say HIST2    
       @ 11,12 say HIST3
       @ 12,12 say HIST4
       @ 13,12 say HIST5
       @ 15,12 say QTDE  picture "999999"   
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
function EXC_SAIDA_BS 
*********************

do while .t.

   sc_SAIDA_BS()
   
   WSEQ = 0

   @ 03,12 get WSEQ picture "@Z 999999"     
   read_f()
   
   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select SAI_BS
   ordsetfocus("SINC001")
   seek WSEQ

   if ! found()
      MENSAGEM("ERRO!;Sequ"+chr(136)+"ncia de saida n"+chr(132)+"o cadastrada!",0)
      return .f.
   endif 
     
   @ 03,12 say strzero(WSEQ,6)
   @ 03,71 say DATA
   @ 05,12 say LOTE   picture "@!"  
   @ 07,12 say DOADOR     
   @ 09,12 say HIST1
   @ 10,12 say HIST2    
   @ 11,12 say HIST3
   @ 12,12 say HIST4
   @ 13,12 say HIST5
   @ 15,12 say QTDE   picture "999999"   
     
   if CONFIRMA(24,"Excluir essa saida...(S/N)?","N") = "S"
      select SAI_BS
     
      if ! reglock()
         loop
      endif

      replace SEQ      with 0,;
              DATA     with ctod(space(08)),;
              LOTE     with space(20),;
              DOADOR   with space(50),;
              HIST1    with space(64),;
              HIST2    with space(64),;
              HIST3    with space(64),;
              HIST4    with space(64),;
              HIST5    with space(64),;
              QTDE     with 0,;      
              USER_INC with space(20),;
              DATE_INC with ctod(space(08)),;
              TIME_INC with space(08),;
              USER_ALT with space(20),;
              DATE_ALT with ctod(space(08)),;
              TIME_ALT with space(08),;
              USER_CAN with space(20),;
              DATE_CAN with ctod(space(08)),;
              TIME_CAN with space(08),;
              USER_EXC with space(20),;
              DATE_EXC with ctod(space(08)),;
              TIME_EXC with space(08),;
              USER_BX  with space(20),;
              DATE_BX  with ctod(space(08)),;
              TIME_BX  with space(08)
     delete
     grava()
   endif
 
enddo

return .t.


******************************
function save_SAIDA_BS(MODULO)
******************************    

select SAI_BS

if ! reglock()
   return .t.
endif

replace LOTE   with WLOTE,;
        DOADOR with WDOADOR,;
        DATA   with WDATA,;
        HIST1  with WHIST1,;
        HIST2  with WHIST2,;
        HIST3  with WHIST3,;
        HIST4  with WHIST4,;
        HIST5  with WHIST5,;
        QTDE   with WQTDE      
        
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

