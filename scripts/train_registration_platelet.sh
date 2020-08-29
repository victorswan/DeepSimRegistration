#!/bin/bash

# trains the models.

# Check if slurm compute cluster available. Submit as slurm job if possible.
if sbatch -h &> /dev/null; then
    echo "Submitting to slurm..."
    WRAPPER_FUNC=scripts/slurm/slurm_submit.sh
else
    echo "Running locally..."
    WRAPPER_FUNC=
fi

$WRAPPER_FUNC python3 -m src.train_registration --dataset platelet-em --savedir ./out/platelet-em/registration/l2/ --loss l2 --lam 0.02 --channels 64 128 256 --batch_size 3 --accumulate_grad_batches 2 --gpus -1 --lr 0.0001 --bnorm --dropout --distributed_backend ddp --max_epochs=3000
$WRAPPER_FUNC python3 -m src.train_registration --dataset platelet-em --savedir ./out/platelet-em/registration/ncc/ --loss ncc --ncc_win_size 9 --lam 0.5 --channels 64 128 256 --batch_size 3 --accumulate_grad_batches 2 --gpus -1 --lr 0.0001 --bnorm --dropout --distributed_backend ddp --max_epochs=3000
$WRAPPER_FUNC python3 -m src.train_registration --dataset platelet-em --savedir ./out/platelet-em/registration/ncc+supervised/ --loss ncc+supervised --ncc_win_size 9 --lam 0.5 --channels 64 128 256 --batch_size 3 --accumulate_grad_batches 2 --gpus -1 --lr 0.0001 --bnorm --dropout --distributed_backend ddp --max_epochs=3000
$WRAPPER_FUNC python3 -m src.train_registration --dataset platelet-em --savedir ./out/platelet-em/registration/deepsim/ --loss deepsim --deepsim_weights ./weights/platelet-em/segmentation/weights.ckpt --lam 1 --accumulate_grad_batches 2 --channels 64 128 256 --batch_size 3 --gpus -1 --lr 0.0001 --bnorm --dropout --distributed_backend ddp --max_epochs=3000
$WRAPPER_FUNC python3 -m src.train_registration --dataset platelet-em --savedir ./out/platelet-em/registration/deepsim_transfer/ --loss deepsim-transfer --deepsim_weights ./weights/phc-u373/segmentation/weights.ckpt --lam 0.5 --accumulate_grad_batches 2 --channels 64 128 256 --batch_size 3 --gpus -1 --lr 0.0001 --bnorm --dropout --distributed_backend ddp --max_epochs=3000
$WRAPPER_FUNC python3 -m src.train_registration --dataset platelet-em --savedir ./out/platelet-em/registration/vgg/ --loss vgg --lam 1 --accumulate_grad_batches 2 --channels 64 128 256 --batch_size 3 --gpus -1 --lr 0.0001 --bnorm --dropout --distributed_backend ddp --max_epochs=3000