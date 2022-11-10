This repo is to store data and scripts of some analyses done on the [SPIS EEG resting state dataset](https://github.com/mastaneht/SPIS-Resting-State-Dataset/tree/master/Pre-SART%20EEG).

Preprcessing (in eeglab):

1. Bandpass 1-40hz
2. ICA and remove noise comoponents
3. Average reference.
4. Split data into 100 segments per recording (approx. 1.5s per segment)

Granger causality (ValidGrang.m ,GrangClassin.m)

- Pairvise GC was computed for each segments, yielding a 64,64 matrix per segment.
- PCA was preformed on these matrices, the first 16 components explained 90% of the variance

- Classifiers were trained on the full data and loadings of the data onto the first 16 PCA components. SVMs, NNs we're best in both cases giving 85-95% accuracy (in general higher for the complete data).

**TODO** statcond on the loadings.
