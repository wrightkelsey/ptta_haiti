*********************************************
*	RANDOMIZED INFERENCE IMPACT ANALYSIS OF INPUT SUBSIDIES IN HAITI, GIGNOUX, MACOURS, STEIN & WRIGHT AJAE 2022
*	MAIN TREATMENT EFFECTS
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


if c(username) == "j.gignoux" {
	cd "/home/j.gignoux/U/Travail/GMSW/analysis/replication"       /*** PATH TO BE MODIFIED ***/
	global workdata="./data"
	global log="./log"
	global results="./results"
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

foreach v in profit_vouch_2 {
	g `v'_c_14=`v'_uc_14 if d_growrice_14==1
}

keep t_prod_value_uc_bsl t_prod_value5_uc* t_plotRiceYield5_1_uc* /*
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
	*/ harv_any_hh_* harv_lost_hh_* /*
	*/ n_allPlot_* n_culPlot_* t_sizeculPlot_* /*
	*/ lagoon_* irrigated_* irrigate_spending_* /*
	*/ treatment h_d_suplag*_bsl group2_bsl habitation_old_bsl /*
	*/ d_thinkben_* /*
	*/ plan_growrice_* plan_numpar_* plan_arearice_* plan_loan_* plan15_newplotrice_14 /*
	*/ F_harv_any_hh_* F_t_prod_value5_uc_* F_profit_2_uc_* F_t_plotRiceYield5_1_uc_* F_t_sale_value_uc_* F_rp_qty_allchem_uc_* F_rp_qty_urea_uc_* F_rp_qty_npk_uc_* F_rp_qty_sulfate_uc_* F_rp_allchem_spending_uc_* F_rp_pest_spending_uc_* F_rp_chempest_spending_uc_* F_rp_labor_spendingEX_uc_* /*
	*/ F_t_plotRiceYield5_1_c* F_profit_2_c_*

local trt treatment

local outcomes ///
	t_plotRiceYield5_1_uc profit_2_uc profit_vouch_2_uc ///
	qty_allchem_kgha_uc rp_chempest_spending_uc rp_labor_spendingEX_uc ///
	d_thinkben ///
	askloaninp_bank obtloanamt_bank askloaninp_sara obtloanamt_sara ///
	t_plotRiceYield5_1_c profit_2_c profit_vouch_2_c ///
	d_growrice t_plot_area_byinst1_uc ///
	harv_any_hh f_harv_any_hh harv_lost_hh t_prod_value5_uc ///
	rp_qty_urea_uc rp_qty_npk_uc rp_qty_sulfate_uc ///
	fert_PTTA fert_loan fert_purch fert_DomRep fert_oth ///
	pest_PTTA pest_loan pest_purch pest_DomRep pest_oth ///
	seed_PTTA seed_loan seed_purch seed_DomRep seed_previous seed_oth ///
	seeds_ha2a_cond tech_3plant_cond d_mult_cond ///
	HungerScale HungerScale_sev months_insecure ///
	savings_st assets_hh_ind assets_farm_ind assets_livst_ind1 ///
	n_allPlot lagoon irrigated irrigate_spending ///
	n_culPlot t_sizeculPlot other_harvest_value other_sale_value ///
	DR_tot_adult_work_HH DR_tot_work_days_HH

lab var n_culPlot_14 "nb of plots cultivated"
lab var n_culPlot_15 "nb of plots cultivated"
lab var t_sizeculPlot_14 "area cultivated"
lab var t_sizeculPlot_15 "area cultivated"
lab var other_harvest_value_14 "harvest value"
lab var other_harvest_value_15 "harvest value"
lab var other_sale_value_14 "sales value"
lab var other_sale_value_15 "sales value"

lab var treatment "Treatment"

keep treatment habitation_old_bsl h_d_suplag*_bsl group2_bsl /*
*/	*t_plotRiceYield5_1_uc* *profit_2_uc* *profit_vouch_2_uc* /*
*/ 	*qty_allchem_kgha_uc* *rp_chempest_spending_uc* *rp_labor_spendingEX_uc* /*
*/	*d_thinkben* /*
*/	*askloaninp_bank* *obtloanamt_bank* *askloaninp_sara* *obtloanamt_sara* /*
*/	*t_plotRiceYield5_1_c* *profit_2_c* *profit_vouch_2_c* /*
*/	*d_growrice* *t_plot_area_byinst1_uc* /*
*/	*harv_any_hh* *harv_lost_hh* *t_prod_value5_uc* /*
*/	*rp_qty_urea_uc* *rp_qty_npk_uc* *rp_qty_sulfate_uc* /*
*/	*fert_PTTA* fert_loan* fert_purch* fert_DomRep* fert_oth* /*
*/	*pest_PTTA* pest_loan* pest_purch* pest_DomRep* pest_oth* /*
*/	*seed_PTTA* seed_loan* seed_purch* seed_DomRep* seed_previous* seed_oth* /*
*/	*seeds_ha2a_cond* *tech_3plant_cond* *d_mult_cond* /*
*/	*HungerScale* *HungerScale_sev* *months_insecure* /*
*/	*savings_st* *assets_hh_ind* *assets_farm_ind* *assets_livst_ind1* /*
*/	*n_allPlot* *lagoon* *irrigated* *irrigate_spending* /*
*/	*t_sizeculPlot* *other_harvest_value* *other_sale_value* /*
*/	*DR_tot_adult_work_HH* *DR_tot_work_days_HH*


* log file 
cap log close
log using "$log/estimates main treatment effects", replace



foreach y in `outcomes' {

	local bsl_cov `y'_bsl
	local var_14 `y'_14
	local var_n14 `y'_n14
	local var_15 `y'_15
	local F_bsl_cov F_`y'_bsl
	local F_var_15 F_`y'_15


	disp "`var'"
	disp "`var_14'" "`var_n14'" "`var_15'" 

	* if baseline var exists
	cap confirm variable `y'_bsl 

	if !_rc {
	
		* 14 first follow-up outcomes
		cap confirm variable `var_14' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1) cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `var_14' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
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

		* November 14 follow-up
		cap confirm variable `var_n14' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1) cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `var_15' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			scalar reps2=r(N_reps)
			matrix pval=r(p)
			scalar p_ri2=pval[1,1]

			* Conventional sampling 
			areg `var_n14' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_n14' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treatment
			estadd scalar p_conv = r(p)
			estadd local bsl_outcome "yes"
			estadd local reps=reps2
			estadd local p_ri=p_ri2
			estadd local yr=112014
			est sto `y'_n14, title(nov'2014, conv)
		}

		* 15 second follow-up outcomes
		cap confirm variable `var_15' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1) cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `var_15' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			scalar reps2=r(N_reps)
			matrix pval=r(p)
			scalar p_ri2=pval[1,1]

			* Conventional sampling 
			areg `var_15' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_15' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treatment
			estadd scalar p_conv = r(p)
			estadd local bsl_outcome "yes"
			estadd local reps=reps2
			estadd local p_ri=p_ri2
			estadd local yr=2015
			est sto `y'_15, title(2015, conv)
		}
	}

	* if baseline var does not exist

	else {
		* 14 first follow-up outcomes
		cap confirm variable `var_14' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1) cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `var_14' `trt' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
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

		* November 14 follow-up
		cap confirm variable `var_n14' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1) cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `var_n14' `trt' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			scalar reps2=r(N_reps)
			matrix pval=r(p)
			scalar p_ri2=pval[1,1]

			* Conventional sampling 
			areg `var_n14' `trt' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_n14' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treatment
			estadd scalar p_conv = r(p)
			estadd local bsl_outcome "no"
			estadd local reps=reps2
			estadd local p_ri=p_ri2
			estadd local yr=112014
			est sto `y'_n14, title(nov'2014, conv)
		}

		* 15 second follow-up outcomes
		cap confirm variable `var_15' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1) cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `var_15' `trt' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			scalar reps2=r(N_reps)
			matrix pval=r(p)
			scalar p_ri2=pval[1,1]

			* Conventional sampling 
			areg `var_15' `trt' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_15' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treatment
			estadd scalar p_conv = r(p)
			estadd local bsl_outcome "no"
			estadd local reps=reps2
			estadd local p_ri=p_ri2
			estadd local yr=2015
			est sto `y'_15, title(2015, conv)
		}
	}

	* first season 15
	* if first season baseline var exists, use as control
	cap confirm variable F_`y'_bsl 

	if !_rc {
		cap confirm variable `F_var_15' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1) cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `F_var_15' `trt' `F_bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
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

	* if first season baseline var does not exist, use baseline full season as control
	else {
		cap confirm variable `F_var_15' 
		if !_rc {
			* RI 
			ritest treatment _b[treatment], reps(1) cluster(habitation_old_bsl) strata(group2_bsl) seed(2018): areg `F_var_15' `trt' h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
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


*Table 3 yields & profits 
		estout t_plotRiceYield5_1_uc_14 profit_2_uc_14 profit_vouch_2_uc_14 ///
			using "$results/T_impacts_yields_profit_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.1f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout t_plotRiceYield5_1_uc_15f profit_2_uc_15f ///
			using "$results/T_impacts_yields_profit_15f_controls.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.1f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

*Table 4 inputs 
		estout qty_allchem_kgha_uc_14 rp_chempest_spending_uc_14 rp_labor_spendingEX_uc_14 ///
			using "$results/T_impacts_inputs_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.1f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout qty_allchem_kgha_uc_15 rp_chempest_spending_uc_15f rp_labor_spendingEX_uc_15f ///
			using "$results/T_impacts_inputs_15f.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.1f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

*Table 5 expectation to receive vouchers in 15 
		estout d_thinkben_n14 d_thinkben_14 ///
			using "$results/T_impacts_expectPTTA.tex", cells("b(star fmt(3))" se(par)) ///
			l mlabels(,depvars) style(tex) ///
			prehead(\begin{tabular}{lcc}\hline) posthead(\hline) ///
			postfoot(\hline\end{tabular}) ///
			keep(treatment) ///
			indicate("Lagoons and randomization strata FE=h_d_suplag1_bsl") ///
			numbers(( )) stats(bsl_outcome p_conv p_ri reps m_ctr N yr, fmt(%9.3f %9.3f %9.3f  %9.3f %9.3f %9.0f) labels("Baseline outcome" "p-value conv" "p-value RI" "Nb replications" "Control mean"  "Observations" "Year")) replace
			
*Table 9 finance 
		estout askloaninp_bank_14 obtloanamt_bank_14 askloaninp_sara_14 obtloanamt_sara_14 ///
			using "$results/T_impacts_finance_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout askloaninp_bank_15 obtloanamt_bank_15 askloaninp_sara_15 obtloanamt_sara_15 ///
			using "$results/T_impacts_finance_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace


*TA2 conditional yields & profits 
		estout t_plotRiceYield5_1_c_14 profit_2_c_14 profit_vouch_2_c_14 ///
			using "$results/TA_impacts_cond_yields_profit_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.1f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout t_plotRiceYield5_1_c_15f profit_2_c_15f ///
			using "$results/TA_impacts_cond_yields_profit_15f.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.1f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

*TA3 rice cultivation
		estout d_growrice_14 t_plot_area_byinst1_uc_14 ///
			using "$results/TA_impacts_cultiv_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout d_growrice_15 t_plot_area_byinst1_uc_15 ///
			using "$results/TA_impacts_cultiv_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

*TA4 harvest outcomes (any and losses, prod value)
		estout harv_any_hh_14 harv_lost_hh_14 t_prod_value5_uc_14 ///
			using "$results/TA_impacts_harvest_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout harv_any_hh_15f harv_lost_hh_15 t_prod_value5_uc_15f ///
			using "$results/TA_impacts_harvest_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

*TA5 quantities chem fert
		estout rp_qty_urea_uc_14 rp_qty_npk_uc_14 rp_qty_sulfate_uc_14 ///
			using "$results/TA_impacts_inputs_qty_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout rp_qty_urea_uc_15f rp_qty_npk_uc_15f rp_qty_sulfate_uc_15f ///
			using "$results/TA_impacts_inputs_qty_15f.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

*TA6 sources of inputs
		estout fert_PTTA_14 fert_loan_14 fert_oth_14 ///
			using "$results/TA_impacts_sourcesfert_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout fert_PTTA_15 fert_loan_15 fert_purch_15 fert_DomRep_15 fert_oth_15 ///
			using "$results/TA_impacts_sourcesfert_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

		estout pest_PTTA_14 pest_loan_14 pest_oth_14 ///
			using "$results/TA_impacts_sourcespest_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout pest_PTTA_15 pest_loan_15 pest_purch_15 pest_DomRep_15 pest_oth_15 ///
			using "$results/TA_impacts_sourcespest_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

		estout seed_PTTA_14 seed_loan_14 seed_oth_14 ///
			using "$results/TA_impacts_sourcesseed_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout seed_PTTA_15 seed_loan_15 seed_purch_15 seed_DomRep_15 seed_oth_15 ///
			using "$results/TA_impacts_sourcesseed_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

*TA13 practices & delays 
		estout seeds_ha2a_cond_14 tech_3plant_cond_14 d_mult_cond_14  ///
			using "$results/T_impacts_practices_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout seeds_ha2a_cond_15 tech_3plant_cond_15 d_mult_cond_15  ///
			using "$results/T_impacts_practices_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

*TA15 food security 
		estout HungerScale_14  HungerScale_sev_14   ///
			using "$results/TA_impacts_food_security_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout HungerScale_15 HungerScale_sev_15 months_insecure_15 ///
			using "$results/TA_impacts_food_security_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

*TA16 asset ownership
		estout savings_st_14  assets_hh_ind_14  assets_farm_ind_14  assets_livst_ind1_14    ///
			using "$results/TA_impacts_assets_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout savings_st_15 assets_hh_ind_15 assets_farm_ind_15 assets_livst_ind1_15 ///
			using "$results/TA_impacts_assets_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

*TA17 land ownership & investments
		estout n_allPlot_14  lagoon_14 irrigated_14 irrigate_spending_14 ///
			using "$results/TA_impacts_land_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout n_allPlot_15 lagoon_15 irrigated_15 irrigate_spending_15 ///
			using "$results/TA_impacts_land_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace

*TA18 other economic activities
		estout  t_sizeculPlot_14  other_harvest_value_14  other_sale_value_14 ///
			using "$results/TA_impacts_oth_activ_14.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr, fmt(%9.3f %9.3f  %9.3f) labels("p-value conv." "p-value RI" "Control mean")) replace

		estout t_sizeculPlot_15 other_harvest_value_15 other_sale_value_15 DR_tot_adult_work_HH_15 DR_tot_work_days_HH_15 ///
			using "$results/TA_impacts_oth_activ_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv p_ri m_ctr reps bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-value conv." "p-value RI" "Control mean" "Nb replications" "Baseline outcome"  "Observations")) replace


*log close






