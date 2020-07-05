# Tune phc-u373
# sbatch ./scripts/slurm/train_reg_phc.sh ncc 0.25 --job-name='ph ncc 0.25' 
# sbatch ./scripts/slurm/train_reg_phc.sh ncc 0.5 --job-name='ph ncc 0.5' 
# sbatch ./scripts/slurm/train_reg_phc.sh ncc 1.0 --job-name='ph ncc 1.0' 
# sbatch ./scripts/slurm/train_reg_phc.sh ncc 2.0 --job-name='ph ncc 2.0' 
# sbatch ./scripts/slurm/train_reg_phc.sh ncc+supervised 0.25 --job-name='ph n+ 0.25' 
# sbatch ./scripts/slurm/train_reg_phc.sh ncc+supervised 0.5 --job-name='ph n+ 0.5' 
# sbatch ./scripts/slurm/train_reg_phc.sh ncc+supervised 1.0 --job-name='ph n+ 1.0' 
# sbatch ./scripts/slurm/train_reg_phc.sh ncc+supervised 2.0 --job-name='ph n+ 2.0' 
# sbatch ./scripts/slurm/train_reg_phc.sh deepsim 0.0625 --job-name='ph d 0.0625' 
# sbatch ./scripts/slurm/train_reg_phc.sh deepsim 0.125 --job-name='ph d 0.125' 
# sbatch ./scripts/slurm/train_reg_phc.sh deepsim 0.25 --job-name='ph d 0.25' 
# sbatch ./scripts/slurm/train_reg_phc.sh deepsim 0.5 --job-name='ph d 0.5' 
# sbatch ./scripts/slurm/train_reg_phc.sh deepsim 1.0 --job-name='ph d 1.0' 

# Tune platelet-em
# sbatch ./scripts/slurm/train_reg_platelet.sh ncc 0.5 --job-name='pl ncc 0.5' 
# sbatch ./scripts/slurm/train_reg_platelet.sh ncc 1.0 --job-name='pl ncc 1.0' 
# sbatch ./scripts/slurm/train_reg_platelet.sh ncc 2.0 --job-name='pl ncc 2.0' 
# sbatch ./scripts/slurm/train_reg_platelet.sh ncc+supervised 0.5 --job-name='pl n+ 0.5' 
# sbatch ./scripts/slurm/train_reg_platelet.sh ncc+supervised 1.0 --job-name='pl n+ 1.0' 
# sbatch ./scripts/slurm/train_reg_platelet.sh ncc+supervised 2.0 --job-name='pl n+ 2.0' 
# sbatch ./scripts/slurm/train_reg_platelet.sh deepsim 0.125 --job-name='pl d 0.125' 
# sbatch ./scripts/slurm/train_reg_platelet.sh deepsim 0.25 --job-name='pl d 0.25' 
# sbatch ./scripts/slurm/train_reg_platelet.sh deepsim 0.5 --job-name='pl d 0.5' 
# sbatch ./scripts/slurm/train_reg_platelet.sh deepsim 1.0 --job-name='pl d 1.0' 

# Tune transfer-learning
sbatch ./scripts/slurm/train_reg_phc_transfer.sh deepsim 0.125 --job-name='ph d 0.125' 
sbatch ./scripts/slurm/train_reg_phc_transfer.sh deepsim 0.25 --job-name='ph d 0.25' 
sbatch ./scripts/slurm/train_reg_phc_transfer.sh deepsim 0.5 --job-name='ph d 0.5' 
sbatch ./scripts/slurm/train_reg_platelet_transfer.sh deepsim 0.5 --job-name='pl d 0.5' 
sbatch ./scripts/slurm/train_reg_platelet_transfer.sh deepsim 1.0 --job-name='pl d 1.0' 
sbatch ./scripts/slurm/train_reg_platelet_transfer.sh deepsim 2.0 --job-name='pl d 2.0' 
sbatch ./scripts/slurm/train_reg_phc_vgg.sh deepsim 0.125 --job-name='ph d 0.125' 
sbatch ./scripts/slurm/train_reg_phc_vgg.sh deepsim 0.25 --job-name='ph d 0.25' 
sbatch ./scripts/slurm/train_reg_phc_vgg.sh deepsim 0.5 --job-name='ph d 0.5' 
sbatch ./scripts/slurm/train_reg_platelet_vgg.sh deepsim 0.5 --job-name='pl d 0.5' 
sbatch ./scripts/slurm/train_reg_platelet_vgg.sh deepsim 1.0 --job-name='pl d 1.0' 
sbatch ./scripts/slurm/train_reg_platelet_vgg.sh deepsim 2.0 --job-name='pl d 2.0' 