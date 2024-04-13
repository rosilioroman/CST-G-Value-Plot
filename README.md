# CST-G-Value-Plot

***WORK IN PROGRESS***  
Python script to process data from CST simulation output and plot G-Values.

## Installation

### Prerequisites

- Python 3.8 or higher

**(OPTIONAL)**  
It would be a good idea to use a Python virtual environment management tool.

Popular choices:
- Virtualenv - Python's built-in virtual environment manager (recommended)
    - [Link to `virtualenv` installation docs](https://virtualenv.pypa.io/en/latest/installation.html)
- Anaconda - a.k.a. `conda`
    - [Link to `conda` installation docs](https://docs.anaconda.com/free/anaconda/install/)
- Pyenv - popular lightweight, open-source option
    - [Link to `pyenv` installation docs](https://github.com/pyenv/pyenv?tab=readme-ov-file#installation)

### Installing Locally

1. Clone the repository to your local machine:  
    ```bash
    git clone https://github.com/yourusername/CST-G-Value-Plot.git
    cd CST-G-Value-Plot
    ```
2. Install the required Python libraries

   ```bash
   pip install -r requirements.txt
   ```

## Script Usage
Make sure you're in the project directory and run:  
```bash
python main.py data_subdir
```

To see the help menu:  
```bash
python main.py -h
```
Changes to general program logic should be made in `main.py`; otherwise, check out the other modules in the `src/`.  

## License
Standard GNU GPLv3.