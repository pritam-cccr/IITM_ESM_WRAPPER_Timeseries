#!/bin/bash
# ==============================================================================
# Copyright (C) 2025 Centre for Climate Change Research (CCCR), IITM
#
# This script is part of the CCCR IITM_ESM diagnostics system.
#
# Author: [Pritam Das Mahapatra]
# Date: January 2025
# ==============================================================================

# Diagnostic type (optional, for logging purposes)
diagnostic_type="Time-Series Analysis"

# List of variables to process (comma-separated)
# Variables with "plev" in their names are treated as pressure-level variables.
variables="tas,rsdt,rlut,rsut,sss,sst"

# Input directories for variable search
input_dir1="path to directory"  # ATM
input_dir2="path to directory"  # OCN

# Model1-specific time range
start_year_model1=start_year                   # Start year for Model1
end_year_model1=end_year                      # End year for Model1

# Debug mode (set to "true" for detailed output)
debug=true

# Output prefix for processed Model1 data
output_prefix_model1="cmip7_output"

# Output directory for all generated files
output_dir="path to directory"  # Specify where output files should be saved

###########~~~~~~~~~~~~~~~~~~~~~~~END~~~~~~~~~~~~~~~~~~##################
