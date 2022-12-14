This repo is to store data and scripts of some analyses done on the [SPIS EEG resting state dataset](https://github.com/mastaneht/SPIS-Resting-State-Dataset/tree/master/Pre-SART%20EEG).

Preprcessing (in eeglab):

1. Bandpass 1-40hz
2. ICA and remove noise comoponents
3. Average reference.
4. Split data into 100 segments per recording (approx. 1.5s per segment)

the final data is [here](https://drive.google.com/file/d/1u1gwD1riakBnp1GLJIv4ByD5I8GZZNcJ/view?usp=share_link)


**TODO** Toss bad segments

Granger causality (ValidGrang.m ,GrangClassin.m)

- Pairvise GC was computed for each segments, [yielding](https://drive.google.com/drive/folders/1214OBAc32IY8Vb97AvrvhmWdErhEjsNY?usp=share_link) a 64,64 matrix per segment.
- PCA was preformed on these matrices, the first 16 components explained 90% of the variance

- Classifiers were trained on the full data and loadings of the data onto the first 16 PCA components. SVMs, NNs we're best in both cases giving 85-95% accuracy (in general higher for the complete data) (models are [here](https://drive.google.com/drive/folders/1P9n3Ga4oiZg_1nXLdJR056TL14YWvWxJ?usp=share_link).

**TODO** statcond on the loadings.

Microstates (using [+microstate matalab toolbox](https://plus-microstate.github.io/); microstates.m,msclassin.m)

- Microstates are (relative) scalp topographies which represent brain states that last cca. 80-120ms after which a new microstate takes hold. Computationally they are the prototypes of clusters obtained after runing an unsuprevised clustering algo. (eg. KNN). [more details](https://www.sciencedirect.com/science/article/pii/S1053811922004657)

- 5 microstates (./ims/maps.png) we're determined to give the best "number of states/explained variance" tradeoff. 
- Next we computed some descriptive statistic related of the maps for the EO and EC conditions. We computed, assignments of timepoints to maps according to max(abs(cov(pnt,maps)). Using the assignments, mean durations (per map) and transition probabilities (a maps,maps matrix). Also and concerningly the mean durations were around 3-4pnts ~= 12-16ms (too short!!) (These can be found in ./ims or recomputed using msclassin.m)
- So far (just by eye) no significant difference in these statistics could be found between the EO and EC case.
- In the literature there are some known canonnical microstates (refer to "more details" above). Some of these were also found in our case. I noticed that they all have a wide region of (in)activity which looks rougly gaussian; they reminded me of volume conduction effects. So I also tried to make maps after laplacian filtering the data. These are somewhat different. I don't know if doing these makes sense or how to interpret the results.

**TODO**: run calssification on microstate asignments, check GCs associated with each microstate.

This is more or less what I have done so far. I am troubeled by the fact that the GCs can be used for classification, but I can't find a metric according to which EO and EC differ. (mbi it's calssifying based on some artifact). 

**TODO global** significance testing, freq. domain. analyses.
