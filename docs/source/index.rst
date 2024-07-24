========================================
TPP Nextflow Workflow Documentation
========================================
This Nextflow workflow automates the running of the Trans Proteomic Pipeline (TPP) and, optionally, the upload of the results to Limelight for visualization and sharing. There is no need for you to install TPP, msconvert,
or any other software required by the workflow components. These documents describe how to install and run the workflow and how to retrieve results. The source code for the workflow can be found at: 
https://github.com/mriffle/nf-ms-dda-tpp. 

**TPP** (http://www.tppms.org/) is a complete and mature suite of free and open-source software tools for peptide and protein identification and validation, quantification, annotation, and more.

**Limelight** (https://limelight-ms.org/) is a general web application for searching, visualizing, sharing, and analyzing proteomics search results from any software pipeline. You may view Peptides, PSMs, and proteins; annotated
MS2 and MS1 scans; QC and statistics visualizations; share data with collaborators or for publication; compare searches; and more.

Please use the links below to navigate to pages describing how to install and run the workflow and how to retrieve results. If you would like to run in the cloud, we have included documentation for how to set up AWS Batch.

Getting Help, Providing Feedback, or Reporting Problems
=======================================================
If you need help, have ideas for new features, encounter a problem, or have any questions or comments, please contact Michael Riffle at mriffle@uw.edu.

Documentation Sections
=======================================================

.. toctree::
   :maxdepth: 2

   self
   overview
   how_to_install
   how_to_run
   workflow_parameters
   results
   set_up_aws
