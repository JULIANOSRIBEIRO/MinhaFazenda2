*********************************************************************
****  Sistema......: MF-Minha Fazenda (Gerenciador)              ****
****  Versao.......: 5.0                                         ****
****  Programa.....: MFZ023.PRG                                  ****
****  Finalidade...: DADOS DE REPRODUÇÃO                         ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versão.......: xHARBOUR                                    ****
*********************************************************************

*********************
function sc_BCO_SEMEN 
*********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79 
@ 24,00 clear to 24,79 

@ 03,01 say "Lote........:"
@ 03,65 say "Data:"
@ 05,01 say "Hist"+chr(162)+"rico...:"
@ 11,01 say "Doador......:"
@ 13,01 say "(+) Qtde....:"
@ 15,01 say "(-) Baixa...:"
@ 17,01 say "(=) Saldo...:"

return .t.

**********************
function INC_BCO_SEMEN
**********************

do while .t.

   sc_BCO_SEMEN()
   
   WLOTE   = space(20)
   WDATA   = ctod(space(08))
   WDOADOR = space(50)
   WHIST1  = space(64)
   WHIST2  = space(64)
   WHIST3  = space(64)
   WHIST4  = space(64)
   WHIST5  = space(64)
   WQTDE   = 0
   WBAIXA  = 0

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 03,15 get WLOTE     picture "@!"       valid checaLoteNoBancoDeSemen()
      @ 03,71 get WDATA
      
      @ 05,15 get WHIST1
      @ 06,15 get WHIST2    
      @ 07,15 get WHIST3
      @ 08,15 get WHIST4
      @ 09,15 get WHIST5
      
      @ 11,15 get WDOADOR   picture "@!"
      
      @ 13,15 get WQTDE     picture "999999"    valid exibeSaldoBancoSemen(WQTDE, WBAIXA)
      @ 15,15 get WBAIXA    picture "999999"    valid exibeSaldoBancoSemen(WQTDE, WBAIXA)
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if empty(WLOTE) .or. empty(WDATA) .or. empty(WDOADOR) .or. empty(WQTDE)
         MENSAGEM("ERRO!;Preencha todos os campos obrigat"+chr(162)+"rios!",0)
         loop
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
 
         select BCO_SEM
         
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

         grava() 

         save_BCO_SEM("INC")

         exit

      endif

    enddo
 
enddo

return .t.

********************************
function checaLoteNoBancoDeSemen
********************************

if empty(WLOTE)
   return .t.
endif 

select BCO_SEM 
ordsetfocus("SINC001")
seek WLOTE 

if found()
   MENSAGEM("ERRO!;N"+chr(163)+"mero de Lote j"+chr(160)+" cadastrado!",0)
   return .f.
endif 

return .t.

***************************************
function exibeSaldoBancoSemen(WQT, WBX)
***************************************
WSLD = WQT - WBX
@ 17,15 say WSLD picture "999999"

return .t.

**********************
function ALT_BCO_SEMEN
**********************

do while .t.

   sc_BCO_SEMEN()
   
   WLOTE = space(20)

   @ 03,15 get WLOTE picture "@!"      
   read_f()

   if empty(WLOTE) .or. lastkey() == 27
      return .t.
   endif

   select BCO_SEM 
   ordsetfocus("SINC001")
   seek WLOTE 

   if ! found()
      MENSAGEM("ERRO!;N"+chr(163)+"mero de Lote n"+chr(132)+"o cadastrado!",0)
      return .f.
   endif 

   WDATA   = DATA   
   WDOADOR = DOADOR 
   WHIST1  = HIST1  
   WHIST2  = HIST2  
   WHIST3  = HIST3  
   WHIST4  = HIST4  
   WHIST5  = HIST5  
   WQTDE   = QTDE   
   WBAIXA  = BAIXA  

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
      
      @ 03,71 get WDATA
      
      @ 05,15 get WHIST1
      @ 06,15 get WHIST2    
      @ 07,15 get WHIST3
      @ 08,15 get WHIST4
      @ 09,15 get WHIST5
      
      @ 11,15 get WDOADOR   picture "@!"
      
      @ 13,15 get WQTDE     picture "999999"    valid exibeSaldoBancoSemen(WQTDE, WBAIXA)
      @ 15,15 get WBAIXA    picture "999999"    valid exibeSaldoBancoSemen(WQTDE, WBAIXA)
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if empty(WDATA) .or. empty(WDOADOR) .or. empty(WQTDE)
         MENSAGEM("ERRO!;Preencha todos os campos obrigat"+chr(162)+"rios!",0)
         loop
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select BCO_SEM
         save_BCO_SEM("INC")
         exit
      endif

    enddo
 
enddo

return .t.


**********************
function CON_BCO_SENEN 
**********************
LOCAL WCOR := setcolor()
LOCAL WOPC  

do while .t.
   
   WOPC = 6

   sc_BCO_SEMEN()
   
   SOMBRA(08,13,17,68,8)

   setcolor(COR_CONS)
   @ 07,11 clear to 16,67
   @ 07,11 to 16,67 

   @ 08,13 say "Consulta a partir do inicio do arquivo............[1]"
   @ 09,13 say "Consulta a partir do final do arquivo.............[2]"
   @ 10,13 say "Consulta a partir do numero de lote...............[3]"
   @ 11,13 say "Consulta a partir da data de cadastro.............[4]"
   @ 12,13 say "Consulta a partir do doador.......................[5]"
   @ 13,13 say "Retorno ao menu principal.........................[6]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,13 say "Escolha sua op"+chr(135)+chr(132)+"o.................................[ ]"
   @ 15,64 get WOPC picture "9" range 1,6
   read_f()

   if WOPC == 6 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_BCO_SEMEN()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select BCO_SEM
      ordsetfocus("SINC001")
      go top

   elseif WOPC == 2
      select BCO_SEM
      ordsetfocus("SINC001")
      go bottom

      if eof()
         skip -1
      endif

   elseif WOPC == 3   

      do while .t.

         WLOTE = space(20)
  
         @ 03,15 get WLOTE picture "@!"
         read_f()
 
         if empty(WLOTE) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select BCO_SEM
         ordsetfocus("SINC001")
         seek WLOTE 

         if ! found()
             MENSAGEM("ERRO!;N"+chr(163)+"mero de Lote n"+chr(132)+"o cadastrado!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC == 4

      do while .t.

         WDATA = DATE()

         @ 03,71 get WDATA
         read_f()           
  
         if empty(WDATA) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select BCO_SEM
         ordsetfocus("SINC002")
         seek WDATA
          
         if eof()
            skip -1
         endif
         
      exit 
      enddo

   elseif WOPC == 5
 
      do while .t.

         WDOADOR = space(50)
         
         @ 11,15 get WDOADOR
         read_f()           
  
         if empty(WDOADOR) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select BCO_SEM
         ordsetfocus("SINC003")
         seek WDOADOR  
          
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

      @ 03,15 say LOTE picture "@!"      
      @ 03,71 say DATA
      
      @ 05,15 say HIST1
      @ 06,15 say HIST2    
      @ 07,15 say HIST3
      @ 08,15 say HIST4
      @ 09,15 say HIST5
      
      @ 11,15 say DOADOR   picture "@!"
      
      @ 13,15 say QTDE     picture "999999"   
      @ 15,15 say BAIXA    picture "999999"   
 
      exibeSaldoBancoSemen(QTDE, BAIXA)

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
function EXC_BCO_SEMEN
**********************

do while .t.

   sc_BCO_SEMEN()
   
   WLOTE = space(20)

   @ 03,15 get WLOTE picture "@!"      
   read_f()

   if empty(WLOTE) .or. lastkey() == 27
      return .t.
   endif

   select BCO_SEM 
   ordsetfocus("SINC001")
   seek WLOTE 

   if ! found()
      MENSAGEM("ERRO!;N"+chr(163)+"mero de Lote n"+chr(132)+"o cadastrado!",0)
      return .f.
   endif 

   @ 03,15 say LOTE picture "@!"      
   @ 03,71 say DATA
      
   @ 05,15 say HIST1
   @ 06,15 say HIST2    
   @ 07,15 say HIST3
   @ 08,15 say HIST4
   @ 09,15 say HIST5
      
   @ 11,15 say DOADOR   picture "@!"
    
   @ 13,15 say QTDE     picture "999999"   
   @ 15,15 say BAIXA    picture "999999"   
 
   exibeSaldoBancoSemen(QTDE, BAIXA)

   if CONFIRMA(24,"Excluir esse lote...(S/N)?","N") = "S"
      select BCO_SEM
     
      if ! reglock()
         loop
      endif

      replace LOTE     with space(20),;
              DATA     with ctod(space(08)),;
              HIST1    with space(64),;
              HIST2    with space(64),;
              HIST3    with space(64),;
              HIST4    with space(64),;
              HIST5    with space(64),;
              DOADOR   with space(50),;
              QTDE     with 0,;       
              BAIXA    with 0,;
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
   endif
 
enddo

return .t.

*****************************
function save_BCO_SEM(MODULO)
*****************************

if ! reglock()
   return .t.
endif

replace LOTE   with WLOTE,;
        DATA   with WDATA,;
        HIST1  with WHIST1,;
        HIST2  with WHIST2,;
        HIST3  with WHIST3,;
        HIST4  with WHIST4,;
        HIST5  with WHIST5,;
        DOADOR with WDOADOR,;
        QTDE   with WQTDE,;       
        BAIXA  with WBAIXA
             
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


**********************
function SC_REPRODUCAO 
**********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79 
@ 24,00 clear to 24,79 

@ 02,01 say "Sequ"+chr(136)+"ncia.:"
@ 02,59 say "Data:"      
@ 03,01 say "Brinco....:"
@ 03,59 say "Tipo:"

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
@ 08,03 say "Lote.......:"
@ 08,31 say "Dose:" 
@ 08,56 say "M"+chr(130)+"todo:"
@ 09,03 say "Touro......:"

setcolor(COR_CONS)
@ 10,01 clear to 10,78
@ 10,01 say chr(175)+" Transplante de Embri"+chr(132)+"o (TE)"
setcolor(COR_TEXT)
@ 11,03 say "Touro......:"
@ 12,03 say "M"+chr(132)+"e........:"
@ 13,03 say "Receptora..:"

setcolor(COR_CONS)
@ 14,01 clear to 14,78
CENTRO(14,"Observa"+chr(135)+chr(148)+"es")
setcolor(COR_TEXT)

setcolor(COR_CONS)
@ 20,01 clear to 20,78
CENTRO(20,"Confirma"+chr(135)+chr(132)+"o da Preenhez")
setcolor(COR_TEXT)

@ 21,01 say "Confirmado.?"
@ 21,61 say "Data:"
@ 22,01 say "Respons"+chr(160)+"vel:"

return .t.


***********************
function INC_REPRODUCAO
***********************

do while .t.

   WDATA       = DATE() 
   WBRINCO     = space(15) 
   WTIPO       = space(15)
   
   WCN_TOURO   = space(50)
   WCN_COMUNIC = ctod(space(08))
   WCN_NUMERO  = space(20) 
   
   WIA_LOTE    = space(20) 
   WIA_DOSE    = 0 
   WIA_METODO  = space(15)
   WIA_TOURO   = space(50)

   WTE_TOURO   = space(50) 
   WTE_MAE     = space(50)
   WTE_RECEP   = space(50) 
   
   WOBS1       = space(78)
   WOBS2       = space(78)
   WOBS3       = space(78)
   WOBS4       = space(78)
   WOBS5       = space(78)

   WCONFIRMA   = space(01) 
   WDATA_CONF  = ctod(space(08))
   WRESPONS    = space(50) 
 
   select REPRODUCAO
   ordsetfocus("SINC001")
   go bottom

   WSEQ = SEQ + 1
 
   SC_REPRODUCAO()

   setcolor(COR_TEXT)
   @ 02,13 say strzero(WSEQ,6)
   @ 02,65 say WDATA 

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 03,13 get WBRINCO picture "@!" valid busca6_BRINCO() .and. checaSeFemea()
      
      @ 03,65,09,78 get WTIPO;                                  
         LISTBOX {"Protocolo   ", "Cobertura   ", "Inserminacao", "Transplante "};
         DROPDOWN SCROLLBAR;
         COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
         MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar as op"+chr(135)+chr(148)+"es v"+chr(160)+"lidas."; 
         VALID ! empty(WTIPO)

      read_f()

      if lastkey() == 27
         return .t.
      endif

      limpaTipoReproducao()

      if alltrim(WTIPO) == "Cobertura"
         @ 05,16 get WCN_TOURO    
         @ 06,16 get WCN_COMUNIC  
         @ 06,48 get WCN_NUMERO   

      elseif alltrim(WTIPO) == "Inserminacao"
         @ 08,16 get WIA_LOTE   picture "@!@S12"     valid buscaLoteBcoSemen() 
         @ 08,37 get WIA_DOSE   picture "@Z 99"      valid checaSaldoBancoDeSemen(0) 
         @ 08,64 get WIA_METODO picture "@!"  
         @ 09,16 say WIA_TOURO     

      elseif alltrim(WTIPO) == "Transplante"
         @ 11,16 get WTE_TOURO    
         @ 12,16 get WTE_MAE     
         @ 13,16 get WTE_RECEP    
      endif 

      @ 15,01 get WOBS1 
      @ 16,01 get WOBS2 
      @ 17,01 get WOBS3 
      @ 18,01 get WOBS4 
      @ 19,01 get WOBS5    
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
          
         select REPRODUCAO
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

         save_REPRODUCAO("INC")

         // baixa a dose utilizada no banco de sêmen 

         if alltrim(WTIPO) == "Inserminacao"
            select BCO_SEM 
            ordsetfocus("SINC001") 
            seek WIA_LOTE

            if found()
               if reglock() 
                  replace BAIXA with BAIXA + WIA_DOSE
                  grava()
               endif 
            endif 
         endif

         exit

      endif

    enddo
 
enddo

return .t.


***********************
function ALT_REPRODUCAO
***********************

do while .t.

   WSEQ = 0

   SC_REPRODUCAO()

   @ 02,13 get WSEQ picture "@Z 999999"
   read_f() 

   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select REPRODUCAO
   ordsetfocus("SINC001")
   seek WSEQ 

   if ! found()
      MENSAGEM("ERRO!;Sequ"+chr(136)+"ncia de controle n"+chr(132)+"o cadastrada!",0)
      loop
   endif 

   WDATA       = DATA      
   WBRINCO     = BRINCO    
   WTIPO       = left(TIPO,12)      
   WCN_TOURO   = CN_TOURO  
   WCN_COMUNIC = CN_COMUNIC 
   WCN_NUMERO  = CN_NUMERO 
   
   WIA_LOTE    = IA_LOTE   
   WIA_DOSE    = IA_DOSE   
   WIA_METODO  = IA_METODO 
   WIA_TOURO   = IA_TOURO  

   WTE_TOURO   = TE_TOURO  
   WTE_MAE     = TE_MAE    
   WTE_RECEP   = TE_RECEP  
   
   WOBS1       = OBS1      
   WOBS2       = OBS2      
   WOBS3       = OBS3      
   WOBS4       = OBS4      
   WOBS5       = OBS5      

   WCONFIRMA   = CONFIRMA  
   WDATA_CONF  = DATA_CONF 
   WRESPONS    = RESPONS   

   // var para estorno de estoque 
   oldTIPO     = TIPO 
   oldIA_LOTE  = IA_LOTE   
   oldIA_DOSE  = IA_DOSE   

   exibeDadosDaReproducao() 

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 03,65,09,78 get WTIPO;                                  
         LISTBOX {"Protocolo   ", "Cobertura   ", "Inserminacao", "Transplante "};
         DROPDOWN SCROLLBAR;
         COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
         MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar as op"+chr(135)+chr(148)+"es v"+chr(160)+"lidas."; 
         VALID ! empty(WTIPO)

      read_f()

      if lastkey() == 27
         return .t.
      endif

      limpaTipoReproducao()

      if alltrim(WTIPO) == "Cobertura"
         @ 05,16 get WCN_TOURO    
         @ 06,16 get WCN_COMUNIC  
         @ 06,48 get WCN_NUMERO   

      elseif alltrim(WTIPO) == "Inserminacao"
         @ 08,16 get WIA_LOTE   picture "@!@S12"     valid buscaLoteBcoSemen() 
         @ 08,37 get WIA_DOSE   picture "@Z 99"      valid checaSaldoBancoDeSemen(oldIA_DOSE) 
         @ 08,64 get WIA_METODO picture "@!"  
         @ 09,16 say WIA_TOURO     

      elseif alltrim(WTIPO) == "Transplante"
         @ 11,16 get WTE_TOURO    
         @ 12,16 get WTE_MAE     
         @ 13,16 get WTE_RECEP    
      endif 

      @ 15,01 get WOBS1 
      @ 16,01 get WOBS2 
      @ 17,01 get WOBS3 
      @ 18,01 get WOBS4 
      @ 19,01 get WOBS5 
      read_f()

      if lastkey() == 27
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
          
         select REPRODUCAO
         
         save_REPRODUCAO("ALT")

         // estorna a baixa da dose utilizada no banco de sêmen (-)

         if alltrim(oldTIPO) == "Inserminacao"
            select BCO_SEM 
            ordsetfocus("SINC001") 
            seek oldIA_LOTE

            if found()
               if reglock() 
                  replace BAIXA with BAIXA - oldIA_DOSE 
                  if BAIXA < 0 
                     replace BAIXA with 0
                  endif 
                  grava()
               endif 
            endif 
         endif

         // baixa a dose utilizada no banco de sêmen (+)

         if alltrim(WTIPO) == "Inserminacao"
            select BCO_SEM 
            ordsetfocus("SINC001") 
            seek WIA_LOTE

            if found()
               if reglock() 
                  replace BAIXA with BAIXA + WIA_DOSE
                  grava()
               endif 
            endif 
         endif

         exit

      endif

    enddo

enddo

return .t.


***********************
function CON_REPRODUCAO 
***********************
LOCAL WCOR := setcolor()
LOCAL WOPC  

do while .t.
   
   WOPC = 9

   SC_REPRODUCAO()
     
   SOMBRA(06,09,18,72,8)

   setcolor(COR_CONS)
   @ 05,07 clear to 17,71
   @ 05,07 to 17,71 

   @ 06,09 say "Consulta a partir do inicio do arquivo....................[1]"
   @ 07,09 say "Consulta a partir do final do arquivo.....................[2]"
   @ 08,09 say "Consulta a partir da sequ"+chr(136)+"ncia de controle................[3]"
   @ 09,09 say "Consulta a partir da data de inclusao.....................[4]"
   @ 10,09 say "Consulta a partir do n"+chr(163)+"mero do brinco.....................[5]"
   @ 11,09 say "Consulta a partir do nome do touro (CN)...................[6]"
   @ 12,09 say "Consulta a partir do lote (IA)............................[7]"
   @ 13,09 say "Consulta a partir do nome do touro (TE)...................[8]"
   @ 14,09 say "Retorno ao menu principal.................................[9]"

   setcolor("W/N,W/N,,,W/N")
   @ 16,09 say "Escolha sua op"+chr(135)+chr(132)+"o.........................................[ ]"
   @ 16,68 get WOPC picture "9" range 1,9
   read_f()

   if WOPC == 9 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   SC_REPRODUCAO()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select REPRODUCAO
      ordsetfocus("SINC001")
      go top

   elseif WOPC == 2
      select REPRODUCAO
      ordsetfocus("SINC001")
      go bottom

      if eof()
         skip -1
      endif

   elseif WOPC == 3   

      do while .t.

         WSEQ = 0
  
         @ 02,13 get WSEQ picture "@Z 999999"
         read_f() 
 
         if empty(WSEQ) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select REPRODUCAO
         ordsetfocus("SINC001")
         seek WSEQ 

         if ! found()
            MENSAGEM("ERRO!;Sequ"+chr(136)+"ncia de controle n"+chr(132)+"o cadastrada!",0)
            loop
         endif 

      exit
      enddo

   elseif WOPC == 4

      do while .t.

         WDATA = Date()
  
         @ 02,65 get WDATA
         read_f() 
 
         if empty(WDATA) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select REPRODUCAO
         ordsetfocus("SINC002")
         seek WDATA

         if eof()
            skip -1
         endif

      exit
      enddo

   elseif WOPC == 5

      do while .t.

         WBRINCO = space(08)

         @ 03,13 get WBRINCO picture "@!" valid busca6_BRINCO() .and. checaSeFemea()                     
         read_f()           
  
         if empty(WBRINCO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select REPRODUCAO
         ordsetfocus("SINC003")
         seek WBRINCO 

         if ! found()
            MENSAGEM("ERRO!;N"+chr(132)+"o houve lan"+chr(135)+"amento de reprodu"+chr(135)+chr(132)+"o para esse brinco!",0)
            loop
         endif 

      exit 
      enddo

   elseif WOPC == 6  
   
      do while .t.

         WCN_TOURO = space(50)

         @ 05,16 get WCN_TOURO                    
         read_f()           
  
         if empty(WCN_TOURO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select REPRODUCAO
         ordsetfocus("SINC004")
         seek WCN_TOURO

         if eof()
            skip -1
         endif

      exit 
      enddo

   elseif WOPC == 7  

       do while .t.

         WIA_LOTE = space(20) 

         @ 08,16 get WIA_LOTE picture "@!@S12"                  
         read_f()           
  
         if empty(WIA_LOTE) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select REPRODUCAO
         ordsetfocus("SINC005")
         seek WIA_LOTE

         if ! found()
            MENSAGEM("ERRO!;N"+chr(163)+"mero de lote de insermina"+chr(135)+chr(132)+"o artificial (IA) n"+chr(132)+"o cadastrado!",0)
            loop
         endif 

      exit 
      enddo

   elseif WOPC == 8  

      do while .t.

         WTE_TOURO = space(50)  

         @ 11,16 get WTE_TOURO                 
         read_f()           
  
         if empty(WTE_TOURO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select REPRODUCAO
         ordsetfocus("SINC006")
         seek WTE_TOURO

         if eof()
            skip -1
         endif

      exit 
      enddo

   endif

   if WTRAVA
      loop
   endif

   SC_REPRODUCAO()     

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo    PgUp-Anterior    P-Preenhez    R-Reg. Protocolo    ESC-FIM")

      exibeDadosDaReproducao()
      
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
      elseif lastkey() == 80 .or. lastkey() == 112   // Pp   
         alteraDadosDePreenhez() 
      elseif lastkey() == 82 .or. lastkey() == 114   // Rr 
         alteraRegistroDeProtocolo()    
      endif

   enddo

enddo

return .t.


******************************
function alteraDadosDePreenhez
******************************

select REPRODUCAO

if ! reglock()
   return .f.
endif 

@ 24,00 clear to 24,79

WOBS1      = OBS1      
WOBS2      = OBS2      
WOBS3      = OBS3      
WOBS4      = OBS4      
WOBS5      = OBS5   
WCONFIRMA  = CONFIRMA  
WDATA_CONF = DATA_CONF 
WRESPONS   = RESPONS   

do while .t.

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 15,01 get WOBS1 
   @ 16,01 get WOBS2 
   @ 17,01 get WOBS3 
   @ 18,01 get WOBS4 
   @ 19,01 get WOBS5 

   @ 21,14 get WCONFIRMA picture "!"  valid confirmaReproducao()
   @ 21,67 get WDATA_CONF 
   @ 22,14 get WRESPONS  
   read_f()

   if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
      select REPRODUCAO
      replace OBS1      with WOBS1,; 
              OBS2      with WOBS2,; 
              OBS3      with WOBS3,; 
              OBS4      with WOBS4,; 
              OBS5      with WOBS5,; 
              CONFIRMA  with WCONFIRMA,;  
              DATA_CONF with WDATA_CONF,; 
              RESPONS   with WRESPONS,;  
              USER_ALT  with WPUSUARIO,;
              DATE_ALT  with DATE(),;
              TIME_ALT  with TIME()
      grava() 
      exit 
   endif 

enddo

return .t.


**********************************
function alteraRegistroDeProtocolo
**********************************

select REPRODUCAO

if ! reglock()
   return .f.
endif

@ 24,00 clear to 24,79

WSEQ        = SEQ 
WDATA       = DATA      
WBRINCO     = BRINCO    
WTIPO       = left(TIPO,12)      
WCN_TOURO   = CN_TOURO  
WCN_COMUNIC = CN_COMUNIC 
WCN_NUMERO  = CN_NUMERO 
   
WIA_LOTE    = IA_LOTE   
WIA_DOSE    = IA_DOSE   
WIA_METODO  = IA_METODO 
WIA_TOURO   = IA_TOURO  

WTE_TOURO   = TE_TOURO  
WTE_MAE     = TE_MAE    
WTE_RECEP   = TE_RECEP  
   
WOBS1       = OBS1      
WOBS2       = OBS2      
WOBS3       = OBS3      
WOBS4       = OBS4      
WOBS5       = OBS5      

WCONFIRMA   = CONFIRMA  
WDATA_CONF  = DATA_CONF 
WRESPONS    = RESPONS   

// var para estorno de estoque 
oldTIPO     = TIPO 
oldIA_LOTE  = IA_LOTE   
oldIA_DOSE  = IA_DOSE   

do while .t.

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,65,09,78 get WTIPO;                                  
      LISTBOX {"Protocolo   ", "Cobertura   ", "Inserminacao", "Transplante "};
      DROPDOWN SCROLLBAR;
      COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
      MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar as op"+chr(135)+chr(148)+"es v"+chr(160)+"lidas."; 
      VALID ! empty(WTIPO)

   read_f()

   limpaTipoReproducao()

   if alltrim(WTIPO) == "Cobertura"
      @ 05,16 get WCN_TOURO    
      @ 06,16 get WCN_COMUNIC  
      @ 06,48 get WCN_NUMERO   

   elseif alltrim(WTIPO) == "Inserminacao"
      @ 08,16 get WIA_LOTE   picture "@!@S12"     valid buscaLoteBcoSemen() 
      @ 08,37 get WIA_DOSE   picture "@Z 99"      valid checaSaldoBancoDeSemen(oldIA_DOSE) 
      @ 08,64 get WIA_METODO picture "@!"  
      @ 09,16 say WIA_TOURO     

   elseif alltrim(WTIPO) == "Transplante"
      @ 11,16 get WTE_TOURO    
      @ 12,16 get WTE_MAE     
      @ 13,16 get WTE_RECEP    
   endif 

   @ 15,01 get WOBS1 
   @ 16,01 get WOBS2 
   @ 17,01 get WOBS3 
   @ 18,01 get WOBS4 
   @ 19,01 get WOBS5 
   read_f()

   if lastkey() == 27
      select REPRODUCAO
      grava()
      return .t.
   endif

   if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
          
      select REPRODUCAO
         
      save_REPRODUCAO("ALT")

      // estorna a baixa da dose utilizada no banco de sêmen (-)

      if alltrim(oldTIPO) == "Inserminacao"
         select BCO_SEM 
         ordsetfocus("SINC001") 
         seek oldIA_LOTE

         if found()
            if reglock() 
               replace BAIXA with BAIXA - oldIA_DOSE 
               if BAIXA < 0 
                  replace BAIXA with 0
               endif 
               grava()
            endif 
         endif 
      endif

      // baixa a dose utilizada no banco de sêmen (+)

      if alltrim(WTIPO) == "Inserminacao"
         select BCO_SEM 
         ordsetfocus("SINC001") 
         seek WIA_LOTE

         if found()
            if reglock() 
               replace BAIXA with BAIXA + WIA_DOSE
               grava()
            endif 
         endif 
      endif

      exit

   endif

enddo

return .t.


***********************
function EXC_REPRODUCAO
***********************

do while .t.

   WSEQ = 0

   SC_REPRODUCAO()

   @ 02,13 get WSEQ picture "@Z 999999"
   read_f() 

   if empty(WSEQ) .or. lastkey() == 27
      return .t.
   endif

   select REPRODUCAO
   ordsetfocus("SINC001")
   seek WSEQ 

   if ! found()
      MENSAGEM("ERRO!;Sequ"+chr(136)+"ncia de controle n"+chr(132)+"o cadastrada!",0)
      loop
   endif 

   // var para estorno de estoque 
   oldTIPO     = TIPO 
   oldIA_LOTE  = IA_LOTE   
   oldIA_DOSE  = IA_DOSE   

   exibeDadosDaReproducao() 

   if CONFIRMA(24,"Excluir esse registro...(S/N)?","N") = "S"
          
      select REPRODUCAO
     
      if ! reglock() 
         loop
      endif 
      
      replace BRINCO     with space(15),; 
              DATA       with ctod(space(08)),;
              TIPO       with space(15),;
              CN_TOURO   with space(50),; 
              CN_COMUNIC with ctod(space(08)),; 
              CN_NUMERO  with space(20),; 
              IA_LOTE    with space(20),; 
              IA_DOSE    with 0,;
              IA_METODO  with space(15),; 
              IA_TOURO   with space(50),; 
              TE_TOURO   with space(50),;  
              TE_MAE     with space(50),; 
              TE_RECEP   with space(50),;  
              OBS1       with space(78),; 
              OBS2       with space(78),; 
              OBS3       with space(78),; 
              OBS4       with space(78),; 
              OBS5       with space(78),; 
              CONFIRMA   with space(01),;  
              DATA_CONF  with ctod(space(08)),; 
              RESPONS    with space(50),;  
              USER_INC   with space(20),;
              DATE_INC   with ctod(space(08)),;
              TIME_INC   with space(08),;
              USER_ALT   with space(20),;
              DATE_ALT   with ctod(space(08)),;
              TIME_ALT   with space(08)
     
      delete
      grava()

      // estorna a baixa da dose utilizada no banco de sêmen (-)

      if alltrim(oldTIPO) == "Inserminacao"
         select BCO_SEM 
         ordsetfocus("SINC001") 
         seek oldIA_LOTE

         if found()
            if reglock() 
               replace BAIXA with BAIXA - oldIA_DOSE 
               if BAIXA < 0 
                  replace BAIXA with 0
               endif 
               grava()
            endif 
         endif 
      endif

      MENSAGEM("AVISO!;Registro exclu"+chr(161)+"do com sucesso.")

   endif

enddo

return .t.


*********************
function checaSeFemea
*********************

if lastkey() == 27
   return .t. 
endif 

select PLANTEL
ordsetfocus("SINC001")
seek WBRINCO

if found()
   if SEXO <> "F"
      MENSAGEM("ERRO!;Informe o brinco de um animal f"+chr(136)+"mea.",0)
      return .f.
   endif 
else 
   MENSAGEM("AVISO!;Como o sistema permite incluir um registro;sem o cadastro no plantel;o sistema n"+chr(132)+"o consegue checar se o brinco;"+chr(130)+" de um animal f"+chr(136)+"mea.",0) 
endif 

return .t.


****************************
function limpaTipoReproducao 
****************************

if alltrim(WTIPO) == "Cobertura"
   WIA_LOTE    = space(20) 
   WIA_DOSE    = 0 
   WIA_METODO  = space(15)
   WIA_TOURO   = space(50)
   WTE_TOURO   = space(50) 
   WTE_MAE     = space(50)
   WTE_RECEP   = space(50) 

   ColorWin(04,01,04,78,"W+/N")
   ColorWin(07,01,07,78,COR_CONS)
   ColorWin(10,01,10,78,COR_CONS)

elseif alltrim(WTIPO) == "Inserminacao"
   WCN_TOURO   = space(50)
   WCN_COMUNIC = ctod(space(08))
   WCN_NUMERO  = space(20) 
   WTE_TOURO   = space(50) 
   WTE_MAE     = space(50)
   WTE_RECEP   = space(50) 

   ColorWin(04,01,04,78,COR_CONS)
   ColorWin(07,01,07,78,"W+/N")
   ColorWin(10,01,10,78,COR_CONS)

elseif alltrim(WTIPO) == "Transplante"
   WCN_TOURO   = space(50)
   WCN_COMUNIC = ctod(space(08))
   WCN_NUMERO  = space(20)   
   WIA_LOTE    = space(20) 
   WIA_DOSE    = 0 
   WIA_METODO  = space(15)
   WIA_TOURO   = space(50)

   ColorWin(04,01,04,78,COR_CONS)
   ColorWin(07,01,07,78,COR_CONS)
   ColorWin(10,01,10,78,"W+/N")
endif 

@ 05,16 say WCN_TOURO    
@ 06,16 say WCN_COMUNIC  
@ 06,48 say WCN_NUMERO   

@ 08,16 say WIA_LOTE   picture "@!@S12"          
@ 08,37 say WIA_DOSE   picture "@Z 99"      
@ 08,64 say WIA_METODO picture "@!"  
@ 09,16 say WIA_TOURO     

@ 11,16 say WTE_TOURO    
@ 12,16 say WTE_MAE     
@ 13,16 say WTE_RECEP    

return .t.


***************************
function confirmaReproducao
***************************

if WCONFIRMA == "S"
   @ ROW(),COL() say "im"
elseif WCONFIRMA == "N"
   @ ROW(),COL() say chr(132)+"o"
else 
    @ ROW(),COL() say space(02)
   return .f.
endif 

return .t.


**************************
function buscaLoteBcoSemen
**************************

if lastkey() == 27
   return .t.
endif  

if empty(WIA_LOTE)
   help_BCO_SEMEN()
   select BCO_SEM
   WIA_LOTE = LOTE
   return .f.
endif 

select BCO_SEM 
ordsetfocus("SINC001")
seek WIA_LOTE

if ! found()
   MENSAGEM("ERRO!;N"+chr(163)+"mero de Lote n"+chr(132)+"o cadastrado!",0)
   return .f.
endif 

WIA_TOURO = DOADOR 
@ 09,16 say WIA_TOURO  

return .t.


******************************************
function checaSaldoBancoDeSemen(WSLD_DESC)
******************************************

select BCO_SEM 
ordsetfocus("SINC001")
seek WIA_LOTE

if ! found()
   MENSAGEM("ERRO!;N"+chr(163)+"mero de Lote n"+chr(132)+"o cadastrado!",0)
   return .f.
endif 

WSALDO = ((QTDE + WSLD_DESC) - BAIXA)

if WIA_DOSE > WSALDO
   MENSAGEM("ERRO!;A dose informada excede o saldo do do banco de s"+chr(136)+"men!",0)
   return .f.
endif 

return .t.

   
***********************
function help_BCO_SEMEN 
***********************
private WAREA := alias()
private WVAR  := readvar()
private WCOR  := setcolor()

select BCO_SEM
ordsetfocus("SINC001")

BRW_HELP("Saldo do Banco de S"+chr(136)+"men",.t., {;
{"LOTE"      ,"@S12","Lote"  },;
{"DOADOR"    ,""    ,"Doador"},;
{"QTDE-BAIXA","9999","Saldo" }})
 
select &WAREA
setcolor(WCOR)

return .f.


*******************************
function exibeDadosDaReproducao
*******************************

@ 02,13 say strzero(SEQ,6)
@ 02,65 say DATA 

@ 03,13 say BRINCO picture "99999999" 
@ 03,65 say TIPO

if alltrim(TIPO) == "Cobertura"
   ColorWin(04,01,04,78,"W+/N")
   ColorWin(07,01,07,78,COR_CONS)
   ColorWin(10,01,10,78,COR_CONS)
   
   @ 05,16 say CN_TOURO    
   @ 06,16 say CN_COMUNIC  
   @ 06,48 say CN_NUMERO   

elseif alltrim(TIPO) == "Inserminacao"
   ColorWin(04,01,04,78,COR_CONS)
   ColorWin(07,01,07,78,"W+/N")
   ColorWin(10,01,10,78,COR_CONS)

   @ 08,16 say IA_LOTE   picture "@!@S12"          
   @ 08,37 say IA_DOSE   picture "@Z 99"      
   @ 08,64 say IA_METODO picture "@!"  
   @ 09,16 say IA_TOURO   

elseif alltrim(TIPO) == "Transplante"
   ColorWin(04,01,04,78,COR_CONS)
   ColorWin(07,01,07,78,COR_CONS)
   ColorWin(10,01,10,78,"W+/N")

   @ 11,16 say TE_TOURO    
   @ 12,16 say TE_MAE     
   @ 13,16 say TE_RECEP    
endif 

@ 15,01 say OBS1 
@ 16,01 say OBS2 
@ 17,01 say OBS3 
@ 18,01 say OBS4 
@ 19,01 say OBS5 

@ 21,14 say if(CONFIRMA == "S","Sim","N"+chr(132)+"o")  
@ 21,67 say DATA_CONF 
@ 22,14 say RESPONS  

return .t.


********************************
function save_REPRODUCAO(MODULO)
********************************

select REPRODUCAO

if ! reglock() 
   return .f.
endif 

replace BRINCO     with WBRINCO,; 
        DATA       with WDATA,;
        TIPO       with WTIPO,;
        CN_TOURO   with WCN_TOURO,; 
        CN_COMUNIC with WCN_COMUNIC,; 
        CN_NUMERO  with WCN_NUMERO,; 
        IA_LOTE    with WIA_LOTE,; 
        IA_DOSE    with WIA_DOSE,;
        IA_METODO  with WIA_METODO,; 
        IA_TOURO   with WIA_TOURO,; 
        TE_TOURO   with WTE_TOURO,;  
        TE_MAE     with WTE_MAE,; 
        TE_RECEP   with WTE_RECEP,;  
        OBS1       with WOBS1,; 
        OBS2       with WOBS2,; 
        OBS3       with WOBS3,; 
        OBS4       with WOBS4,; 
        OBS5       with WOBS5,; 
        CONFIRMA   with WCONFIRMA,;  
        DATA_CONF  with WDATA_CONF,; 
        RESPONS    with WRESPONS   
 
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


**********************
function busca6_BRINCO
**********************

if lastkey() == 27
   return .t.
endif

if empty(WBRINCO)
   help_BRINCO()
   select PLANTEL
   WBRINCO = BRINCO
   return .f.
endif

select PLANTEL
ordsetfocus("SINC001")
seek WBRINCO

if ! found()
   mensagem("AVISO!;N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado no plantel.;O sistema permitira seguir com o cadastro.",0)
endif

return .t.