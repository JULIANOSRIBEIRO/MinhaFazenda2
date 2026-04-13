*********************************************************************
****  Sistema......: MF-Minha Fazenda                            ****
****  Programa.....: MFZ011.PRG                                  ****
****  Finalidade...: Gerenciamento das Pesagens dos Animais      ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************
#include "TBrowse.ch"
#include "inkey.ch"

************************
function leitura_PESAGEM
************************
WLOCAL = "C:\SISTEMA\MF\publico\pesos\"

do while .t.

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79

   setcolor(COR_TEXT)
   @ 03,01 say "Local dos aquivos...............: "+WLOCAL
   @ 05,01 say "Nome arquivo CSV a ser importado: "

   setcolor(COR_DEST)
   @ 20,01 say "#LAYOUT DO ARQUIVO"
   @ 21,01 say "1-Brinco; 2-Data (DD/MM/AAAA as HH:MM:SS); 3-Peso (999.999)"

   WN_ARQ = space(40)

   @ 05,35 get WN_ARQ  
   READ_F()
 
   if lastkey() == 27 .or. empty(WN_ARQ)
      return .t.
   endif

   if upper(right(alltrim(WN_ARQ),4)) <> ".CSV"
      MENSAGEM2("AVISO;Informe um arquivo no formato CSV.",0)
      loop
   endif 

   if ! file(WLOCAL+alltrim(WN_ARQ))
      MENSAGEM2("AVISO;Nome de arquivo n"+chr(132)+"o encontrado.",0)
      loop
   endif
    
   if CONFIRMA(24,"Confirma a importa"+chr(135)+chr(132)+"o...(S/N)?","N") = "N"
      loop
   endif
  
   WHANDLE1 = FOPEN(WLOCAL+alltrim(WN_ARQ),0)
   
   if FERROR() <> 0
      MENSAGEM("AVISO!;Erro na abertura do arquivo. Importa"+chr(135)+chr(132)+"o cancelada.")
      loop
   endif
   
   AGUARDE()    

   *************************************************************************************** cria a tabela temporaria

   WARQ  := pathMAIN+"\TAB"+strzero(HB_RandomInt(999,99999),5)

   WCMP  := {"ARQUIVO", "BRINCO", "DATA", "HORA", "PESO", "PLANTEL"}
   WTPO  := {"N"      , "C"     , "D"   , "C"   , "N"   , "C"      } 
   WTMO  := {08       , 15      , 08    , 08    , 14    , 10       }
   WDEC  := {00       , 00      , 00    , 00    , 06    , 00       }
   
   WIDX1 := "BRINCO"
   WIDX2 := ""
   WIDX3 := ""
   
   cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)

   ************************************************************************************ gera a numeracao do arquivo 

   WARQUIVO = val(right(str(year(DATE()),4),2)+strzero(month(DATE()),2)+strzero(day(DATE()),2)+"01")

   select PESAGEM
   ordsetfocus("SINC003")
   seek str(WARQUIVO,8)

   if found()
      for I=2 to 99
          WARQUIVO = val(right(str(year(DATE()),4),2)+strzero(month(DATE()),2)+strzero(day(DATE()),2)+strzero(I,2))
               
          select PESAGEM
          ordsetfocus("SINC003")
          seek str(WARQUIVO,8)
      
          if ! found()
             exit
          endif 
      next 
   endif 

   ****************************************************************************************************************

   WTOT_ANIMAIS = 0
   WTOT_PESO    = 0
   
   // insere os dados do arquivo importado

   WCHAR   = space(01)
   WSTRING = ""
   WCOLUNA = 0
   WBRINCO = space(15)
   WDT_HR  = ""
   WPESO   = 0
     
   C = 0

   do while .t.
   
      if fread(WHANDLE1, @WCHAR, 1) <> 1
         exit
      endif

      C++
   
      if C > 200
         C = 1
      endif
 
      if WCHAR = ";" .or. asc(WCHAR) == 13 .or. asc(WCHAR) == 10
         WCOLUNA++
 
         if WCOLUNA == 1 
            WBRINCO = WSTRING 
         elseif WCOLUNA == 2
            WDT_HR = WSTRING 
         elseif WCOLUNA == 3
            WPESO = val(WSTRING) 
         endif
 
         WSTRING = ""

      elseif asc(WCHAR) <> 13 .and. asc(WCHAR) <> 10 
         
         if WCHAR = ","
            WCHAR = "." 
         endif
   
         WSTRING = WSTRING + WCHAR
      endif

      if asc(WCHAR) == 13  .or. asc(WCHAR) == 10 

         // checa se o brinco esta cadastrado no plantel
         
         WPLANTEL = "N"

         select PLANTEL
         ordsetfocus("SINC001")
         seek left(alltrim(WBRINCO)+space(15),15)

         if found()
            WPLANTEL = "S"
         else
            for I=1 to 5 
                WNB = left(replicate("0",I)+alltrim(WBRINCO)+space(15),15)
 
                seek WNB 
       
                if found()
                   WPLANTEL = "S"
                   WBRINCO  = WNB  
                   exit 
                endif 
            next
         endif    
 
         if ! empty(WBRINCO) .and. WPESO > 0
            WTOT_ANIMAIS++
            WTOT_PESO = WTOT_PESO + WPESO
            WDATA     = ctod(left(WDT_HR,10))
            WHORA     = right(WDT_HR,8)

            select TMP 
            dbappend()
            replace ARQUIVO with WARQUIVO,;
                    BRINCO  with WBRINCO,;
                    DATA    with WDATA,;
                    HORA    with WHORA,;
                    PESO    with WPESO,;
                    PLANTEL with WPLANTEL
         endif 

         WCHAR   = space(01)
         WSTRING = ""
         WCOLUNA = 0
         WBRINCO = space(15)
         WDT_HR  = ""
         WPESO   = 0
     
      endif
   
   enddo
   
   fclose(WHANDLE1)

   @ 24,00 clear to 24,79

   select TMP
   ordsetfocus("SINC001")
   go top 
   
   BRW_HELP("IMPORTACAO DE PESAGENS",.t.,{;
   {"str(ARQUIVO,8)","99999999" ,"Arquivo"},;
   {"BRINCO"        ,""         ,"Brinco" },;   
   {"DATA"          ,""         ,"DATA"   },;
   {"HORA"          ,""         ,"Hora"   },;
   {"PESO"          ,"99999999" ,"Peso"   },;   
   {"PLANTEL"       ,""         ,"Plantel"}})
    
   @ 24,00 clear to 24,79
   if CONFIRMA(24,"Confirma a importa"+chr(135)+chr(132)+"o dos dados...(S/N)?","S") == "S"
   
      select TMP
      ordsetfocus("SINC001")
      go top 
   
      do while ! eof()

         WBRINCO  = BRINCO
         WDATA    = DATA 
         WHORA    = HORA 
         WPESO    = PESO  
         WPLANTEL = PLANTEL

         select PESAGEM
         ordsetfocus("SINC003")
         seek str(ARQUIVO,8)+WBRINCO+descend(dtos(WDATA))+descend(WHORA)

         if ! found()
            dbappend()
            replace ARQUIVO  with WARQUIVO,;
                    BRINCO   with WBRINCO,;
                    DATA     with WDATA,;
                    HORA     with WHORA,;
                    PESO     with WPESO,;
                    PLANTEL  with WPLANTEL,;
                    USER_INC with WPUSUARIO,;
                    DATE_INC with DATE(),;
                    TIME_INC with TIME()   
            grava()
         endif 

         select TMP
         skip +1

      enddo
   
   endif

   exclui_TMP("201", WARQ+".DBF", WARQ+".cdx" )    
   keyboard ""

   select PESAGEM
   
   setcolor(COR_TEXT)
   @ 06,00 clear to 22,79
   @ 24,00 clear to 24,00

   setcolor(COR_DEST)
   @ 08,01 say "   RESUMO DA IMPORTA"+chr(128)+chr(142)+"O DAS PESAGENS"
   setcolor(COR_TEXT)

   @ 10,01 say "1. Peso Total...................... "+transform(WTOT_PESO ,'@R@E 999,999.9')
   @ 11,01 say "2. Peso M"+chr(130)+"dio...................... "+transform(WTOT_PESO / WTOT_ANIMAIS,'@R@E 999,999.9')
   @ 12,01 say "3. Quantidade de animais pesados... "+alltrim(str(WTOT_ANIMAIS,5))

   setcolor(COR_DEST)
   CENTRO(14,"IMPORTA"+chr(128)+chr(142)+"O FINALIZADA!")
   setcolor(COR_TEXT)
   inkey(30)

enddo

return .t.


**************************
function consulta_PESAGENS
**************************
LOCAL WBOX := savescreen(00,00,24,79)
PRIVATE WOPC

setcolor(COR_TEXT)
@ 00,00 clear to 22,79
@ 24,00 clear to 24,79
   
setcolor(COR_CONS)
@ 00,00 clear to 00,79
centro(00,"CONSULTA AS PESAGENS DOS ANIMAIS")

WOPC = 7

do while .t.
   
   WRET = .f.

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79

   SOMBRA(07,14,17,67,8)

   setcolor(COR_CONS)
   @ 06,12 clear to 16,66
   @ 06,12 to 16,66 

   @ 07,14 say "Consulta a partir do in"+chr(161)+"cio do arquivo..........[1]"
   @ 08,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 09,14 say "Consulta a partir do n"+chr(163)+"mero do arquivo..........[3]"
   @ 10,14 say "Consulta a partir do n"+chr(163)+"mero do brinco...........[4]"
   @ 11,14 say "Consulta a partir da data de leitura............[5]"
   @ 12,14 say "Consulta INTERATIVA AO BANCO DE DADOS...........[6]"
   @ 13,14 say "Retorno ao menu principal.......................[7]"

   setcolor(COR_TEXT)
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o de consulta...................[ ]"
   @ 15,63 get WOPC picture "9" range 1,7
   read_f()

   if WOPC == 7 .or. lastkey() == 27
      restscreen(00,00,24,79,WBOX)
      return .t.
   endif

   if WOPC == 6
      select PESAGEM
      ordsetfocus("SINC001")
      find_DBF()
      WOPC = 7
      loop
   endif

   do while .t.

      if WOPC == 1
         select PESAGEM
         ordsetfocus("SINC002")
         go top

      elseif WOPC == 2
         select PESAGEM
         ordsetfocus("SINC002")
         go bottom

      elseif WOPC == 3

         @ 02,00 clear to 22,79
         @ 03,01 say "Arquivo: "

         WARQUIVO = 0

         @ 03,10 get WARQUIVO picture "@Z 99999999"  
         read_f()

         if empty(WARQUIVO) .or. lastkey() == 27
            WRET = .t.
            exit
         endif

         select PESAGEM
         ordsetfocus("SINC003")
         seek str(WARQUIVO,8)

         if ! found()
            MENSAGEM2("N"+chr(163)+"mero de arquivo n"+chr(132)+"o cadastrado!")
            loop
         endif

         SET OPTIMIZE ON 

         SET FILTER TO ARQUIVO == WARQUIVO

      elseif WOPC == 4

         @ 02,00 clear to 22,79
         @ 03,01 say "Brinco: "

         WBRINCO = space(15)

         @ 03,09 get WBRINCO picture "@!"  
         read_f()

         if empty(WBRINCO) .or. lastkey() == 27
            WRET = .t.
            exit
         endif

         select PESAGEM
         ordsetfocus("SINC002")
         seek WBRINCO

         if ! found()
            MENSAGEM2("N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado!")
            loop
         endif

         SET OPTIMIZE ON 

         SET FILTER TO BRINCO == WBRINCO
         
      elseif WOPC == 5

         @ 02,00 clear to 22,79
         @ 03,01 say "Leitura: "

         WDATA = DATE()

         @ 03,10 get WDATA  
         read_f()

         if empty(WDATA) .or. lastkey() == 27
            WRET = .t.
            exit
         endif

         select PESAGEM
         ordsetfocus("SINC004")
         seek dtos(WDATA)

         if ! found()
            MENSAGEM2("Data de leitura n"+chr(132)+"o cadastrada!")
            loop
         endif

         SET OPTIMIZE ON 

         SET FILTER TO DATA == WDATA
         
      endif

   exit
   enddo

   if WRET 
      WOPC = 7
      loop
   endif

   @ 02,00 clear to 22,79
   
   setcolor(COR_TEXT)
   @ 24,00 clear to 24,79

   if WOPC == 4
      CENTRO(24,"PgDw/PgUp   I-Incluir   A-Alterar   DEL-Deletar   R-Relat"+chr(162)+"rio   ESC-Retornar")
   else
      CENTRO(24,"PgDw/PgUp   I-Incluir   A-Alterar   DEL-Deletar   ESC-Retornar")
   endif

   select PESAGEM
   
   private aCAMPO:={{"strzero(ARQUIVO,8)+space(01)+BRINCO+space(03)+dtoc(DATA)+space(02)+HORA+space(04)+transform(PESO,'@R@E 999,999.9')+space(02)+ret_GANHO()+space(02)+if(PLANTEL='S','Sim','N'+chr(132)+'o')+space(13)","",""}}

   setcolor(COR_CONS)
   @ 02,01 say "ARQUIVO  BRINCO     DATA      HORA          PESAGEM   GANHO  PLANTEL"+space(09)    
   setcolor(COR_TEXT)

   brw_PESAGEM(02,00,22,79,aCAMPO)
   
   @ 02,00 clear to 22,79

   SET FILTER TO 
   SET OPTIMIZE OFF

   if WOPC > 2
      keyboard chr(13)
   endif

enddo 

return .t.

****************************************************************
function brw_PESAGEM(BRW_LS, BRW_CS, BRW_LI, BRW_CI, BRW_CAMPOS)
****************************************************************
LOCAL oTBrowse, oTBColumn
LOCAL bFieldBlock, cFieldName, i, nKey 

// create TBrowse object

oTBrowse           := TBrowse():new( BRW_LS+1, BRW_CS+1, BRW_LI-1, BRW_CI-1)
oTBrowse:headSep   := "" 
oTBrowse:colsep    := " "+chr(179)+" "
oTBrowse:colorSpec := "7/3"

// add code blocks for navigating the record pointer

oTBrowse:goTopBlock    := {|| DbGoTop() }
oTBrowse:goBottomBlock := {|| DbGoBottom() }
oTBrowse:skipBlock     := {|nskip| Dbskipper(nskip) }

// create TBColumn objects and add them to TBrowse object

for i:=1 to len(BRW_CAMPOS)

    cp_titu:=brw_campos[i,3]
    cp_masc:=brw_campos[i,2]
    cp_:=brw_campos[i,1]
    
    oTBColumn := TBColumn():new(cp_titu,&("{||transform("+cp_+",["+cp_masc+"])}"))
    oTBrowse:addColumn( oTBColumn )
    oTBrowse:getcolumn(i):width := len(transform(&cp_.,cp_masc))
    oTBrowse:getcolumn(i):colorblock=&("{7,3}")

next

// display browser and process user input 
 
do while .t.

   oTBrowse:forceStable()
  
   nKEY := inkey(0)
   
   if oTBrowse:applyKey( nKEY ) == TBR_EXIT  
      exit
   endif
  
   if nKEY == 7  
      
      @ 24,00 clear to 24,79
      
      if CONFIRMA(24,"Excluir essa pesagem...(S/N)?","N") == "S"
         if reglock()
            replace ARQUIVO  with 0,;
                    BRINCO   with space(15),;
                    DATA     with ctod(space(08)),;
                    HORA     with space(08),;
                    PESO     with 0,;
                    PLANTEL  with space(01),;
                    USER_INC with space(20),;
                    DATE_INC with ctod(space(08)),;            
                    TIME_INC with space(08)
            delete        
            grava()
         endif
      endif   

      @ 24,00 clear to 24,79

      if WOPC == 4
         CENTRO(24,"PgDw/PgUp   I-Incluir   A-Alterar   DEL-Deletar   R-Relat"+chr(162)+"rio   ESC-Retornar")
      else
         CENTRO(24,"PgDw/PgUp   I-Incluir   A-Alterar   DEL-Deletar   ESC-Retornar")
      endif

      oTBrowse:refreshAll()

   elseif nKEY == 65 .or. nKEY == 97      // Aa
      ALT_PESOS()
      
      @ 24,00 clear to 24,79

      if WOPC == 4
         CENTRO(24,"PgDw/PgUp   I-Incluir   A-Alterar   DEL-Deletar   R-Relat"+chr(162)+"rio   ESC-Retornar")
      else
         CENTRO(24,"PgDw/PgUp   I-Incluir   A-Alterar   DEL-Deletar   ESC-Retornar")
      endif

      oTBrowse:refreshAll()

   elseif nKEY == 73 .or. nKEY == 105     // Ii
      INC_PESOS() 

      @ 24,00 clear to 24,79

      if WOPC == 4
         CENTRO(24,"PgDw/PgUp   I-Incluir   A-Alterar   DEL-Deletar   R-Relat"+chr(162)+"rio   ESC-Retornar")
      else
         CENTRO(24,"PgDw/PgUp   I-Incluir   A-Alterar   DEL-Deletar   ESC-Retornar")
      endif

      oTBrowse:refreshAll()
   elseif nKEY == 82 .or. nKEY == 114     // Rr
      rpr_PESOS(WBRINCO)
      CENTRO(24,"PgDw/PgUp   I-Incluir   A-Alterar   DEL-Deletar   R-Relat"+chr(162)+"rio   ESC-Retornar")
      oTBrowse:refreshAll()
    endif   
  
enddo

return .t.


******************
function ret_GANHO
******************
LOCAL WBRINCO := space(15)

WBRINCO = BRINCO 
WPESO_1 = PESO 
WPESO_2 = 0
WGANHO  = 0

skip +1

if BRINCO == WBRINCO
   WPESO_2 = PESO
endif

skip -1

if WPESO_1 > 0 .and. WPESO_2 > 0
   WGANHO = WPESO_1 - WPESO_2
endif

return(transform(WGANHO,"@R@E 9999.9"))


******************
function INC_PESOS
******************
LOCAL WCOR := setcolor()
LOCAL WBOX := savescreen(07,07,18,74)

WARQUIVO = 0
WBRINCO  = space(08)
WDATA    = date()  
WHORA    = time()
WPESO    = 0
WPLANTEL = "N"

WVACINA  = 999
WPROXIMA = ctod(space(08))
WOBS1    = space(60)

sc_PESAGEM()

do while .t.
   
   setcolor(COR_CONS+","+COR_GETS+",,,"+COR_CONS)

   @ 09,21 get WARQUIVO picture "99999999"
   @ 10,21 get WBRINCO  picture "@!"              valid seek_BRINCO()
   @ 11,21 get WDATA
   @ 12,21 get WHORA     
   @ 13,21 get WPESO    picture "@R@E 999,999.9"  valid WPESO > 0 

   @ 15,21 get WVACINA  picture "@Z 999"          valid busca6_VACINA()
   @ 16,21 get WOBS1    picture "@S50"            when WVACINA <> 999
   read_f()

   if lastkey() == 27
      setcolor(WCOR)
      restscreen(07,07,18,74,WBOX)
      select PESAGEM
      return .t.
   endif  

   select PLANTEL
   ordsetfocus("SINC001")
   seek WBRINCO

   if found()
      WPLANTEL = "S"
   endif 

   setcolor(COR_TEXT) 
   if CONFIRMA(24,"Dados corretos...(S/N)?","S") == "S"
      
      select PESAGEM
      dbappend()
      replace ARQUIVO  with WARQUIVO,;
              BRINCO   with WBRINCO,;
              DATA     with WDATA,;
              HORA     with WHORA,;
              PESO     with WPESO,;
              PLANTEL  with WPLANTEL,;
              USER_INC with WPUSUARIO,;
              DATE_INC with DATE(),;            
              TIME_INC with TIME()
      grava()

      // insere a vacinação do animal

      if WVACINA <> 999
      
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

         replace SEQ      with WSEQ,;  
                 DATA     with WDATA,;  
                 BRINCO   with WBRINCO,;
                 VACINA   with WVACINA,;
                 PROXIMA  with WPROXIMA,;
                 OBS1     with WOBS1,;
                 USER_INC with WPUSUARIO,;
                 DATE_INC with DATE(),;
                 TIME_INC with TIME()

      endif 
      
      select PESAGEM
      exit 
   endif

enddo

setcolor(WCOR)
restscreen(07,07,18,74,WBOX)

return .t.

********************
function seek_BRINCO
********************

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
   MENSAGEM2("N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado!")
endif

return .t.

*******************
function sc_PESAGEM
*******************

SOMBRA(08,09,18,74,8)

setcolor(COR_CONS)
@ 07,07 clear to 17,73
@ 07,24 say "LAN"+chr(128)+"AMENTO DE PESAGEM/VACINA"+chr(128)+chr(142)+"O"

@ 09,09 say "Arquivo...:"
@ 10,09 say "Brinco....:"
@ 11,09 say "Data......:"
@ 12,09 say "Hora......:" 
@ 13,09 say "Pesagem...:"

setcolor(COR_CONS+"+")
@ 14,09 to 14,71

setcolor(COR_CONS)
@ 15,09 say "Vacina....:"
@ 16,09 say "Observa"+chr(135)+chr(132)+"o:" 

return .t.

**********************
function busca6_VACINA
**********************

if lastkey() == 27
   return .t.
endif

if WVACINA == 999
   @ 15,24 say "-N"+chr(142)+"O APLICADO"
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

setcolor(COR_CONS)
@ 15,24 say "-"+NOME 

WPROXIMA = WDATA + FREQUENC

return .t.


******************
function ALT_PESOS
******************
LOCAL WCOR := setcolor()

select PESAGEM

if ! reglock()
   return .t.
endif

WLIN     = ROW()
WARQUIVO = ARQUIVO
WBRINCO  = BRINCO  
WDATA    = DATA  
WHORA    = HORA  
WPESO    = PESO  
WPLANTEL = PLANTEL 

@ WLIN,01 say str(ARQUIVO,8)+space(01)+BRINCO+space(03)+dtoc(DATA)+space(02)+HORA+space(04)+transform(PESO,'@R@E 999,999.9')+space(02)+ret_GANHO()+space(02)+if(PLANTEL='S','Sim','N'+chr(132)+'o')+space(13)

do while .t.
   
   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ WLIN,01 get WARQUIVO picture "99999999"
   @ WLIN,10 get WBRINCO  picture "@!"  valid check_PLANTEL()
   @ WLIN,21 get WDATA
   @ WLIN,31 get WHORA    picture "99:99:99"
   @ WLIN,43 get WPESO    picture "@R@E 999,999.9"
   read_f()

   if lastkey() == 27
      grava()
      setcolor(WCOR)
      return .t.
   endif  

   @ WLIN,62 say if(WPLANTEL == "S","Sim","N"+chr(132)+"o")
   
   select PESAGEM

   if CONFIRMA(24,"Dados corretos...(S/N)?","S") == "S"
      select PESAGEM
      replace ARQUIVO  with WARQUIVO,;
              BRINCO   with WBRINCO,;
              DATA     with WDATA,;
              HORA     with WHORA,;
              PESO     with WPESO,;
              PLANTEL  with WPLANTEL,;
              USER_INC with WPUSUARIO,;
              DATE_INC with DATE(),;            
              TIME_INC with TIME()
      grava()
      exit 
   endif

enddo

setcolor(WCOR)

return .t.

**********************
function check_PLANTEL
**********************

select PLANTEL
ordsetfocus("SINC001")
seek WBRINCO

if found()
   WPLANTEL = "S"
else 
   WPLANTEL = "N"
   MENSAGEM("N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado no plantel.")
endif 

return .t.

***************************
function rpr_PESOS(WBRINCO)
***************************
LOCAL WORD := ordsetfocus()
LOCAL WREG := recno()

// inicia a impressao do relatorio

WIMP = sel_PRINTER()

if lastkey() == 27
   return .t.
endif   

PAG = 0
CAB = .t.

if ! Open_OBJ32PRN(1,"",WIMP)  
   return .t.
endif

setcolor(COR_TEXT)
@ 24,00 clear to 24,79

AGUARDE()

select PESAGEM
ordsetfocus("SINC002")
seek WBRINCO

do while BRINCO == WBRINCO .and. ! eof()

   if CAB 
      cab_PESOS()  
   endif

   oPrinter:newLine()
   Left_OBJ32PRN(str(ARQUIVO,8)+space(02)+dtoc(DATA)+space(03)+HORA+space(04)+transform(PESO,'@R@E 999,999.9')+space(04)+ret_GANHO(),1)
   
   skip +1

   if oPrinter:pRow() > 60
      Rodape_OBJ32PRN(PAG)
      oPrinter:endPage()
      CAB = .t. 
   endif
   
enddo

oPrinter:newLine()
Left_OBJ32PRN(replicate("-",137))

Rodape_OBJ32PRN(PAG)
Close_OBJ32PRN()

select PESAGEM
ordsetfocus(WORD)
go WREG

setcolor(COR_TEXT)
@ 24,00 clear to 24,79

return .t.


******************
function cab_PESOS
******************
PAG++

CAB = .f.

Cabecalho_OBJ32PRN("FAZ")
Left_OBJ32PRN("BRINCO: "+alltrim(WBRINCO),1)
Middle_OBJ32PRN("ESPELHO DE PESAGEM INDIVIDUAL",1)
Right_OBJ32PRN("Data: "+dtoc(DATE()),1)
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",137))
oPrinter:newLine()
Left_OBJ32PRN("Arquivo   Data       Hora          Pesagem     Ganho",1)  
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",137))

return .t.


**************************
function exclusao_PESAGENS
**************************

do while .t.

   WTP_EXC = "A"

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79

   @ 03,01 say "Excluir pesagens por Arquivo/Brinco...(A/B)?"
   @ 03,46 get WTP_EXC picture "!" valid WTP_EXC $ "AB"
   read_f()

   if lastkey() == 27
      return .t.
   endif

   if WTP_EXC == "A"

      do while .t.

         WARQUIVO = 0

         @ 05,01 say "N"+chr(163)+"mero do Arquivo..........................:"
         @ 05,46 get WARQUIVO picture "@Z 99999999"  
         read_f()

         if empty(WARQUIVO) .or. lastkey() == 27
            exit
         endif

         select PESAGEM
         ordsetfocus("SINC003")
         seek str(WARQUIVO,8)

         if ! found()
            MENSAGEM2("N"+chr(163)+"mero de arquivo n"+chr(132)+"o cadastrado!")
            loop
         endif

         if CONFIRMA(24,"Confirma a exclus"+chr(132)+"o...(S/N)?","N") == "N"
            loop
         endif

         AGUARDE()

         do while str(ARQUIVO,8) == str(WARQUIVO,8) .and. ! eof()

            if reglock()
               replace ARQUIVO  with 0,;
                       BRINCO   with space(15),;
                       DATA     with ctod(space(08)),;
                       HORA     with space(08),;
                       PESO     with 0,;
                       USER_INC with space(20),;
                       DATE_INC with ctod(space(08)),;
                       TIME_INC with space(08)           
               delete        
               grava()
            endif
  
            seek str(WARQUIVO,8)
 
         enddo

         pack_PESOS()

         setcolor(COR_TEXT)
         @ 24,00 clear to 24,79

      enddo

   else

      do while .t.

         WBRINCO = space(15)

         @ 05,01 say "N"+chr(163)+"mero do Brinco...........................:"
         @ 05,46 get WBRINCO picture "@!"  
         read_f()

         if empty(WBRINCO) .or. lastkey() == 27
            exit  
         endif

         select PESAGEM
         ordsetfocus("SINC002")
         seek WBRINCO

         if ! found()
            MENSAGEM2("N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado!")
            loop
         endif

         if CONFIRMA(24,"Confirma a exclus"+chr(132)+"o...(S/N)?","N") == "N"
            loop
         endif

         AGUARDE()

         do while BRINCO == WBRINCO .and. ! eof()

            if reglock()
               replace ARQUIVO with 0,;
                       BRINCO  with space(15),;
                       DATA    with ctod(space(08)),;
                       HORA    with space(08),;
                       PESO    with 0,;
                       USER_INC with space(20),;
                       DATE_INC with ctod(space(08)),;
                       TIME_INC with space(08)           
               delete        
               grava()
            endif
  
            seek WBRINCO
 
         enddo
 
         pack_PESOS()

         setcolor(COR_TEXT)
         @ 24,00 clear to 24,79

      enddo

   endif

enddo

return .t.


*******************
function pack_PESOS
*******************
AOF = 0

select PESAGEM
dbclosearea()

abre(AOF,"&WDIRE_FAZ\PESAGEM","E","PESAGEM",)

select PESAGEM
pack

select PESAGEM
dbclosearea()

abre(AOF,"&WDIRE_FAZ\PESAGEM","C","PESAGEM",)

return .t.

  