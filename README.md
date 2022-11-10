This repo is to store data and scripts of some analyses done on the [SPIS EEG resting state dataset](https://github.com/mastaneht/SPIS-Resting-State-Dataset/tree/master/Pre-SART%20EEG).

Preprcessing (in eeglab):

1. Bandpass 1-40hz
2. ICA and remove noise comoponents
3. Average reference.
4. Split data into 100 segments per recording (approx. 1.5s per segment)

**TODO** Toss bad segments

Granger causality (ValidGrang.m ,GrangClassin.m)

- Pairvise GC was computed for each segments, yielding a 64,64 matrix per segment.
- PCA was preformed on these matrices, the first 16 components explained 90% of the variance

- Classifiers were trained on the full data and loadings of the data onto the first 16 PCA components. SVMs, NNs we're best in both cases giving 85-95% accuracy (in general higher for the complete data) (models are [here](https://drive.google.com/drive/folders/1P9n3Ga4oiZg_1nXLdJR056TL14YWvWxJ?usp=share_link).

**TODO** statcond on the loadings.

Microstates (using [+microstate matalab toolbox](https://plus-microstate.github.io/); microstates.m,msclassin.m)

- Microstates are (relative) scalp topographies which represent brain states that last cca. 80-120ms after which a new microstate takes hold. Computationally they are the prototypes of clusters obtained after runing an unsuprevised clustering algo. (eg. KNN). more details

- 5 microstates (./ims/maps.png) we're determined to give the best "number of states/explained variance" tradeoff. 
- Next we computed some descriptive statistic related of the maps for the EO and EC conditions. We computed, assignments of timepoints to maps according to max(abs(cov(pnt,maps))
