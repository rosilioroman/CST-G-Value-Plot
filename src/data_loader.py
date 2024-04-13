'''
Author: Rosilio Roman

Contains functions to read and preprocess data.
'''

import os

def load_data(data_path):

    current_directory = os.getcwd()
    full_path = os.path.join(current_directory, data_path)

    # Check that the given data_path is valid
    print("\tChecking data subdirectory exists...")

        # CHANGE THIS TO MORE ROBUST ERROR HANDLING
    if os.path.exists(full_path):
        print("\tSuccess!")
        return True
    else:
        print("\tDid not find the data subdirectory.")
        return False