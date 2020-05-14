#!/bin/bash

source settings.sh

# Submit the parallel analysis
unset JOB_IDS
for ANALYSIS in ${ANALYSES}
do
    JOB_IDS="${JOB_IDS}:$(sbatch --parsable --ntasks=${NUMBER_OF_SEEDS} <(sed "s/ANALYSIS/$ANALYSIS/" simulation.sh))"
done

# Submit the post-processing
sbatch --dependency=afterok${JOB_IDS} postprocess.sh
