	do _do/Preambulo.do
********************************************************************************
* BLOQUE 4: MODELO ECONOMETRICO DESCOMPOSICION DE OAXACA-BLINDER
	
* 4.1 Regresiones MCO

	label variable aestudio "Escolaridad"
	label variable edad2 "Edad al cuadrado"
	label variable edad "Edad"
	label variable seg_soc "Seguro social"
	label define seg_soc_label 1 "Con contrato" 2 "Sin contrato"
	label values seg_soc seg_soc_label

	svy: reg lnylab_hrs  edad  edad2 aestudio i.mujer i.area i.seg_soc if d_discap==0 & caeb_op_nocal==1
	reg lnylab_hrs  edad  edad2 aestudio i.mujer i.area i.seg_soc if d_discap==0 & caeb_op_nocal==1, robust
	eststo MCO1 
	
	svy: reg lnylab_hrs   edad  edad2 aestudio i.mujer i.area i.seg_soc  if d_discap==1 & caeb_op_nocal==1
	reg lnylab_hrs   edad  edad2 aestudio i.mujer i.area i.seg_soc  if d_discap==1 & caeb_op_nocal==1, robust
	eststo MCO2 
	
	esttab MCO1 MCO2 using "_tbl/t_8.tex", replace ///
    b(%9.2f) ///
    mtitles("Sin discapacidad" "Con discapacidad") ///
    title(\textbf{"Regresión para ambos grupos"}) ///
    stats(N r2, labels("Observaciones" "R-cuadrado ajustado")) ///
    alignment(D{.}{,}{-1}) ///
    note(\textbf{Fuente:} Elaboración propia a partir de datos de la Encuesta Hogares 2021)

* 4.2 Descomposición Blinder Oaxaca 

	oaxaca lnylab_hrs   aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1, by(d_discap) pooled svy nodetail
	eststo  oaxaca_lnylabhrs

	oaxaca lnylab_hrs aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1 , by(d_discap) pooled svy  eform nodetail
	eststo  oaxaca_lnylabhrs_bs
	
	esttab oaxaca_lnylabhrs oaxaca_lnylabhrs_bs using "_tbl/t_9.tex", replace ///
    label ///
    cells(b(fmt(%9.2f)) se(fmt(%9.2f) star)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    title("Resultados de la Descomposición Oaxaca en ocupaciones no calificadas") ///
    mtitle("Oaxaca" "Blinder-Oaxaca") ///
    nonotes ///
    compress ///
    booktabs ///
    varwidth(40)


* 4.3 Descomposición Blinder Oaxaca con PCD severa y no severa

	oaxaca lnylab_hrs   aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1 , by(d_discap2) pooled svy nodetail
	eststo no_severa
	oaxaca lnylab_hrs   aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1, by(d_discap34) pooled svy nodetail
	eststo severa
	
	esttab no_severa severa using "_tbl/t_10.tex", replace ///
    label ///
    cells(b(fmt(%9.2f)) se(fmt(%9.2f) star)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    title("Resultados de la Descomposición Oaxaca") ///
    mtitle("PSD vs. PCD no severa" " PSD vs. PCD severa") ///
    nonotes ///
    compress ///
    booktabs ///
    varwidth(40)


* Anexo A 

 	oaxaca lnylab   aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1, by(d_discap) pooled svy nodetail
	eststo logaritmo
	
	oaxaca lnylab aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1 , by(d_discap) pooled svy  eform nodetail
	eststo nominal
	
	esttab logaritmo nominal using "_tbl/t_11.tex", replace ///
    label ///
    cells(b(fmt(%9.2f)) se(fmt(%9.2f) star)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    title("\textbf{Tabla 11: Descomposición Oaxaca con el Ingreso laboral mensual}") ///
    mtitle("Sin discapacidad" " Con discapacidad") ///
    nonotes ///
    compress ///
    booktabs ///
    varwidth(40)
	