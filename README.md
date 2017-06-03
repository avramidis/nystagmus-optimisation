## Nystagmus Optimisation ##

This repositosy includes MATLAB code for the optimisation of occulomotor models to nystagmus waveforms. 

This code was developed for the work presented in the publication:

Avramidis Eleftherios, and Ozgur E. Akman. ["Optimisation of an exemplar oculomotor model using multi-objective genetic algorithms executed on a GPU-CPU combination."](http://dx.doi.org/10.1186/s12918-017-0416-2) BMC Systems Biology 11.1 (2017): 40. DOI:10.1186/s12918-017-0416-2

This codebase was developed in collaboration with [Dr. Ozgur E. Akman](http://emps.exeter.ac.uk/mathematics/staff/oea201) at the [University of Exeter, UK](http://www.exeter.ac.uk/). 

### Folders description ###

The upoextraction folder includes the code needed to extract a single nystagmus waveform for an experimental time series.
This waveform can be used to optimise an oculomotor model.

The gpuserver and client folders include the code needed to optimise an occulomotor model. The optimisation is done using the NSGA-II.
The code in these two folder allows the parallel run of multiple NSGA-II instances. This way statistics of the found solutions can be aquired if one unique waveform target is used or 
optimise the model to different waveform targets.
The integration of the oculomotor model is done using ODECL library that uses OpenCL. This allows the use of a GPU to accelerate the integration of the ocumolotor model for multiple parameter sets.

### How to run the code ###

The optimisation pipeline first include the execution of the upoextraction/test_upoextraction.m to extract a nystagmus waveform from an experimental recording.
The extracted waveform can be saved in a mat file named target1.mat and copied to the client folder (example of a target is included in the client folder). 

Then, to run the optimisation of the oculomotor model two MATLAB instances are needed.
Using the first MATLAB instance we execute the gpuserver/gpuservercaller.m script.
Using the second MATLAB instance we execute the client/workitemsmanagercaller.m script.
For better performace the gpuserver folder must be in a RAMDISK or at least an SSD.

### Future work ###

Future work on this repositosy includes the addition of code that presents the optimisation results to figures.