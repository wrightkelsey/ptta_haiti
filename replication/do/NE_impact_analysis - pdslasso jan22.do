


*********************************************
*	RANDOMIZED INFERENCE IMPACT ANALYSIS OF INPUT SUBSIDIES IN HAITI, GIGNOUX, MACOURS, STEIN & WRIGHT AJAE 2022
*	”post-double-selection” method of Belloni et al. (2014)
*	author: Jeremie Gignoux, PSE-INRAE
* 	first version : sept 2021 
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


* controls for lasso

g HH_nonagroccup_bsl=inlist(HH_occupation_bsl,3,4,5,6,7,8,9,10) if HH_occupation_bsl!=.

g sevhunger= HungerScale_cat_bsl==3 if  HungerScale_cat_bsl!=.

recode n_riceplot_bsl .=0 

lab var HH_literacy_bsl "Head can read or write"
lab var HH_nonagroccup_bsl "Head has non-agricultural occupation"
lab var d_growrice_bsl "Grows rice"
lab var n_riceplot_bsl "Nb of plots cultivated with rice"
lab var t_plot_area_bsl "Area of plots with rice (cond.)"
lab var t_prod_value_uc_bsl "Rice production value"
lab var fert_spending_bsl "Total spending in fertilizer"
lab var askloan_bank_bsl "Asked for a bank loan in previous year"
lab var sevhunger "Severe hunger"
lab var months_insecure_bsl "Months food insecure"
g liveoth_income_bsl=other_income_bsl+livestock_income_bsl
g total2_income_bsl=income_bsl+ag_income_bsl+liveoth_income_bsl
lab var rp_urea_uc_bsl "Used urea on rice plot(s)"
lab var rp_npk_uc_bsl "Used NPK on rice plot(s)"
g rp_chfert_uc_bsl=rp_urea_uc_bsl==1& rp_npk_uc_bsl==1
lab var rp_chfert_uc_bsl "Used both npk and urea on rice"
g rp_chfert_pest_uc_bsl=rp_urea_uc_bsl==1& rp_npk_uc_bsl==1& rp_pesticide_uc_bsl==1
lab var rp_chfert_pest_uc_bsl "Used chemical fertilizer and pesticides on rice"
recode rp_pesticide_bsl .=0

foreach y in total_income_bsl income_bsl ag_income_bsl other_income_bsl livestock_income_bsl liveoth_income_bsl {
	winsor2 `y', replace cuts(0 98)
}

lab var total2_income_bsl "total hh income (annual)"
lab var ag_income_bsl "total agricultural income"
lab var income_bsl "non farm income"
lab var liveoth_income_bsl "income from livestock and sales of charcoal and wood"

recode HH_nonagroccup_bsl .=0
recode rp_irrigated_bsl .=0
recode t_plot_area_bsl .=0
recode askloan_bank_bsl .=0

local controls ///
	HH_literacy_bsl HH_nonagroccup_bsl access_water_bsl d_growrice_bsl  n_riceplot_bsl rp_irrigated_bsl t_plot_area_bsl askloan_bank_bsl ///
	total2_income_bsl ag_income_bsl liveoth_income_bsl income_bsl sevhunger months_insecure_bsl ///
	t_prod_value_uc_bsl rp_urea_uc_bsl rp_npk_uc_bsl rp_chfert_uc_bsl rp_pesticide_bsl rp_chfert_pest_uc_bsl seed_spending_bsl fert_spending_bsl pest_spending_bsl

su `controls'



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


*preserve 

keep harv_any_hh_* t_prod_value_uc_bsl t_prod_value5_uc* t_plotRiceYield5_1_uc* /*
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
	*/ treatment informed treat_inf treat_no_inf control_inf h_d_suplag*_bsl group2_bsl habitation_old_bsl /*
	*/ d_thinkben_* /*
	*/ plan_growrice_* plan_numpar_* plan_arearice_* plan_loan_* plan15_newplotrice_14 /*
	*/ F_harv_any_hh_* F_t_prod_value5_uc_* F_profit_2_uc_* F_t_plotRiceYield5_1_uc_* F_t_sale_value_uc_* F_rp_qty_allchem_uc_* F_rp_qty_urea_uc_* F_rp_qty_npk_uc_* F_rp_qty_sulfate_uc_* F_rp_allchem_spending_uc_* F_rp_pest_spending_uc_* F_rp_chempest_spending_uc_* F_rp_labor_spendingEX_uc_* /*
	*/ F_t_plotRiceYield5_1_c* F_profit_2_c_* /*
	*/ `controls'


lab var n_culPlot_14 "nb of plots cultivated"
lab var n_culPlot_15 "nb of plots cultivated"
lab var t_sizeculPlot_14 "area cultivated"
lab var t_sizeculPlot_15 "area cultivated"
lab var other_harvest_value_14 "harvest value"
lab var other_harvest_value_15 "harvest value"
lab var other_sale_value_14 "sales value"
lab var other_sale_value_15 "sales value"

lab var treatment "Treatment"


keep treatment treatment informed treat_inf treat_no_inf control_inf habitation_old_bsl h_d_suplag*_bsl group2_bsl `controls' /*
*/	*t_plotRiceYield5_1_uc* *profit_2_uc* *pr*recode t_plot_area_bsl .=0
ofit_vouch_2_uc* /*
*/	*qty_allchem_kgha_uc* *rp_chempest_spending_uc* *rp_labor_spendingEX_uc* /*
*/	*askloaninp_bank* *obtloanamt_bank* *askloaninp_sara* *obtloanamt_sara*


cap log close
log using "$log/pdslasso", replace


*set-up estim

local trt_info ///
	treat_inf treat_no_inf control_inf

local controls ///
	HH_literacy_bsl HH_nonagroccup_bsl access_water_bsl d_growrice_bsl  n_riceplot_bsl rp_irrigated_bsl t_plot_area_bsl askloan_bank_bsl ///
	total2_income_bsl ag_income_bsl liveoth_income_bsl income_bsl sevhunger months_insecure_bsl ///
	t_prod_value_uc_bsl rp_urea_uc_bsl rp_npk_uc_bsl rp_chfert_uc_bsl rp_pesticide_bsl rp_chfert_pest_uc_bsl seed_spending_bsl fert_spending_bsl pest_spending_bsl

local lagoon ///
	h_d_suplag1_bsl h_d_suplag2_bsl h_d_suplag3_bsl h_d_suplag4_bsl h_d_suplag5_bsl h_d_suplag6_bsl
	


	*Table A19
	
			/* yields */
		pdslasso t_plotRiceYield5_1_uc_14 treatment (t_plotRiceYield5_1_uc_bsl i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		displ "`e(xselected)'"
		su t_plotRiceYield5_1_uc_14 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "yes"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto yields_14, title(2014)

		pdslasso F_t_plotRiceYield5_1_uc_15 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		su t_plotRiceYield5_1_uc_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local nbcontr=e(xselected_ct)
		estadd local bsl_outcome "no"
		estadd local ind "yes"
		est sto yields_15, title(2015)

			/* profits */
		pdslasso profit_2_uc_14 treatment (profit_2_uc_bsl i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		su profit_2_uc_14 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "yes"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto profits_14, title(2014)

		pdslasso profit_2_uc_15 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		su profit_2_uc_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local nbcontr=e(xselected_ct)
		estadd local bsl_outcome "no"
		estadd local ind "yes"
		est sto profits_15, title(2015)

			/* profits net of vouchers */
		pdslasso profit_vouch_2_uc_14 treatment (profit_2_uc_bsl i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		su profit_vouch_2_uc_14 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "yes"
		estadd local ind "yes"
		estadd local nbcontr=e(xselected_ct)
		est sto netprofits_14, title(2014)

		estout yields_14 profits_14 netprofits_14 ///
				using "$results/TA_lasso_impacts_yields_profit_14.tex", cells("b(star fmt(3))" se(par)) ///
				mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
				keep(treatment) ///
				numbers(( )) stats(p_conv m_ctr bsl_outcome ind nbcontr, fmt(%9.3f %9.1f %9.0f %9.0f %9.0f) labels("p-value conv." "Control mean" "Baseline outcome" "Strata and lagoon FE" "Nb. controls selected" )) replace
				
		estout yields_15 profits_15 ///
				using "$results/TA_lasso_impacts_yields_profit_15.tex", cells("b(star fmt(3))" se(par)) ///
				mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
				keep(treatment) ///
				numbers(( )) stats( p_conv m_ctr bsl_outcome ind nbcontr  N, fmt(%9.3f %9.3f %9.0f %9.0f %9.0f) labels("p-value conv" "Control mean" "Baseline outcome" "Strata and lagoon FE" "Nb. additional controls selected" "Observations")) replace


	*Table A20

			/* qty fertilizer */
		pdslasso qty_allchem_kgha_uc_14 treatment (qty_allchem_kgha_uc_bsl i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		displ "`e(xselected)'"
		su qty_allchem_kgha_uc_14 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "yes"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto qtyfertilizer_14, title(2014)

		pdslasso qty_allchem_kgha_uc_15 treatment (qty_allchem_kgha_uc_bsl i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		displ "`e(xselected)'"
		su qty_allchem_kgha_uc_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "yes"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto qtyfertilizer_15, title(2015)

			/* spending fertilizer & pests */
		pdslasso rp_chempest_spending_uc_14 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		displ "`e(xselected)'"
		su rp_chempest_spending_uc_14 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "yes"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "no"
		est sto pestspending_14, title(2014)

		pdslasso rp_chempest_spending_uc_15 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		displ "`e(xselected)'"
		su rp_chempest_spending_uc_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "yes"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "no"
		est sto pestspending_15, title(2015)
		
			/* spending in labor */
		pdslasso rp_labor_spendingEX_uc_14 treatment (rp_labor_spendingEX_uc_bsl i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		displ "`e(xselected)'"
		su rp_labor_spendingEX_uc_14 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "yes"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto laborspending_14, title(2014)

		pdslasso rp_labor_spendingEX_uc_15 treatment (rp_labor_spendingEX_uc_bsl i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		displ "`e(xselected)'"
		su rp_labor_spendingEX_uc_14 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "yes"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto laborspending_15, title(2015)

		estout qtyfertilizer_14 pestspending_14 laborspending_14 ///
				using "$results/TA_lasso_impacts_inputs_14.tex", cells("b(star fmt(3))" se(par)) ///
				mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
				keep(treatment) ///
				numbers(( )) stats(p_conv m_ctr bsl_outcome ind nbcontr, fmt(%9.3f %9.1f %9.0f %9.0f %9.0f) labels("p-value conv." "Control mean" "Baseline outcome" "Strata and lagoon FE" "Nb. controls selected" )) replace
				
		estout qtyfertilizer_15 pestspending_15 laborspending_15 ///
				using "$results/TA_lasso_impacts_inputs_15.tex", cells("b(star fmt(3))" se(par)) ///
				mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
				keep(treatment) ///
				numbers(( )) stats( p_conv m_ctr bsl_outcome ind nbcontr  N, fmt(%9.3f %9.3f %9.0f %9.0f %9.0f) labels("p-value conv" "Control mean" "Baseline outcome" "Strata and lagoon FE" "Nb. additional controls selected" "Observations")) replace


	*Table A21

			/* yields */
		pdslasso F_t_plotRiceYield5_1_uc_15 treat_inf treat_no_inf control_inf (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		displ "`e(xselected)'"
		su F_t_plotRiceYield5_1_uc_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treat_inf=treat_no_inf 
		estadd scalar p_trt = r(p)
		estadd local bsl_outcome "no"
		estadd local ind "yes"
		estadd local nbcontr=e(xselected_ct)
		est sto yieldsinfo_15, title(2015)

			/* profits */
		pdslasso F_profit_2_uc_15 treat_inf treat_no_inf control_inf (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		displ "`e(xselected)'"
		su F_profit_2_uc_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treat_inf=treat_no_inf 
		estadd scalar p_trt = r(p)
		estadd local bsl_outcome "no"
		estadd local ind "yes"
		estadd local nbcontr=e(xselected_ct)
		est sto profitsinfo_15, title(2015)


		estout yieldsinfo_15 profitsinfo_15 ///
				using "$results/TA_lasso_impacts_info_yields_profit_15f.tex", cells("b(star fmt(3))" se(par)) ///
				mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) varlabels(treat_inf Treatmentxinformed treat_no_inf Treatmentxuninformed control_inf Controlxinformed) ///
				keep(treat_inf treat_no_inf control_inf) ///
				numbers(( )) stats(p_trt m_ctr bsl_outcome ind nbcontr N, fmt(%9.3f %9.3f %9.0f %9.0f %9.0f %9.0f) labels("p-val trt informed=trt uninformed" "Uninformed control mean" "Baseline outcome" "Strata and lagoon FE" "Nb. additional controls selected"  "Observations")) replace


	*Table A22

			/* qty fertilizer */
		pdslasso qty_allchem_kgha_uc_15 treat_inf treat_no_inf control_inf (qty_allchem_kgha_uc_bsl i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		displ "`e(xselected)'"
		su qty_allchem_kgha_uc_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treat_inf=treat_no_inf 
		estadd scalar p_trt = r(p)
		estadd local bsl_outcome "yes"
		estadd local ind "yes"
		estadd local nbcontr=e(xselected_ct)
		est sto qtyfertilizer_15, title(2015)

			/* spending fertilizer & pests */
		pdslasso rp_chempest_spending_uc_15 treat_inf treat_no_inf control_inf (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		displ "`e(xselected)'"
		su rp_chempest_spending_uc_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treat_inf=treat_no_inf 
		estadd scalar p_trt = r(p)
		estadd local bsl_outcome "no"
		estadd local ind "yes"
		estadd local nbcontr=e(xselected_ct)
		est sto spendfertilizer_15, title(2015)

			/* spending in labor */
		pdslasso rp_labor_spendingEX_uc_15 treat_inf treat_no_inf control_inf (rp_labor_spendingEX_uc_bsl i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		displ "`e(xselected)'"
		su rp_labor_spendingEX_uc_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treat_inf=treat_no_inf 
		estadd scalar p_trt = r(p)
		estadd local bsl_outcome "yes"
		estadd local ind "yes"
		estadd local nbcontr=e(xselected_ct)
		est sto spendlabor_15, title(2015)

		estout qtyfertilizer_15 spendfertilizer_15 spendlabor_15 ///
				using "$results/TA_lasso_impacts_info_inputs_15f.tex", cells("b(star fmt(3))" se(par)) ///
				mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) varlabels(treat_inf Treatmentxinformed treat_no_inf Treatmentxuninformed control_inf Controlxinformed) ///
				keep(treat_inf treat_no_inf control_inf) ///
				numbers(( )) stats(p_trt m_ctr bsl_outcome ind nbcontr N, fmt(%9.3f %9.3f %9.0f %9.0f %9.0f %9.0f) labels("p-val trt informed=trt uninformed" "Uninformed control mean" "Baseline outcome" "Strata and lagoon FE" "Nb. additional controls selected"  "Observations")) replace


	*Table A23

			/* request input loan from bank */
		pdslasso askloaninp_bank_14 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		displ "`e(xselected)'"
		su askloaninp_bank_14 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "no"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto askloanbank_14, title(2014)

		pdslasso askloaninp_bank_15 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		displ "`e(xselected)'"
		su askloaninp_bank_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "no"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto askloanbank_15, title(2015)

			/* amount bank loan */
		pdslasso obtloanamt_bank_14 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		displ "`e(xselected)'"
		su obtloanamt_bank_14 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "no"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto amtloanbank_14, title(2014)

		pdslasso obtloanamt_bank_15 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		displ "`e(xselected)'"
		su obtloanamt_bank_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "no"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto amtloanbank_15, title(2015)
		
			/* request input loan from merchant */
		pdslasso askloaninp_sara_14 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		displ "`e(xselected)'"
		su askloaninp_sara_14 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "no"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto askloansara_14, title(2014)

		pdslasso askloaninp_sara_15 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon')
		displ "`e(xselected)'"
		su askloaninp_sara_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "no"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto askloansara_15, title(2015)

			/* amount merchant loan */
		pdslasso obtloanamt_sara_14 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		displ "`e(xselected)'"
		su obtloanamt_sara_14 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "no"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto amtloansara_14, title(2014)

		pdslasso obtloanamt_sara_15 treatment (i.group2_bsl `lagoon' `controls'), cluster(habitation_old_bsl) partial(i.group2_bsl `lagoon') 
		displ "`e(xselected)'"
		su obtloanamt_sara_15 if treatment==0
		estadd scalar m_ctr=r(mean)
		test treatment
		estadd scalar p_conv = r(p)
		estadd local bsl_outcome "no"
		estadd local nbcontr=e(xselected_ct)
		estadd local ind "yes"
		est sto amtloansara_15, title(2015)

		estout askloanbank_14 amtloanbank_14 askloansara_14 amtloansara_14 ///
				using "$results/TA_lasso_impacts_finance_14.tex", cells("b(star fmt(3))" se(par)) ///
				mgroups(none) mlabels(none) collabels(none) eqlabels(none) style(tex) ///
				keep(treatment) ///
				numbers(( )) stats(p_conv m_ctr bsl_outcome ind nbcontr, fmt(%9.3f %9.1f %9.0f %9.0f %9.0f) labels("p-value conv." "Control mean" "Baseline outcome" "Strata and lagoon FE" "Nb. controls selected" )) replace
				
		estout askloanbank_15 amtloanbank_15 askloansara_15 amtloansara_15 ///
				using "$results/TA_lasso_impacts_finance_15.tex", cells("b(star fmt(3))" se(par)) ///
				mgroups(none) l mlabels(none) collabels(none) eqlabels(none) style(tex) ///
				keep(treatment) ///
				numbers(( )) stats( p_conv m_ctr bsl_outcome ind nbcontr  N, fmt(%9.3f %9.3f %9.0f %9.0f %9.0f) labels("p-value conv" "Control mean" "Baseline outcome" "Strata and lagoon FE" "Nb. additional controls selected" "Observations")) replace


log close


