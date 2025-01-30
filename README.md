===========================================
IITM_ESM_WRAPPER_Timeseries
Time Series Plot for CMIP7 Climate Data
===========================================

This script processes CMIP7 climate model data and generates timeseries plots 
for selected variables. Follow the steps below for proper execution.

------------------------------------------------------
INSTALLATION & SETUP
------------------------------------------------------

1️⃣ Clone the Repository:
    git clone <repository-url>
    cd IITM_ESM_WRAPPER_Timeseries

2️⃣ Set Execution Permissions:
    chmod +x IITM-ESM_wrapper_Timeseries.sh

------------------------------------------------------
CONFIGURATION STEPS
------------------------------------------------------

3️⃣ Open `user_inputs_timeseries.sh` and Set Inputs:

- Define Input Data Paths:
  - input_dir1 → Path to CMIP7 ATM data
  - input_dir2 → Path to CMIP7 OCN data

- Specify Time Range:
  - Set start and end years for processing

- Define Output Directory:
  - Update `output_dir` to save results

------------------------------------------------------
DEPENDENCIES (Python & CDO Setup)
------------------------------------------------------

4️⃣ Activate Python Environment (if needed):
    conda activate /home/cccr/pritam/anaconda3/envs/wrapper
   (Or use your own Python environment.)

5️⃣ Load CDO Module:
    module load cdo/2.0.5

------------------------------------------------------
RUNNING THE WRAPPER SCRIPT
------------------------------------------------------

6️⃣ Execute the Wrapper Script:
    ./IITM-ESM_wrapper_Timeseries.sh

7️⃣ Cleanup Prompt:
   After processing, you will be prompted:

   Do you want to delete all processed files? (y/n)

   - Enter 'y' → Deletes intermediate files
   - Enter 'n' → Keeps processed files

------------------------------------------------------
OUTPUT & VISUALIZATION
------------------------------------------------------

8️⃣ Generated Output Files:
- Plots saved in `output_dir` as .pdf files
- HTML Summary File: plots_overview.html
  (Open in a browser to view plots)

------------------------------------------------------
EXPECTED OUTPUT EXAMPLE
------------------------------------------------------

- Time-series plots for:
  - Surface Air Temperature (TAS)
  - TOA Net Radiation
  - Sea Surface Temperature (SST)
  - Sea Surface Salinity (SSS)

- Plots stored in `output_dir`
- Clickable HTML report for visualization

------------------------------------------------------
TROUBLESHOOTING
------------------------------------------------------

❗ If the script doesn’t run:
- Check execution permission:
    ls -l IITM-ESM_wrapper_Timeseries.sh
  If not executable, run:
    chmod +x IITM-ESM_wrapper_Timeseries.sh

❗ CDO command not found?
- Ensure CDO is loaded:
    module load cdo/2.0.5

❗ Python module missing?
- Install missing packages:
    pip install xarray matplotlib numpy

------------------------------------------------------
CONTACT & SUPPORT
------------------------------------------------------

For any issues, contact [Pritam] at [pritam.mahapatra@tropmet.res.in] 
or visit CCCR, IITM.

------------------------------------------------------

✅ Now your script is properly documented!
Save this file as README.txt and include it in your project.

