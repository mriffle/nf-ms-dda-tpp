process TPP {
    publishDir "${params.result_dir}/tpp", failOnError: true, mode: 'copy'
    label 'process_high_constant'
    label 'process_long'
    container params.images.tpp

    input:
        path pepxml_files
        path fasta_file
        path mzml_files
        path comet_params_file
        val peptide_prophet_params
        val ptm_prophet_mods
        val ptm_prophet_params
        val import_decoys

    output:
        path("interact.pep.xml"), emit: peptide_prophet_pepxml_file
        path("interact.ptm.pep.xml"), emit: ptm_prophet_pepxml_file
        path("interact.ipro.ptm.pep.xml"), emit: inter_prophet_pepxml_file
        path("*.stdout"), emit: stdout
        path("*.stderr"), emit: stderr

    script:

    pepxml_file_list = pepxml_files.join(" ")

    // if decoys are being imported into limelight, all decoys must be present in pepxml
    // this is accomplished using MINPROB=0
    if (import_decoys) {
        hasMinprob = peptide_prophet_params.find(/MINPROB=\d+(\.\d+)?/)

        if (hasMinprob) {
            peptide_prophet_params = peptide_prophet_params.replaceAll(/MINPROB=\d+(\.\d+)?/, 'MINPROB=0')
        } else {
            peptide_prophet_params += ' MINPROB=0'
        }
    }

    """
    # running peptideprophet commands
    InteractParser interact.pep.xml ${pepxml_file_list} \
    > >(tee "InteractParser.stdout") 2> >(tee "InteractParser.stderr" >&2)
    
    RefreshParser interact.pep.xml ${fasta_file} \
    > >(tee "RefreshParser.stdout") 2> >(tee "RefreshParser.stderr" >&2)
    
    # get the decoy prefix from the comet params file
    export DECOY_PREFIX=\$(grep -oP 'decoy_prefix\\s*=\\s*\\K\\w+' ${comet_params_file})

    # ensure DECOY_PREFIX is set
    if [[ -z "\$DECOY_PREFIX" ]]; then
        echo "DECOY_PREFIX is not set or is empty"
        exit 1
    fi

    PeptideProphetParser interact.pep.xml MAXTHREADS=${task.cpus} ${peptide_prophet_params} DECOY=\$DECOY_PREFIX \
    > >(tee "PeptideProphetParser.stdout") 2> >(tee "PeptideProphetParser.stderr" >&2)

    # running ptmprophet command
    PTMProphetParser \
       ${ptm_prophet_mods} \
       MAXTHREADS=${task.cpus} \
       ${ptm_prophet_params} \
       interact.pep.xml \
       interact.ptm.pep.xml \
       > >(tee "PTMProphetParser.stdout") 2> >(tee "PTMProphetParser.stderr" >&2)

    # running iprophet command
    InterProphetParser THREADS=${task.cpus} interact.ptm.pep.xml interact.ipro.ptm.pep.xml \
    > >(tee "InterProphetParser.stdout") 2> >(tee "InterProphetParser.stderr" >&2)
    """
}

process TPP_NO_PTMPROPHET {
    publishDir "${params.result_dir}/tpp", failOnError: true, mode: 'copy'
    label 'process_high_constant'
    label 'process_long'
    container 'spctools/tpp:version6.3.3'

    input:
        path pepxml_files
        path fasta_file
        path mzml_files
        path comet_params_file
        val peptide_prophet_params
        val import_decoys

    output:
        path("interact.pep.xml"), emit: peptide_prophet_pepxml_file
        path("interact.ipro.pep.xml"), emit: inter_prophet_pepxml_file
        path("*.stdout"), emit: stdout
        path("*.stderr"), emit: stderr

    script:

    pepxml_file_list = pepxml_files.join(" ")

    // if decoys are being imported into limelight, all decoys must be present in pepxml
    // this is accomplished using MINPROB=0
    if (import_decoys) {
        hasMinprob = peptide_prophet_params.find(/MINPROB=\d+(\.\d+)?/)

        if (hasMinprob) {
            peptide_prophet_params = peptide_prophet_params.replaceAll(/MINPROB=\d+(\.\d+)?/, 'MINPROB=0')
        } else {
            peptide_prophet_params += ' MINPROB=0'
        }
    }

    """
    # running peptideprophet commands
    InteractParser interact.pep.xml ${pepxml_file_list} \
    > >(tee "InteractParser.stdout") 2> >(tee "InteractParser.stderr" >&2)
    
    RefreshParser interact.pep.xml ${fasta_file} \
    > >(tee "RefreshParser.stdout") 2> >(tee "RefreshParser.stderr" >&2)
    
    # get the decoy prefix from the comet params file
    export DECOY_PREFIX=\$(grep -oP 'decoy_prefix\\s*=\\s*\\K\\w+' ${comet_params_file})

    # ensure DECOY_PREFIX is set
    if [[ -z "\$DECOY_PREFIX" ]]; then
        echo "DECOY_PREFIX is not set or is empty"
        exit 1
    fi

    PeptideProphetParser interact.pep.xml MAXTHREADS=${task.cpus} ${peptide_prophet_params} DECOY=\$DECOY_PREFIX \
    > >(tee "PeptideProphetParser.stdout") 2> >(tee "PeptideProphetParser.stderr" >&2)

    # running iprophet command
    InterProphetParser THREADS=${task.cpus} interact.pep.xml interact.ipro.pep.xml \
    > >(tee "InterProphetParser.stdout") 2> >(tee "InterProphetParser.stderr" >&2)
    """
}
