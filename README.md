# CST-G-Value-Plot
Python script to process data from [CST](https://www.3ds.com/products/simulia/cst-studio-suite) simulation output and plot the resulting G-Values.

***This is still a WORK IN PROGRESS.***

## Installation

### Prerequisites

- Python 3.8 or higher

#### Python Virtual Environment Management (OPTIONAL)
Managing various requirements for different Python projects is crucial to making sure the scripts run as expected and with less complications. For this reason, it's a good idea to use a Python virtual environment management tool. This is a rabbit hole worth exploring if Python is used moving forward.  
This article provides a good overview of virtual environments and why they are useful: [*Python Virtual Environments: The Why, What, and How.*](https://medium.com/towards-data-engineering/python-virtual-environments-the-why-what-and-how-8705c50d3ecf)

Reccommended option:
- `venv` - Python's built-in virtual environment manager
    - [Link to `venv` docs](https://docs.python.org/3/library/venv.html)  
    - Pros: No installation required (included with Python), straightforward usage.

Alternatives: 
- `virtualenv` - 3rd party open-source tool
    - [Link to `virtualenv` docs](https://github.com/pyenv/pyenv?tab=readme-ov-file#installation)  
    - Pros: More flexible than `venv` and can support earlier versions of Python (earlier than 3.3).
- `conda` -  Part of the Anaconda distribution
    - [Link to `conda` docs](https://docs.anaconda.com/free/anaconda/install/)  

All these options work just fine and are commonly used. The installation instructions in the next section demonstrate the use of `venv`.

### Installing Locally

1. Clone the repository to your local machine:  
    ```bash
    git clone https://github.com/rosilioroman/CST-G-Value-Plot.git
    cd CST-G-Value-Plot
    ```
2. Create a virtual environment
    ```bash
    python -m venv env
    ```
3. Activate the environment  
    MacOS / Linux:
    ```bash
    source env/bin/activate
    ```  
    Windows:
    ```powershell
    .\env\Scripts\activate
    ```
4.  Install the required Python libraries
    ```bash
    pip install -r requirements.txt
    ```

## Script Usage
Make sure you're in the project's base directory and run:  
```bash
python main.py DATA_SUBDIR
```  
- Note: The `data/` directory comes with the raw CST data files from the spherical spacecraft model (`CST_Data_V4`) and the Parker Solar Probe model (`PSP_Data`). If you want to work with a different set of CST data files (i.e., data from a different spacecraft model, different data from an existing model, etc.), make sure to create a new subdirectory to store those files.
- *Replace `DATA_SUBDIR` with the name of the directory with the CST data you want to work with (e.g. `python main.py PSP_Data`).*

To see the help menu:  
```bash
python main.py -h
```

## Modifying the script
Feel free to modify the script to fit your needs
- Changes to overall program logic should be made in `main.py`.  
- Otherwise, check out the other modules in `src/`.  

## License
Standard GNU GPLv3.