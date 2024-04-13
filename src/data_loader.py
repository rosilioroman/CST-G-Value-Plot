'''
Author: Rosilio Roman
Desc: Module with data loading and processing functions.
'''
import pandas as pd
import os
import re

def load_data(data_path):
    """
    Load and process data from text files within subdirectories of a specified data directory.

    Parameters:
        data_path: Name of the specified data directory that contains subdirectories named after the z-values; each z-subdirectory contains the respective CST txt files.

    Returns:
        pandas.DataFrame: A DataFrame containing the concatenated data from all files.

    Raises:
        FileNotFoundError: If the directory does not exist or contains no valid text files.
        Exception: For errors during file reading and data parsing.
    """

    # Check if the specified data directory exists
    if not os.path.exists(data_path):
        raise FileNotFoundError(f"The specified data directory does not exist: {data_path}")

    CST_output = pd.DataFrame()
    files_processed = 0

    # Iterate through each z-value subdirectory in the model directory
    for z_subdir in os.listdir(data_path):
        z_subdir_path = os.path.join(data_path, z_subdir)
        if os.path.isdir(z_subdir_path):  # Ensure it is a directory
            # Process each file in the z-value subdirectory
            for filename in os.listdir(z_subdir_path):
                file_path = os.path.join(z_subdir_path, filename)
                if filename.endswith('.txt'):
                    try:
                        data_blocks = process_file(file_path)
                        file_df = pd.concat(data_blocks, ignore_index=True)
                        file_df['object'] = filename.split('.')[0]
                        file_df['z'] = float(z_subdir)  # Assuming z_subdir name is the z-value
                        CST_output = pd.concat([CST_output, file_df], ignore_index=True)
                        files_processed += 1
                    except Exception as e:
                        print(f"Error processing file {filename} in {z_subdir}: {e}")

    if files_processed == 0:
        raise FileNotFoundError("No valid text files found in the directory.")

    return CST_output

def process_file(file_path):
    """
    Process a single file to extract data blocks into DataFrames.

    Parameters:
        file_path (str): Full path to the file to be processed.

    Returns:
        list: A list of DataFrames, each representing a data block from the file.
    """
    with open(file_path, 'r') as file:
        lines = file.readlines()

    data_blocks = []
    headers = []
    current_block = []

    # Process each line in the file
    for line in lines:
        if line.startswith('#'):
            if 'x_pos' in line:
                if current_block:
                    # Create DataFrame from the current block of data
                    df = pd.DataFrame(current_block, columns=['x', 'V'])
                    df['y'] = headers[-1]  # Assign the last y_pos value to the current block
                    data_blocks.append(df)
                    current_block = []  # Reset the current block for the next data block

                # Use regex to find the numeric value for y_pos more reliably
                match = re.search(r'y_pos=([-\d.]+)', line)
                if match:
                    y_pos = float(match.group(1))  # Convert the matched string to float
                    headers.append(y_pos)  # Append the y_pos to the headers list
        else:
            parts = line.strip().split('\t')
            if len(parts) == 2:
                current_block.append([float(parts[0]), float(parts[1])])  # Append data to the current block

    # Handle the last block if it exists after finishing all lines
    if current_block:
        df = pd.DataFrame(current_block, columns=['x', 'V'])
        df['y'] = headers[-1]  # Assign the last y_pos value to the last block
        data_blocks.append(df)

    return data_blocks
