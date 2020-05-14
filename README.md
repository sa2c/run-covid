# run-covid

A utility to run the `covid-uk` workflow on Slurm clusters (specifically the
Supercomputing Wales SUNBIRD machine in Swansea).

## Installation

1. Clone this repository to a convenient location on SUNBIRD.

    git clone https://github.com/sa2c/run-covid

2. Tell git to pull down the corresponding version of the covid-uk software.

    cd run-covid
    git submodule update


## Usage

1. Adjust the file `settings.sh` to specify the Slurm account (on Supercomputing
   Wales, this is the project identifier, `scwXXXX`, where `XXXX` is a four-digit
   number), and the number of samples you want to consider for each analysis.
   You most likely do not want to change the value of `ANALYSES`, as it should match
   what the `covid-uk` software expects.
2. Run the shell script `submit_full_analysis.sh`

    bash submit_full_analysis.sh

You will see *N* + 1 jobs in the queue, where *N* is the number of `ANALYSES`.
All but the last of these will either be running or ready to run, while the final one
is pending on a dependency.


## How it works

`submit_full_analysis.sh` does two things:

* Submits one Slurm job defined by `simulation.sh` for each of the `ANALYSES`, keeping 
  track of the job IDs.
* Submits one Slurm job defined by `postprocess.sh` to do the post-processing. This
  is submitted with a Slurm dependency, so that it won't start until all of the analysis
  jobs are completed successfully.

`simulation.sh` allocates as many cores for this as there are samples to consider;
each should take an approximately similar amount of time to run, and they are run in
parallel with GNU Parallel.

`postprocess.sh` combines the parallel outputs into one file per analysis using
`parallel-recombination.R`, and then plots and tabulates the results with `UK-view.R`
