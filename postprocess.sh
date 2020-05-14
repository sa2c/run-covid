#!/bin/bash --login

#SBATCH -p compute
#SBATCH --exclusive
#SBATCH --job-name=covid_post
#SBATCH --output=output/covid_post.out
#SBATCH --error=output/covid_post.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40
#SBATCH --time=0-0:30

module purge

module load compiler/gnu/8/1.0
module load gsl/2.6
module load R/3.6.2
module load parallel

source settings.sh

parallel Rscript ../covid-uk/parallel-recombination.R {1} ${NUMBER_OF_SEEDS} ::: ${ANALYSES}

Rscript ../covid-uk/UK-view.R
