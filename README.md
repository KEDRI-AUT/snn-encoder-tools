# snn-encoder-tools
Spiking Neural Networks - Encoding Optimization Tools

- developed by Balint Petro from Budapest University of Technology and Economics, Hungary
- developed at Auckland University of Technology - Knowledge Engineering and Discovery Research Intitute, New Zealand

# How To use Matlab GUI version:
1. Open Matlab and navigate to the folder of where you store snn-encoder-tools.
2. Find 'Spiker.m' and run it (select and F9 or double-click). This will add the snn-encoder-tools folder and subfolders to path.
3. Load your own data from the 'Data', 'Load data' menu item (Ctrl+O), or select a test signal type in the top left corner of window, then click the appearing 'Generate data' button. (The loaded data size is displayed in the console - make sure it is n-by-1, where n is your signal length. The current GUI version supports only one sample of one feature).
4. Select encoding algorithm amongst the top right radio buttons.
5. Set parameters and click 'Encode'. Use slider to adjust 'threshold' parameter if you wish.
6. Alternatively, perform a simple search for an optimal threshold parameter. You can also set the 'threshold' at the optimum value by clicking 'Optimize threshold'. A grid search for multi-parameter optimization is also available (for MW and BSA encoding).
7. Observe Fast Fourier Transformation results for original, reconstructed and spike signals by clicking 'FFT' button.
8. In the 'Utilities' menu, select 'Save to workspace' (or Ctrl+S) to save original, reconstructed and spike signals (if these exist) to the workspace as variables.

# About formatting your own data to be loaded:
Currently, only a single data sample can be loaded into the Spiker tool. The data should be stored as an '.xls', '.xlsx'., or '.csv' or similar file and it should have a layout such that the consecutive rows represent the consecutive time points. It is okay to have multiple columns (e.g. for multiple features); during the loading process, a dialog box appears to select the column that you wish to work with.
-----
Future collaborations regarding this work are welcome!
