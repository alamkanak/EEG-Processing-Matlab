# EEG-Processing-Matlab

This is a MATLAB project to process three EEG datasets.

## Datasets

| Dataset | Name | Description | Location |
| ------------- | ------------- | ------------- | ------------- |
| Dataset 1 | TMS-EEG | EEG was collected while applying TMS to the primary cortex. The TMS was applied such that right APB generated a MEP response of predefined strength. | It can be found in the Artemis `/project/RDS-FEI-EEGMEPVariability-RW/dataset1` | 
| Dataset 2 | VEP-EEG | EEG was collected while alcoholic and non-alcoholic subjects performed visual object recognition task. | It can be found in the Artemis `/project/RDS-FEI-EEGMEPVariability-RW/dataset2`. The dataset description can be found at [UCI](https://archive.ics.uci.edu/ml/datasets/EEG+Database). |
| Dataset 3 | Resting state EEG | EEG was collected in different states but we are only interested in only the resting state EEG. | It can be found in the Artemis `/project/RDS-FEI-EEGMEPVariability-RW/dataset3`. The data was downloaded from https://dataverse.tdl.org/dataset.xhtml?persistentId=doi:10.18738/T8/9TTLK8 |

## MATLAB Processing

In MATLAB the EEG processing steps included the following steps:
1. Epoch the continuous EEG waveforms.
2. Correct baseline.
3. Remove artifacts using independent component analysis (manual or automatic).
4. Transform EEG to Hjorth CSD signals.

### Dataset 1
#### Requirements

- [EEGLAB](https://sccn.ucsd.edu/eeglab/index.php)
- [TESA](https://nigelrogasch.github.io/TESA)
- [FieldTrip](http://www.fieldtriptoolbox.org/)

#### Notes
- The file [`CleanPreStimulusEegScript.m`](https://github.com/alamkanak/EEG-Processing-Matlab/blob/master/CleanPreStimulusEegScript.m) was used to process all of the EEGs in Dataset 1.
- The file [`CleanPreStimulusEeg6.m`](https://github.com/alamkanak/EEG-Processing-Matlab/blob/master/CleanPreStimulusEeg6.m) is a function that can process a single EEG file.

### Dataset 2
#### Requirements
- [EEGLAB](https://sccn.ucsd.edu/eeglab/index.php)
- [FieldTrip](http://www.fieldtriptoolbox.org/)

#### Notes
The file [`AlcoholHjorth.m`](https://github.com/alamkanak/EEG-Processing-Matlab/blob/master/AlcoholHjorth.m) was used to process the EEGs.

### Dataset 3
#### Requirements
- [EEGLAB](https://sccn.ucsd.edu/eeglab/index.php)
- [FieldTrip](http://www.fieldtriptoolbox.org/)
- [ARTIST](https://drive.google.com/drive/folders/1Q05okkwrqssBRkVGv8PpYRRhaZOy0HrU) | [Method paper](https://onlinelibrary.wiley.com/doi/full/10.1002/hbm.23938)
- [ADJUST](https://www.nitrc.org/projects/adjust/) | [Method paper](https://pubmed.ncbi.nlm.nih.gov/20636297)

#### Notes
The file [`dataset3.m`](https://github.com/alamkanak/EEG-Processing-Matlab/blob/master/dataset3.m) was used to process the EEGs. Please note that the library ADJUST was customized before processing. The customization was done in order for the library not display figures during processing. The figures originally waited for manual confirmation which can drastically slow down the process.
