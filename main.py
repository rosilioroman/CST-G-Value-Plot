'''
Author: Rosilio Roman
Desc: Main script that controls program logic
'''
import sys
import argparse
from src.data_loader import load_data
# from src.analysis import perform_analysis
# from src.simulation import run_simulation
# from src.visualization import visualize_results

def main(DATA_DIR):
    '''
    Loading Data
    '''
    # Build the full path to the specified data directory based on command line argument
    data_path = f'data/{DATA_DIR}'

    try:
        # Load data from the specified source
        print(f"Loading data from {data_path}...")
        data = load_data(data_path)
        print(data.head())
    except Exception as e:
        print(f"Failed to load data: {e}")
        return  # Stop execution if data loading fails

    try:
        # '''
        # Processing Data
        # '''
        # # Perform data preprocessing and analysis
        # print("Analyzing data...")
        # processed_data = perform_analysis(data)

        # '''
        # Run Simulation
        # '''
        # # Run simulation with the processed data
        # print("Running simulations...")
        # simulation_results = run_simulation(processed_data)

        # '''
        # Visualize Data
        # '''
        # # Visualize the results of the simulation
        # print("Visualizing results...")
        # visualize_results(simulation_results)

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