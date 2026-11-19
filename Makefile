Report.html: Report.Rmd output/table_one.rds output/phi_matrix.rds output/muac.png output/table_two.rds
	Rscript -e "rmarkdown::render('Report.Rmd')"

data/f75_interim_clean.rds: code/00_clean_data.R data/f75_interim_raw.csv
	Rscript code/00_clean_data.R
	
output/table_one.rds: code/01_table_one.R data/f75_interim_clean.rds
	Rscript code/01_table_one.R
	
output/phi_matrix.rds: code/02_correlation_map.R data/f75_interim_clean.rds
	Rscript code/02_correlation_map.R

output/muac.png: code/03_MUAC_figure.R data/f75_interim_clean.rds
	Rscript code/03_MUAC_figure.R
	
output/table_two.rds: code/04_table_two.R data/f75_interim_clean.rds
	Rscript code/04_table_two.R
	
.PHONY: clean
clean:
	rm -f output/*.rds output/*.png data/f75_interim_clean.rds Report.html