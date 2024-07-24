===================================
Workflow Parameters
===================================

The workflow parameters should be included in a configuration file, an example
of which can be found at
https://raw.githubusercontent.com/mriffle/nf-ms-dda-tpp/main/resources/pipeline.config

The parameters in this file should be changed to indicate the locations of your data, the
options you'd like to use for the software included in the workflow, and the capabilities and
configuration for the system on which you are running the workflow steps.

The configuration file is roughly organized as:

.. code-block:: groovy

    params {
    ...
    }

    profiles {
    ...
    }

    mail {
    ...
    }

- The ``params`` section includes locations of data and configuration options for a specific run of the workflow.
- The ``profiles`` sections includes parameters that describe the capabilities of the systems that run the steps of the workflow. For example, if running on your local system, this will include things like how many cores and how much RAM may be used by the steps of the workflow. This will not need to be changed for each run of the workflow.
- The ``mail`` section includes configuration options for sending email. This is optional and only necessary if you wish to send emails when the workflow completes. This will not need to be changed for each run of the workflow.

Below is a complete description of all parameters that may be included in these sections.

.. note::

    This workflow can process files stored in **PanoramaWeb**. When specifying directories or file locations, any paths that begin with ``https://`` will be interpreted as being PanoramaWeb locations.

    For example, to process a raw file stored in PanoramaWeb, you would have the following in your pipeline.config file:

    .. code-block:: bash

        spectra_file= 'https://panoramaweb.org/_webdav/path/to/@files/RawFiles/my_raw_file.raw'


    Where, ``https://panoramaweb.org/_webdav/path/to/@files/RawFiles/my_raw_file.raw`` is the WebDav URL of the file on the Panorama server.


The ``params`` Section
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table:: Parameters for the ``params`` section
   :widths: 5 20 75
   :header-rows: 1

   * - Req?
     - Parameter Name
     - Description
   * - ✓
     - ``fasta``
     - The path to the location of a FASTA file to use as the search database. This can be a local file (e.g., ``/data/mass_spec/my_raw_files/yeast.fasta`` or a Panorama WebDAV URL (described above).
   * - ✓
     - ``spectra_dir``
     - The path to directory containing either .raw or .mzML files to be processed. This can be a local file (e.g., ``/data/mass_spec/my_raw_files`` or a Panorama WebDAV URL (described above).
   * -
     - ``spectra_glob``
     - The file glob to use to find the correct files to process. Default: ``'*.raw'``
   * - 
     - ``comet_params``
     - The path to the location of the Comet params file to be used in the Comet search. This can be a local file (e.g., ``/data/mass_spec/comet.params`` or a Panorama WebDAV URL (described above). A sample can be found at: https://raw.githubusercontent.com/mriffle/nf-ms-dda-tpp/main/resources/comet.params Default: ``'comet.params'``.
   * - 
     - ``peptide_prophet_params``
     - The command line parameters to be used by PeptideProphet. Default: ``'MINPROB=0.1 NONPARAM BANDWIDTHX=2 CLEVEL=1 PPM ACCMASS NONPARAM ONEFVAL VMC EXPECTSCORE'``
   * - 
     - ``run_ptm_prophet``
     - Whether or not to run PTMProphet. Default: false
   * - 
     - ``ptm_prophet_mods``
     - If running PTMProphet, this defines the modifications that will be found and localized. Default: ``'C:57.02146,MWFHCP:15.9949'`` See: http://www.tppms.org/tools/ptm/ for more information.
   * - 
     - ``ptm_prophet_params``
     - The command line parameters to be used by PTMProphet. Default: ``'FRAGPPMTOL=50 STATIC NOSTACK MINPROB=0.1'`` See: http://www.tppms.org/tools/ptm/ for more information.
   * - 
     - ``limelight_upload``
     - Set to ``'true'`` to upload to Limelight. If set to ``true``, the following Limelight-related parameters apply. Default: ``false``.
   * - 
     - ``limelight_project_id``
     - This is required if ``limelight_upload`` is set to ``true``. This is the Limelight project ID to which to upload data.
   * - 
     - ``limelight_webapp_url``
     - This is required if ``limelight_upload`` is set to ``true``. This is the URL of the Limelight instance to which to upload data. E.g., ``'https://limelight.yeastrc.org/limelight'``.
   * - 
     - ``limelight_search_description``
     - This is required if ``limelight_upload`` is set to ``true``. This is a one-line description of the search that will appear in Limelight. 
   * - 
     - ``limelight_search_short_name``
     - This is required if ``limelight_upload`` is set to ``true``. This is a very brief one-word nickname for this search. Used in plots to label data.
   * - 
     - ``limelight_tags``
     - Comma-delimited list of Limelight tags to use for this search (e.g., ``'yeast,control,2023'``. Any tags present that haven't been created in Limelight will be created in Limelight. Note: You can also specify
       categories for tags, and tags with the same tag categories will be grouped together in Limelight. For example, one could have a tag category called ``treatment`` and tags called ``control`` or ``irradiated`` as
       tags within this tag category. To specify a tag category use the tag category name then a tilda (~) then the tag name. E.g., ``treatment~control,organism~yeast,year~2023``. Default: no tags will be sent.
   * - 
     - ``limelight_import_decoys``
     - If set to ``true``, decoy hits will be imported into Limelight--enabling target/decoy QC visualization. Only set to ``true`` if this is required, dramatically increases file sizes. Default: ``false``
   * - 
     - ``limelight_entrapment_prefix``
     - If this set, any protein that begins with this string will be considered an entrapment decoy by Limelight--that is a target hit that is secretly really a decoy. This enables some QC/statistic tools within Limelight to estimate error. Example: ``limelight_entrapment_prefix = 'ENTRAP'``. Default: not set.
   * - 
     - ``email``
     - The email address to which a notification should be sent upon workflow completion. If no email is specified, no email will be sent. To send email, you must configure mail server settings (see below).

The ``profiles`` Section
^^^^^^^^^^^^^^^^^^^^^^^^
The example configuration file includes this ``profiles`` section:

.. code-block:: groovy

    profiles {

        // "standard" is the profile used when the steps of the workflow are run
        // locally on your computer. These parameters should be changed to match
        // your system resources (that you are willing to devote to running
        // workflow jobs).
        standard {
            params.max_memory = '8.GB'
            params.max_cpus = 4
            params.max_time = '240.h'

            params.mzml_cache_directory = '/data/mass_spec/nextflow/nf-ms-dda-tpp/mzml_cache'
            params.panorama_cache_directory = '/data/mass_spec/nextflow/panorama/raw_cache'
        }
    }

These parameters describe the capability of your local computer for running the steps of the workflow. Below is a description of each parameter:

.. list-table:: Parameters for the ``profiles/standard`` section
   :widths: 5 20 75
   :header-rows: 1

   * - Req?
     - Parameter Name
     - Description
   * - ✓
     - ``params.max_memory``
     - The maximum amount of RAM that may be used by steps of the workflow. Default: 8 gigabytes.
   * - ✓
     - ``params.max_cpus``
     - The number of cores that may be used by the workflow. Default: 4 cores.
   * - ✓
     - ``params.max_time``
     - The maximum amount of a time a step in the workflow may run before it is stopped and error generated. Default: 240 hours.
   * - ✓
     - ``params.mzml_cache_directory``
     - When ``msconvert`` converts a RAW file to mzML, the mzML file is cached for future use. This specifies the directory in which the cached mzML files are stored.
   * - ✓
     - ``params.panorama_cache_directory``
     - If the RAW files to be processed are in PanoramaWeb, the RAW files will be downloaded to and cached in this directory for future use.

The ``mail`` Section
^^^^^^^^^^^^^^^^^^^^^^^
This is a more advanced and entirely optional set of parameters. When the workflow completes, it can optionally send an email to the address specified above in the ``params`` section.
For this to work, the following parameters must be changed to match the settings of your email server. You may need to contact your IT department to obtain the appropriate settings.

The example configuration file includes this ``mail`` section:

.. code-block:: groovy

    mail {
        from = 'address@host.com'
        smtp.host = 'smtp.host.com'
        smtp.port = 587
        smtp.user = 'smpt_user'
        smtp.password = 'smtp_password'
        smtp.auth = true
        smtp.starttls.enable = true
        smtp.starttls.required = false
        mail.smtp.ssl.protocols = 'TLSv1.2'
    }

Below is a description of each parameter:

.. list-table:: Parameters for the ``profiles/standard`` section
   :widths: 5 20 75
   :header-rows: 1

   * - Req?
     - Parameter Name
     - Description
   * - ✓
     - ``from``
     - The email address **from** which the email should be sent.
   * - ✓
     - ``smtp.host``
     - The internet address (host name or ip address) of the email SMTP server.
   * - ✓
     - ``smtp.port``
     - The port on the host to connect to. Most likely will be ``587``.
   * - 
     - ``smtp.user``
     - If authentication is required, this is the username.
   * - 
     - ``smtp.password``
     - If authentication is required, this is the password.
   * - ✓
     - ``smtp.auth``
     - Whether or not (true or false) authentication is required.
   * - ✓
     - ``smtp.starttls.enable``
     - Whether or not to enable TLS support.
   * - ✓
     - ``smtp.starttls.required``
     - Whether or not TLS is required.
   * - ✓
     - ``smtp.ssl.protocols``
     - SSL protocol to use for sending SMTP messages.
