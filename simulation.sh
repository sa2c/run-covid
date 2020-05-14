#!/bin/bash --login

#SBATCH -p compute
#SBATCH --job-name=covid_ANALYSIS
#SBATCH --output=output/covid_ANALYSIS.out
#SBATCH --error=output/covid_ANALYSIS.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-2:00

module purge

module load compiler/gnu/8/1.0
module load gsl/2.6
module load R/3.6.2
module load parallel

export OMP_NUM_THREADS=1

source settings.sh

parallel --max-procs ${SLURM_NTASKS} --joblog output/parallel_joblog_ANALYSIS \
    srun --nodes=1 --ntasks=1 \
    "bash ./covid-uk/run_single_covid.sh {1} {2} ${NUMBER_OF_SEEDS} > covid_{1}_{2}.out 2> covid_{1}_{2}.err" ::: $(seq 1 ${NUMBER_OF_SEEDS}) ::: ANALYSIS
