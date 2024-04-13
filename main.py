'''
Author: Rosilio Roman

Main script that controls program logic
'''

import argparse
from src.data_loader import load_data
# from src.analysis import perform_analysis
# from src.simulation import run_simulation
# from src.visualization import visualize_results

def main(data_subdir):

    '''
    Loading Data
    '''
    # Build the full path to the data directory based on command line argument
    data_path = f'data/{data_subdir}'

    # Load data from the specified source
    print(f"Loading data from {data_path}...")
    data = load_data(data_path)

    '''
    Processing Data
    '''
    # # Perform data preprocessing and analysis
    # print("Analyzing data...")
    # processed_data = perform_analysis(data)

    '''
    Simulating
    '''
    # # Run simulation with the processed data
    # print("Running simulations...")
    # simulation_results = run_simulation(processed_data)

    '''
    Visualize Data
    '''
    # # Visualize the results of the simulation
    # print("Visualizing results...")
    # visualize_results(simulation_results)

    if data == True:
        print("Process completed successfully.")
    else:
        print("Process failed.")

def parse_arguments():
    parser = argparse.ArgumentParser(description='Run the CST-G-Value-Plot simulation and analysis.')
    parser.add_argument('data_subdir', type=str, help='Name of subdirectory under data/ containing the input files.')
    args = parser.parse_args()
    return args

if __name__ == "__main__":
    args = parse_arguments()
    main(args.data_subdir)