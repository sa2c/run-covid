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
#SBATCH --signal=B:USR1@120

source modules.sh
source settings.sh

# Create a build directory in the RAM disk so run is independent
export TMPDIR=$(mktemp --directory --tmpdir=/dev/shm)

# Don't leave a mess if terminated halfway through
term_handler() {
  echo "Time limit is up; tidying up run ${SEED_INDEX} ${ANALYSIS}..."
  rm -rf ${TMPDIR}
  exit -1
}
trap 'term_handler' TERM USR1

parallel Rscript ./covid-uk/parallel-recombination.R {1} ${NUMBER_OF_SEEDS} ::: ${ANALYSES}

Rscript ./covid-uk/UK-view.R
