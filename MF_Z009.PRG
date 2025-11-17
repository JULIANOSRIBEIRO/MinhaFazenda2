*********************************************************************
****  Sistema......: MF-Minha Fazenda                            ****
****  Programa.....: MF_Z009.PRG                                 ****
****  Finalidade...: Cadastro do Plantel de Animais              ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************
#include "TBrowse.ch"
#include "inkey.ch"

*************************
function sc_PLANTEL(WACT)
*************************
LOCAL W

setcolor(COR_TEXT)
@ 00,00 clear to 22,79
@ 24,00 clear to 24,79

setcolor(COR_CONS)
@ 00,00 clear to 00,79
@ 00,26 say "FICHA INDIVIDUAL DO ANIMAL"

setcolor(COR_TEXT)

@ 01,01 say "Brinco.......:                                   Registro..:" 
@ 02,01 say "Nome.........:"
@ 03,01 say "Nascimento...:                                   Idade.....:"      
@ 04,01 say "Ra"+chr(135)+"a.........:    -                              Sexo......:" 
@ 05,01 say "Cor Pelagem..:                                   Brinco M"+chr(132)+"e:"                                  
@ 06,01 say "Lote.........:    -"
@ 07,01 say "Pasto/Piquete:    -"  

setcolor(COR_SUB)
@ 08,01 to 08,78
setcolor(COR_TEXT)

if WACT == 1

   @ 09,01 say "Categoria....:    -" 
   @ 10,01 say "Grupo........:    -"
   @ 11,01 say "Sub-Grupo....:    -"
   @ 12,01 say "Pend"+chr(136)+"ncias...:    -"

   setcolor(COR_CONS)
   @ 14,00 clear to 14,79
   @ 14,31 say "DADOS FAMILIARES"

   setcolor("BG/N")
   @ 15,00 clear to 15,79
   @ 15,01 say "Materno                                    Ra"+chr(135)+"a"                               

   setcolor(COR_TEXT)
   @ 16,01 say "M"+chr(132)+"e:"
   @ 17,01 say "Av"+chr(162)+":"                      
   @ 18,01 say "Av"+chr(147)+":"                    

   setcolor("BG/N")
   @ 19,00 clear to 19,79
   @ 19,01 say "Paterno                                    Ra"+chr(135)+"a"  

   setcolor(COR_TEXT)
   @ 20,01 say "Pai:"
   @ 21,01 say "Av"+chr(162)+":" 
   @ 22,01 say "Av"+chr(147)+":"

   for W=15 to 22 
       @ W,42 say chr(176)
   next

elseif WACT == 2

   setcolor(COR_TEXT)
   @ 08,00 clear to 22,79 

   setcolor(COR_CONS)
   @ 09,00 clear to 09,79
   @ 09,24 say "DADOS DE ENTRADA/SAIDA DO ANIMAL"
   setcolor(COR_TEXT)
   
   @ 10,01 say "Data Entrada.:                             Peso.....:" 
   @ 11,01 say "Documento....:                             Valor R$.:" 
   @ 12,01 say "Origem.......:" 

   @ 14,01 say "Data Saida...:" 
   @ 15,01 say "Motivo.......:" 

   setcolor(COR_SUB)
   @ 16,01 to 16,78
   setcolor(COR_TEXT)

   @ 17,01 say "Observa"+chr(135)+chr(132)+"o...:" 

endif 

return .t.


********************
function INC_PLANTEL
********************
LOCAL WBOX := savescreen(00,00,24,79)
LOCAL WCOR := setcolor() 

do while .t.

   // dados de entrada da 1a tela 

   WBRINCO     = space(08)
   WREGISTRO   = space(15)
   WNOME       = space(35) 
   WNASC       = ctod(space(08))
   WRACA       = 0 
   WSEXO       = space(01)
   WPELAGEM    = space(20)
   WBRINCO_MAE = space(08)
   WLOTE       = 0
   WPASTO      = 0
   WCATEG      = 0 
   WGRUPO      = 0 
   WSUB_GRP    = 0
   WPEND       = 0 

   // Dados Familiares - Materno 
   WDFM_NMAE   = space(35)        // nome da mãe 
   WDFM_RMAE   = 0                // raça da mãe 
   WDFM_NAVO1  = space(35)        // nome da avó 
   WDFM_RAVO1  = 0                // raça da avó 
   WDFM_NAVO2  = space(35)        // nome do avô
   WDFM_RAVO2  = 0                // raça do avô 

  // Dados Familiares - Paterno  
   WDFP_NPAI   = space(35)        // nome do pai 
   WDFP_RPAI   = 0                // raça do pai 
   WDFP_NAVO1  = space(35)        // nome da avó 
   WDFP_RAVO1  = 0                // raça da avó 
   WDFP_NAVO2  = space(35)        // nome do avô
   WDFP_RAVO2  = 0                // raça do avô 

   // dados de entrada da 2a tela 

   WENTRADA    = ctod(space(08))
   WPESO       = 0
   WDOC        = space(12)
   WVALOR      = 0
   WORIGEM     = space(35) 
   WSAIDA      = ctod(space(08))
   WMOTIVO     = space(15)
   WOBS1       = space(60)
   WOBS2       = space(60)
   WOBS3       = space(60)
   WOBS4       = space(60)

   do while .t.

      sc_PLANTEL(1)

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 01,16 get WBRINCO     picture "99999999"                                 valid busca_NBRINCO()
      @ 01,62 get WREGISTRO
      @ 02,16 get WNOME       picture "@!"
      @ 03,16 get WNASC                                                          valid calc_IDADE()  
      @ 04,16 get WRACA       picture "@Z 999"                                   valid busca_RACA(04,20)
      @ 04,62 get WSEXO       picture "!"                                        valid busca_SEXO()
      @ 05,16 get WPELAGEM 
      @ 05,62 get WBRINCO_MAE picture "99999999"                                 valid busca_MAE()
      @ 06,16 get WLOTE       picture "@Z 999"                                   valid busca_LOTE()
      @ 07,16 get WPASTO      picture "@Z 999"                                   valid busca_PASTO()
 
      @ 09,16 get WCATEG      picture "@Z 999"                                   valid busca_CATEG()      
      @ 10,16 get WGRUPO      picture "@Z 999"                                   valid busca_GRUPO()
      @ 11,16 get WSUB_GRP    picture "@Z 999"                                   valid busca_SUB_GRUPO()
      @ 12,16 get WPEND       picture "@Z 999"                                   valid busca_PEND()
      
      // Dados Familiares - Materno 
      @ 16,06 get WDFM_NMAE   picture "@!"       // nome da mãe 
      @ 16,44 get WDFM_RMAE   picture "@Z 999"   // raça da mãe 
      @ 17,06 get WDFM_NAVO1  picture "@!"       // nome da avó 
      @ 17,44 get WDFM_RAVO1  picture "@Z 999"   // raça da avó 
      @ 18,06 get WDFM_NAVO2  picture "@!"       // nome do avô
      @ 18,44 get WDFM_RAVO2  picture "@Z 999"   // raça do avô 

      // Dados Familiares - Paterno  
      @ 20,06 get WDFP_NPAI   picture "@!"       // nome do pai 
      @ 20,44 get WDFP_RPAI   picture "@Z 999"   // raça do pai 
      @ 21,06 get WDFP_NAVO1  picture "@!"       // nome da avó 
      @ 21,44 get WDFP_RAVO1  picture "@Z 999"   // raça da avó 
      @ 22,06 get WDFP_NAVO2  picture "@!"       // nome do avô
      @ 22,44 get WDFP_RAVO2  picture "@Z 999"   // raça do avô    
      read_f()

      if empty(WBRINCO) .or. lastkey() == 27
         restscreen(00,00,24,79,WBOX)
         setcolor(WCOR)
         return .t.
      endif

      if CONFIRMA(24,"Confirma...(S/N)?","S") == "N"
         loop
      endif 

      WVOLTA = .f. 

      do while .t.

         sc_PLANTEL(2)

         @ 10,16 get WENTRADA                       
         @ 10,55 get WPESO       picture "@R@E 999.9"       when ! empty(WENTRADA)
         @ 11,16 get WDOC                                   when ! empty(WENTRADA)
         @ 11,55 get WVALOR      picture "@R@E 999,999.99"  when ! empty(WENTRADA)
         @ 12,16 get WORIGEM     picture "@!"

         @ 14,16 get WSAIDA                                                         valid empty(WSAIDA) .or. WSAIDA >= WENTRADA                        
         
         @ 15,16,22,32 get WMOTIVO;   
         LISTBOX {"Venda          ", "Transferencia  ", "Morte          ", "Doacao         "};
         DROPDOWN SCROLLBAR;
         COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
         WHEN ! EMPTY(WSAIDA);
         MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar os motivos v"+chr(160)+"lidos."; 
         VALID ! empty(WMOTIVO)
     
         @ 17,16 get WOBS1   
         @ 18,16 get WOBS2  
         @ 19,16 get WOBS3
         @ 20,16 get WOBS4  
         read_f()

         if empty(WBRINCO) .or. lastkey() == 27
            WVOLTA = .t.
            exit 
         endif

         if empty(WENTRADA)
            WPESO  = 0
            WDOC   = space(12)
            WVALOR = 0
         endif

         if empty(WENTRADA)
            WMOTIVO = space(15)
        endif 

         if CONFIRMA(24,"Confirma...(S/N)?","S") == "S"
            exit 
         endif 

      enddo 

      if WVOLTA 
         loop
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
 
         select PLANTEL
         ordsetfocus("SINC001")

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

         save_PLANTEL()

         exit

      endif

    enddo
 
enddo

return .t.

**********************
function busca_NBRINCO
**********************

if lastkey() == 27
   return .t.
endif

if empty(WBRINCO)
   return .f.
endif 

select PLANTEL
ordsetfocus("SINC001")
seek WBRINCO 

if found()
   MENSAGEM("AVISO!;N"+chr(163)+"mero de brinco j"+chr(160)+" cadastrado!",0)
   return .f.
endif

return .t.

*******************
function calc_IDADE
*******************

if empty(WNASC) .or. lastkey() == 27
   return .t.
endif

WIDADE = round(((DATE() - WNASC) / 30),1)
@ 03,62 say WIDADE picture "@R@E 999.9 meses"

return .t.

*******************************
function busca_RACA(WLIN, WCOL)
*******************************

if lastkey() == 27
   return .t.
endif

if empty(WRACA)
   help_RACA()
   select RACA
   WRACA = CODIGO
endif

select RACA
ordsetfocus("SINC001")
seek WRACA

if ! found()
   MENSAGEM("C"+chr(162)+"digo de ra"+chr(135)+"a n"+chr(132)+"o cadastrado!",0)
   return .f.
endif

@ WLIN, WCOL say NOME

return .t.

*******************
function busca_SEXO
*******************

if lastkey() == 27
   return .t.
endif

if ! (WSEXO $ "M-F")
   MENSAGEM("Sexo v"+chr(160)+"lido: M-Macho ou F-F"+chr(136)+"mea")
   return .f.
endif

if WSEXO = "M"
   @ 04,62 say "Macho"
else
   @ 04,62 say "F"+chr(136)+"mea"
endif 

return .t.

******************
function busca_MAE
******************
LOCAL WREC := 0
LOCAL WORD

if lastkey() == 27
   return .t.
endif

if empty(WBRINCO_MAE)
   return .t.
endif 

select PLANTEL
WORD = ordsetfocus()
WREC = RECNO()

ordsetfocus("SINC003")
seek WBRINCO_MAE 

if ! found()
   MENSAGEM("AVISO!;N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado!",0)
   select PLANTEL
   ordsetfocus(WORD)
   go WREC
   return .f.
endif

if SEXO <> "F"
   MENSAGEM("AVISO!;O brinco informado n"+chr(132)+"o corresponde a uma f"+chr(136)+"mea!",0)
   select PLANTEL
   ordsetfocus(WORD)
   go WREC
   return .f.
endif

select PLANTEL
ordsetfocus(WORD)
go WREC

return .t.

*******************
function busca_LOTE 
*******************

if lastkey() == 27
   return .t.
endif

if empty(WLOTE)
   help_LOTE()
   select LOTE 
   WLOTE = CODIGO
endif

select LOTE
ordsetfocus("SINC001")
seek WLOTE

if ! found()
   MENSAGEM("C"+chr(162)+"digo de lote n"+chr(132)+"o cadastrado!",0)
   return .f.
endif

@ 06,20 say NOME

return .t.

********************
function busca_PASTO 
********************

if lastkey() == 27
   return .t.
endif

if empty(WPASTO)
   help_PASTO()
   select PASTO 
   WPASTO = CODIGO
endif

select PASTO 
ordsetfocus("SINC001")
seek WPASTO 

if ! found()
   MENSAGEM("C"+chr(162)+"digo de pasto/piquete n"+chr(132)+"o cadastrado!",0)
   return .f.
endif

@ 07,20 say NOME

return .t.

********************
function busca_CATEG
********************

return .t.

********************
function busca_GRUPO 
********************

return .t.


************************
function busca_SUB_GRUPO
************************

return .t.

*******************
function busca_PEND 
*******************

return .t. 

********************
function ALT_PLANTEL
********************
LOCAL WBOX := savescreen(00,00,24,79)
LOCAL WCOR := setcolor() 

do while .t.

   WBRINCO = space(08)

   sc_PLANTEL(1)

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 01,16 get WBRINCO picture "99999999" valid busca5_BRINCO()
   read_f()

   if empty(WBRINCO) .or. lastkey() == 27
      restscreen(00,00,24,79,WBOX)
      setcolor(WCOR)
      return .t.
   endif

   select PLANTEL 
   ordsetfocus("SINC001")
   seek WBRINCO 

   if ! found()
      MENSAGEM("AVISO!;N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado!",0)
      loop
   endif

   exibe_DADOS_PLANTEL(1)
   
   WREGISTRO   = REGISTRO  
   WNOME       = NOME      
   WNASC       = NASC      
   WRACA       = RACA      
   WSEXO       = SEXO      
   WPELAGEM    = PELAGEM   
   WBRINCO_MAE = BRINCO_MAE
   WLOTE       = LOTE      
   WPASTO      = PASTO     
   WCATEG      = CATEG     
   WGRUPO      = GRUPO     
   WSUB_GRP    = SUB_GRP   
   WPEND       = PEND      

   // Dados Familiares - Materno 
   WDFM_NMAE   = DFM_NMAE         // nome da mãe 
   WDFM_RMAE   = DFM_RMAE         // raça da mãe 
   WDFM_NAVO1  = DFM_NAVO1        // nome da avó 
   WDFM_RAVO1  = DFM_RAVO1        // raça da avó 
   WDFM_NAVO2  = DFM_NAVO2        // nome do avô
   WDFM_RAVO2  = DFM_RAVO2        // raça do avô 

  // Dados Familiares - Paterno  
   WDFP_NPAI   = DFP_NPAI         // nome do pai 
   WDFP_RPAI   = DFP_RPAI         // raça do pai 
   WDFP_NAVO1  = DFP_NAVO1        // nome da avó 
   WDFP_RAVO1  = DFP_RAVO1        // raça da avó 
   WDFP_NAVO2  = DFP_NAVO2        // nome do avô
   WDFP_RAVO2  = DFP_RAVO2        // raça do avô 

   // dados de entrada da 2a tela 

   WENTRADA    = ENTRADA 
   WPESO       = PESO    
   WDOC        = DOC     
   WVALOR      = VALOR   
   WORIGEM     = ORIGEM  
   WSAIDA      = SAIDA   
   WMOTIVO     = MOTIVO  
   WOBS1       = OBS1    
   WOBS2       = OBS2    
   WOBS3       = OBS3    
   WOBS4       = OBS4    
    
   do while .t.

      sc_PLANTEL(1)

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 01,16 say WBRINCO     picture "99999999"      
      @ 01,62 get WREGISTRO
      @ 02,16 get WNOME       picture "@!"
      @ 03,16 get WNASC                                                          valid calc_IDADE()  
      @ 04,16 get WRACA       picture "@Z 999"                                   valid busca_RACA(04,20)
      @ 04,62 get WSEXO       picture "!"                                        valid busca_SEXO()
      @ 05,16 get WPELAGEM 
      @ 05,62 get WBRINCO_MAE picture "99999999"                                 valid busca_MAE()
      @ 06,16 get WLOTE       picture "@Z 999"                                   valid busca_LOTE()
      @ 07,16 get WPASTO      picture "@Z 999"                                   valid busca_PASTO()
 
      @ 09,16 get WCATEG      picture "@Z 999"                                   valid busca_CATEG()      
      @ 10,16 get WGRUPO      picture "@Z 999"                                   valid busca_GRUPO()
      @ 11,16 get WSUB_GRP    picture "@Z 999"                                   valid busca_SUB_GRUPO()
      @ 12,16 get WPEND       picture "@Z 999"                                   valid busca_PEND()
      
      // Dados Familiares - Materno 
      @ 16,06 get WDFM_NMAE   picture "@!"       // nome da mãe 
      @ 16,44 get WDFM_RMAE   picture "@Z 999"   // raça da mãe 
      @ 17,06 get WDFM_NAVO1  picture "@!"       // nome da avó 
      @ 17,44 get WDFM_RAVO1  picture "@Z 999"   // raça da avó 
      @ 18,06 get WDFM_NAVO2  picture "@!"       // nome do avô
      @ 18,44 get WDFM_RAVO2  picture "@Z 999"   // raça do avô 

      // Dados Familiares - Paterno  
      @ 20,06 get WDFP_NPAI   picture "@!"       // nome do pai 
      @ 20,44 get WDFP_RPAI   picture "@Z 999"   // raça do pai 
      @ 21,06 get WDFP_NAVO1  picture "@!"       // nome da avó 
      @ 21,44 get WDFP_RAVO1  picture "@Z 999"   // raça da avó 
      @ 22,06 get WDFP_NAVO2  picture "@!"       // nome do avô
      @ 22,44 get WDFP_RAVO2  picture "@Z 999"   // raça do avô    
      read_f()

      if empty(WBRINCO) .or. lastkey() == 27
         restscreen(00,00,24,79,WBOX)
         setcolor(WCOR)
         return .t.
      endif

      if CONFIRMA(24,"Confirma...(S/N)?","S") == "N"
         loop
      endif 

      WVOLTA = .f. 

      do while .t.

         sc_PLANTEL(2)

         @ 10,16 get WENTRADA                       
         @ 10,55 get WPESO       picture "@R@E 999.9"       when ! empty(WENTRADA)
         @ 11,16 get WDOC                                   when ! empty(WENTRADA)
         @ 11,55 get WVALOR      picture "@R@E 999,999.99"  when ! empty(WENTRADA)
         @ 12,16 get WORIGEM     picture "@!"

         @ 14,16 get WSAIDA                                                         valid empty(WSAIDA) .or. WSAIDA >= WENTRADA                        
         
         @ 15,16,22,32 get WMOTIVO;   
         LISTBOX {"Venda          ", "Transferencia  ", "Morte          ", "Doacao         "};
         DROPDOWN SCROLLBAR;
         COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
         WHEN ! EMPTY(WSAIDA);
         MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar os motivos v"+chr(160)+"lidos."; 
         VALID ! empty(WMOTIVO)
     
         @ 17,16 get WOBS1   
         @ 18,16 get WOBS2  
         @ 19,16 get WOBS3
         @ 20,16 get WOBS4  
         read_f()

         if empty(WBRINCO) .or. lastkey() == 27
            WVOLTA = .t.
            exit 
         endif

         if empty(WENTRADA)
            WPESO  = 0
            WDOC   = space(12)
            WVALOR = 0
         endif

         if empty(WENTRADA)
            WMOTIVO = space(15)
        endif 

         if CONFIRMA(24,"Confirma...(S/N)?","S") == "S"
            exit 
         endif 

      enddo 

      if WVOLTA 
         loop
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
         select PLANTEL
             
         if ! reglock()
            loop
         endif

         save_PLANTEL()

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

********************
function CON_PLANTEL
********************
LOCAL WBOX := savescreen(00,00,24,79)
LOCAL WCOR := setcolor() 
LOCAL WOPC 

do while .t.

   WOPC = 7

   sc_PLANTEL(1)
     
   SOMBRA(07,14,17,67,8)

   setcolor(COR_CONS)
   @ 06,12 clear to 16,66
   @ 06,12 to 16,66 

   @ 07,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 08,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 09,14 say "Consulta a partir do brinco.....................[3]"
   @ 10,14 say "Consulta a partir do registro...................[4]"
   @ 11,14 say "Consulta a partir do brinco da mae..............[5]"
   @ 12,14 say "Consulta a partir da data de entrada............[6]"
   @ 13,14 say "Retorno ao menu principal.......................[7]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 15,63 get WOPC picture "9" range 1,7
   read_f()

   if WOPC == 7 .or. lastkey() == 27
      setcolor(WCOR)
      restscreen(00,00,24,79,WBOX)
      return .t.
   endif

   WTRAVA = .f.

   sc_PLANTEL(1)     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC = 1
      select PLANTEL
      ordsetfocus("SINC001")
      go top 

   elseif WOPC = 2
      select PLANTEL
      ordsetfocus("SINC001")
      go bottom

      if eof()
         skip -1
      endif 

   elseif WOPC = 3

      do while .t.

         WBRINCO = space(08)
  
         @ 03,16 get WBRINCO picture "99999999" valid busca5_BRINCO()
         read_f()
 
         if empty(WBRINCO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select PLANTEL
         ordsetfocus("SINC001")
         seek WBRINCO 

         if ! found()
            MENSAGEM("N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado!",0)
           loop
         endif

      exit
      enddo

   elseif WOPC = 4

      do while .t.

         WREGISTRO = space(15)

         @ 03,62 get WREGISTRO                           
         read_f()           

         if empty(WREGISTRO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select PLANTEL 
         ordsetfocus("SINC002")
         seek WREGISTRO 
         
         if ! found()
            MENSAGEM("N"+chr(163)+"mero de registro n"+chr(132)+"o cadastrado!",0)
           loop
         endif

      exit
      enddo

   elseif WOPC = 5
 
      do while .t.

         WBRINCO_MAE = space(08)
  
         @ 06,62 get WBRINCO_MAE picture "99999999" 
         read_f()
 
         if empty(WBRINCO_MAE) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select PLANTEL
         ordsetfocus("SINC003")
         seek WBRINCO_MAE

         if ! found()
            MENSAGEM("N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado!",0)
           loop
         endif

      exit
      enddo

   elseif WOPC = 6

      WENTRADA = DATE()

      @ 11,16 get WENTRADA                          
      read_f()           

      if ! empty(WENTRADA) .or. lastkey() <> 27

         select PLANTEL
         ordsetfocus("SINC004")
         seek WENTRADA 
        
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
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo    PgUp-Anterior    I-Info    ESC-FIM")

      exibe_DADOS_PLANTEL(1)

      setcolor(COR_DEST)

      if WOPC = 1
         @ 03,00 say chr(175)   
         @ 03,49 say space(01)      
         @ 06,50 say space(01)     
         @ 11,00 say space(01)  
      elseif WOPC = 2
         @ 03,00 say chr(175)      
         @ 03,49 say space(01)      
         @ 06,49 say space(01)     
         @ 11,00 say space(01)  
      elseif WOPC = 3
         @ 03,00 say chr(175)      
         @ 03,49 say space(01)      
         @ 06,49 say space(01)     
         @ 11,00 say space(01)  
      elseif WOPC = 4
         @ 03,49 say chr(175)      
         @ 03,00 say space(01) 
         @ 06,49 say space(01)     
         @ 11,00 say space(01)  
      elseif WOPC = 5
         @ 06,49 say chr(175)      
         @ 03,00 say space(01)   
         @ 06,49 say space(01)     
         @ 11,00 say space(01)  
      elseif WOPC = 6
         @ 11,00 say chr(175) 
         @ 03,00 say space(01) 
         @ 03,49 say space(01)      
         @ 06,49 say space(01)     
      endif

      setcolor(COR_TEXT)

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
      elseif lastkey() == 73 .or. lastkey() == 105 
         info_PLANTEL() 
      elseif lastkey() == 7
         @ 24,00 clear to 24,79
         if CONFIRMA(24,"Excluir esse brinco do plantel...(S/N)?","N") == "N"
            loop
         endif 
         
         if ! reglock()
            loop
         endif
       
         replace BRINCO     with space(08),;
                 REGISTRO   with space(15),;
                 NASC       with ctod(space(08)),;
                 RACA       with 0,;
                 SEXO       with space(01),;
                 PELAGEM    with space(20),;
                 BRINCO_MAE with space(08),;
                 LOTE       with 0,;
                 PASTO      with 0,;
                 ENTRADA    with ctod(space(08)),;
                 PESO       with 0,;
                 DOC        with space(12),;
                 VALOR      with 0,;
                 SAIDA      with ctod(space(08)),;
                 MOTIVO     with space(15),;
                 OBS1       with space(60),;
                 OBS2       with space(60),;
                 OBS3       with space(60)
         delete
         grava()

         MENSAGEM("AVISO!;Brinco exclu"+chr(161)+"do do plantel.")     
         skip +1
            
      endif

   enddo

enddo

return .t.

*********************
function info_PLANTEL
*********************

MENSAGEM("AVISO!;Nessa tela ser"+chr(160)+" exibido informa"+chr(135)+chr(148)+"es de peso/vacina"+chr(135)+chr(132)+"o.")

return .t.

********************
function EXC_PLANTEL
********************

do while .t.

   sc_PLANTEL()

   WBRINCO = space(08)
  
   @ 03,16 get WBRINCO picture "99999999" valid busca5_BRINCO()
   read_f()
 
   if empty(WBRINCO) .or. lastkey() == 27
      return .t.
   endif
   
   select PLANTEL
   ordsetfocus("SINC001")
   seek WBRINCO

   if ! found()
      MENSAGEM("N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado!",0)
      loop
   endif
   
   exibe_DADOS_PLANTEL(1)

   if CONFIRMA(24,"Excluir esse brinco do plantel...(S/N)?","N") = "S"
      select PLANTEL
 
      if ! reglock()
         loop
      endif
       
      replace BRINCO     with space(08),;
              REGISTRO   with space(15),;
              NASC       with ctod(space(08)),;
              RACA       with 0,;
              SEXO       with space(01),;
              PELAGEM    with space(20),;
              BRINCO_MAE with space(08),;
              LOTE       with 0,;
              PASTO      with 0,;
              ENTRADA    with ctod(space(08)),;
              PESO       with 0,;
              DOC        with space(12),;
              VALOR      with 0,;
              SAIDA      with ctod(space(08)),;
              MOTIVO     with space(15),;
              OBS1       with space(60),;
              OBS2       with space(60),;
              OBS3       with space(60)
      delete
      grava()        
             
   endif 

enddo

return .t.

**********************************
function exibe_DADOS_PLANTEL(WACT)
**********************************

@ 01,16 say BRINCO     picture "99999999"                                  
@ 01,62 say REGISTRO
@ 02,16 say NOME       picture "@!"
@ 03,16 say NASC                                                           
@ 04,16 say RACA       picture "@Z 999"                                    
@ 04,62 say SEXO       picture "!"                                        
@ 05,16 say PELAGEM 
@ 05,62 say BRINCO_MAE picture "99999999"                                  
@ 06,16 say LOTE       picture "@Z 999"                                   
@ 07,16 say PASTO      picture "@Z 999"                                    

if WACT == 1
   @ 09,16 say CATEG      picture "@Z 999"                                          
   @ 10,16 say GRUPO      picture "@Z 999"                                    
   @ 11,16 say SUB_GRP    picture "@Z 999"                                    
   @ 12,16 say PEND       picture "@Z 999"                                    
   
   // Dados Familiares - Materno 
   @ 16,06 say DFM_NMAE   picture "@!"       // nome da mãe 
   @ 16,44 say DFM_RMAE   picture "@Z 999"   // raça da mãe 
   @ 17,06 say DFM_NAVO1  picture "@!"       // nome da avó 
   @ 17,44 say DFM_RAVO1  picture "@Z 999"   // raça da avó 
   @ 18,06 say DFM_NAVO2  picture "@!"       // nome do avô
   @ 18,44 say DFM_RAVO2  picture "@Z 999"   // raça do avô 
   
   // Dados Familiares - Paterno  
   @ 20,06 say DFP_NPAI   picture "@!"       // nome do pai 
   @ 20,44 say DFP_RPAI   picture "@Z 999"   // raça do pai 
   @ 21,06 say DFP_NAVO1  picture "@!"       // nome da avó 
   @ 21,44 say DFP_RAVO1  picture "@Z 999"   // raça da avó 
   @ 22,06 say DFP_NAVO2  picture "@!"       // nome do avô
   @ 22,44 say DFP_RAVO2  picture "@Z 999"   // raça do avô    
   
   WNASC  = NASC 
   WRACA  = RACA
   WSEXO  = SEXO 
   WLOTE  = LOTE 
   WPASTO = PASTO 
   
   calc_IDADE()
   
   select RACA
   ordsetfocus("SINC001")
   seek WRACA
   
   if found()
      @ 04,20 say NOME
   else
      @ 04,20 say "N/C"+space(27)
   endif
   
   if WSEXO == "M"
      @ 04,62 say "Macho"
   elseif WSEXO == "F"
      @ 04,62 say "F"+chr(136)+"mea"
   else
      @ 04,62 say space(05)
   endif 
   
   select LOTE
   ordsetfocus("SINC001")
   seek WLOTE
   
   if found()
      @ 06,20 say NOME
   endif 
   
   select PASTO 
   ordsetfocus("SINC001")
   seek WPASTO 
   
   if found()
      @ 07,20 say NOME
   endif 

elseif WACT == 2 

   @ 10,16 say ENTRADA                       
   @ 10,55 say PESO    picture "@R@E 999.9"        
   @ 11,16 say DOC                                    
   @ 11,55 say VALOR   picture "@R@E 999,999.99"  
   @ 12,16 say ORIGEM  picture "@!"
   @ 14,16 say SAIDA                                                   
   @ 15,16 say MOTIVO
   @ 17,16 say OBS1   
   @ 18,16 say OBS2  
   @ 19,16 say OBS3
   @ 20,16 say OBS4  

endif 

select PLANTEL 

return .t.

*********************
function save_PLANTEL
*********************
select PLANTEL 

replace BRINCO     with WBRINCO,; 
        REGISTRO   with WREGISTRO,; 
        NOME       with WNOME,;
        NASC       with WNASC,; 
        RACA       with WRACA,; 
        SEXO       with WSEXO,; 
        PELAGEM    with WPELAGEM,; 
        BRINCO_MAE with WBRINCO_MAE,; 
        LOTE       with WLOTE,; 
        PASTO      with WPASTO,; 
        CATEG      with WCATEG,;    
        GRUPO      with WGRUPO,;   
        SUB_GRP    with WSUB_GRP,; 
        PEND       with WPEND,;    
        DFM_NMAE   with WDFM_NMAE,;
        DFM_RMAE   with WDFM_RMAE,; 
        DFM_NAVO1  with WDFM_NAVO1,;
        DFM_RAVO1  with WDFM_RAVO1,;
        DFM_NAVO2  with WDFM_NAVO2,;
        DFM_RAVO2  with WDFM_RAVO2,;
        DFP_NPAI   with WDFP_NPAI,;
        DFP_RPAI   with WDFP_RPAI,;
        DFP_NAVO1  with WDFP_NAVO1,;
        DFP_RAVO1  with WDFP_RAVO1,;
        DFP_NAVO2  with WDFP_NAVO2,;
        DFP_RAVO2  with WDFP_RAVO2,;
        ENTRADA    with WENTRADA,; 
        PESO       with WPESO,; 
        DOC        with WDOC,; 
        VALOR      with WVALOR,; 
        ORIGEM     with WORIGEM,;
        SAIDA      with WSAIDA,; 
        MOTIVO     with WMOTIVO,; 
        OBS1       with WOBS1,; 
        OBS2       with WOBS2,; 
        OBS3       with WOBS3,;
        OBS4       with WOBS4

grava()

return .t.

