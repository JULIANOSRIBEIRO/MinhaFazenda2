*********************************************************************
****  Sistema......: MF-Minha Fazenda (Gerenciador)              ****
****  Versao.......: 1.0                                         ****
****  Programa.....: MF.PRG                                      ****
****  Finalidade...: Programa Principal                          ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR - Março/2022                       ****
*********************************************************************
#include "winuser.ch"
#include "win32prn.ch"
#include "inkey.ch"
#include "colors.ch" 
 
REQUEST DBFCDX     // Indice CDX 
REQUEST HB_LANG_PT // Portuguese language
REQUEST HB_CODEPAGE_PTISO
REQUEST HB_CODEPAGE_PT850
REQUEST DESCEND

PROCEDURE Main()

LOCAL nTask
LOCAL hIniData := HB_ReadIni("MF.INI")           
LOCAL aDIR := Directory(ExeName())
PUBLIC nServer := atrepl('"', getenv("COMPUTERNAME"), "") 
PUBLIC WPUSUARIO  
PUBLIC WPSENHA 
PUBLIC WWNAV := .f.

********************************************************************

rddSetDefault( "DBFCDX" )
HB_LangSelect( "PT" )
HB_SetCodePage( "PT850" )

HB_IdleAdd( {|| HB_BackGroundRun() } )
nTask := HB_BackGroundAdd( {||timeout() }, 1000 )

set exclusive off
set intens on
set deleted on
set talk off 
set echo off
set bell off  
set scoreboard off
set date british 
set softseek on
set decimals to 2
set fixed on
set century off
set epoch to 1950
set errorlog to erro_mf.log additive

setcursor(0)
setblink(.t.)
setmode(25,80)

set key 28 to SCALC

// declara as variaveis publicas do Sistema
public WPUSUARIO, WPDOMINIO, WPPERFIL, SIR
public WBUILD

WPUSUARIO = space(50)            // upper(left(atrepl('"', getenv("USERNAME"), "")+space(50),50)) 
WPDOMINIO = upper(left(atrepl("", getenv("USERDOMAIN"), "")+space(20),20))
SIR       = "BMA"
WBUILD    = NumToHex((abs(aDIR[1,3]-ctod("01/01/2020"))*24*60*60)+timetosec(aDIR[1,4]),8)

if alltrim(WPUSUARIO) == "ADMINISTRATOR" 
   WPUSUARIO = left("ADMINISTRADOR"+space(50),50)
endif

CRI = ""                        // Codigo de Referencia Interna 

public oPrinter                 // objeto de impressao
public pathMAIN, pathTXT, pathXLS, pathTMP, pathEDI, WPRFX
public WDIRE1, WDIRE_AUX, WDIRE_TEMP

COR_MENU   = "W/R"
COR_OPC    = "BG/W"
COR_DEST   = "GR+/BG"
COR_SUB    = "BG+/BG"
COR_CAB    = "N/W"
COR_CONS   = "N/W"
COR_TEXT   = "N/BG"
COR_GETS   = "GR+/R"
COR_GETA   = "GR+/BG"
COR_BARRA  = "R/W"
COR_NEG    = "W+/N"
COR_GREEN  = "G/W"
COR_WHI    = "W+/BG"
COR_RED    = "R/BG"
COR_NGV    = "W+/N"
COR_GREEN2 = "N+/G"

if Maxrow() <> 24 .and. MaxCol() <> 79
   setcolor(right(COR_TEXT,len(COR_TEXT)-at("/",COR_TEXT))+"+/N")
   centro(09, "Aten"+chr(135)+chr(132)+"o") 
   centro(10, "Dimensione o tamanho da janela para largura 80 e altura 25") 
   @ 11,20 to 11,59
   centro(12, "Em caso de d"+chr(163)+"vida, entre em contato com o nosso suporte.")
   centro(13, "Gera Sinergia")
   centro(14, "0800-721-0809")
   inkey(0)
   quit
endif 

setcolor(COR_TEXT+","+COR_GETS+","+COR_TEXT+","+COR_TEXT+","+COR_GETA)

WDIRE1     = hIniData["MAIN"]["WDIRE1"]          // Diretorio Ativo
WDIRE_AUX  = hIniData["MAIN"]["WDIRE_AUX"]       // Diretorio Auxiliar
WDIRE_TEMP = hIniData["MAIN"]["WDIRE_TEMP"]      // Diretorio Temp
WWEB       = hIniData["MAIN"]["WWEB"]            // Diretorio Web

WPRFX      = len(alltrim(hIniData["DIRETORIOS"]["pathMAIN"])) + 1

pathMAIN   = hIniData["DIRETORIOS"]["pathMAIN"]
pathTXT    = pathMAIN+"\RELAT"
pathCSV    = pathMAIN+"\EXCEL"
pathTMP    = WDIRE_TEMP
pathWEB    = WWEB

if ! IsDirectory(pathMAIN)
   MakeDir(pathMAIN)
endif

if ! IsDirectory(pathTXT)
   MakeDir(pathTXT)
endif

if ! IsDirectory(pathCSV)
   MakeDir(pathCSV)
endif

if ! IsDirectory(pathTMP)
   MakeDir(pathCSV)
endif

if file("TEMP\STOP.INI")
   setcolor(right(COR_TEXT,len(COR_TEXT)-at("/",COR_TEXT))+"+/N")
   centro(12, "Desculpe o transtorno. Estamos em manuten"+chr(135)+chr(132)+"o.")
   inkey(5)
   fim()
endif

*********************************************** LOGIN.DBF

if ! file("&WDIRE_AUX\LOGIN.CDX")
   abre(204,"&WDIRE_AUX\LOGIN","E")
   index on HB_Decrypt(USUARIO,"$!nc0n@2012") tag SINC001
   index on HB_Decrypt(PERFIL,"$!nc0n@2012")  tag SINC002
   dbclosearea()
endif

abre(000,"&WDIRE_AUX\LOGIN")

*********************************************************
MENSAGEM("OLA MUNDO :);ESTOU AQUI...",0)
LOGIN()

MENU_PRINCIPAL()

return .t.


***********************
function MENU_PRINCIPAL
***********************
setcolor(COR_TEXT)
@ 00,00 clear to 24,79

setcolor(COR_TEXT)
@ 00,01 say "MINHA FAZENDA"
setcolor(COR_SUB)
@ 00,75 say chr(175)+"MF"+chr(174)

setcolor(COR_BARRA)
@ 01,00 clear to 01,79
@ 01,41 say chr(179)
@ 01,52 say chr(179)
@ 01,58 say chr(179)

@ 01,54 say SIR

@ 23,00 clear to 23,79
@ 23,23 say chr(179)
@ 23,34 say chr(179)
@ 23,45 say chr(179)
@ 23,61 say chr(179)

@ 23,01 say left(WPUSUARIO,20)
@ 23,25 say "PRODU"+chr(128)+chr(142)+"O"
@ 23,36 say upper(WBUILD)

if (len(alltrim(nServer)) > 13)
   @ 23,47 say left(nServer,10)+"..."
else
   @ 23,47 say left(nServer,13)
endif

setcolor(COR_TEXT)

setcursor(0)

SET BACKGROUND TASKS ON

OPC0 = 1

do while .t.

   setcolor(COR_TEXT)
   @ 00,01 clear to 00,40
   @ 00,01 say "MINHA FAZENDA"

   private OPCAO[3]

   OPCAO[1] = " Fazendas " 
   OPCAO[2] = " Utilit"+chr(160)+"rios " 
   OPCAO[3] = " Fim " 

   private LETRA[3]

   LETRA[1] = "A"
   LETRA[2] = "U"  
   LETRA[3] = "F"  
   
   private ACESSO[3]
   for I = 1 to 2
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[3] = .t.

   OPC0 = achoise(OPC0,0,OPCAO,ACESSO,LETRA,.f.)

   if OPC0 == 0
      OPC0 = 3
   elseif OPC0 == 1  
      acesso_FAZ()
   elseif OPC0 == 2 
      UTIL()
   elseif OPC0 == 3  
      fim()
   endif    

enddo

return .t.

**************
function LOGIN
**************
#include "setcurs.ch"
#include "getexit.ch"
#include "inkey.ch"
#include "common.ch"

LOCAL nCHOICE := 1
LOCAL nCOR    := setcolor()

PAPEL()

WPUSUARIO = space(20)
WPSENHA   = space(10)

SOMBRA(04,28,20,54,8)

setcolor(COR_CAB)
@ 03,26 clear to 19,53
@ 03,26 to 19,53
@ 04,32 say 'LOGIN DE ACESSO'

setcolor(COR_CAB+'+') 
@ 04,26 to 18,26  
@ 03,27 to 03,52
@ 03,26 say chr(218)  
@ 19,26 say chr(192)  

@ 05,38 say 'MF'
@ 08,36 say 'usu'+chr(160)+'rio'
@ 11,37 say 'senha'

setcolor(COR_GREEN)
@ 15,37 say "      __"
@ 16,37 say "|\/| |_ "
@ 17,37 say "|  | |  "

setcolor(COR_CAB+'+') 
@ 18,34 say "MinhaFazenda"

do while .t.

   setcolor(COR_CAB+','+COR_NEG+',,,'+COR_CAB)

   @ 07,30 get WPUSUARIO picture '@!@S20'
   read_f()

   if lastkey() = 27 .or. empty(WPUSUARIO)
      fim()
   endif

   select LOGIN
   ordsetfocus("SINC001")
   seek WPUSUARIO+space(30)

   if ! found()
      setcolor(COR_NEG)
      SaySpread("Usu"+chr(160)+"rio n"+chr(132)+"o cadastrado!", 50, 14, 40 )
      inkey(3)
      setcolor(COR_CONS)
      @ 14,29 clear to 14,51
      loop
   endif

   WPPERFIL = HB_Decrypt(PERFIL, "$!nc0n@2012")
 
   WTM = ((79-len(alltrim(WPUSUARIO))) / 2)
   @ 07,30 clear to 07,50
   @ 07,WTM say alltrim(WPUSUARIO)

   do while .t.

      setcolor(COR_CONS+'+')
      @ 11,37 say 'senha'

      setcolor(COR_CAB+','+COR_NEG+',,,'+COR_CAB)

      WPSENHA = GetSecret( WPSENHA, 10, 35, .t., '')

      if lastkey() == 27
         fim()
      endif
 
      if alltrim(WPSENHA) <> alltrim(HB_Decrypt(SENHA,"$!nc0n@2012"))
         setcolor(COR_NEG)
         SaySpread("Senha de acesso inv"+chr(160)+"lida!", 50, 14, 40 )
         inkey(3)
         setcolor(COR_CONS)
         @ 14,28 clear to 14,52
         loop
      endif

      WTM = ((79-len(alltrim(WPSENHA))) / 2)
      WTL = len(alltrim(WPSENHA))
      @ 10,30 clear to 10,50
      @ 10,WTM say replicate(chr(01),WTL)

   exit
   enddo

exit
enddo

setcolor(COR_GREEN)

if seconds() <= 43200
   WMSG = ' Bom dia! '
elseif seconds() <= 64800
   WMSG = 'Boa tarde!'
else
   WMSG = 'Boa noite!'
endif

@ 13,35 say WMSG

setcolor(COR_CAB+'+')
@ 14,27 to 14,52

setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_GETA)

OPEN_ARQ()
  
return .t.

*************************
function VER_SENHA(WPCRI)
*************************
LOCAL WAREA := ALIAS()

if alltrim(WPPERFIL) == "@ADMINISTRADOR"
   return .t.
endif

select ACESSO
ordsetfocus("SINC001")
seek WPPERFIL+WPCRI

if (HB_Decrypt(USUARIO,"$!nc0n@2012") == WPPERFIL .and. alltrim(WPCRI) == alltrim(HB_Decrypt(ACRI,"$!nc0n@2012")))
   if ! empty(WAREA)
      select &WAREA
   endif
   return .t.
else
   if ! empty(WAREA)
      select &WAREA
   endif
   return .f.
endif

return .t.
                                               
****************  
function TIMEOUT                                     
****************  
STATIC COUNTTIME  := 0
STATIC LASTKEYREG := 0

LOCAL WROW := row()
LOCAL WCOL := col()

if lastkey() == LASTKEYREG
   COUNTTIME = COUNTTIME + 1
else
   COUNTTIME  = 0
   LASTKEYREG = lastkey()
endif   

if COUNTTIME >= 1801 .or. file("TEMP\STOP.INI")
   FIM()
elseif COUNTTIME >= 3600  // 60 minutos
   if alert('Sistema inoperante a 60 minutos!', {"Finalizar.","Continuar."}, "W+/R,"+COR_BARRA, 20) == 2
      COUNTTIME = 0
   endif
else
   DispOutAt(23, 71, time(), COR_BARRA, .f.)
   setpos(WROW,WCOL)
endif

return .t.

function totalDeAnimaisNoPasto
function totaldeanimaisnolote 
function totalDeAnimaisPorRaca
function totalDeAnimaisPorGrupo
   