


*********************************************
*	RANDOMIZED INFERENCE IMPACT ANALYSIS OF INPUT SUBSIDIES IN HAITI, GIGNOUX, MACOURS, STEIN & WRIGHT AJAE 2022
*	MAIN TREATMENT EFFECTS, INTERACTIONS WITH BASELINE CHARACTERISTICS
*	author: Jeremie Gignoux, PSE-INRAE
* 	first version : jul 2018 
* 	this version : jan 2022 
*********************************************


clear
clear mata
clear matrix
pause off
set more off
set maxvar 20000
set matsize 1000 

* working directory

global user 3


if c(username) == "wrigh" {
	global root "D:\ptta_haiti\replication"       /*** PATH TO BE MODIFIED ***/
	global workdata="D:\Dropbox\Haiti\GAFSP Haiti\submission\final version\replication\data"
	global notreleased="D:\Dropbox\Haiti\GAFSP Haiti\submission\final version\data do not include\data_hasPII_donotinclude"
	global log="${root}\log"
	global results="${root}/results"
}	


** DATA

	use "$workdata/panel_dataset_for_replication.dta", clear


* select main outcomes presented

d harv_any_hh_* t_prod_value_uc_bsl t_prod_value5_uc* t_plotRiceYield5_1_uc* /*
	*/ t_sale_value_uc_* profit_2_uc_* profit_vouch_2_uc_14 /*
	*/ d_growrice_* n_riceplot_uc_* t_plot_area_byins*1_uc* /* 
	*/ rp_qty_allchem_uc_* qty_allchem_kgha* /*
	*/ rp_qty_urea_uc_* rp_qty_npk_uc_* rp_qty_sulfate_uc_* /*
	*/ rp_allchem_spending_uc_* rp_pest_spending_uc_* rp_labor_spendingEX_uc_* /*
	*/ fert_PTTA_* fert_loan_* fert_purch_* fert_DomRep_* fert_oth_* /*
	*/ pest_PTTA_* pest_loan_* pest_purch_* pest_DomRep_* pest_oth_* /*
	*/ seed_PTTA_* seed_loan_* seed_purch_* seed_DomRep_* seed_previous_* seed_oth_* /*
	*/ seeds_ha2a_* tech_3plant_* d_mult* rp_h_d_3bagsulf_uc_* rp_allchem_totmore150_* rp_allchem_totmore135_* rp_allchem_tot120150_* fstMonth_* /*
	*/ askloaninp_bank_* obtloanamt_bank_* askloaninp_sara_* obtloanamt_sara_* /*
	*/ other_harvest_value_* other_sale_value_* /*
	*/ savings_st_* assets_hh_ind_* assets_farm_ind_* assets_livst_ind1_* /*
	*/ HungerScale_* HungerScale_sev_* months_insecure_* /*
	*/ harv_lost_hh_* /*
	*/ n_allPlot_* n_culPlot_* t_sizeculPlot_* /*
	*/ lagoon_* irrigated_* irrigate_spending_* /*
	*/ DR_male_adult_work_HH_15 DR_male_work_HH_15 DR_fem_work_HH_15 DR_tot_work_days_HH_15 DR_male_work_days_HH_15 DR_fem_work_days_HH_15 /*
	*/ thinkben_* d_thinkben_* /*
	*/ plan_growrice_* plan_numpar_* plan_arearice_* plan_loan_* plan15_newplotrice_14 /*
	*/ treatment h_d_suplag*_bsl group2_bsl habitation_old_bsl, f


** estimates


* vars 

g rp_chempest_spending_uc_14=rp_allchem_spending_uc_14+rp_pest_spending_uc_14
g rp_chempest_spending_uc_15=rp_allchem_spending_uc_15+rp_pest_spending_uc_15
g F_rp_chempest_spending_uc_15=F_rp_allchem_spending_uc_15+F_rp_pest_spending_uc_15
lab var rp_chempest_spending_uc_14 "Spending in fertilizer and pesticides (USD)"
lab var rp_chempest_spending_uc_15 "Spending in fertilizer and pesticides (USD)"
lab var F_rp_chempest_spending_uc_15 "Spending in fertilizer and pesticides (USD)"

	/*unconditional profit vars */
foreach v in t_plotRiceYield5_1 profit_2 {
	g `v'_c_14=`v'_uc_14 if d_growrice_14==1
	*g `v'_c_15=`v'_uc_15 if d_growrice_15==1
	g F_`v'_c_15=`v'_uc_15 if d_growrice_15==1
}
	lab var t_plotRiceYield5_1_c_14 "yields (defined if growing rice)"
	*lab var t_plotRiceYield5_1_c_15 "yields (defined if growing rice)"
	lab var F_t_plotRiceYield5_1_c_15 "yields (defined if growing rice)"

foreach v in profit_vouch_2 {
	g `v'_c_14=`v'_uc_14 if d_growrice_14==1
}


*interaction terms

	gen treatment1 = treatment 
	label variable treatment1 "Treatment" 

	
		*input use bsl
	gen rpchem_bsl = 0 
	replace rpchem_bsl = 1 if rp_npk_bsl == 1 & rp_urea_bsl == 1
	replace rpchem_bsl = 0 if d_growrice_bsl == 0 	
	label variable rpchem_bsl "used chem fert (both npk and urea) at baseline" 

	gen trtXrpchem_bsl = 0 
	replace trtXrpchem_bsl = 1 if treatment == 1 & rpchem_bsl == 1 
	label variable trtXrpchem_bsl "Interaction" 

		*water access bsl
	label variable access_water_bsl "good water habitation" 

	gen trtXwater_bsl = 0 
	replace trtXwater_bsl = 1 if treatment == 1 & water_bsl == 1 
	label variable trtXwater_bsl "Interaction" 

	replace irrigated_bsl=1 if rp_irrigated_bsl==1
	gen trtXirrig_bsl = 0 
	replace trtXirrig_bsl = 1 if treatment == 1 & rp_irrigated_bsl == 1 
	label variable trtXirrig_bsl "Interaction" 
	
		*credit bsl
	drop _merge
	merge 1:1 nsm using "/home/j.gignoux/U/Travail/GMSW/analysis/data/Dec'13/sale_place.dta"
	keep if _merge==3
	gen sale_fieldsara_bsl=sale_sara==1|sale_field==1
	lab var sale_fieldsara_bsl "sales on field / merchant"
	gen trtXsale_fieldsara_bsl = 0 
	replace trtXsale_fieldsara_bsl = 1 if treatment == 1 & sale_fieldsara_bsl == 1 
	label variable trtXsale_fieldsara_bsl "Interaction" 

		*labor available bsl
	g HH_adults_4p_bsl=HH_adults_bsl>=4
	lab var HH_adults_4p_bsl "4 or more adults in HH"
	gen trtXadults_4p_bsl = 0 
	replace trtXadults_4p_bsl = 1 if treatment == 1 & HH_adults_4p_bsl == 1 
	label variable trtXadults_4p_bsl "Interaction" 

	g HH_adults_5p_bsl=HH_adults_bsl>=5
	lab var HH_adults_5p_bsl "5 or more adults in HH"
	gen trtXadults_5p_bsl = 0 
	replace trtXadults_5p_bsl = 1 if treatment == 1 & HH_adults_5p_bsl == 1 
	label variable trtXadults_5p_bsl "Interaction" 

		*vouchers late
	g vouchers_late=v_pl_ontime_14==0|v_s_ontime_14==0|v_f_ontime_14==0|v_p_ontime_14==0 if treatment==1
	g vouchers_late2=v_pl_ontime_14==0|v_s_ontime_14==0|v_f_ontime_14==0|v_p_ontime_14==0|v_tr_ontime_14==0|v_pa_ontime_14==0|v_tc_ontime_14==0 if treatment==1
	lab var vouchers_late2 "Some vouchers got late"
	gen trtXvouchers_late2 = 0 
	replace trtXvouchers_late2 = 1 if treatment == 1 & vouchers_late2 == 1 
	label variable trtXvouchers_late2 "Interaction" 
	
		*hunger severe
	lab var HungerScale_sev_bsl "Severe hunger"
	gen trtXHungerScale_sev_bsl = 0 
	replace trtXHungerScale_sev_bsl = 1 if treatment == 1 & HungerScale_sev_bsl == 1 
	label variable trtXHungerScale_sev_bsl "Interaction" 

		*visits from PTTA agents
	recode techvisit_got_14 -888 .=0
	replace techvisit_got_14=0 if treatment==0

	g techvisit_advice_14=techvisit_got_14==1 & inlist(techvisit_whichinfo_14,"2","1 2","2 3","1 2 3","2 other")
	lab var techvisit_advice_14 "PTTA tech advice"
	gen trtXtechvisit_advice_14=0
	replace trtXtechvisit_advice_14=1 if treatment==1 & techvisit_advice_14==1
	lab var trtXtechvisit_advice_14 "Interaction"



*preserve 

keep harv_any_hh_* t_prod_value_uc_bsl t_prod_value5_uc* t_plotRiceYield5_1_uc* t_plotRiceYield5_1_c* /*
	*/ t_sale_value_uc_* profit_2_uc_* profit_vouch_2_uc_14 /*
	*/ t_plotRiceYield5_1_c* profit_2_c_* profit_vouch_2_c_14 /*
	*/ d_growrice_* n_riceplot_uc_* t_plot_area_byins*1_uc* /* 
	*/ rp_qty_allchem_uc_* qty_allchem_kgha* rp_input_spending_uc* rp_chempest_spending_uc* /*
	*/ rp_qty_urea_uc_* rp_qty_npk_uc_* rp_qty_sulfate_uc_* rp_allchem_totmore150_* rp_allchem_totmore135_* rp_allchem_tot120150_* fstMonth_* /*
	*/ rp_allchem_spending_uc_* rp_pest_spending_uc_* rp_labor_spendingEX_uc_* /*
	*/ fert_PTTA_* fert_loan_* fert_purch_* fert_DomRep_* fert_oth_* /*
	*/ pest_PTTA_* pest_loan_* pest_purch_* pest_DomRep_* pest_oth_* /*
	*/ seed_PTTA_* seed_loan_* seed_purch_* seed_DomRep_* seed_previous_* seed_oth_* /*
	*/ seeds_ha2a_cond_* tech_3plant_cond_* d_mult_cond_* rp_h_d_3bagsulf_* rp_allchem_totmore150_* fstMonth_* /*
	*/ askloaninp_bank_* obtloanamt_bank_* askloaninp_sara_* obtloanamt_sara_* /*
	*/ other_harvest_value_* other_sale_value_* /*
	*/ DR_tot_adult_work_HH_15 DR_male_work_HH_15 DR_fem_work_HH_15 DR_tot_work_days_HH_15 DR_male_work_days_HH_15 DR_fem_work_days_HH_15 /*
	*/ savings_st_* assets_hh_ind_* assets_farm_ind_* assets_livst_ind1_* /*
	*/ HungerScale_* HungerScale_sev_* months_insecure_* /*
	*/ harv_lost_hh_* /*
	*/ n_allPlot_* n_culPlot_* t_sizeculPlot_* /*
	*/ lagoon_* irrigated_* irrigate_spending_* /*
	*/ treatment h_d_suplag*_bsl group2_bsl habitation_old_bsl /*
	*/ d_thinkben_* /*
	*/ plan_growrice_* plan_numpar_* plan_arearice_* plan_loan_* plan15_newplotrice_14 /*
	*/ F_harv_any_hh_* F_t_prod_value5_uc_* F_profit_2_uc_* F_t_plotRiceYield5_1_uc_* F_t_plotRiceYield5_1_c_* F_t_sale_value_uc_* F_rp_qty_allchem_uc_* F_rp_qty_urea_uc_* F_rp_qty_npk_uc_* F_rp_qty_sulfate_uc_* F_rp_allchem_spending_uc_* F_rp_pest_spending_uc_* F_rp_chempest_spending_uc_* F_rp_labor_spendingEX_uc_* /*
	*/ F_t_plotRiceYield5_1_c* F_profit_2_c_* /*
	*/ treatment1 rpchem_bsl trtXrpchem_bsl water_bsl trtXwater_bsl irrigated_bsl trtXirrig_bsl sale_fieldsara_bsl trtXsale_fieldsara_bsl HH_adults_4p_bsl trtXadults_4p_bsl HH_adults_5p_bsl trtXadults_5p_bsl vouchers_late2 trtXvouchers_late2 HungerScale_sev_bsl trtXHungerScale_sev_bsl trtXtechvisit_advice_14


keep treatment treatment1 habitation_old_bsl h_d_suplag*_bsl group2_bsl /*
*/	*t_plotRiceYield5_1_uc* *t_plotRiceYield5_1_c* *profit_2_uc* *profit_vouch_2_uc* /*
*/	rpchem_bsl trtXrpchem_bsl water_bsl trtXwater_bsl irrigated_bsl trtXirrig_bsl sale_fieldsara_bsl trtXsale_fieldsara_bsl HH_adults_4p_bsl trtXadults_4p_bsl HH_adults_5p_bsl trtXadults_5p_bsl vouchers_late2 trtXvouchers_late2 HungerScale_sev_bsl trtXHungerScale_sev_bsl trtXtechvisit_advice_14
	


* log file 
cap log close
log using "$log/estimates main treatment with interactions effects", replace


local outcomes ///
	t_plotRiceYield5_1_uc profit_2_uc profit_vouch_2_uc


forvalues x=1/6 {

	if `x'==1 {
		local trt "treatment1 rpchem_bsl trtXrpchem_bsl"
	}
	if `x'==2 {
		local trt "treatment1 sale_fieldsara_bsl trtXsale_fieldsara_bsl"
	}
	if `x'==3 {
		local trt "treatment1 HH_adults_4p_bsl trtXadults_4p_bsl"
	}
	if `x'==4 {
		local trt "treatment1 water_bsl trtXwater_bsl"
	}
	if `x'==5 {
		local trt "treatment1 trtXvouchers_late2"
	}
	if `x'==6 {
		local trt "treatment1 trtXtechvisit_advice_14"
	}


foreach y in `outcomes' {

	local bsl_cov `y'_bsl
	local var_14 `y'_14
	local var_n14 `y'_n14
	local var_15 `y'_15
	local F_bsl_cov F_`y'_bsl
	local F_var_15 F_`y'_15

	disp "`var'"
	disp "`var_14'" "`var_n14'" "`var_15'" 

	cap confirm variable `y'_bsl 


	if !_rc {
		cap confirm variable `var_14' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1)    cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `var_14' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)

			scalar reps2=r(N_reps)
			matrix pval=r(p)
			scalar p_ri2=pval[1,1]

			* Conventional sampling 
			areg `var_14' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_14' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treatment
			estadd scalar p_conv = r(p)
			estadd local bsl_outcome "yes"
			estadd local reps=reps2
			estadd local p_ri=p_ri2
			estadd local yr=2014
			est sto `y'_14, title(2014, conv)
		}
	}

	else {
		cap confirm variable `var_14' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1)    cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `var_14' `trt' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			scalar reps2=r(N_reps)
			matrix pval=r(p)
			scalar p_ri2=pval[1,1]

			* Conventional sampling 
			areg `var_14' `trt' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_14' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treatment
			estadd scalar p_conv = r(p)
			estadd local bsl_outcome "no"
			estadd local reps=reps2
			estadd local p_ri=p_ri2
			estadd local yr=2014
			est sto `y'_14, title(2014, conv)
		}
	}

	cap confirm variable F_`y'_bsl 

	if !_rc {
		cap confirm variable `F_var_15' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1)    cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `F_var_15' `trt' `F_bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			scalar reps2=r(N_reps)
			matrix pval=r(p)
			scalar p_ri2=pval[1,1]

			* Conventional sampling 
			areg `F_var_15' `trt' `F_bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `F_var_15' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treatment
			estadd scalar p_conv = r(p)
			estadd local bsl_outcome "yes"
			estadd local reps=reps2
			estadd local p_ri=p_ri2
			estadd local yr=2015
			est sto `y'_15f, title(FS 2015, conv)
		}
	}

	else {
		cap confirm variable `F_var_15' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1)    cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `F_var_15' `trt' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			scalar reps2=r(N_reps)
			matrix pval=r(p)
			scalar p_ri2=pval[1,1]

			* Conventional sampling 
			areg `F_var_15' `trt' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `F_var_15' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treatment
			estadd scalar p_conv = r(p)
			estadd local bsl_outcome "no"
			estadd local reps=reps2
			estadd local p_ri=p_ri2
			estadd local yr=2015
			est sto `y'_15f, title(FS 2015, conv)
		}
	}
}






*Table A7 to 14 yields & profits with interactions

		estout t_plotRiceYield5_1_uc_14 profit_2_uc_14 profit_vouch_2_uc_14 ///
			using "$results/T_impacts_yields_profit_14_int`x'.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(`treatment') ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.1f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout t_plotRiceYield5_1_uc_15f profit_2_uc_15f ///
			using "$results/T_impacts_yields_profit_15f_int`x'.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(`treatment') ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.1f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace
p_bsl trtXadults_4p_bsl"
	}
	if `x'==4 {
		local trt "treatment1 water_bsl trtXwater_bsl"
	}
	if `x'==5 {
		local trt "treatment1 trtXvouchers_late2"
	}
	if `x'==6 {
		local trt "treatment1 trtXtechvisit_advice_14"
	}



	keep treatment treatment1 habitation_old_bsl h_d_suplag*_bsl group2_bsl /*
	*/	*t_plotRiceYield5_1_uc* *t_plotRiceYield5_1_c* *profit_2_uc* *profit_vouch_2_uc* /*
	*/	rpchem_bsl trtXrpchem_bsl water_bsl trtXwater_bsl irrigated_bsl trtXirrig_bsl sale_fieldsara_bsl trtXsale_fieldsara_bsl HH_adults_4p_bsl trtXadults_4p_bsl HH_adults_5p_bsl trtXadults_5p_bsl vouchers_late2 trtXvouchers_late2 HungerScale_sev_bsl trtXHungerScale_sev_bsl trtXtechvisit_advice_14
		


	foreach y in `outcomes' {

		local bsl_cov `y'_bsl
		local var_14 `y'_14
		local var_n14 `y'_n14
		local var_15 `y'_15
		local F_bsl_cov F_`y'_bsl
		local F_var_15 F_`y'_15

		disp "`var'"
		disp "`var_14'" "`var_n14'" "`var_15'" 

		cap confirm variable `y'_bsl 


		if !_rc {
			cap confirm variable `var_14' 
			if !_rc {
				* RI 
				ritest treatment _b[treatment], reps(1)    cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `var_14' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)

				scalar reps2=r(N_reps)
				matrix pval=r(p)
				scalar p_ri2=pval[1,1]

				* Conventional sampling 
				areg `var_14' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
				su `var_14' if treatment==0
				estadd scalar m_ctr=r(mean)
				test treatment
				estadd scalar p_conv = r(p)
				estadd local bsl_outcome "yes"
				estadd local reps=reps2
				estadd local p_ri=p_ri2
				estadd local yr=2014
				est sto `y'_14, title(2014, conv)
			}
		}

		else {
			cap confirm variable `var_14' 
			if !_rc {
				* RI 
				ritest treatment _b[treatment], reps(1)    cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `var_14' `trt' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
				scalar reps2=r(N_reps)
				matrix pval=r(p)
				scalar p_ri2=pval[1,1]

				* Conventional sampling 
				areg `var_14' `trt' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
				su `var_14' if treatment==0
				estadd scalar m_ctr=r(mean)
				test treatment
				estadd scalar p_conv = r(p)
				estadd local bsl_outcome "no"
				estadd local reps=reps2
				estadd local p_ri=p_ri2
				estadd local yr=2014
				est sto `y'_14, title(2014, conv)
			}
		}

		cap confirm variable F_`y'_bsl 

		if !_rc {
			cap confirm variable `F_var_15' 
			if !_rc {
				* RI 
				ritest treatment _b[treatment], reps(1)    cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `F_var_15' `trt' `F_bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
				scalar reps2=r(N_reps)
				matrix pval=r(p)
				scalar p_ri2=pval[1,1]

				* Conventional sampling 
				areg `F_var_15' `trt' `F_bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
				su `F_var_15' if treatment==0
				estadd scalar m_ctr=r(mean)
				test treatment
				estadd scalar p_conv = r(p)
				estadd local bsl_outcome "yes"
				estadd local reps=reps2
				estadd local p_ri=p_ri2
				estadd local yr=2015
				est sto `y'_15f, title(FS 2015, conv)
			}
		}

		else {
			cap confirm variable `F_var_15' 
			if !_rc {
				* RI 
				ritest treatment _b[treatment], reps(1)    cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `F_var_15' `trt' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
				scalar reps2=r(N_reps)
				matrix pval=r(p)
				scalar p_ri2=pval[1,1]

				* Conventional sampling 
				areg `F_var_15' `trt' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
				su `F_var_15' if treatment==0
				estadd scalar m_ctr=r(mean)
				test treatment
				estadd scalar p_conv = r(p)
				estadd local bsl_outcome "no"
				estadd local reps=reps2
				estadd local p_ri=p_ri2
				estadd local yr=2015
				est sto `y'_15f, title(FS 2015, conv)
			}
		}
	}



	*Table A7 to 14 yields & profits with interactions

			estout t_plotRiceYield5_1_uc_14 profit_2_uc_14 profit_vouch_2_uc_14 ///
				using "$results/T_impacts_yields_profit_14_int`x'.tex", cells("b(star fmt(3))" se(par)) ///
				mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
				keep(`treatment') ///
				numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.1f) labels("p-value conv." "p-value RI" "Control mean")) replace

			estout t_plotRiceYield5_1_uc_15f profit_2_uc_15f ///
				using "$results/T_impacts_yields_profit_15f_int`x'.tex", cells("b(star fmt(3))" se(par)) ///
				mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
				keep(`treatment') ///
				numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.1f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace


}




