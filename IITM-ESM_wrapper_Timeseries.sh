#!/bin/bash
# DESCRIPTION: Wrapper script for IITM_ESM diagnostics for Model1 (simplified, efficient version)
# Processes `tas`, `rsdt`, `rlut`, `rsut` from `input_dir1` and `sss`, `sst` from `input_dir2`.
# Last updated: January 2025
#This is to push check in VSCode
#checking reverse


# Check if user_inputs_timeseries.sh exists
if [[ ! -f "user_inputs_timeseries.sh" ]]; then
    echo "Error: 'user_inputs_timeseries.sh' file not found."
    exit 1
fi

# Source user inputs
source ./user_inputs_timeseries.sh

# Check if output directory variable is set
if [[ -z "$output_dir" ]]; then
    echo "Error: Output directory variable 'output_dir' not set in user_inputs_timeseries.sh"
    exit 1
fi

# Initialize output directory
mkdir -p "$output_dir"

# Error handling function
function check_error {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed."
        exit 1
    fi
}

# Cleanup function for temporary files
function cleanup {
    echo "Cleaning up temporary files..."
    rm -f temp_var_*.nc merged_*.nc annual_mean_*.nc 2>/dev/null || true
}
trap cleanup EXIT

# Variables to process
variables=("tas" "rsdt" "rlut" "rsut" "sss" "sst")
declare -A input_dirs=(
    ["tas"]="$input_dir1"
    ["rsdt"]="$input_dir1"
    ["rlut"]="$input_dir1"
    ["rsut"]="$input_dir1"
    ["sss"]="$input_dir2"
    ["sst"]="$input_dir2"
)

# Process each variable
for var in "${variables[@]}"; do
    input_dir=${input_dirs[$var]}
    echo "Processing variable: $var from directory: $input_dir"

    # Output time-series file for the variable
    annual_timeseries_file="${output_dir}/${output_prefix_model1}_timeseries_${var}.nc"

    # Skip processing if the time-series file already exists
    if [[ -f "$annual_timeseries_file" ]]; then
        echo "Time-series file for $var already exists. Skipping processing."
        continue
    fi

    # Initialize arrays for annual mean and yearly merged files
    annual_mean_files=()
    yearly_merged_files=()

    # Process data year by year
    for year in $(seq "$start_year_model1" "$end_year_model1"); do
        monthly_temp_files=()

        # Process monthly files for the year
        for month in $(seq -w 01 12); do
            monthly_file=$(ls "$input_dir"/*"${year}_${month}"*.nc 2>/dev/null | head -n 1)
            if [ -z "$monthly_file" ]; then
                echo "No file found for $year-$month. Skipping."
                continue
            fi

            # Check if the variable exists in the file
            if ! ncdump -h "$monthly_file" | grep -q " $var("; then
                echo "Variable $var not found in $monthly_file. Skipping."
                continue
            fi

            temp_var_file="temp_${output_prefix_model1}_${var}_${year}_${month}.nc"
            cdo selvar,"$var" "$monthly_file" "$temp_var_file"
            check_error "Selecting variable $var for $year-$month"
            monthly_temp_files+=("$temp_var_file")
        done

        # Merge monthly files for the year
        if [ ${#monthly_temp_files[@]} -gt 0 ]; then
            yearly_merged_file="merged_${output_prefix_model1}_${var}_${year}.nc"
            cdo mergetime "${monthly_temp_files[@]}" "$yearly_merged_file"
            check_error "Merging monthly files for $var for year $year"
            yearly_merged_files+=("$yearly_merged_file")

            annual_mean_file="annual_mean_${output_prefix_model1}_${var}_${year}.nc"
            cdo timmean "$yearly_merged_file" "$annual_mean_file"
            check_error "Calculating annual mean for $var for year $year"
            annual_mean_files+=("$annual_mean_file")

            # Remove temporary monthly files after processing
            rm -f "${monthly_temp_files[@]}"
        fi
    done

    # Merge annual mean files into a time-series
    if [ ${#annual_mean_files[@]} -gt 0 ]; then
        cdo mergetime "${annual_mean_files[@]}" "$annual_timeseries_file"
        check_error "Merging annual means into time-series for $var failed"
        echo "Time-series file created for $var: $annual_timeseries_file"
        rm -f "${annual_mean_files[@]}"
    else
        echo "Warning: No annual mean files created for $var."
    fi
done

echo "Processing completed. Time-series files saved in $output_dir."

######################################### CALCULATE FLDMEAN ##########################################
echo "Starting fldmean calculation for all variables..."

fldmean_files=()

################################### PROCESSING FOR SST & SSS (With Remapping) ###################################
for var in "sst" "sss"; do
    input_file="${output_dir}/${output_prefix_model1}_timeseries_${var}.nc"
    remapped_file="${output_dir}/${output_prefix_model1}_remapped_${var}.nc"
    fldmean_file="${output_dir}/${output_prefix_model1}_fldmean_${var}.nc"

    # Skip if fldmean file already exists
    if [[ -f "$fldmean_file" ]]; then
        echo "Field mean file for $var already exists. Skipping..."
        fldmean_files+=("$fldmean_file")
        continue
    fi

    # Check if the input time-series file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Error: Time-series file for $var not found: $input_file. Skipping..."
        continue
    fi

    echo "Remapping $var to r360x180..."
    cdo remapbil,r360x180 "$input_file" "$remapped_file"
    check_error "Remapping $var failed"

    echo "Calculating fldmean for $var..."
    cdo fldmean "$remapped_file" "$fldmean_file"
    check_error "Calculating fldmean for $var failed"

    fldmean_files+=("$fldmean_file")
    echo "Field mean file created for $var: $fldmean_file"
done

################################### PROCESSING FOR OTHER VARIABLES ###################################
for var in "${variables[@]}"; do
    # Skip sst and sss (already processed)
    if [[ "$var" == "sst" || "$var" == "sss" ]]; then
        continue
    fi

    input_file="${output_dir}/${output_prefix_model1}_timeseries_${var}.nc"
    fldmean_file="${output_dir}/${output_prefix_model1}_fldmean_${var}.nc"

    # Skip if fldmean file already exists
    if [[ -f "$fldmean_file" ]]; then
        echo "Field mean file for $var already exists. Skipping..."
        fldmean_files+=("$fldmean_file")
        continue
    fi

    # Check if the input time-series file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Error: Time-series file for $var not found: $input_file. Skipping..."
        continue
    fi

    echo "Calculating fldmean for $var..."
    cdo fldmean "$input_file" "$fldmean_file"
    check_error "Calculating fldmean for $var failed"

    fldmean_files+=("$fldmean_file")
    echo "Field mean file created for $var: $fldmean_file"
done

echo "Field mean calculation completed. Outputs saved in $output_dir."

################################# PLOTTING ##########################################

# Check if the Python script exists
if [ ! -f "plot_timeseries_CMIP7_testrun.py" ]; then
    echo "Error: Python plotting script 'plot_timeseries_CMIP7_testrun.py' not found. Exiting."
    exit 1
fi

# Call the Python script with the prepared files and output directory
python plot_timeseries_CMIP7_testrun.py \
    "${output_dir}/${output_prefix_model1}_fldmean_tas.nc" \
    "${output_dir}/${output_prefix_model1}_fldmean_rsdt.nc" \
    "${output_dir}/${output_prefix_model1}_fldmean_rlut.nc" \
    "${output_dir}/${output_prefix_model1}_fldmean_rsut.nc" \
    "${output_dir}/${output_prefix_model1}_fldmean_sss.nc" \
    "${output_dir}/${output_prefix_model1}_fldmean_sst.nc" \
    "$output_dir"  # Passing the output directory to the Python script

check_error "Timeseries plotting failed."

echo "Timeseries plots generated successfully and saved in $output_dir."

######################################### FINAL OUTPUT MANAGEMENT ##########################################

echo "Processing and plotting completed successfully. Outputs are saved in $output_dir."
######################################### CLEANUP ##########################################

echo "Do you want to delete all processed files? (y/n)"
read -r user_input

if [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
    echo "Deleting all processed files..."

    # Remove intermediate and final processed NetCDF files
    rm -f "$output_dir"/"${output_prefix_model1}"_timeseries_*.nc
    rm -f "$output_dir"/"${output_prefix_model1}"_fldmean_*.nc
    rm -f temp_var_*.nc merged_*.nc annual_mean_*.nc 2>/dev/null || true

    echo "All processed files deleted from $output_dir."
else
    echo "Cleanup skipped. Processed files are retained in $output_dir."
fi

echo "Script execution completed."


