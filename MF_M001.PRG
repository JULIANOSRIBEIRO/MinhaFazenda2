*********************************************************************
****  Sistema......: MF-Minha Fazenda (Gerenciador)              ****
****  Versao.......: 5.0                                         ****
****  Programa.....: MFM001.PRG                                  ****
****  Finalidade...: Menus acesso da Fazenda                     ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************

*******************
function acesso_FAZ
*******************
PUBLIC WDIRE_FAZ
PUBLIC WNAM_FAZ

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

setcolor(COR_TEXT)
CENTRO(24,chr(024)+chr(025)+" selecionar / ENTER acessar / ESC-Retornar")

select FAZENDA
ordsetfocus("SINC001")
go top
DbEdit(03,10,22,70,"","","")

setcolor(COR_TEXT)
@ 02,00 clear to 22,79

if lastkey() <> 27
   WAREA     := ALIAS()
   WDIRE_FAZ := "ATIVO\"+alltrim(CODIGO)
   WNAM_FAZ  := FAZENDA   

   if ! file(WDIRE_FAZ+"\PLANTEL.DBF")
      mensagem("AVISO!;Contacte o administrador.;Diret"+chr(162)+"rio de dados inv"+chr(160)+"lido.")
      return .f.
   endif

   OPEN_ARQ_FAZ()

   menu_FAZ()

   WDIR = WDIRE_FAZ+"\FAZENDA.CFG"

   if ! file(WDIR)
      mensagem("AVISO!;Os dados da Fazenda est"+chr(132)+"o incompletos. Atualize o cadastro.")

      setcolor(COR_TEXT)
      @ 00,01 clear to 00,40
      @ 00,01 say "*** DADOS DA FAZENDA NAO CADASTRADO ***"
   
   else  
      restore from &WDIR additive
   
      setcolor(COR_TEXT)
      @ 00,01 clear to 00,40
      @ 00,01 say alltrim(CFG_FAZ)
   endif 

   FECHA_ARQ_FAZ()

   select &WAREA

else
   return .t.
endif

return .t.


*****************
function menu_FAZ
*****************
OPC1 = 1

WDIR = WDIRE_FAZ+"\FAZENDA.CFG"
restore from &WDIR additive
   
setcolor(COR_TEXT)
@ 00,01 clear to 00,40
@ 00,01 say alltrim(CFG_FAZ)

do while .t.

   private OPCAO[8]
   OPCAO[1] = " Plantel " 
   OPCAO[2] = " Movimenta"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Estoque  " 
   OPCAO[4] = " Caixa " 
   OPCAO[5] = " Dashboard" 
   OPCAO[6] = " Cadastros Diversos " 
   OPCAO[7] = " Relat"+chr(162)+"rios " 
   OPCAO[8] = " Fim " 

   private LETRA[8]
   LETRA[1] = "L"
   LETRA[2] = "M"
   LETRA[3] = "E"  
   LETRA[4] = "C"  
   LETRA[5] = "D"  
   LETRA[6] = "A"  
   LETRA[7] = "R" 
   LETRA[8] = "F" 

   private ACESSO[9]
   for I = 1 to 8
      ACESSO[I] = ver_SENHA(LETRA[I])
   next

   ACESSO[1] = .t.
   ACESSO[2] = .t.
   ACESSO[3] = .t.
   ACESSO[4] = .f.
   ACESSO[5] = .t.
   ACESSO[6] = .t.
   ACESSO[7] = .t.
   ACESSO[8] = .t.

   OPC1 = achoise(OPC1,1,OPCAO,ACESSO,LETRA,.f.)

   if OPC1 == 0 .or. OPC1 == 8
      return .t.
   elseif OPC1 == 1       // MF_Z009.PRG 
      menu_PLANTEL()
   elseif OPC1 == 2  
      menu_MOVIMENT()
   elseif OPC1 == 3  
      menu_ESTOQUE()
   elseif OPC1 == 4
      mensagem("Modulo a ser desenvolvido...")
   elseif OPC1 == 5
      DASHBOARD()
   elseif OPC1 == 6      // MF_Z010.PRG 
      menu_CAD_DIV()
   elseif OPC1 == 7
      menu_RELAT()
   endif    

enddo

return .t.

*********************
function menu_PLANTEL
*********************
OPC2 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC2 = ACHOISE(OPC2,2,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC2 == 0 .or. OPC2 == 5
      return .t.
   elseif OPC2 == 1
      INC_PLANTEL()
   elseif OPC2 == 2 
      ALT_PLANTEL() 
   elseif OPC2 == 3
      CON_PLANTEL()
   elseif OPC2 == 4
      EXC_PLANTEL()   
   endif
   
enddo

return .t.

**********************
function menu_MOVIMENT
**********************
OPC2 = 1

do while .t.

   private OPCAO[8]
   OPCAO[1] = " Pesagens " 
   OPCAO[2] = " Troca de Lote " 
   OPCAO[3] = " Troca de Pasto/Piquete " 
   OPCAO[4] = " Saida do Plantel "
   OPCAO[5] = " Vacina"+chr(135)+chr(132)+"o " 
   OPCAO[6] = " Sintomas Cl"+chr(161)+"nicos/Tratamentos " 
   OPCAO[7] = " Dados Reprodutivos " 
   OPCAO[8] = " Fim " 

   private LETRA[8]
   LETRA[1] = "P" 
   LETRA[2] = "L"
   LETRA[3] = "P"
   LETRA[4] = "S"
   LETRA[5] = "V"
   LETRA[6] = "T"
   LETRA[7] = "R"
   LETRA[8] = "F"

   private ACESSO[8]
   for I=1 to 7
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[1] = .t.
   ACESSO[2] = .t.
   ACESSO[3] = .t.
   ACESSO[4] = .t.
   ACESSO[5] = .t.
   ACESSO[6] = .t.
   ACESSO[7] = .t.
   ACESSO[8] = .t.

   OPC2 = ACHOISE(OPC2,2,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC2 == 0 .or. OPC2 == 8
       return .t.
   elseif OPC2 == 1  
      menu_PESAGEM()   
   elseif OPC2 == 2
      menu_TROCA_LOTE()
   elseif OPC2 == 3 
      menu_TROCA_PASTO()
   elseif OPC2 == 4
      menu_SAIDA_PLANTEL()
   elseif OPC2 == 5
      menu_VACINACAO()
   elseif OPC2 == 6
      menu_ANAMNESE()
   elseif OPC2 == 7
      menu_DADOS_REPRODUTIVOS()    
   endif
   
enddo

return .t.

*********************
function menu_PESAGEM
*********************
OPC3 = 1

do while .t.

   private OPCAO[4]
   OPCAO[1] = " Consulta as Pesagens " 
   OPCAO[2] = " Exclus"+chr(132)+"o de Pesagens " 
   OPCAO[3] = " Leitura das Pesagens (Coimma KM3 Plus) " 
   OPCAO[4] = " Fim " 

   private LETRA[4]
   LETRA[1] = "C"
   LETRA[2] = "E"  
   LETRA[3] = "L"
   LETRA[4] = "F"  
 
   private ACESSO[4]
   for I = 1 to 3
      ACESSO[I] = ver_SENHA(LETRA[I])
   next

   ACESSO[1] = .t.
   ACESSO[2] = .t.
   ACESSO[3] = .t.
   ACESSO[4] = .t.

   OPC3 = achoise(OPC3,3,OPCAO,ACESSO,LETRA,.f.)

   if OPC3 == 0 .or. OPC3 == 6
      return .t.
   elseif OPC3 == 1  
      consulta_PESAGENS()
   elseif OPC3 == 2
      exclusao_PESAGENS()  
   elseif OPC3 == 3  
      leitura_PESAGEM()
   endif    

enddo

return .t.
   
************************
function menu_TROCA_LOTE
************************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o " 
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"  
   LETRA[4] = "E"  
   LETRA[5] = "F"  
 
   private ACESSO[5]
   for I = 1 to 4
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = achoise(OPC3,3,OPCAO,ACESSO,LETRA,.f.)

   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1  
      INC_TROCA_LOTE()
   elseif OPC3 == 2
      ALT_TROCA_LOTE()
   elseif OPC3 == 3
      CON_TROCA_LOTE() 
   elseif OPC3 == 4
      EXC_TROCA_LOTE()
   endif    

enddo

return .t.

*************************
function menu_TROCA_PASTO
*************************
OPC3 = 1

do while .t.

   private OPCAO[3]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Consulta " 
   OPCAO[3] = " Fim " 

   private LETRA[3]
   LETRA[1] = "I"
   LETRA[2] = "C"  
   LETRA[3] = "F"  
 
   private ACESSO[3]
   for I = 1 to 2
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[3] = .t.

   OPC3 = achoise(OPC3,3,OPCAO,ACESSO,LETRA,.f.)

   if OPC3 == 0 .or. OPC3 == 3
      return .t.
   elseif OPC3 == 1  
      INC_TROCA_PASTO()
   elseif OPC3 == 2
      CON_TROCA_PASTO() 
   endif    

enddo

return .t.

***************************
function menu_SAIDA_PLANTEL
***************************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o " 
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"  
   LETRA[4] = "E"  
   LETRA[5] = "F"  
 
   private ACESSO[5]
   for I = 1 to 4
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = achoise(OPC3,3,OPCAO,ACESSO,LETRA,.f.)

   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1  
      INC_SAIDA_PLANTEL()
   elseif OPC3 == 2
      ALT_SAIDA_PLANTEL()
   elseif OPC3 == 3
      CON_SAIDA_PLANTEL() 
   elseif OPC3 == 4
      EXC_SAIDA_PLANTEL()
   endif    

enddo

return .t.


***********************
function menu_VACINACAO
***********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o " 
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"  
   LETRA[4] = "E"  
   LETRA[5] = "F"  
 
   private ACESSO[5]
   for I = 1 to 4
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = achoise(OPC3,3,OPCAO,ACESSO,LETRA,.f.)

   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1  
      INC_VACINACAO()
   elseif OPC3 == 2
      ALT_VACINACAO()
   elseif OPC3 == 3
      CON_VACINACAO() 
   elseif OPC3 == 4
      EXC_VACINACAO()
   endif    

enddo

return .t.

**********************
function menu_ANAMNESE
**********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o " 
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"  
   LETRA[4] = "E"  
   LETRA[5] = "F"  
 
   private ACESSO[5]
   for I = 1 to 4
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = achoise(OPC3,3,OPCAO,ACESSO,LETRA,.f.)

   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1  
      INC_ANAMNESE()
   elseif OPC3 == 2
      ALT_ANAMNESE()
   elseif OPC3 == 3
      CON_ANAMNESE() 
   elseif OPC3 == 4
      EXC_ANAMNESE()
   endif    

enddo

return .t.

*********************
function menu_ESTOQUE
*********************
OPC2 = 1

do while .t.

   private OPCAO[5]
   
   OPCAO[1] = " Produtos " 
   OPCAO[2] = " Entradas " 
   OPCAO[3] = " Saidas "
   OPCAO[4] = " Relat"+chr(162)+"rios " 
   OPCAO[5] = " Fim " 

   private LETRA[5]

   LETRA[1] = "P"
   LETRA[2] = "E"  
   LETRA[3] = "S"  
   LETRA[4] = "R"  
   LETRA[5] = "F"  
 
   private ACESSO[5]
   for I = 1 to 4
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[5] = .t.

   OPC2 = achoise(OPC2,2,OPCAO,ACESSO,LETRA,.f.)

   if OPC2 == 0 .or. OPC2 == 5
      return .t.
   elseif OPC2 == 1  
      menu_PRODUTOS() 
   elseif OPC2 == 2
      menu_ENTRADAS()
   elseif OPC2 == 3  
      menu_SAIDAS()
   elseif OPC2 == 4  
      menu_REL_ESTOQUE()
   endif    

enddo

return .t.


**********************
function menu_PRODUTOS
**********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o " 
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"  
   LETRA[4] = "E"  
   LETRA[5] = "F"  
 
   private ACESSO[5]
   for I = 1 to 4
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = achoise(OPC3,3,OPCAO,ACESSO,LETRA,.f.)

   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1  
      INC_PRODUTOS()
   elseif OPC3 == 2
      ALT_PRODUTOS()
   elseif OPC3 == 3
      CON_PRODUTOS() 
   elseif OPC3 == 4
      EXC_PRODUTOS()
   endif    

enddo

return .t.


**********************
function menu_ENTRADAS
**********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o " 
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"  
   LETRA[4] = "E"  
   LETRA[5] = "F"  
 
   private ACESSO[5]
   for I = 1 to 4
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = achoise(OPC3,3,OPCAO,ACESSO,LETRA,.f.)

   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1  
      INC_OUTRAS_E()
   elseif OPC3 == 2
      ALT_OUTRAS_E()
   elseif OPC3 == 3
      CON_OUTRAS_E()
   elseif OPC3 == 4
      EXC_OUTRAS_E()
   endif    

enddo

return .t.


********************
function menu_SAIDAS
********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o " 
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"  
   LETRA[4] = "E"  
   LETRA[5] = "F"  
 
   private ACESSO[5]
   for I = 1 to 4
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = achoise(OPC3,3,OPCAO,ACESSO,LETRA,.f.)

   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1  
      INC_OUTRAS_S()
   elseif OPC3 == 2
      ALT_OUTRAS_S()
   elseif OPC3 == 3
      CON_OUTRAS_S()
   elseif OPC3 == 4
      EXC_OUTRAS_S()
   endif    

enddo

return .t.

*************************
function menu_REL_ESTOQUE
*************************
OPC3 = 1

do while .t.

   private OPCAO[4]
   OPCAO[1] = " Rela"+chr(135)+chr(132)+"o de Entradas " 
   OPCAO[2] = " Rela"+chr(135)+chr(132)+"o de Saidas " 
   OPCAO[3] = " Rela"+chr(135)+chr(132)+"o de Materiais " 
   OPCAO[4] = " Fim " 

   private LETRA[4]
   LETRA[1] = "E"
   LETRA[2] = "S"
   LETRA[3] = "Q"  
   LETRA[4] = "F"  
 
   private ACESSO[4]
   for I = 1 to 3
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[4] = .t.

   OPC3 = achoise(OPC3,3,OPCAO,ACESSO,LETRA,.f.)

   if OPC3 == 0 .or. OPC3 == 4
      return .t.
   elseif OPC3 == 1  
      rpr_ENTRADA()
   elseif OPC3 == 2
      rpr_SAIDA()
   elseif OPC3 == 3
      rpr_ESTOQUE() 
   endif    

enddo

return .t.

*********************
function menu_CAD_DIV
*********************
OPC2 = 1

do while .t.

   private OPCAO[15]
   OPCAO[1]  = " Pastos/Piquetes " 
   OPCAO[2]  = " Lotes de Animais " 
   OPCAO[3]  = " Ra"+chr(135)+"as " 
   OPCAO[4]  = " Vacinas "
   OPCAO[5]  = " Sintomas/Doen"+chr(135)+"as "
   OPCAO[6]  = " Categorias de Animais " 
   OPCAO[7]  = " Grupos de Animais " 
   OPCAO[8]  = " Sub-Grupos de Animais " 
   OPCAO[9]  = " Pend"+chr(136)+"ncias " 
   OPCAO[10] = " Centros de Custo " 
   OPCAO[11] = " Grupos de Estoque "
   OPCAO[12] = " Fornecedores "
   OPCAO[13] = " Indicadores "
   OPCAO[14] = " Dados da Fazenda "
   OPCAO[15] = " Fim "

   private LETRA[15]
   LETRA[1]  = "P"
   LETRA[2]  = "L"
   LETRA[3]  = "R"  
   LETRA[4]  = "V" 
   LETRA[5]  = "D" 
   LETRA[6]  = "C" 
   LETRA[7]  = "G" 
   LETRA[8]  = "S" 
   LETRA[9]  = "D" 
   LETRA[10] = "O"  
   LETRA[11] = "T"  
   LETRA[12] = "E"  
   LETRA[13] = "I"  
   LETRA[14] = "A"  
   LETRA[15] = "F" 

   private ACESSO[15]
   for I = 1 to 14
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[15] = .t.

   OPC2 = achoise(OPC2,2,OPCAO,ACESSO,LETRA,.f.)

   if OPC2 == 0 .or. OPC2 == 15
      return .t.
   elseif OPC2 == 1       // MF_Z010.PRG 
      menu_PASTO()
   elseif OPC2 == 2  
      menu_LOTE() 
   elseif OPC2 == 3
      menu_RACA()
   elseif OPC2 == 4  
      menu_VACINA()
   elseif OPC2 == 5  
      menu_SINTOMA()
   elseif OPC2 == 6  
      menu_CATEGORIA()
   elseif OPC2 == 7  
      menu_GRUPO_P() 
   elseif OPC2 == 8  
      menu_SUB_GRP()
   elseif OPC2 == 9  
      menu_PENDENC()
   elseif OPC2 == 10  
      menu_CCUSTO() 
   elseif OPC2 == 11    
      menu_GRUPO()
   elseif OPC2 == 12
      menu_FORNEC() 
   elseif OPC2 == 13
      dados_INDICADORES()
   elseif OPC2 == 14
      dados_FAZENDA()
   endif    

enddo

return .t.

*******************
function menu_PASTO
*******************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_PASTO()
   elseif OPC3 == 2 
      ALT_PASTO() 
   elseif OPC3 == 3
      CON_PASTO()
   elseif OPC3 == 4
      EXC_PASTO()   
   endif
   
enddo

return .t.

******************
function menu_LOTE
******************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_LOTE()
   elseif OPC3 == 2 
      ALT_LOTE() 
   elseif OPC3 == 3
      CON_LOTE()
   elseif OPC3 == 4
      EXC_LOTE()   
   endif
   
enddo

return .t.

******************
function menu_RACA
******************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_RACA()
   elseif OPC3 == 2 
      ALT_RACA() 
   elseif OPC3 == 3
      CON_RACA()
   elseif OPC3 == 4
      EXC_RACA()   
   endif
   
enddo

return .t.

********************
function menu_VACINA
********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_VACINA()
   elseif OPC3 == 2 
      ALT_VACINA()
   elseif OPC3 == 3
      CON_VACINA()
   elseif OPC3 == 4
      EXC_VACINA()
   endif
   
enddo

return .t.

*********************
function menu_SINTOMA
*********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_SINTOMA()
   elseif OPC3 == 2 
      ALT_SINTOMA()
   elseif OPC3 == 3
      CON_SINTOMA()
   elseif OPC3 == 4
      EXC_SINTOMA()
   endif
   
enddo

return .t.


***********************
function menu_CATEGORIA
***********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_CATEGORIA()
   elseif OPC3 == 2 
      ALT_CATEGORIA()
   elseif OPC3 == 3
      CON_CATEGORIA()
   elseif OPC3 == 4
      EXC_CATEGORIA()
   endif
   
enddo

return .t.

*********************
function menu_GRUPO_P
*********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_GRUPO_P()
   elseif OPC3 == 2 
      ALT_GRUPO_P()
   elseif OPC3 == 3
      CON_GRUPO_P()
   elseif OPC3 == 4
      EXC_GRUPO_P()
   endif
   
enddo

return .t.

*********************
function menu_SUB_GRP
*********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_SUB_GRP()
   elseif OPC3 == 2 
      ALT_SUB_GRP()
   elseif OPC3 == 3
      CON_SUB_GRP()
   elseif OPC3 == 4
      EXC_SUB_GRP()
   endif
   
enddo

return .t.

*********************
function menu_PENDENC
*********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_PENDENC()
   elseif OPC3 == 2 
      ALT_PENDENC()
   elseif OPC3 == 3
      CON_PENDENC()
   elseif OPC3 == 4
      EXC_PENDENC()
   endif
   
enddo

return .t.

********************
function menu_CCUSTO
********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_CUSTO()
   elseif OPC3 == 2 
      ALT_CUSTO()
   elseif OPC3 == 3
      CON_CUSTO()
   elseif OPC3 == 4
      EXC_CUSTO()
   endif
   
enddo

return .t.


*******************
function menu_GRUPO
*******************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_GRUPO()
   elseif OPC3 == 2 
      ALT_GRUPO()
   elseif OPC3 == 3
      CON_GRUPO()
   elseif OPC3 == 4
      EXC_GRUPO()
   endif
   
enddo

return .t.

********************
function menu_FORNEC
********************
OPC3 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o "
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"
   LETRA[4] = "E"
   LETRA[5] = "F"

   private ACESSO[5]
   for I=1 to 4
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   ACESSO[5] = .t.

   OPC3 = ACHOISE(OPC3,3,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC3 == 0 .or. OPC3 == 5
      return .t.
   elseif OPC3 == 1
      INC_FORNEC()
   elseif OPC3 == 2
      ALT_FORNEC()   
   elseif OPC3 == 3
      CON_FORNEC()
   elseif OPC3 == 4
      EXC_FORNEC()
   endif
   
enddo

return .t.

*******************
function menu_RELAT 
*******************
OPC2 = 1

do while .t.

   private OPCAO[7]
   OPCAO[1] = " Rela"+chr(135)+chr(132)+"o de Plantel " 
   OPCAO[2] = " Hist"+chr(162)+"rico de Pesagens do Plantel " 
   OPCAO[3] = " Pesagens Comparativas "
   OPCAO[4] = " Custo com Engorda "
   OPCAO[5] = " Hist"+chr(162)+"rico de Vacina"+chr(135)+chr(132)+"o " 
   OPCAO[6] = " Rela"+chr(135)+chr(132)+"o de Saida " 
   OPCAO[7] = " Fim " 

   private LETRA[7]
   LETRA[1] = "R"
   LETRA[2] = "H"
   LETRA[3] = "P"
   LETRA[4] = "C"
   LETRA[5] = "V"
   LETRA[6] = "S"
   LETRA[7] = "F"

   private ACESSO[7]
   for I=1 to 6
      ACESSO[I] = ver_SENHA(left(CRI,2)+LETRA[I])
   next
   
   ACESSO[1] = .t.
   ACESSO[2] = .t.
   ACESSO[3] = .t.
   ACESSO[4] = .t.
   ACESSO[5] = .t.
   ACESSO[6] = .t.
   ACESSO[7] = .t.

   OPC2 = ACHOISE(OPC2,2,OPCAO,ACESSO,LETRA,.t.)
   
   if OPC2 == 0 .or. OPC2 == 7
      return .t.
   elseif OPC2 == 1
      rpr_REL_PLANTEL()
   elseif OPC2 == 2
      rpr_HIST_PESO_PLANTEL()   
   elseif OPC2 == 3  
      rpr_PESAGENS()
   elseif OPC2 == 4
      rpr_CUSTO_ENGORDA()     
   elseif OPC2 == 5
      rpr_HIST_VACINACAO()
   elseif OPC2 == 6
      rpr_REL_SAIDA()
   endif
   
enddo

return .t.


********************************
function menu_DADOS_REPRODUTIVOS
********************************
OPC3 = 1

do while .t.

   private OPCAO[3]
   OPCAO[1] = " Banco de S"+chr(136)+"men " 
   OPCAO[2] = " Reprodu"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Fim " 

   private LETRA[3]
   LETRA[1] = "B"
   LETRA[2] = "R"  
   LETRA[3] = "F"  
 
   private ACESSO[3]
   for I = 1 to 2
      ACESSO[I] = ver_SENHA(LETRA[I])
   next

   ACESSO[1] = .t.
   ACESSO[2] = .t.
   ACESSO[3] = .t.

   OPC3 = achoise(OPC3,3,OPCAO,ACESSO,LETRA,.f.)

   if OPC3 == 0 .or. OPC3 == 3
      return .t.
   elseif OPC3 == 1  
      menu_BANCO_DE_SEMEN() 
   elseif OPC3 == 2
      menu_REPRODUCAO() 
   endif    

enddo

return .t.


****************************
function menu_BANCO_DE_SEMEN
****************************
OPC4 = 1

do while .t.

   private OPCAO[3]
   OPCAO[1] = " Estoque " 
   OPCAO[2] = " Movimenta"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Fim " 

   private LETRA[3]
   LETRA[1] = "B"
   LETRA[2] = "R"  
   LETRA[3] = "F"  
 
   private ACESSO[3]
   for I = 1 to 2
      ACESSO[I] = ver_SENHA(LETRA[I])
   next

   ACESSO[1] = .t.
   ACESSO[2] = .f.
   ACESSO[3] = .t.

   OPC4 = achoise(OPC4,4,OPCAO,ACESSO,LETRA,.f.)

   if OPC4 == 0 .or. OPC4 == 3
      return .t.
   elseif OPC4 == 1  
      menu_ESTOQUE_BS()
   elseif OPC4 == 2
      
   endif    

enddo
return .t.


************************
function menu_ESTOQUE_BS
************************
OPC5 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o " 
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"  
   LETRA[4] = "E"  
   LETRA[5] = "F"  
 
   private ACESSO[5]
   for I = 1 to 4
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[5] = .t.

   OPC5 = achoise(OPC5,5,OPCAO,ACESSO,LETRA,.f.)

   if OPC5 == 0 .or. OPC5 == 5
      return .t.
   elseif OPC5 == 1  
      INC_BCO_SEMEN()
   elseif OPC5 == 2
      ALT_BCO_SEMEN()
   elseif OPC5 == 3
      CON_BCO_SENEN() 
   elseif OPC5 == 4 
      EXC_BCO_SEMEN()
   endif    

enddo

return .t.

 
************************
function menu_REPRODUCAO
************************
OPC4 = 1

do while .t.

   private OPCAO[5]
   OPCAO[1] = " Inclus"+chr(132)+"o " 
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o " 
   OPCAO[3] = " Consulta " 
   OPCAO[4] = " Exclus"+chr(132)+"o " 
   OPCAO[5] = " Fim " 

   private LETRA[5]
   LETRA[1] = "I"
   LETRA[2] = "A"
   LETRA[3] = "C"  
   LETRA[4] = "E"  
   LETRA[5] = "F"  
 
   private ACESSO[5]
   for I = 1 to 4
      ACESSO[I] = ver_SENHA(LETRA[I])
   next
   ACESSO[5] = .t.

   OPC4 = achoise(OPC4,4,OPCAO,ACESSO,LETRA,.f.)

   if OPC4 == 0 .or. OPC4 == 5
      return .t.
   elseif OPC4 == 1  
      INC_REPRODUCAO()
   elseif OPC4 == 2
      ALT_REPRODUCAO()
   elseif OPC4 == 3
      CON_REPRODUCAO() 
   elseif OPC4 == 4
      EXC_REPRODUCAO()
   endif    

enddo

return .t.