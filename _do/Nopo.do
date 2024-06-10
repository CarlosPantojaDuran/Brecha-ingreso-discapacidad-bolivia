	do _do/Preambulo.do
********************************************************************************
* BLOQUE 5: MODELO ECONOMETRICO EMPAREJAMEIENTO DE NOPO

	//net install nopo, from("https://raw.githubusercontent.com/mhamjediers/nopo_decomposition/main/")
	//ssc install moremata,replace
	//ssc install kmatch, replace
	
	global pred edad edad2 aestudio sexo area seg_soc caeb_op_nocal
	
	* 2.Nopo Normalizado
	nopo decomp lnylab_hrs edad edad2 aestudio, by(d_discap)  bref(grp == 0) normalize
	qui: est store edadescolaridad
	 nopo decomp lnylab_hrs edad edad2 aestudio sexo, by(d_discap)  bref(grp == 0) normalize
	qui: est store sexo
	nopo decomp lnylab_hrs edad edad2 aestudio sexo area, by(d_discap)  bref(grp == 0) normalize
	qui: est store area	
	 nopo decomp lnylab_hrs edad edad2 aestudio sexo area seg_soc, by(d_discap)  bref(grp == 0) normalize
	qui: est store seguro_social
	nopo decomp lnylab_hrs edad edad2 aestudio sexo area seg_soc caeb_op_nocal, by(d_discap)  bref(grp == 0) normalize
	qui: est store ocupacion
	esttab edadescolaridad sexo area seguro_social ocupacion using "_tbl/t_12.tex", replace se nonumbers nonotes /// 
	mtitles("Edad y Escolaridad" "+Sexo" "+ Área" "+Seguro Social" "+Ocupacion no calificada") /// 
	stats(nA nB nmatched, label("N(A)" "N(B)"  "Bandwidth")) ///
    cells(b(fmt(%9.2f)) se(fmt(%9.2f) star)) ///
    title("\textbf{Tabla 12: Descomposición de la brecha de ingreso entre las PSD y la PCD}") ///
	
	
	* Grafico
	nopo decomp lnylab_hrs $pred, by(d_discap) bref(grp == 0) normalize
	nopo gapoverdist
	graph export "_ghp/g_2.pdf", replace 


	
	
	* Anexo B1
	nopo decomp lnylab_hrs edad edad2 aestudio, by(d_discap)  bref(grp == 0) swap normalize
	qui: est store edadescolaridad
	 nopo decomp lnylab_hrs edad edad2 aestudio sexo, by(d_discap)  bref(grp == 0) swap normalize
	qui: est store sexo
	nopo decomp lnylab_hrs edad edad2 aestudio sexo area, by(d_discap)  bref(grp == 0)  swap normalize
	qui: est store area	
	 nopo decomp lnylab_hrs edad edad2 aestudio sexo area seg_soc, by(d_discap)  bref(grp == 0) swap normalize
	qui: est store seguro_social
	nopo decomp lnylab_hrs edad edad2 aestudio sexo area seg_soc caeb_op_nocal, by(d_discap)  bref(grp == 0) swap normalize
	qui: est store ocupacion
	esttab edadescolaridad sexo area seguro_social ocupacion using "_tbl/t_13.tex", replace se nonumbers nonotes /// 
	mtitles("Edad y Escolaridad" "+Sexo" "+ Área" "+Seguro Social" "+Ocupacion no calificada") /// 
	stats(nA nB nmatched, label("N(A)" "N(B)"  "Bandwidth")) ///
    cells(b(fmt(%9.2f)) se(fmt(%9.2f) star)) ///
    title("\textbf{Tabla 13: Descomposición de la brecha de ingreso entre las PSD y la PCD}")
	
	
	
	
	
	nopo gapoverdist
	graph export "_ghp/g_3.pdf", replace 


	
	* Anexo B2
	
	qui: nopo decomp lnylab_hrs ${pred}, by(d_discap) 
	qui: est store em 
	qui: nopo decomp lnylab_hrs ${pred}, by(d_discap) kmatch(ps) 
	qui: est store ps 
	qui: nopo decomp lnylab_hrs ${pred}, by(d_discap) kmatch(md) 
	qui: est store md 
	qui: nopo decomp lnylab_hrs ${pred}, by(d_discap) kmatch(ps) kmopt(pscmd(probit) bw(0.0001))
	qui: est store ps_probbw
	esttab em ps md ps_probbw using "_tbl/t_14.tex", replace se nonumbers nonotes /// 
	mtitles("exact" "prop. score" "multi. dist." "probit ps") /// 
	stats(nA mshareuwA nB mshareuwB bwidth, label("N(A)" "% matched A" "N(B)" "% matched B" "Bandwidth"))

