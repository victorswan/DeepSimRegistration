python3 -m src.train_registrationG2 --net voxelmorph --dataset phc-u373 --savedir ./out/phc-u373/registration/deepsim-zero/ --loss deepsim-zero --deepsim_weights ./weights/phc-u373/segmentation/weights.ckpt --lam 0.125 --channels 64 128 256 --batch_size 5 --gpus -1 --lr 0.0001 --bnorm --dropout --accumulate_grad_batches 2 --distributed_backend ddp --max_epochs=3000
python3 -m src.train_registrationG2 --net voxelmorph --dataset phc-u373 --savedir ./out/phc-u373/registration/deepsim-ae-zero/ --loss deepsim-ae-zero --deepsim_weights ./weights/phc-u373/autoencoder/weights.ckpt --lam 0.125 --channels 64 128 256 --batch_size 5 --gpus -1 --lr 0.0001 --bnorm --dropout --accumulate_grad_batches 2 --distributed_backend ddp --max_epochs=3000