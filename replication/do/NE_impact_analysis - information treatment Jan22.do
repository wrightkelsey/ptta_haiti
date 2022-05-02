*********************************************
*	RANDOMIZED INFERENCE IMPACT ANALYSIS OF INPUT SUBSIDIES IN HAITI, GIGNOUX, MACOURS, STEIN & WRIGHT AJAE 2022
*	MAIN AND INFORMATION TREATMENT EFFECTS
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
	*/ seeds_ha2a_* tech_3plant_* d_mult* rp_h_d_3bagsulf_uc_* /*
	*/ askloaninp_bank_* obtloanamt_bank_* askloaninp_sara_* obtloanamt_sara_* /*
	*/ other_harvest_value_* other_sale_value_* /*
	*/ savings_st_* assets_hh_ind_* assets_farm_ind_* assets_livst_ind1_* /*
	*/ HungerScale_* HungerScale_sev_* months_insecure_* /*
	*/ fstMonth_* harv_lost_hh_* /*
	*/ n_allPlot_* n_culPlot_* t_sizeculPlot_* /*
	*/ lagoon_* irrigated_* irrigate_spending_* /*
	*/ treatment h_d_suplag*_bsl group2_bsl habitation_old_bsl, f


** estimates

* vars 

g rp_chempest_spending_uc_14=rp_allchem_spending_uc_14+rp_pest_spending_uc_14
g rp_chempest_spending_uc_15=rp_allchem_spending_uc_15+rp_pest_spending_uc_15
g F_rp_chempest_spending_uc_15=F_rp_allchem_spending_uc_15+F_rp_pest_spending_uc_15
lab var rp_chempest_spending_uc_14 "Spending in fertilizer and pesticides (USD)"
lab var rp_chempest_spending_uc_15 "Spending in fertilizer and pesticides (USD)"
lab var F_rp_chempest_spending_uc_15 "Spending in fertilizer and pesticides (USD)"


** treatment variables

rename trt_info informed 	
gen treat_inf = trtXinfo
label variable treat_inf "Treatment, Informed" 
gen treat_no_inf = 0 
replace treat_no_inf = 1 if treatment == 1 & informed == 0
label variable treat_no_inf "Treatment, Uninformed" 
gen control_inf = 0 
replace control_inf = 1 if treatment == 0 & informed == 1 
label variable control_inf "Control, Informed" 


keep /*
	*/ d_thinkben_* /*
	*/ t_plotRiceYield5_1_uc* F_t_plotRiceYield5_1_uc_* profit_2_uc_* F_profit_2_uc_* profit_vouch_2_uc* /*
	*/ qty_allchem_kgha* rp_chempest_spending_uc_* rp_labor_spendingEX_uc_* F_rp_allchem_spending_uc_* F_rp_chempest_spending_uc_* F_rp_labor_spendingEX_uc_*  /*
	*/ askloaninp_bank_* obtloanamt_bank_* askloaninp_sara_* obtloanamt_sara_* /*
	*/ treatment informed treat_inf treat_no_inf control_inf h_d_suplag*_bsl group2_bsl habitation_old_bsl


local trt="treat_inf treat_no_inf control_inf" 	

lab var treat_inf 

local outcomes ///
	d_thinkben ///
	t_plotRiceYield5_1_uc profit_2_uc profit_vouch_2_uc ///
	qty_allchem_kgha_uc rp_chempest_spending_uc rp_labor_spendingEX_uc ///
	askloaninp_bank obtloanamt_bank askloaninp_sara obtloanamt_sara


cap log close
log using "$log/estimates main and information treatment effects", replace



foreach y in `outcomes' {
	local bsl_cov `y'_bsl
	local var_14 `y'_14
	local var_n14 `y'_n14
	local var_15 `y'_15
	local F_bsl_cov F_`y'_bsl
	local F_var_15 F_`y'_15

	disp "`var'"

	cap confirm variable `y'_bsl 

	if !_rc {
		cap confirm variable `var_14' 
		if !_rc {
			* Conventional sampling 
			areg `var_14' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_14' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treat_inf=treat_no_inf 
			estadd scalar p_trt = r(p)
			test treat_inf=treat_no_inf=control_inf
			estadd scalar p_X2 = r(p)				
			estadd local bsl_outcome "yes"
			estadd local yr=2014
			est sto `y'_14, title(2014, conv)
		}

		cap confirm variable `var_n14' 
		if !_rc {
			* Conventional sampling 
			areg `var_n14' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_n14' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treat_inf=treat_no_inf 
			estadd scalar p_trt = r(p)
			test treat_inf=treat_no_inf=control_inf
			estadd scalar p_X2 = r(p)				
			estadd local bsl_outcome "yes"
			estadd local yr=2014
			est sto `y'_n14, title(2014, conv)
		}

		cap confirm variable `var_15' 
		if !_rc {
			* Conventional sampling 
			areg `var_15' `trt' `bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_15' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treat_inf=treat_no_inf 
			estadd scalar p_trt = r(p)
			test treat_inf=treat_no_inf=control_inf
			estadd scalar p_X2 = r(p)				
			estadd local bsl_outcome "yes"
			estadd local yr=2015
			est sto `y'_15, title(2015, conv)
		}
	}

	else {
		cap confirm variable `var_14' 
		if !_rc {
			* Conventional sampling 
			areg `var_14' `trt' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_14' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treat_inf=treat_no_inf 
			estadd scalar p_trt = r(p)
			test treat_inf=treat_no_inf=control_inf
			estadd scalar p_X2 = r(p)				
			estadd local bsl_outcome "no"
			estadd local yr=2014
			est sto `y'_14, title(2014, conv)
		}

		cap confirm variable `var_n14' 
		if !_rc {
			* Conventional sampling 
			areg `var_n14' `trt' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_n14' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treat_inf=treat_no_inf 
			estadd scalar p_trt = r(p)
			test treat_inf=treat_no_inf=control_inf
			estadd scalar p_X2 = r(p)				
			estadd local bsl_outcome "no"
			estadd local yr=2014
			est sto `y'_n14, title(2014, conv)
		}

		cap confirm variable `var_15' 
		if !_rc {
			* Conventional sampling 
			areg `var_15' `trt' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `var_15' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treat_inf=treat_no_inf 
			estadd scalar p_trt = r(p)
			test treat_inf=treat_no_inf=control_inf
			estadd scalar p_X2 = r(p)				
			estadd local bsl_outcome "no"
			estadd local yr=2015
			est sto `y'_15, title(2015, conv)
		}
	}

	cap confirm variable F_`y'_bsl 

	if !_rc {
		cap confirm variable `F_var_15' 
		if !_rc {
			* Conventional sampling 
			areg `F_var_15' `trt' `F_bsl_cov' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `F_var_15' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treat_inf=treat_no_inf 
			estadd scalar p_trt = r(p)
			test treat_inf=treat_no_inf=control_inf
			estadd scalar p_X2 = r(p)				
			estadd local bsl_outcome "yes"
			estadd local yr=2015
			est sto `y'_15f, title(FS 2015, conv)
		}
	}

	else {
		cap confirm variable `F_var_15' 
		if !_rc {
			* Conventional sampling 
			areg `F_var_15' `trt' h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl, a(group2_bsl) cluster(habitation_old_bsl)
			su `F_var_15' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treat_inf=treat_no_inf 
			estadd scalar p_trt = r(p)
			test treat_inf=treat_no_inf=control_inf
			estadd scalar p_X2 = r(p)				
			estadd local bsl_outcome "no"
			estadd local yr=2015
			est sto `y'_15f, title(FS 2015, conv)
		}
	}
}


*Table 5 expectations of PTTA benefits in 15

		estout d_thinkben_14 ///
			using "$results/T_impacts_info_expect_benefPTTA_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) varlabels(treat_inf Treatment*informed treat_no_inf Treatment*uninformed control_inf Control*informed) ///
			keep(treat_inf treat_no_inf control_inf) ///
			indicate("Lagoons and randomization strata FE=h_d_suplag1_bsl") ///
			numbers(( )) stats(bsl_outcome p_trt p_X2 m_ctr N, fmt(%9.3f %9.3f %9.3f %9.3f %9.0f) labels("Baseline outcome" "p-val trt informed=trt uninformed" "p-val trt informed=trt uninformed=ctr informed" "Uninformed control mean"  "Observations")) replace

*Table 6 yields & profit
		estout t_plotRiceYield5_1_uc_15f profit_2_uc_15f ///
			using "$results/T_impacts_info_yields_profit_15f.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treat_inf treat_no_inf control_inf) varlabels(treat_inf Treatmentxinformed treat_no_inf Treatmentxuninformed control_inf Controlxinformed) ///
			numbers(( )) stats(p_trt p_X2 m_ctr bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-val trt informed=trt uninformed" "p-val trt informed=trt uninformed=ctr informed" "Uninformed control mean" "Baseline outcome"  "Observations")) replace

*Table 7 inputs
		estout qty_allchem_kgha_uc_15 rp_chempest_spending_uc_15f rp_labor_spendingEX_uc_15f ///
			using "$results/T_impacts_info_inputs_15f.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) varlabels(treat_inf Treatment*informed treat_no_inf Treatment*uninformed control_inf Control*informed) ///
			keep(treat_inf treat_no_inf control_inf) ///
			numbers(( )) stats(p_trt p_X2 m_ctr bsl_outcome N, fmt(%9.3f %9.3f %9.1f %9.3f %9.0f) labels("p-val trt informed=trt uninformed" "p-val trt informed=trt uninformed=ctr informed" "Uninformed control mean" "Baseline outcome"  "Observations")) replace

*Table 10 finance
		estout askloaninp_bank_15 obtloanamt_bank_15 askloaninp_sara_15 obtloanamt_sara_15 ///
			using "$results/T_impacts_info_finance_15.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) varlabels(treat_inf Treatment*informed treat_no_inf Treatment*uninformed control_inf Control*informed) ///
			keep(treat_inf treat_no_inf control_inf) ///
			numbers(( )) stats(p_trt p_X2 m_ctr bsl_outcome N, fmt(%9.3f %9.3f %9.3f %9.3f %9.0f) labels("p-val trt informed=trt uninformed" "p-val trt informed=trt uninformed=ctr informed" "Uninformed control mean" "Baseline outcome"  "Observations")) replace



log close

e





