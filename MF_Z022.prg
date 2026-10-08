*********************************************************************
****  Sistema......: MF-Minha Fazenda                            ****
****  Programa.....: MF_Z022.PRG                                 ****
****  Finalidade...: Exibe o total do plantel por filtro         ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************

***************************************
function totalDeAnimaisNoPasto(WCODIGO)
***************************************
LOCAL WAREA := ALIAS()
LOCAL WCOR  := setcolor()

**************************************************************************************** cria a tabela temporaria
  
WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
WCMP  := {"BRINCO", "SEXO", "PELAGEM", "IDADE", "RACA"}                   
WTPO  := {"C"     , "C"   , "C"      , "C"    , "C"   }
WTMO  := {08      , 05    , 20       , 20     , 30    }
WDEC  := {00      , 00    , 00       , 00     , 00    }
    
WIDX1 := "BRINCO"
WIDX2 := ""
WIDX3 := ""
    
cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
*****************************************************************************************************************  

setcolor(COR_DEST)

WTOTAL_F = 0
WTOTAL_M = 0 

select PASTO 
ordsetfocus("SINC001")
seek WCODIGO

if found()
   det_PASTO = NOME
else
   det_PASTO = "NAO CADASTRADO"
endif

select PLANTEL
ordsetfocus("SINC001")
go top

do while ! eof()

   if PASTO <> WCODIGO 
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

BRW_HELP(alltrim(det_PASTO)+"|M: "+str(WTOTAL_M,3)+"|F:"+str(WTOTAL_F,3),.t., {;
{"BRINCO" ,"99999999","Brinco"         },;
{"SEXO"   ,""        ,"Sexo"           },;
{"PELAGEM",""        ,"Pelagem"        },;
{"IDADE"  ,""        ,"Idade"          },;
{"RACA"   ,""        ,"Ra"+chr(135)+"a"}})
 
@ 24,00 clear to 24,79
if CONFIRMA(24,"Imprimir rela"+chr(135)+chr(132)+"o de animais do pasto...(S/N)?","N") == "S"
   // print_ANIMAIS_PASTO(det_PASTO, WTOTAL_M, WTOTAL_F)
endif

exclui_TMP("201", WARQ+".DBF" , WARQ+".CDX" )

select &WAREA 

setcolor(WCOR)

keyboard ""

return .t.


**************************************
function totalDeAnimaisNoLote(WCODIGO)
**************************************
LOCAL WAREA := ALIAS()
LOCAL WCOR  := setcolor()

**************************************************************************************** cria a tabela temporaria
  
WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
WCMP  := {"BRINCO", "SEXO", "PELAGEM", "IDADE", "RACA"}                   
WTPO  := {"C"     , "C"   , "C"      , "C"    , "C"   }
WTMO  := {08      , 05    , 20       , 20     , 30    }
WDEC  := {00      , 00    , 00       , 00     , 00    }
    
WIDX1 := "BRINCO"
WIDX2 := ""
WIDX3 := ""
    
cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
*****************************************************************************************************************  

setcolor(COR_DEST)

WTOTAL_F = 0
WTOTAL_M = 0

select LOTE
ordsetfocus("SINC001")
seek WCODIGO

if found()
   det_LOTE = NOME
else
   det_LOTE = "NAO CADASTRADO"
endif

select PLANTEL
ordsetfocus("SINC001")
go top

do while ! eof()

   if LOTE <> WLOTE
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

BRW_HELP(alltrim(det_LOTE)+"|M: "+str(WTOTAL_M,3)+"|F:"+str(WTOTAL_F,3),.t., {;
{"BRINCO" ,"99999999","Brinco"         },;
{"SEXO"   ,""        ,"Sexo"           },;
{"PELAGEM",""        ,"Pelagem"        },;
{"IDADE"  ,""        ,"Idade"          },;
{"RACA"   ,""        ,"Ra"+chr(135)+"a"}})
 
@ 24,00 clear to 24,79
if CONFIRMA(24,"Imprimir rela"+chr(135)+chr(132)+"o de animais do lote...(S/N)?","N") == "S"
   // print_ANIMAIS_LOTE(det_PASTO, WTOTAL_M, WTOTAL_F)
endif

exclui_TMP("201", WARQ+".DBF" , WARQ+".CDX" )

select &WAREA 

setcolor(WCOR)

keyboard ""

return .t.


***************************************
function totalDeAnimaisPorRaca(WCODIGO)
***************************************
LOCAL WAREA := ALIAS()
LOCAL WCOR  := setcolor()

**************************************************************************************** cria a tabela temporaria
  
WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
WCMP  := {"BRINCO", "SEXO", "PELAGEM", "IDADE", "RACA"}                   
WTPO  := {"C"     , "C"   , "C"      , "C"    , "C"   }
WTMO  := {08      , 05    , 20       , 20     , 30    }
WDEC  := {00      , 00    , 00       , 00     , 00    }
    
WIDX1 := "BRINCO"
WIDX2 := ""
WIDX3 := ""
    
cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
*****************************************************************************************************************  

setcolor(COR_DEST)

WTOTAL_F = 0
WTOTAL_M = 0 

select RACA 
ordsetfocus("SINC001")
seek WCODIGO 

if found()
   det_RACA = NOME
else
   det_RACA = "NAO CADASTRADO"
endif

select PLANTEL
ordsetfocus("SINC001")
go top

do while ! eof()

   if RACA <> WRACA
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

BRW_HELP(alltrim(det_RACA)+"|M: "+str(WTOTAL_M,3)+"|F:"+str(WTOTAL_F,3),.t., {;
{"BRINCO" ,"99999999","Brinco"         },;
{"SEXO"   ,""        ,"Sexo"           },;
{"PELAGEM",""        ,"Pelagem"        },;
{"IDADE"  ,""        ,"Idade"          },;
{"RACA"   ,""        ,"Ra"+chr(135)+"a"}})
 
@ 24,00 clear to 24,79
if CONFIRMA(24,"Imprimir rela"+chr(135)+chr(132)+"o de animais por ra"+chr(135)+"a...(S/N)?","N") == "S"
 //  print_ANIMAIS_RACA(det_RACA, WTOTAL_M, WTOTAL_F)
endif

exclui_TMP("201", WARQ+".DBF" , WARQ+".CDX" )

select &WAREA 

setcolor(WCOR)

keyboard ""

return .t.


****************************************
function totalDeAnimaisPorGrupo(WCODIGO)
****************************************
LOCAL WAREA := ALIAS()
LOCAL WCOR  := setcolor()

**************************************************************************************** cria a tabela temporaria
  
WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
WCMP  := {"BRINCO", "SEXO", "PELAGEM", "IDADE", "RACA"}                   
WTPO  := {"C"     , "C"   , "C"      , "C"    , "C"   }
WTMO  := {08      , 05    , 20       , 20     , 30    }
WDEC  := {00      , 00    , 00       , 00     , 00    }
    
WIDX1 := "BRINCO"
WIDX2 := ""
WIDX3 := ""
    
cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
*****************************************************************************************************************  

setcolor(COR_DEST)

WTOTAL_F = 0
WTOTAL_M = 0 

select GRUPO_P
ordsetfocus("SINC001")
seek WCODIGO 

if found()
   det_GRUPO = NOME
else
   det_GRUPO = "NAO CADASTRADO"
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

BRW_HELP(alltrim(det_RACA)+"|M: "+str(WTOTAL_M,3)+"|F:"+str(WTOTAL_F,3),.t., {;
{"BRINCO" ,"99999999","Brinco"         },;
{"SEXO"   ,""        ,"Sexo"           },;
{"PELAGEM",""        ,"Pelagem"        },;
{"IDADE"  ,""        ,"Idade"          },;
{"RACA"   ,""        ,"Ra"+chr(135)+"a"}})
 
@ 24,00 clear to 24,79
if CONFIRMA(24,"Imprimir rela"+chr(135)+chr(132)+"o de animais do grupo...(S/N)?","N") == "S"
   // print_ANIMAIS_GRUPO(det_GRUPO, WTOTAL_M, WTOTAL_F)
endif

exclui_TMP("201", WARQ+".DBF" , WARQ+".CDX" )

select &WAREA 

setcolor(WCOR)

keyboard ""

return .t.
