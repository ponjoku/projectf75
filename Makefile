output/table_one.rds: code/01_table_one.R data/f75_interim_clean.rds
	Rscript code/01_table_one.R

.PHONY:
clean:

output/muac.png: code/03_MUAC_figure.R data/f75_interim_clean.rds
	Rscript code/03_MUAC_figure.R