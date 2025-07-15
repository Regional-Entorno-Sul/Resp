Function main()
cls
set color to g+/
set century on
set date to british

@ 1,0 say "-----------------------------------------------------------"
@ 2,0 say "| RESP - 1.1 - 14/07/2025                                 |"
@ 3,0 say "| Consolida os dados de virus respiratorio do SIVEP Gripe |"
@ 4,0 say "-----------------------------------------------------------"

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

@ 5,0 say "Limpando arquivos remanescentes..."
@ 6,0 say ""
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
				
				dbCreate( (cMolde3 ) , aStruct2 )
close ( cMolde1 )

rename (cMolde3) to (cMolde4)

use ( cMolde4 )
append blank
close

for f := 1 to 3

use "c:\resp\dbf\srag.dbf"

count to var_tot for sem_not = "0" + alltrim(str(f))
count to var_sra_ne for sem_not = "0" + alltrim(str(f)) .and. classi_fin = "4"
count to var_sra_cov for sem_not = "0" + alltrim(str(f)) .and. classi_fin = "5"
count to var_sra_inf for sem_not = "0" + alltrim(str(f)) .and. classi_fin = "1"
count to var_sra_o_a for sem_not = "0" + alltrim(str(f)) .and. classi_fin = "3"
count to var_sra_o_v for sem_not = "0" + alltrim(str(f)) .and. classi_fin = "2"
var_inv := var_tot - ( var_sra_ne + var_sra_cov + var_sra_inf + var_sra_o_a + var_sra_o_v )

? "Sem:" + "0" + alltrim(str(f))
? var_tot
? var_sra_ne
? var_sra_cov
? var_sra_inf
? var_sra_o_a
? var_sra_o_v
? var_inv
? "---------------------------"

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




















return nil