============= Read All the Informations =================
========================================================
# DESCRIPTION: Wrapper script for IITM_ESM diagnostics for Model1 (simplified, efficient version)
# Processes `tas`, `rsdt`, `rlut`, `rsut` from `input_dir1` and `sss`, `sst` from `input_dir2`.
# Last updated: January 2025 by Pritam DasMahapatra,CCCR,IITM.


=======================================
CLIMATE DATA PROCESSING - INSTALLATION
=======================================

This document provides instructions for installing the necessary Python packages required for climate data processing and visualization.

------------------------
REQUIRED DEPENDENCIES
------------------------
The script requires the following Python libraries:

- os (built-in)
- sys (built-in)
- xarray
- matplotlib
- numpy

------------------------
PREREQUISITES
------------------------
Ensure you have Python 3.8 or later installed.
To check your Python version, run:

    python --version

If Python is not installed, download and install it from:
https://www.python.org/downloads/

------------------------
INSTALLATION STEPS
------------------------

1. (OPTIONAL) CREATE A VIRTUAL ENVIRONMENT
   It is recommended to use a virtual environment to manage dependencies.

   Run the following command to create a virtual environment:

       python -m venv climate_env

   Activate the virtual environment:

   - Linux/macOS:
       source climate_env/bin/activate
   - Windows:
       climate_env\Scripts\activate

2. INSTALL REQUIRED PACKAGES
   Use pip to install the necessary packages:

       pip install xarray matplotlib numpy

   If you also need Jupyter Notebook for interactive work, install:

       pip install jupyter

3. VERIFY INSTALLATION
   Run the following script to ensure everything is installed correctly:

   ```python
   import os
   import sys
   import xarray as xr
   import matplotlib.pyplot as plt
   import numpy as np

   print("All packages installed successfully!")


========================================================
--------------------------------------------------------
========================================================

##########$$$$$$$$~~~~~~STEPS TO RUN~~~~~~~~$$$$$$$$====

1. Open user_inputs_timeseries.sh

2. Give path to CMIP7 ATM and OCN folder (Input1-> ATM, Input2->OCN); Give start and end year information (random years in file name); Define output_dir name as needed; Save it.

3. Load python env for run.[ conda activate /home/cccr/pritam/anaconda3/envs/wrapper] or use personal python env.

4. Load CDO module. [module load cdo/2.0.5]

5. Run "./IITM-ESM_wrapper_Timeseries.sh"

6. Select "y" or "n" to keep proceesd data.

6. Plot will be visible on succesfull executaion in given output folder.

7. Any problem reach at "pritam.mahapatra@tropmet.res.in" and extension "809"


===================~~~~NEW FIRST USER~~~~~~~~=====================
Don't forget to make all scripts executable after copy from source.
===================================================================
      
