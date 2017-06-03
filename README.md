## Nystagmus Optimisation ##

This repositosy includes MATLAB code for the optimisation of occulomotor models to nystagmus waveforms. 

This code was developed for the work presented in the publication:

Avramidis Eleftherios, and Ozgur E. Akman. ["Optimisation of an exemplar oculomotor model using multi-objective genetic algorithms executed on a GPU-CPU combination."](http://dx.doi.org/10.1186/s12918-017-0416-2) BMC Systems Biology 11.1 (2017): 40. DOI:10.1186/s12918-017-0416-2

This codebase was developed in collaboration with [Dr. Ozgur E. Akman](http://emps.exeter.ac.uk/mathematics/staff/oea201) at the [University of Exeter, UK](http://www.exeter.ac.uk/). 

### How to run the code ###

To run the optimisation of the oculomotor model two MATLAB instances are needed.
Using the first MATLAB instance we execute the gpuserver/gpuservercaller.m script.
Using the second MATLAB instance we execute the client/workitemsmanagercaller.m script.
For better performace the gpuserver folder must be in a RAMDISK or at least an SSD.