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

if WACT == 1
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

   WBRINCO     = space(15)
   WREGISTRO   = space(15)
   WNOME       = space(50) 
   WNASC       = ctod(space(08))
   WRACA       = 0 
   WSEXO       = space(05)
   WPELAGEM    = space(20)
   WBRINCO_MAE = space(15)
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

   SET CENTURY ON 

   do while .t.

      sc_PLANTEL(1)

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 01,16 get WBRINCO     picture "@!"                                       valid busca_NBRINCO()
      @ 01,62 get WREGISTRO   picture "@!"
      @ 02,16 get WNOME       picture "@!"                            

      @ 03,16 get WNASC                                                          valid calc_IDADE()  
      @ 04,16 get WRACA       picture "@Z 999"                                   valid busca_RACA(04,20)
      
      @ 04,62,08,69 get WSEXO;                                  
         LISTBOX {"Macho", "Femea"};
         DROPDOWN SCROLLBAR;
         COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
         MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar as op"+chr(135)+chr(148)+"es v"+chr(160)+"lidas."; 
         VALID ! empty(WSEXO)

      @ 05,16,13,36 get WPELAGEM;   
         LISTBOX {"Branca              ", "Preta               ", "Malhada             ", "Castanha            ", "Marrom              ", "Outra               "};
         DROPDOWN SCROLLBAR;
         COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
         MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar as cores v"+chr(160)+"lidas."; 
         VALID ! empty(WPELAGEM)
     
      @ 05,62 get WBRINCO_MAE picture "@!"                                       valid busca_MAE()
      @ 06,16 get WLOTE       picture "@Z 999"                                   valid busca_LOTE()
      @ 07,16 get WPASTO      picture "@Z 999"                                   valid busca_PASTO()
 
      @ 09,16 get WCATEG      picture "@Z 999"                                   valid busca_CATEG()    
      @ 10,16 get WGRUPO      picture "@Z 999"                                   valid busca_GRUPO()
      @ 11,16 get WSUB_GRP    picture "@Z 999"                                   valid busca_SUB_GRUPO()
      @ 12,16 get WPEND       picture "@Z 999"                                   valid busca_PEND()
     
      // Dados Familiares - Materno 
      @ 16,06 get WDFM_NMAE   picture "@!"                                       // nome da mãe 
      @ 16,44 get WDFM_RMAE   picture "@Z 999"                                   when ! empty(WDFM_NMAE)  valid busca_RACA(16,48)   // raça da mãe 
      @ 17,06 get WDFM_NAVO1  picture "@!"                                       // nome da avó 
      @ 17,44 get WDFM_RAVO1  picture "@Z 999"                                   when ! empty(WDFM_NAVO1) valid busca_RACA(17,48)  // raça da avó 
      @ 18,06 get WDFM_NAVO2  picture "@!"                                       // nome do avô
      @ 18,44 get WDFM_RAVO2  picture "@Z 999"                                   when ! empty(WDFM_NAVO2) valid busca_RACA(18,48)  // raça do avô 
 
      // Dados Familiares - Paterno                                  
      @ 20,06 get WDFP_NPAI   picture "@!"                                       // nome do pai 
      @ 20,44 get WDFP_RPAI   picture "@Z 999"                                   when ! empty(WDFP_NPAI)  valid busca_RACA(20,48)   // raça do pai 
      @ 21,06 get WDFP_NAVO1  picture "@!"                                       // nome da avó 
      @ 21,44 get WDFP_RAVO1  picture "@Z 999"                                   when ! empty(WDFP_NAVO1) valid busca_RACA(21,48)  // raça da avó 
      @ 22,06 get WDFP_NAVO2  picture "@!"                                       // nome do avô
      @ 22,44 get WDFP_RAVO2  picture "@Z 999"                                   when ! empty(WDFP_NAVO2) valid busca_RACA(22,48)  // raça do avô    
      read_f()

      if empty(WBRINCO) .or. lastkey() == 27
         restscreen(00,00,24,79,WBOX)
         setcolor(WCOR)
         SET CENTURY OFF  
         return .t.
      endif

      if CONFIRMA(24,"Confirma...(S/N)?","S") == "N"
         loop
      endif 

      WVOLTA = .f. 

      do while .t.

         sc_PLANTEL(2)

         @ 10,16 get WENTRADA                                                      valid empty(WENTRADA) .or. WENTRADA >= WNASC             
         @ 10,55 get WPESO       picture "@R@E 999.9"       when ! empty(WENTRADA)
         @ 11,16 get WDOC                                   when ! empty(WENTRADA)
         @ 11,55 get WVALOR      picture "@R@E 999,999.99"  when ! empty(WENTRADA)
         @ 12,16 get WORIGEM     picture "@!"

         @ 14,16 get WSAIDA                                                         valid empty(WSAIDA) .or. WSAIDA >= WENTRADA                        
         
         @ 15,16,22,32 get WMOTIVO;   
         LISTBOX {"Venda          ", "Transferencia  ", "Morte          ", "Doacao         ", "Emprestimo     "};
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

         save_PLANTEL("INC")
         MENSAGEM("Brinco: "+alltrim(WBRINCO)+";Inserido com Sucesso!",0)
        
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
@ 03,62 say WIDADE picture "@R 999.9 meses"

return .t.


*******************************
function busca_RACA(WLIN, WCOL)
*******************************
PRIVATE WVAR := readvar()

if lastkey() == 27
   return .t.
endif

if empty(&WVAR)
   help_RACA()
   select RACA
   &WVAR = CODIGO
   return .f.
endif

select RACA
ordsetfocus("SINC001")
seek &WVAR

if ! found()
   MENSAGEM("C"+chr(162)+"digo de ra"+chr(135)+"a n"+chr(132)+"o cadastrado!",0)
   return .f.
endif

@ WLIN,WCOL say NOME

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
   return .t.
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

if lastkey() == 27
   return .t.
endif

if empty(WCATEG)
   help_CATEG()
   select CATEG
   WCATEG = CODIGO
endif

select CATEG
ordsetfocus("SINC001")
seek WCATEG

if ! found()
   MENSAGEM("C"+chr(162)+"digo de categoria n"+chr(132)+"o cadastrado!",0)
   return .f.
endif

@ 09,20 say NOME

return .t.


********************
function busca_GRUPO 
********************

if lastkey() == 27
   return .t.
endif

if empty(WGRUPO)
   help_GRUPO_P()
   select GRUPO_P
   WGRUPO = CODIGO
endif

select GRUPO_P
ordsetfocus("SINC001")
seek WGRUPO 

if ! found()
   MENSAGEM("C"+chr(162)+"digo de grupo n"+chr(132)+"o cadastrado!",0)
   return .f.
endif

@ 10,20 say NOME

return .t.


************************
function busca_SUB_GRUPO
************************

if lastkey() == 27
   return .t.
endif

if empty(WSUB_GRP)
   help_SUB_GRP()
   select SUB_GRP 
   WSUB_GRP = CODIGO
endif

select SUB_GRP
ordsetfocus("SINC001")
seek WSUB_GRP

if ! found()
   MENSAGEM("C"+chr(162)+"digo de sub-grupo n"+chr(132)+"o cadastrado!",0)
   return .f.
endif

@ 11,20 say NOME

return .t.


*******************
function busca_PEND 
*******************

if lastkey() == 27
   return .t.
endif

if empty(WPEND)
   help_PENDENC()
   select PENDENC 
   WPEND = CODIGO
endif

select PENDENC
ordsetfocus("SINC001")
seek WPEND

if ! found()
   MENSAGEM("C"+chr(162)+"digo de pend"+chr(136)+"ncia n"+chr(132)+"o cadastrado!",0)
   return .f.
endif

@ 12,20 say NOME

return .t. 


********************
function ALT_PLANTEL
********************
LOCAL WBOX := savescreen(00,00,24,79)
LOCAL WCOR := setcolor() 

SET CENTURY ON 
 
do while .t.
 
   WBRINCO = space(15)

   sc_PLANTEL(1)

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 01,16 get WBRINCO picture "@!" valid busca5_BRINCO()
   read_f()

   if empty(WBRINCO) .or. lastkey() == 27
      restscreen(00,00,24,79,WBOX)
      setcolor(WCOR)
      SET CENTURY OFF
      return .t.
   endif

   select PLANTEL 
    
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
      exibe_DADOS_PLANTEL(1)

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 01,16 say WBRINCO     picture "@!"                                 
      @ 01,62 get WREGISTRO
      @ 02,16 get WNOME       picture "@!"                            

      @ 03,16 get WNASC                                                          valid calc_IDADE()  
      @ 04,16 get WRACA       picture "@Z 999"                                   valid busca_RACA(04,20)
      
      @ 04,62,08,69 get WSEXO;                                  
         LISTBOX {"Macho", "Femea"};
         DROPDOWN SCROLLBAR;
         COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
         MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar as op"+chr(135)+chr(148)+"es v"+chr(160)+"lidas."; 
         VALID ! empty(WSEXO)

      @ 05,16,13,36 get WPELAGEM;   
         LISTBOX {"Branca              ", "Preta               ", "Malhada             ", "Castanha            ", "Marrom              ", "Outra               "};
         DROPDOWN SCROLLBAR;
         COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
         MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar as cores v"+chr(160)+"lidas."; 
         VALID ! empty(WPELAGEM)
     
      @ 05,62 get WBRINCO_MAE picture "@!"                                       valid busca_MAE()
      @ 06,16 get WLOTE       picture "@Z 999"                                   valid busca_LOTE()
      @ 07,16 get WPASTO      picture "@Z 999"                                   valid busca_PASTO()
 
      @ 09,16 get WCATEG      picture "@Z 999"                                   valid busca_CATEG()    
      @ 10,16 get WGRUPO      picture "@Z 999"                                   valid busca_GRUPO()
      @ 11,16 get WSUB_GRP    picture "@Z 999"                                   valid busca_SUB_GRUPO()
      @ 12,16 get WPEND       picture "@Z 999"                                   valid busca_PEND()
     
      // Dados Familiares - Materno 
      @ 16,06 get WDFM_NMAE   picture "@!"                                       // nome da mãe 
      @ 16,44 get WDFM_RMAE   picture "@Z 999"                                   when ! empty(WDFM_NMAE)  valid busca_RACA(16,48)   // raça da mãe 
      @ 17,06 get WDFM_NAVO1  picture "@!"                                       // nome da avó 
      @ 17,44 get WDFM_RAVO1  picture "@Z 999"                                   when ! empty(WDFM_NAVO1) valid busca_RACA(17,48)  // raça da avó 
      @ 18,06 get WDFM_NAVO2  picture "@!"                                       // nome do avô
      @ 18,44 get WDFM_RAVO2  picture "@Z 999"                                   when ! empty(WDFM_NAVO2) valid busca_RACA(18,48)  // raça do avô 
 
      // Dados Familiares - Paterno                                  
      @ 20,06 get WDFP_NPAI   picture "@!"                                       // nome do pai 
      @ 20,44 get WDFP_RPAI   picture "@Z 999"                                   when ! empty(WDFP_NPAI)  valid busca_RACA(20,48)   // raça do pai 
      @ 21,06 get WDFP_NAVO1  picture "@!"                                       // nome da avó 
      @ 21,44 get WDFP_RAVO1  picture "@Z 999"                                   when ! empty(WDFP_NAVO1) valid busca_RACA(21,48)  // raça da avó 
      @ 22,06 get WDFP_NAVO2  picture "@!"                                       // nome do avô
      @ 22,44 get WDFP_RAVO2  picture "@Z 999"                                   when ! empty(WDFP_NAVO2) valid busca_RACA(22,48)  // raça do avô    
      read_f()

      if empty(WBRINCO) .or. lastkey() == 27
         restscreen(00,00,24,79,WBOX)
         setcolor(WCOR)
         SET CENTURY OFF  
         return .t.
      endif

      if CONFIRMA(24,"Confirma...(S/N)?","S") == "N"
         loop
      endif 

      WVOLTA = .f. 

      do while .t.

         sc_PLANTEL(2)

         @ 10,16 get WENTRADA                                                      valid empty(WENTRADA) .or. WENTRADA >= WNASC             
         @ 10,55 get WPESO       picture "@R@E 999.9"       when ! empty(WENTRADA)
         @ 11,16 get WDOC                                   when ! empty(WENTRADA)
         @ 11,55 get WVALOR      picture "@R@E 999,999.99"  when ! empty(WENTRADA)
         @ 12,16 get WORIGEM     picture "@!"

         @ 14,16 get WSAIDA                                                         valid empty(WSAIDA) .or. WSAIDA >= WENTRADA                        
         
         @ 15,16,22,32 get WMOTIVO;   
         LISTBOX {"Venda          ", "Transferencia  ", "Morte          ", "Doacao         ", "Emprestimo     "};
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

         save_PLANTEL("ALT")
         MENSAGEM("Brinco: "+alltrim(WBRINCO)+";Alterado com Sucesso!",0)

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
   select PLANTEL
   WBRINCO = BRINCO
   return .f.
endif

select PLANTEL
ordsetfocus("SINC001")
seek WBRINCO

if ! found()
   mensagem("AVISO!;N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado no plantel.",0)
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

   WOPC = 9

   sc_PLANTEL(1)
     
   SOMBRA(05,14,17,67,8)

   setcolor(COR_CONS)
   @ 04,12 clear to 16,66
   @ 04,12 to 16,66 

   @ 05,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 06,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 07,14 say "Consulta a partir do n"+chr(163)+"mero do brinco...........[3]"
   @ 08,14 say "Consulta a partir do n"+chr(163)+"mero de registro.........[4]"
   @ 09,14 say "Consulta a partir do nome do animal.............[5]"
   @ 10,14 say "Consulta a partir do n"+chr(163)+"mero do brinco da m"+chr(132)+"e....[6]"
   @ 11,14 say "Consulta a partir da data de entrada............[7]"
   @ 12,14 say "Consulta a partir da data de saida..............[8]"
   @ 13,14 say "Retorno ao menu principal.......................[9]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 15,63 get WOPC picture "9" range 1,9
   read_f()

   if WOPC == 9 .or. lastkey() == 27
      setcolor(WCOR)
      restscreen(00,00,24,79,WBOX)
      return .t.
   endif

   WTRAVA = .f.

   sc_PLANTEL(1)     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select PLANTEL
      ordsetfocus("SINC001")
      go top 

   elseif WOPC == 2
      select PLANTEL
      ordsetfocus("SINC001")
      go bottom

      if eof()
         skip -1
      endif 

   elseif WOPC == 3

      do while .t.

         WBRINCO = space(15)
  
         @ 01,16 get WBRINCO picture "@!" valid busca5_BRINCO()
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

   elseif WOPC == 4

      do while .t.

         WREGISTRO = space(15)

         @ 01,62 get WREGISTRO picture "@!"                           
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

   elseif WOPC == 5
    
      WNOME = space(50)

      @ 02,16 get WNOME picture "@!"                           
      read_f()           

      if empty(WNOME) .or. lastkey() == 27
         loop
      endif

      select PLANTEL 
      ordsetfocus("SINC003")
      seek upper(WNOME)
       
      if eof() 
         skip -1
      endif 

   elseif WOPC == 6
 
      do while .t.

         WBRINCO_MAE = space(15)
  
         @ 05,62 get WBRINCO_MAE picture "@!" 
         read_f()
 
         if empty(WBRINCO_MAE) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select PLANTEL
         ordsetfocus("SINC004")
         seek WBRINCO_MAE

         if ! found()
            MENSAGEM("N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado!",0)
           loop
         endif

      exit
      enddo

   elseif WOPC == 7
 
      sc_PLANTEL(2)   

      WENTRADA = DATE()

      @ 10,16 get WENTRADA                          
      read_f()           

      if ! empty(WENTRADA) .or. lastkey() <> 27
         select PLANTEL
         ordsetfocus("SINC005")
         seek WENTRADA 
        
         if eof()
            skip -1
         endif
      else
         WTRAVA = .t.
      endif

   elseif WOPC == 7
 
      sc_PLANTEL(2)   

      WSAIDA = DATE()

      @ 14,16 get WSAIDA                          
      read_f()           

      if ! empty(WSAIDA) .or. lastkey() <> 27
         select PLANTEL
         ordsetfocus("SINC006")
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

   WTL = 1

   do while .t.
        
      WNASC    = NASC 
      WLOTE    = LOTE
      WRACA    = RACA      
      WPASTO   = PASTO     
      WCATEG   = CATEG     
      WGRUPO   = GRUPO     
      WSUB_GRP = SUB_GRP   
      WPEND    = PEND      
   
      // Dados Familiares - Materno 
      WDFM_RMAE  = DFM_RMAE         // raça da mãe 
      WDFM_RAVO1 = DFM_RAVO1        // raça da avó 
      WDFM_RAVO2 = DFM_RAVO2        // raça do avô 
   
      // Dados Familiares - Paterno  
      WDFP_RPAI  = DFP_RPAI         // raça do pai 
      WDFP_RAVO1 = DFP_RAVO1        // raça da avó 
      WDFP_RAVO2 = DFP_RAVO2        // raça do avô 

      exibe_DADOS_PLANTEL(WTL)

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw/Pgup-Pr"+chr(162)+"ximo/Anterior   ENTER-Muda P"+chr(160)+"gina   H-Hist"+chr(162)+"rico   ESC-FIM")

      setcolor(COR_DEST)

      if WOPC == 1 .or. WOPC == 2 .or. WOPC == 3
         @ 01,00 say chr(175)   
         @ 01,49 say space(01)   
         @ 02,00 say space(01)   
         @ 05,49 say space(01)  
         
         if WTL == 2   
            @ 10,00 say space(01)  
            @ 14,00 say space(01)
         endif 

      elseif WOPC = 4
        
         @ 01,00 say space(01)  
         @ 01,49 say chr(175)    
         @ 02,00 say space(01)
         @ 05,49 say space(01)  
         
         if WTL == 2   
            @ 10,00 say space(01)  
            @ 14,00 say space(14)
         endif 

      elseif WOPC == 5
        
         @ 01,00 say space(01)  
         @ 01,49 say space(01)    
         @ 02,00 say chr(175)    
         @ 05,49 say space(01)  
         
         if WTL == 2   
            @ 10,00 say space(01)  
            @ 14,00 say space(14)
         endif 

      elseif WOPC == 6
         @ 01,00 say space(01)  
         @ 01,49 say space(01)  
         @ 02,00 say space(01)
         @ 05,49 say chr(175)   
         
         if WTL == 2   
            @ 10,00 say space(01)  
            @ 14,00 say space(14)
         endif 

      elseif WOPC == 7
         @ 01,00 say space(01)  
         @ 01,49 say space(01)  
         @ 02,00 say space(01)
         @ 05,49 say space(01)
         
         if WTL == 2   
            @ 10,00 say chr(175) 
            @ 14,00 say space(01)
         endif 
      
      elseif WOPC == 8
         @ 01,00 say space(01)  
         @ 01,49 say space(01)  
         @ 02,00 say space(01)
         @ 05,49 say space(01)
         
         if WTL == 2   
            @ 10,00 say space(01)
            @ 14,00 say chr(175) 
         endif 
      endif

      setcolor(COR_TEXT)

      KEY = inkey(0)

      if KEY == 03
         skip +1
         if eof()
            skip -1
         endif
      elseif KEY == 18
         skip -1
      elseif KEY == 27
         exit
      elseif KEY == 13
         WTL++ 
         if WTL > 2
            WTL = 1
         endif 
      elseif KEY == 72 .or. KEY == 104 
         painelDeHistoricoDoPLANTEL(BRINCO) 
      endif

      if ! KEYS()
         @ 02,00 clear to 22,79
         @ 24,00 clear to 24,79
         exit
      endif

   enddo

enddo

return .t.


********************
function EXC_PLANTEL
********************
LOCAL WBOX := savescreen(00,00,24,79)
LOCAL WCOR := setcolor() 

SET CENTURY ON 
 
do while .t.

   sc_PLANTEL(1)

   WBRINCO = space(15)
  
   @ 01,16 get WBRINCO picture "@!" valid busca5_BRINCO()
   read_f()
 
   if empty(WBRINCO) .or. lastkey() == 27
      restscreen(00,00,24,79,WBOX)
      setcolor(WCOR)
      SET CENTURY OFF
      return .t.
   endif
   
   select PLANTEL
   ordsetfocus("SINC001")
   seek WBRINCO

   if ! found()
      MENSAGEM("N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado!",0)
      loop
   endif

   WNASC    = NASC 
   WLOTE    = LOTE
   WRACA    = RACA      
   WPASTO   = PASTO     
   WCATEG   = CATEG     
   WGRUPO   = GRUPO     
   WSUB_GRP = SUB_GRP   
   WPEND    = PEND      

   // Dados Familiares - Materno 
   WDFM_RMAE  = DFM_RMAE         // raça da mãe 
   WDFM_RAVO1 = DFM_RAVO1        // raça da avó 
   WDFM_RAVO2 = DFM_RAVO2        // raça do avô 

   // Dados Familiares - Paterno  
   WDFP_RPAI  = DFP_RPAI         // raça do pai 
   WDFP_RAVO1 = DFP_RAVO1        // raça da avó 
   WDFP_RAVO2 = DFP_RAVO2        // raça do avô 

   exibe_DADOS_PLANTEL(1)

   if CONFIRMA(24,"Excluir a ficha do aninmal do plantel...(S/N)?","N") = "S"
      select PLANTEL
 
      if ! reglock()
         loop
      endif
       
      replace BRINCO     with space(15),;
              REGISTRO   with space(15),;
              NOME       with space(50),;
              NASC       with ctod(space(08)),;
              RACA       with 0,;
              SEXO       with space(01),;
              PELAGEM    with space(20),;
              BRINCO_MAE with space(15),;
              LOTE       with 0,;
              PASTO      with 0,;
              CATEG      with 0,;
              GRUPO      with 0,; 
              SUB_GRP    with 0,;
              PEND       with 0,; 
              DFM_NMAE   with space(35),;
              DFM_RMAE   with 0,;
              DFM_NAVO1  with space(35),;
              DFM_RAVO1  with 0,;
              DFM_NAVO2  with space(35),;
              DFM_RAVO2  with 0,;
              DFP_NPAI   with space(35),;
              DFP_RPAI   with 0,;
              DFP_NAVO1  with space(35),;
              DFP_RAVO1  with 0,;
              DFP_NAVO2  with space(35),;
              DFP_RAVO2  with 0,;
              ENTRADA    with ctod(space(08)),;
              PESO       with 0,;
              DOC        with space(12),;
              VALOR      with 0,;
              SAIDA      with ctod(space(08)),;
              MOTIVO     with space(15),;
              OBS1       with space(60),;
              OBS2       with space(60),;
              OBS3       with space(60),;
              OBS4       with space(60),;
              USER_INC   with space(20),;
              DATE_INC   with ctod(space(08)),;
              TIME_INC   with space(08),;
              USER_ALT   with space(20),;
              DATE_ALT   with ctod(space(08)),;
              TIME_ALT   with space(08),; 
              USER_BX    with space(20),;
              DATE_BX    with ctod(space(08)),;
              TIME_BX    with space(08),;
              USER_CAN   with space(20),;
              DATE_CAN   with ctod(space(08)),;
              TIME_CAN   with space(08)      
      delete
      grava()        
          
      MENSAGEM("AVISO!;A ficha do animal foi exclu"+chr(161)+"do com sucesso!",0)
   endif 

enddo

return .t.


**********************************
function exibe_DADOS_PLANTEL(WACT)
**********************************
SET CENTURY ON 

sc_PLANTEL(WACT)

select PLANTEL 

@ 01,16 say BRINCO        picture "@!"                                  
@ 01,62 say REGISTRO
@ 02,16 say NOME          picture "@!"
@ 03,16 say NASC                                                           
@ 04,16 say RACA          picture "@Z 999"          
  
select RACA
ordsetfocus("SINC001")
seek WRACA
   
if found()
   @ 04,20 say NOME
else 
   @ 04,20 say space(30) 
endif
   
select PLANTEL 

@ 04,62 say SEXO          picture "!"      

if SEXO == "M"
   @ 04,62 say "Macho"
elseif SEXO == "F"
   @ 04,62 say "F"+chr(136)+"mea"
else 
   @ 04,62 say "N/D  "
endif 

@ 05,16 say PELAGEM 
@ 05,62 say BRINCO_MAE    picture "@!"                                  
@ 06,16 say LOTE          picture "@Z 999"                                   
@ 07,16 say PASTO         picture "@Z 999"                                    

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
   
   select RACA
   ordsetfocus("SINC001")
   seek WDFM_RMAE

   if found()
      @ 16,48 say NOME
   else 
      @ 16,48 say space(30) 
   endif

   seek WDFM_RAVO1

   if found()
      @ 17,48 say NOME
   else 
      @ 17,48 say space(30) 
   endif

   seek WDFM_RAVO2

   if found()
      @ 18,48 say NOME
   else 
      @ 18,48 say space(30) 
   endif

   select PLANTEL 

   // Dados Familiares - Paterno  
   @ 20,06 say DFP_NPAI   picture "@!"       // nome do pai 
   @ 20,44 say DFP_RPAI   picture "@Z 999"   // raça do pai 
   @ 21,06 say DFP_NAVO1  picture "@!"       // nome da avó 
   @ 21,44 say DFP_RAVO1  picture "@Z 999"   // raça da avó 
   @ 22,06 say DFP_NAVO2  picture "@!"       // nome do avô
   @ 22,44 say DFP_RAVO2  picture "@Z 999"   // raça do avô    
     
   select RACA
   ordsetfocus("SINC001")
   seek WDFP_RPAI

   if found()
      @ 20,48 say NOME
   else 
      @ 20,48 say space(30) 
   endif

   seek WDFP_RAVO1

   if found()
      @ 21,48 say NOME
   else 
      @ 21,48 say space(30) 
   endif

   seek WDFP_RAVO2

   if found()
      @ 22,48 say NOME
   else 
      @ 22,48 say space(30) 
   endif
  
   select PLANTEL 

   calc_IDADE()
   
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

   select CATEG
   ordsetfocus("SINC001")
   seek WCATEG

   if found()
      @ 09,20 say NOME
   endif 

   select GRUPO_P
   ordsetfocus("SINC001")
   seek WGRUPO 
   
   if found()
      @ 10,20 say NOME
   endif 

   select SUB_GRP
   ordsetfocus("SINC001")
   seek WSUB_GRP
   
   if found()
      @ 11,20 say NOME
   endif 

   select PENDENC
   ordsetfocus("SINC001")
   seek WPEND
   
   if found()
      @ 12,20 say NOME
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

SET CENTURY OFF

return .t.

*****************************
function save_PLANTEL(MODULO)
*****************************
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

if MODULO == "INC" 
   replace USER_INC with WPUSUARIO,;
           DATE_INC with date(),;
           TIME_INC with time(),;
           USER_ALT with space(20),;
           DATE_ALT with ctod(space(08)),;
           TIME_ALT with space(08),;
           USER_BX  with space(20),;
           DATE_BX  with ctod(space(08)),;
           TIME_BX  with space(08),;
           USER_CAN with space(20),;
           DATE_CAN with ctod(space(08)),;
           TIME_CAN with space(08)      
 
elseif MODULO == "ALT" 
   replace USER_ALT with WPUSUARIO,;
           DATE_ALT with date(),;
           TIME_ALT with time()

elseif MODULO == "BX"
   replace USER_BX  with WPUSUARIO,;
           DATE_BX  with date(),;
           TIME_BX  with time()   
endif

grava()

return .t.


********************************************
function painelDeHistoricoDoPLANTEL(WBRINCO)
********************************************
LOCAL WOP

SOMBRA(14,46,21,79,8)

setcolor(COR_CONS)
@ 13,44 clear to 20,78

@ 13,45 say    "        H I S T O R I C O        "

@ 15,45 PROMPT "Dados Reprodutivos               "
@ 16,45 PROMPT "Pesagens                         "
@ 17,45 PROMPT "Sintomas Cl"+chr(161)+"nicos/Tratamentos    "
@ 18,45 PROMPT "Troca de Lote                    "
@ 19,45 PROMPT "Troca de Pasto/Piquete           "
@ 20,45 PROMPT "Vacina"+chr(135)+chr(132)+"o                        "
MENU TO WOP 

setcolor(COR_TEXT)

if WOP == 5
   painelDeTrocaPasto(WBRINCO)
elseif WOP == 6
   painelDeVacinacoes(WBRINCO)  
endif 

return .t.


************************************
function painelDeTrocaPasto(WBRINCO)
************************************
LOCAL WAREA := ALIAS()
LOCAL WBOX  := savescreen(08,00,22,79)
LOCAL WLIN  := 12

setcolor(COR_TEXT)
@ 08,00 clear to 22,79 
@ 24,00 clear to 24,79

setcolor(COR_CONS)
@ 09,01 clear to 09,78
CENTRO(09,"DADOS DE TROCA DE PASTO/PIQUETE")
setcolor(COR_TEXT)
   
@ 10,01 say "SEQ    DATA        DE                            PARA"

setcolor(COR_SUB)
@ 11,01 to 11,78
setcolor(COR_TEXT)

select TROCA_P 
ordsetfocus("SINC002")
seek WBRINCO 

do while BRINCO == WBRINCO .and. ! eof() 

   @ WLIN,01 say SEQ    picture "999999"
   @ WLIN,09 say DATA
   @ WLIN,19 say strzero(PASTO_ANT,3)
   @ WLIN,49 say strzero(PASTO_NEW,3) 

   WP1 = PASTO_ANT 
   WP2 = PASTO_NEW

   select PASTO
   ordsetfocus("SINC001")
   seek WP1

   if found() 
      @ WLIN,22 say "-"+NOME 
   else 
      @ WLIN,22 say "-"+"N/C"
   endif 
 
   seek WP2

   if found() 
      @ WLIN,52 say "-"+NOME 
   else 
      @ WLIN,52 say "-"+"N/C"
   endif 

   select TROCA_P 
   skip +1 
   
   WLIN++

   if WLIN > 22 
      inkey(0)
      WLIN = 22
      scroLl(12,00,22,79,-1) 
   endif 

enddo

CENTRO(24,"Pressione qualquer tecla para retornar...")
inkey(0)

restscreen(08,00,22,79,WBOX)

select &WAREA

return .t.


************************************
function painelDeVacinacoes(WBRINCO)
************************************
LOCAL WAREA := ALIAS()
LOCAL WBOX  := savescreen(08,00,22,79)
LOCAL WLIN  := 12

setcolor(COR_TEXT)
@ 08,00 clear to 22,79 
@ 24,00 clear to 24,79

setcolor(COR_CONS)
@ 09,01 clear to 09,78
CENTRO(09,"DADOS DE VACINA"+chr(128)+chr(142)+"O")
setcolor(COR_TEXT)
   
@ 10,01 say "SEQ     DATA        VACINA                              PROXIMA"

setcolor(COR_SUB)
@ 11,01 to 11,78
setcolor(COR_TEXT)

select VACINA_P 
ordsetfocus("SINC002")
seek WBRINCO 

do while BRINCO == WBRINCO .and. ! eof() 

   @ WLIN,01 say SEQ    picture "999999"
   @ WLIN,09 say DATA
   @ WLIN,21 say strzero(VACINA,3)
   @ WLIN,57 say PROXIMA

   WCOD = VACINA 
    
   select VACINA 
   ordsetfocus("SINC001")
   seek WCOD 

   if found() 
      @ WLIN,24 say "-"+NOME 
   else 
      @ WLIN,24 say "-"+"N/C"
   endif 

   select VACINA_P 
   skip +1 
   
   WLIN++

   if WLIN > 22 
      inkey(0)
      WLIN = 22
      scroLl(12,00,22,79,-1) 
   endif 

enddo

CENTRO(24,"Pressione qualquer tecla para retornar...")
inkey(0)

restscreen(08,00,22,79,WBOX)

select &WAREA

return .t.

