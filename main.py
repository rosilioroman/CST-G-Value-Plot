'''
Author: Rosilio Roman
Desc: Main script that controls program logic
'''
import sys
import argparse
from src.data_loader import load_data
# from src.analysis import perform_analysis
# from src.simulation import run_simulation
from src.visualization import plot_v_potential

def main(DATA_DIR):
    '''
    Main script flow:
    1. Load data from CST output files into a pandas DataFrame
    2. Plot the resulting V potential values
    '''
    # Build the full path to the specified data directory based on command line argument
    data_path = f'data/{DATA_DIR}'

    try:
        # Load data from the specified source
        print(f"Loading data from {data_path}...")
        data = load_data(data_path)

        # Plot V potential values
        print("Generating a plot of V Potential Values...")
        plot_v_potential(data)
        print("Process completed successfully.")
    except Exception as e:
        print(f"An error occurred during processing: {e}")

def parse_arguments():
    parser = argparse.ArgumentParser(description='Process CST Studio output data and plot resulting G-Values.')
    parser.add_argument('DATA_DIR', type=str, help='Name of subdirectory under data/ containing the input files.')
    args = parser.parse_args()
    return args

if __name__ == "__main__":
    rc = 1 # return code
    args = parse_arguments()
    try:
        main(args.DATA_DIR)
        rc = 0
    except Exception as e:
        print('Error: %s' % e, file=sys.stderr)
    sys.exit(rc)
