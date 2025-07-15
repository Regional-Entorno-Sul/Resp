Function main()
cls
set color to n/gr
set century on
set date to british

@ 1,0 say "-------------------------------------------------------------------------"
@ 2,0 say "| RESP - 1.2 - 15/07/2025                                               |"
@ 3,0 say "| https://github.com/Regional-Entorno-Sul/resp                          |"
@ 4,0 say "| Regional Entorno Sul, Diretoria Macrorregional Nordeste               |"
@ 5,0 say "| Consolida os dados de virus respiratorio do SIVEP Gripe.              |"
@ 6,0 say "| Sintaxe do executavel: resp.exe [ano do processamento]                |"
@ 7,0 say "| Exemplo: resp.exe 2025                                                |"
@ 8,0 say "------------------------------------------------------------------------ "

set color to g+/
cAno := HB_ArgV ( 1 )
cAnoLeft := ""
cAnoRight := ""

if empty( cAno ) = .T.
set color to r+/
? ""
? "Erro! Falta o argumento do ano na linha de comando."
? "Fim do programa."
wait
set color to g+/
quit
endif

@ 9,0 say "Limpando arquivos remanescentes..."
@ 10,0 say ""
__run( "echo off & del /F /Q c:\resp\zip\*.dbf" )
__run( "echo off & del /F /Q c:\resp\dbf\*.dbf" )
__run( "echo off & del /F /Q c:\resp\run\*.dbf" )

set color to g+/

public zip_list := HB_DirScan( "c:\resp\zip\" )

if len(zip_list) > 1
set color to r+/
? ""
? "Erro! Nao pode haver mais de um arquivo no subdiretorio 'zip'."
? "Fim do programa."
wait
set color to g+/
quit
endif

if len(zip_list) = 0
set color to r+/
? ""
? "Erro! Nao ha nenhum arquivo no subdiretorio 'zip'."
? "Fim do programa."
wait
set color to g+/
quit
endif

if len(zip_list) = 1

cExtesion := right( zip_list[1,1] , 3)

if cExtesion <> alltrim("zip")
set color to r+/
? ""
? "Erro! Arquivo no subdiretorio 'zip' nao e um arquivo compactado. "
? "Fim do programa."
wait
set color to g+/
quit
endif

endif

public cFileZip := alltrim( "c:\resp\zip\" + zip_list[1,1] )

if len(zip_list) = 1
hb_UnzipFile( cFileZip )
endif

if file("c:\resp\zip\*.dbf") = .F.

set color to r+/
? ""
? "Erro! Descompactacao do arquivo no subdiretorio 'zip' nao foi bem sucedida. "
? "Fim do programa."
wait
set color to g+/
quit

else
__run( "echo off & copy /Y c:\resp\zip\*.dbf c:\resp\dbf\*.dbf" )
endif

public file_list := HB_DirScan( "c:\resp\dbf\" )

if len(file_list) > 1
set color to r+/
? ""
? "Erro! Nao pode haver mais de um arquivo no subdiretorio 'dbf'."
? "Fim do programa."
wait
set color to g+/
quit
endif

if len(file_list) = 0
set color to r+/
? ""
? "Erro! Nao ha nenhum arquivo no subdiretorio 'dbf'."
? "Fim do programa."
wait
set color to g+/
quit
endif

if len(file_list) = 1

cExtesion := right( file_list[1,1] , 3)

if cExtesion <> alltrim("dbf")
set color to r+/
? ""
? "Erro! Extensao do arquivo com a base de dados nao e DBF."
? "Fim do programa."
wait
set color to g+/
quit
endif

endif

cFile := "c:\resp\dbf\" + alltrim( file_list[1,1] )

cFile1 := cFile
cFile2 := "c:\resp\dbf\srag.dbf"
rename ( cFile1 ) to ( cFile2 )

cAnoLeft := alltrim( str( val( cAno ) - 1 ) )
cAnoRight := alltrim( str( val( cAno ) + 1 ) )
use "c:\resp\dbf\srag.dbf"

do while .not. eof()
replace co_regiona with alltrim( right( dt_notific,4 ) )
skip
enddo
goto top

count to cAnoLeft_x for co_regiona = cAnoLeft
count to cAno_x for co_regiona = cAno
count to cAnoRight_x for co_regiona = cAnoRight

if ( cAnoLeft_x > cAno_x ) .or. ( cAnoRight_x > cAno_x )
set color to r+/
? ""
? "Erro! Base de dados nao corresponde ao ano do argumento."
? "Fim do programa."
wait
set color to g+/
quit
endif

if cAno_x = 0
set color to r+/
? ""
? "Erro! Base de dados nao corresponde ao ano do argumento."
? "Fim do programa."
wait
set color to g+/
quit
endif

close

set color to g+/
@ 10,0 say "                                                 "
@ 11,0 say "                                                 "
@ 12,0 say "                                                 "
@ 13,0 say "                                                 "
@ 14,0 say "                                                 "

@ 10,0 say "Criando arquivo para salvar as informacoes..."

cMolde1 := ( "c:\resp\run\molde1.dbf" )
cMolde2 := ( "c:\resp\run\molde2.dbf" )
cMolde3 := ( "c:\resp\run\molde3.dbf" )
cMolde4 := ( "c:\resp\run\molde4.dbf" )
	
aStruct := { { "sra_ne_01","N", 10, 0 }, ;
			 { "sra_cov_01","N", 10, 0 }, ;
			 { "sra_inf_01","N", 10, 0 }, ;
			 { "sra_o_a_01", "N", 10, 0 }, ;
			 { "sra_o_v_01", "N", 10, 0 }, ;
			 { "sra_inv_01", "N", 10, 0 }, ;			 
			 { "sra_ne_02", "N", 10, 0 }, ;
			 { "sra_cov_02", "N", 10, 0 }, ;
			 { "sra_inf_02", "N", 10, 0 }, ;
			 { "sra_o_a_02", "N", 10, 0 }}
			 dbcreate (( cMolde1 ),aStruct )

use ( cMolde1 )
copy to ( cMolde2 )

* Acrescenta campos novos.
				use ( cMolde2 ) new
				aStruct2 := dbStruct( cMolde2 )
				AADD(aStruct2, { "sra_o_v_02", "N", 10, 0 })
				AADD(aStruct2, { "sra_inv_02", "N", 10, 0 })
				
                AADD(aStruct2, { "sra_ne_03", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_03", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_03", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_03", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_03", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_03", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_04", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_04", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_04", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_04", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_04", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_04", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_05", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_05", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_05", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_05", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_05", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_05", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_06", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_06", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_06", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_06", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_06", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_06", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_07", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_07", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_07", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_07", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_07", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_07", "N", 10, 0 })
				
                AADD(aStruct2, { "sra_ne_08", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_08", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_08", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_08", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_08", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_08", "N", 10, 0 })				

                AADD(aStruct2, { "sra_ne_09", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_09", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_09", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_09", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_09", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_09", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_10", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_10", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_10", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_10", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_10", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_10", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_11", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_11", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_11", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_11", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_11", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_11", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_12", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_12", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_12", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_12", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_12", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_12", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_13", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_13", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_13", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_13", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_13", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_13", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_14", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_14", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_14", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_14", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_14", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_14", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_15", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_15", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_15", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_15", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_15", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_15", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_16", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_16", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_16", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_16", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_16", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_16", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_17", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_17", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_17", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_17", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_17", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_17", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_18", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_18", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_18", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_18", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_18", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_18", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_19", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_19", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_19", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_19", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_19", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_19", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_20", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_20", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_20", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_20", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_20", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_20", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_21", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_21", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_21", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_21", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_21", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_21", "N", 10, 0 })

                AADD(aStruct2, { "sra_ne_22", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_22", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_22", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_22", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_22", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_22", "N", 10, 0 })				

                AADD(aStruct2, { "sra_ne_23", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_23", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_23", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_23", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_23", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_23", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_24", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_24", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_24", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_24", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_24", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_24", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_25", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_25", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_25", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_25", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_25", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_25", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_26", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_26", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_26", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_26", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_26", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_26", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_27", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_27", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_27", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_27", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_27", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_27", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_28", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_28", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_28", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_28", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_28", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_28", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_29", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_29", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_29", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_29", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_29", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_29", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_30", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_30", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_30", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_30", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_30", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_30", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_31", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_31", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_31", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_31", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_31", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_31", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_32", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_32", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_32", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_32", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_32", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_32", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_33", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_33", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_33", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_33", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_33", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_33", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_34", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_34", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_34", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_34", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_34", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_34", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_35", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_35", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_35", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_35", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_35", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_35", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_36", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_36", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_36", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_36", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_36", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_36", "N", 10, 0 })			
				
                AADD(aStruct2, { "sra_ne_37", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_37", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_37", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_37", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_37", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_37", "N", 10, 0 })							

                AADD(aStruct2, { "sra_ne_38", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_38", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_38", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_38", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_38", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_38", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_39", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_39", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_39", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_39", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_39", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_39", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_40", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_40", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_40", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_40", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_40", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_40", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_41", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_41", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_41", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_41", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_41", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_41", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_42", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_42", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_42", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_42", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_42", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_42", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_43", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_43", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_43", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_43", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_43", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_43", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_44", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_44", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_44", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_44", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_44", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_44", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_45", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_45", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_45", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_45", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_45", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_45", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_46", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_46", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_46", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_46", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_46", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_46", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_47", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_47", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_47", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_47", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_47", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_47", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_48", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_48", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_48", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_48", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_48", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_48", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_49", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_49", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_49", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_49", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_49", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_49", "N", 10, 0 })		

                AADD(aStruct2, { "sra_ne_50", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_50", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_50", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_50", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_50", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_50", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_51", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_51", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_51", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_51", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_51", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_51", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_52", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_52", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_52", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_52", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_52", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_52", "N", 10, 0 })			

                AADD(aStruct2, { "sra_ne_53", "N", 10, 0 })				
                AADD(aStruct2, { "sra_cov_53", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inf_53", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_a_53", "N", 10, 0 })		
                AADD(aStruct2, { "sra_o_v_53", "N", 10, 0 })		
                AADD(aStruct2, { "sra_inv_53", "N", 10, 0 })
		
				dbCreate( (cMolde3 ) , aStruct2 )
close ( cMolde1 )

rename (cMolde3) to (cMolde4)

use ( cMolde4 )
append blank
close

@ 11,0 say "Gerando dados das semanas epidemiologicas do ano " + alltrim( cAno ) + "."

for f := 1 to 9

use "c:\resp\dbf\srag.dbf"

count to var_tot for sem_not = "0" + alltrim(str(f))
count to var_sra_ne for sem_not = "0" + alltrim(str(f)) .and. classi_fin = "4"
count to var_sra_cov for sem_not = "0" + alltrim(str(f)) .and. classi_fin = "5"
count to var_sra_inf for sem_not = "0" + alltrim(str(f)) .and. classi_fin = "1"
count to var_sra_o_a for sem_not = "0" + alltrim(str(f)) .and. classi_fin = "3"
count to var_sra_o_v for sem_not = "0" + alltrim(str(f)) .and. classi_fin = "2"
var_inv := var_tot - ( var_sra_ne + var_sra_cov + var_sra_inf + var_sra_o_a + var_sra_o_v )

@ 12,0 say "Semana:" + "0" + alltrim(str(f)) + "..."

close

use ( cMolde4 )

x0 := "sra_ne_0" + alltrim(str(f))
x1 := "sra_cov_0" + alltrim(str(f))
x2 := "sra_inf_0" + alltrim(str(f))
x3 := "sra_o_a_0" + alltrim(str(f))
x4 := "sra_o_v_0" + alltrim(str(f))
x5 := "sra_inv_0" + alltrim(str(f))

replace &(x0) with var_sra_ne
replace &(x1) with var_sra_cov
replace &(x2) with var_sra_inf
replace &(x3) with var_sra_o_a
replace &(x4) with var_sra_o_v
replace &(x5) with var_inv

close

endfor

for g := 10 to 53

use "c:\resp\dbf\srag.dbf"

count to var_tot for sem_not = alltrim(str(g))
count to var_sra_ne for sem_not = alltrim(str(g)) .and. classi_fin = "4"
count to var_sra_cov for sem_not = alltrim(str(g)) .and. classi_fin = "5"
count to var_sra_inf for sem_not = alltrim(str(g)) .and. classi_fin = "1"
count to var_sra_o_a for sem_not = alltrim(str(g)) .and. classi_fin = "3"
count to var_sra_o_v for sem_not = alltrim(str(g)) .and. classi_fin = "2"
var_inv := var_tot - ( var_sra_ne + var_sra_cov + var_sra_inf + var_sra_o_a + var_sra_o_v )

@ 12,0 say "Semana:" + alltrim(str(g)) + "..."

close

use ( cMolde4 )

x0 := "sra_ne_" + alltrim(str(g))
x1 := "sra_cov_" + alltrim(str(g))
x2 := "sra_inf_" + alltrim(str(g))
x3 := "sra_o_a_" + alltrim(str(g))
x4 := "sra_o_v_" + alltrim(str(g))
x5 := "sra_inv_" + alltrim(str(g))

replace &(x0) with var_sra_ne
replace &(x1) with var_sra_cov
replace &(x2) with var_sra_inf
replace &(x3) with var_sra_o_a
replace &(x4) with var_sra_o_v
replace &(x5) with var_inv

close

endfor

return nil
