# Research Project CSE3000

This repository links to the work of students for the Research project course of the CSE bachelor at TU Delft.

Please see their projects [here](https://cse3000-research-project.github.io/2026/Q4).

## Environment Setup

This project was written on Python 3.14 and thus I advise using this version.

Create a virtual environment (if not already done):
   ```bash
   python -m venv .venv
   ```

Activate the virtual environment:
   - **Windows (PowerShell)**:
     ```powershell
     .\.venv\Scripts\Activate.ps1
     ```
   - **Windows (CMD)**:
     ```cmd
     .venv\Scripts\activate.bat
     ```
   - **Unix/macOS**:
     ```bash
     source .venv/bin/activate
     ```

Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

Run the notebook:
   Open `downsampling_eeg.ipynb` in VS Code or Jupyter