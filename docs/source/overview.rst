===================================
Workflow Overview
===================================

Workflow Components
===================
The workflow is made up of the following software components, each may be run multiple times for different tasks.

*  **PanoramaWeb** (https://panoramaweb.org/home/project-begin.view)

   Users may optionally use WebDAV URLs as locations for input data files in PanoramaWeb, a member of the ProteomeXchange. The workflow will automatically download files as necessary.

*  **msconvert** (https://proteowizard.sourceforge.io/)

   If users supply RAW files as input, they will be converted to mzML using *msconvert*.

*  **Comet** (https://uwpr.github.io/Comet/)

   Comet is an open source tandem mass spectrometry (MS/MS) sequence database search tool.

*  **Trans Proteomic Pipeline (TPP)** (http://www.tppms.org/)

   The TPP is used used as a suite of post-processing software that includes PeptideProphet, InterProphet, and PTMProphet.

*  **Limelight XML Conversion** (https://github.com/yeastrc/limelight-import-comet-tpp)

   The Limelight XML converter converts the native output of the TPP to Limelight XML, suitable for import into Limelight. This step will only run if uploading to Limelight is enabled.

*  **Limelight** (https://limelight-ms.org/)

   Limelight is a web application for visualization, analysis, and sharing of proteomics results generated from mass spectrometry data. If uploading to Limelight is enabled, the results will be uploaded automatically to the specified Limelight instance.

How to Run
===================
This workflow uses the Nextflow standardized workflow platform. The Nextflow platform emphasizes ease of use, workflow portability,
and containerization of the individual steps. To run this workflow, **you do not need to install any of the software components of
the workflow**. There is no need to worry about installing necessary software libararies, version incompatibilities, or compiling or
installing complex and fickle software.

To run the workflow you need only install Nextflow, which is relatively simple. To run the individual steps of the workflow on your
own computer, you will need to install Docker. After these are installed, you will need to edit the pipeline configuration file to
supply the locations of your data and execute a simple Nextflow command, such as:

.. code-block:: bash

    nextflow run -resume -r main mriffle/nf-ms-dda-tpp -c pipeline.config

The entire workflow will be run automatically, downloading Docker images as necessary, and the results output to
the ``results`` directory. See :doc:`how_to_install` for more details on how to install Nextflow and Docker. See 
:doc:`how_to_run` for more details on how to run the workflow. And see :doc:`results` for more details on how to
retrieve the results.
