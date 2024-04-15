'''
Author: Rosilio Roman

Module with functions for visualizing data and results.
'''
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def plot_v_potential(data):
    """
    Plots the V potential values from the data in a 3D scatter plot.
    Dynamically adjusts the x, y, z axis limits based on the data.

    Parameters:
        data: A pandas DataFrame with the combined data from the CST txt files.
    """
    # Segment data by object type
    objects = data['object'].unique()
    separated_data = {obj: data[data['object'] == obj] for obj in objects} # dictionary of DataFrames separated by object type

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    colors = ['blue', 'green', 'red', 'cyan', 'magenta']
    color_map = {obj: colors[i % len(colors)] for i, obj in enumerate(objects)}

    # Initialize variables to find the range
    min_x, max_x = float('inf'), float('-inf')
    min_y, max_y = float('inf'), float('-inf')
    min_z, max_z = float('inf'), float('-inf')

    for obj, df in separated_data.items():
        ax.scatter(df['x'], df['y'], df['z'], c=color_map[obj], label=obj, s=20, alpha=0.5)
        # Update the min and max values
        min_x, max_x = min(min_x, df['x'].min()), max(max_x, df['x'].max())
        min_y, max_y = min(min_y, df['y'].min()), max(max_y, df['y'].max())
        min_z, max_z = min(min_z, df['z'].min()), max(max_z, df['z'].max())

    # Set axis limits based on the data
    ax.set_xlim([min_x, max_x])
    ax.set_ylim([min_y, max_y])
    ax.set_zlim([min_z, max_z])

    ax.set_xlabel('X (cm)')
    ax.set_ylabel('Y (cm)')
    ax.set_zlabel('Z (cm)')
    ax.set_title('Voltage Induced on the Modeled Spacecraft')
    
    # Adjust plot to make room for the legend
    plt.subplots_adjust(right=0.8)
    ax.legend(title='Object', loc='center left', bbox_to_anchor=(1, 0.5))
    plt.show()
