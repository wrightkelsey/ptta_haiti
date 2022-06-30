# ptta_haiti 

Reference: "Input Subsidies, credit constraints and expectations of future transfers: evidence from Haiti"


American Journal of Agricultural Economics 
Authors: Jérémie Gignoux, Karen Macours, Daniel Stein, Kelsey A. Wright 



1. Overview

This archive contains all Stata do files required to replicate estimations reported in tables 1-10, and Appendix tables A1-A24. Estimation results are output in tex. 





There are 6 do files and 1 dataset in .dta format. 

Questionnaires and manuals, and supporting document are in folder doc. 

Stata version 14 or later. Requires Stata commands available from SSC : distinct, estout, pdslasso, ritest. Last versions tested for replication are copied in /ado. 

			which pdslasso
			*! pdslasso 1.0.03 04sept2018
			*! pdslasso package 1.1 15jan2019
			*! authors aa/cbh/ms

			which distinct
			*! 1.2.1 NJC 1 March 2012         
			*! 1.2.0 NJC 15 September 2008

			. which ritest
			*! version 1.1.7 feb2020.


			which estout
			*! version 3.24  30apr2021  Ben Jann



2. Data availability and provenance statement

The data was collected during the experimental impact study described in the paper (Gignoux et al. 2022), section 2, through field surveys described, in section 4.2.

The replication data is here on Github, and starting in July 2022, through The World Bank MicroData Repository.

3. Statement about rights

I certify that the author(s) of the manuscript have legitimate access to and permission to use the data used in this manuscript.


4. Summary of Availability

Some household location data cannot be made publicly available - see below for details. 


5. Details on data source and dataset

'panel_dataset_for_replication.dta' is a Stata dataset containing constructed variables from 4 rounds of survey data as described in section 4.2 of the paper; datasets are de-identified.

Variables from baseline in 2013 end in *bsl 
Variables from the short survey collected with the information intervention with reference to November 2014, end in *nov14 
Variables from follow-up 1 with reference year 2014, end in *14 
Variables from follow-up 2 with reference year 2015, end in *15 
Variables starting in F* refer to the first rice season. 

Analysis variables are labelled.

	Data file				Source					Notes											Provided
 	****************************************************************************************************************************************************************************

	panel_dataset_for_replication.dta	Baseline and three follow-up surveys	Combines multiple data sources, constructed variables, serves as input for all programs	Yes

** "Distances from households.dta" are author's calculations based on GPS coordinates collected during survey data, and 
are not included in the data release due to personal identifying information (PII). This data is required in NE balance test - jan22.


6. Description and list of programs
	
The 6 provided programs reproduces all tables and figures in the paper (except Table 2 which provides a summary of the program implementation).

Program "NE_impact_analysis-baseline characteristics Jan22" computes descriptive statistics for observable characteristics of study sample
Program "NE balance test-jan22" conducts balancing tests reported in Table 1
Program "NE_impact_analysis-random inference jan22" estimates main treatment effects reported in Tables 3-5, 9, A2-A6, A13, and A15-A18 using the randomized inference method of Young (2018)
Program "NE_impact_analysis-information treatment jan22" estimates main and information treatment effects reported in Tables 6-7, and 10
Program "NE_impact_analysis-random inference interactions jan22" estimates main treatment effects with interactions with baseline characteristics reported in Tables A7-A12, A14	
Program "NE_impact_analysis-pdslasso jan22" reports main treatment effects with controls obtained using the ”post-double-selection” method of Belloni et al. (2014)

The list below indicates input data and ouput tables for the provided programs.

	Program / do file						Input data								Output table 
 	********************************************************************************************************************************************************************

	NE_impact_analysis  - baseline characteristics Jan22 		panel_dataset_for_replication.dta 					1	
	NE_impact_analysis - random inference jan22			panel_dataset_for_replication.dta					3-5,9, A2-A6,A13,A15-A18	
	NE_impact_analysis - information treatment jan22		panel_dataset_for_replication.dta					6-7,10	
	NE balance test - jan22						panel_dataset_for_replication.dta, distances from households.dta*	A1, 6 tables var sets
	NE_impact_analysis - random inference interactions jan22	panel_dataset_for_replication.dta					A7-A12, A14	
	NE_impact_analysis - pdslasso jan22				panel_dataset_for_replication.dta					A19-A24	


7. Instructions to replicators

In what follows, we explain the steps required to use the attached files:

1) 	Folders in the working directory are: do, data, results, doc, and log. 
2) 	Change the file paths at the beginning of each  do-file 
	- The do-files generate log-files that are saved in a folder "log"
	- The do-files generate tex files that are saved in a folder "results"
3) 	Make sure have distinct, estout, psdlasso, and ritest from SSC. The last versions checked for compatibility are in ado.  
4) 	Run one of the 6 do files 
5) 	Output from the log files references the table in the paper
	Output in the tex files should be viewed using Latex 


8. References

Belloni, A., Chernozhukov, V. & Hansen, C. (2014), ‘Inference on Treatment Effects after Selection among High-Dimensional ControlsˆaC’, Review of Economic Studies 81(2), 608–650.

Gignoux, J., Macours, K., Stein, D. and Wright, K. (2022), "Inputs subsidies, credit constraints and expectations of future transfers: evidence from Haïti", conditionnally accepted at the American Journal of Agricultural Economics

Young, A. (2018), ‘Channeling Fisher: Randomization Tests and the Statistical Insignificance of Seemingly Significant Experimental Results*’, The Quarterly Journal of Economics 134(2), 557–598.


9. Acknowledgements

This research project is based on a collaboration between MARNDR (the Ministère de l’Agriculture, des Ressources Naturelles et du Développement Rural in Haiti),  the Inter-American Development Bank (IADB), Development Impact Evaluation (DIME) - World Bank, and PSE.  We are grateful to Hermann Augustin, Jean Marie Robert Chéry and the staff at the MARNDR. Sébastien Gachot was instrumental in setting up the experiment and baseline data collection and we are grateful to him, Gilles Damais, Bruno Jacquet and IDB-Port-au-Prince team for their dedication to the project.  We are also grateful to Diana Lopez-Avila, Hamza Benhhadou and Paul Dutronc-Postel for field coordination and to Nitin Bharti, Michell Dong and Tom Wright for supporting the analysis. At DIME, we are indebted to Florence Kondylis for support throughout the project, and to Kristoffer Bjarkefur, Maria Ruth Jones and Cindy Sobieski for sharing their expertise in data collection. Herard Jean Pierre Osias and Marckendy Petit-Louis were superb survey leads. We thank the agronomy students of the Université d'État d'Haïti, Limonade Campus along with all surveyors. We are appreciative of inputs and comments at various parts of the study from Jean Dieugo Barthelus, Paul Christian, Bertrand Dayot, Estimable Frantz, Jery Rambao, Josias Toussaint and Collins Zamor, among others. The paper benefited from discussions with Tanguy Bernard, Andrew Foster, Markus Goldstein, Alain de Janvry, Jeremy Magruder, Paul Winters and participants at a DIME workshop, EUDN conference, FAO, LACEA conference, and seminars at PSE, and from comments by the editor and 3 anonymous referees. We thank the rice growing residents of Bas and Haut Maribahoux for graciously sharing their experiences with the researchers. We gratefully acknowledge support and funding from GAFSP, IADB, and the Agence Nationale de la Recherche under grant ANR-17-EURE-001.

