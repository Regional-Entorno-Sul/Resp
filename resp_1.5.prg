Function main()
cls
set color to n/gr
set century on
set date to british

@ 1,0 say "-------------------------------------------------------------------------"
@ 2,0 say "| RESP - 1.5 - 21/07/2025                                               |"
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

@ 10,0 say "Criando arquivo para salvar as informacoes de SRAG..."

cMolde1 := ( "c:\resp\run\molde1_srag.dbf" )
cMolde2 := ( "c:\resp\run\molde2_srag.dbf" )
cMolde3 := ( "c:\resp\run\molde3_srag.dbf" )
cMolde4 := ( "c:\resp\run\molde4_srag.dbf" )

aStruct := { { "sem_epid","C", 6, 0 }, ;
			 { "srag_nespe","N", 10, 0 }, ;
			 { "srag_covid","N", 10, 0 }, ;
			 { "srag_influ","N", 10, 0 }, ;
			 { "srag_ou_ag", "N", 10, 0 }, ;
			 { "srag_ou_vi", "N", 10, 0 }, ;
			 { "srag_inves", "N", 10, 0 }}
			 dbcreate (( cMolde1 ),aStruct )
			 
			 use ( cMolde1 )
copy to ( cMolde2 )

* Acrescenta campos novos.
				use ( cMolde2 ) new
				aStruct2 := dbStruct( cMolde2 )
				AADD(aStruct2, { "a_h1n1", "N", 10, 0 })
				AADD(aStruct2, { "a_h3n2", "N", 10, 0 })				
                AADD(aStruct2, { "a_tipado", "N", 10, 0 })				
                AADD(aStruct2, { "a_tipavel", "N", 10, 0 })		
                AADD(aStruct2, { "a_outro", "N", 10, 0 })		
                AADD(aStruct2, { "b_victoria", "N", 10, 0 })		
                AADD(aStruct2, { "b_yamagath", "N", 10, 0 })		
                AADD(aStruct2, { "b_outro", "N", 10, 0 })				
				dbCreate( (cMolde3 ) , aStruct2 )
close ( cMolde1 )

rename (cMolde3) to (cMolde4)
			 
@ 11,0 say "SRAG...Gerando dados das semanas epidemiologicas do ano " + alltrim( cAno ) + "."

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
append blank

replace sem_epid with "0" + alltrim(str(f))
replace srag_nespe with var_sra_ne
replace srag_covid with var_sra_cov
replace srag_influ with var_sra_inf
replace srag_ou_ag with var_sra_o_a
replace srag_ou_vi with var_sra_o_v
replace srag_inves with var_inv

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
append blank

replace sem_epid with "" + alltrim(str(g))
replace srag_nespe with var_sra_ne
replace srag_covid with var_sra_cov
replace srag_influ with var_sra_inf
replace srag_ou_ag with var_sra_o_a
replace srag_ou_vi with var_sra_o_v
replace srag_inves with var_inv

close

endfor

@ 13,0 say "Influenza...Gerando dados das semanas epidemiologicas do ano " + alltrim( cAno ) + "."

for h := 1 to 9

use "c:\resp\dbf\srag.dbf"

count to var_a_h1n1 for sem_not = "0" + alltrim(str(h)) .and. pcr_fluasu = "1"
count to var_a_h3n2 for sem_not = "0" + alltrim(str(h)) .and. pcr_fluasu = "2"
count to var_a_pado for sem_not = "0" + alltrim(str(h)) .and. pcr_fluasu = "3"
count to var_a_pavel for sem_not = "0" + alltrim(str(h)) .and. pcr_fluasu = "4"
count to var_a_outro for sem_not = "0" + alltrim(str(h)) .and. pcr_fluasu = "6"
count to var_b_vic for sem_not = "0" + alltrim(str(h)) .and. pcr_flubli = "1"
count to var_b_yam for sem_not = "0" + alltrim(str(h)) .and. pcr_flubli = "2"
count to var_b_out for sem_not = "0" + alltrim(str(h)) .and. pcr_flubli = "5"

@ 14,0 say "Semana:" + "0" + alltrim(str(h)) + "..."

close

use ( cMolde4 )

goto (h)

replace a_h1n1 with var_a_h1n1
replace a_h3n2 with var_a_h3n2
replace a_tipado with var_a_pado
replace a_tipavel with var_a_pavel
replace a_outro with var_a_outro
replace b_victoria with var_b_vic
replace b_yamagath with var_b_yam
replace b_outro with var_b_out

close

endfor

for i := 10 to 53

use "c:\resp\dbf\srag.dbf"

count to var_a_h1n1 for sem_not = alltrim(str(i)) .and. pcr_fluasu = "1"
count to var_a_h3n2 for sem_not = alltrim(str(i)) .and. pcr_fluasu = "2"
count to var_a_pado for sem_not = alltrim(str(i)) .and. pcr_fluasu = "3"
count to var_a_pavel for sem_not = alltrim(str(i)) .and. pcr_fluasu = "4"
count to var_a_outro for sem_not = alltrim(str(i)) .and. pcr_fluasu = "6"
count to var_b_vic for sem_not = alltrim(str(i)) .and. pcr_flubli = "1"
count to var_b_yam for sem_not = alltrim(str(i)) .and. pcr_flubli = "2"
count to var_b_out for sem_not = alltrim(str(i)) .and. pcr_flubli = "5"

@ 14,0 say "Semana:" + alltrim(str(i)) + "..."

close

use ( cMolde4 )

goto (i)

replace a_h1n1 with var_a_h1n1
replace a_h3n2 with var_a_h3n2
replace a_tipado with var_a_pado
replace a_tipavel with var_a_pavel
replace a_outro with var_a_outro
replace b_victoria with var_b_vic
replace b_yamagath with var_b_yam
replace b_outro with var_b_out

close

endfor

return nil
