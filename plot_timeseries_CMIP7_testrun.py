import os
import sys
import xarray as xr
import matplotlib.pyplot as plt
import numpy as np

# Check for input arguments
if len(sys.argv) < 8:  # Expecting 7 files + 1 output directory
    print("Usage: python plot_timeseries_CMIP7_testrun.py <tas_file> <rsdt_file> <rlut_file> <rsut_file> <sss_file> <sst_file> <output_dir>")
    sys.exit(1)

# File paths from arguments
tas_file = sys.argv[1]
rsdt_file = sys.argv[2]
rlut_file = sys.argv[3]
rsut_file = sys.argv[4]
sss_file = sys.argv[5]
sst_file = sys.argv[6]
output_dir = sys.argv[7]  # New: Output directory

# Ensure the output directory exists
os.makedirs(output_dir, exist_ok=True)

# Function to read a NetCDF file and extract data
def load_data(filepath, var_name, convert_to_celsius=False):
    try:
        ds = xr.open_dataset(filepath)
        if var_name in ds:
            data = ds[var_name][:, 0, 0]  # Extract field mean data
            time = np.arange(len(data))  # Use model index instead of real years
            if convert_to_celsius:
                data = data - 273.15  # Convert from Kelvin to Celsius
            return time, data
        else:
            print(f"Variable {var_name} not found in {filepath}. Skipping.")
            return None, None
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return None, None

# Function to format and beautify the plots
def plot_timeseries(time, data, ax, title, color, ylabel, y_limits=None, ref_line=None):
    ax.plot(time, data, color=color, linewidth=2.5, label="Model Data")
    ax.set_ylabel(ylabel, fontsize=12, fontweight='bold')
    ax.set_title(title, fontsize=14, fontweight='bold')
    ax.grid(True, linestyle="--", linewidth=0.5, alpha=0.7)
    ax.tick_params(axis='both', labelsize=10)
    ax.set_facecolor("#eaeaea")  # Light gray background
    #    ax.set_facecolor("#f9f9f9")  # Light background for clarity
    #    ax.set_facecolor("#eaeaea")  # Light gray background for clarity

    if y_limits:
        ax.set_ylim(y_limits)  # Set scaling limits

    # Add a reference horizontal line if needed
    if ref_line is not None:
        ax.axhline(y=ref_line, color="black", linestyle="--", linewidth=1.5, label=f"Reference: {ref_line}°C")

    ax.legend()

# Initialize figure
fig, axes = plt.subplots(4, 1, figsize=(12, 18), sharex=True)
fig.suptitle("Annual Mean Timeseries for CMIP7", fontsize=18, fontweight='bold')

# 🌡️ Plot TAS
tas_time, tas_data = load_data(tas_file, "tas", convert_to_celsius=True)
if tas_data is not None:
    plot_timeseries(tas_time, tas_data, axes[0], "Surface Air Temperature (TAS, °C)", "blue", "Temperature (°C)", (14, 16), ref_line=15)

# ☀️ Plot TOA Net Radiation
rlut_time, rlut_data = load_data(rlut_file, "rlut")
rsut_time, rsut_data = load_data(rsut_file, "rsut")
rsdt_time, rsdt_data = load_data(rsdt_file, "rsdt")

if rlut_data is not None and rsut_data is not None and rsdt_data is not None:
    toa_net = rsdt_data - (rlut_data + rsut_data)
    if not np.isnan(toa_net).all() and not np.all(toa_net == 0):
        plot_timeseries(rlut_time, toa_net, axes[1], "Top of Atmosphere Net Radiation", "orange", "Radiation (W/m²)", (0, 2.5))
    else:
        print("Warning: TOA Net Radiation is all NaN or zero. Skipping TOA plot.")

# 🌊 Plot SSS
sss_time, sss_data = load_data(sss_file, "sss")
if sss_data is not None:
    plot_timeseries(sss_time, sss_data, axes[2], "Sea Surface Salinity (SSS)", "green", "SSS (PSU)")

# 🌊 Plot SST
sst_time, sst_data = load_data(sst_file, "sst")
if sst_data is not None:
    plot_timeseries(sst_time, sst_data, axes[3], "Sea Surface Temperature (SST)", "red", "SST (°C)", (18, 19), ref_line=18.5)

# Save the plot in the specified output directory
output_path = os.path.join(output_dir, "CMIP7_timeseries_testrun.pdf")
plt.tight_layout(rect=[0, 0, 1, 0.95])  # Adjust layout to fit title
plt.savefig(output_path, dpi=600, bbox_inches="tight")

print(f"Timeseries plots saved to {output_path}")

