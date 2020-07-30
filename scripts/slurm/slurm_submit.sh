#!/bin/bash -l

# usage:
# submit a slurm-job via
# $ slurm_submit.sh <script to run> <arg1> <arg2> ...

# parse some parameters of the submitted script to set slurm commands appropriately
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --dataset)
    DATASET="$2"
    POSITIONAL+=("$1")
    shift # past argument
    POSITIONAL+=("$1")
    shift # past value
    ;;
    --loss)
    LOSS="$2"
    POSITIONAL+=("$1")
    shift # past argument
    POSITIONAL+=("$1")
    shift # past value
    ;;
    --lam)
    LAM="$2"
    POSITIONAL+=("$1")
    shift # past argument
    POSITIONAL+=("$1")
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore parameters

# build parameters for slurm
TASK=$3
if [[ $TASK == "src.train_segmentation" ]]; then 
    JOBNAME="seg-"$DATASET
else
    JOBNAME=$LOSS-$LAM
fi
case $DATASET in
    brain-mri)
    TIME=5-00:00:00
    GRES=gpu:titanrtx:1
    ;;
    platelet-em)
    TIME=1-00:00:00
    GRES=gpu:titanx:1
    ;;
    phc-u373)
    TIME=1-00:00:00
    GRES=gpu:titanx:1
    ;;
esac

echo "Setting job max time to "$TIME
echo "Scheduling Job " --job-name=$JOBNAME --time=$TIME --gres=$GRES ./scripts/slurm/slurm_script.sh $@

# comment given to sbatch here will overwrite defaults set in the slurm script
sbatch --job-name=$JOBNAME --time=$TIME --gres=$GRES ./scripts/slurm/slurm_script.sh $@