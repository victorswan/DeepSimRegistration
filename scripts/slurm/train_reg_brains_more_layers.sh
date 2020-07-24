#!/bin/bash -l

# usage:
# submit a slurm-job via
# $ sbatch ./scripts/slurm_header.sh <your script to run>

# set job name
#SBATCH --job-name='reg platelet'

# normal cpu stuff: allocate cpus, memory
#SBATCH --ntasks=1 --cpus-per-task=1 --mem=30000M

# we run on the gpu partition and we allocate some titanx gpu
#SBATCH -p gpu --gres=gpu:titanrtx:1

#Runtime
#Note that a program will be killed once it exceeds this time!
#SBATCH --time=0-18:00:00

# debugging flags (optional)
export NCCL_DEBUG=INFO
export PYTHONFAULTHANDLER=1

hostname
echo CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES
srun python3 -m src.train_registration --dataset brain-mri --loss $1 --ncc_win_size 9 --deepsim_weights ./weights/platelet-em/segmentation/weights.ckpt --lam $2 --channels 32 64 128 --batch_size 1 --gpus -1 --lr 0.0001 --bnorm --dropout --accumulate_grad_batches 4 --max_epochs=150000
