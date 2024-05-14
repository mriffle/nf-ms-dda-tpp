def exec_java_command(mem) {
    def xmx = "-Xmx${mem.toGiga()-1}G"
    return "java -Djava.aws.headless=true ${xmx} -jar /usr/local/bin/cometTPP2LimelightXML.jar"
}

process CONVERT_TO_LIMELIGHT_XML {
    publishDir "${params.result_dir}/limelight", failOnError: true, mode: 'copy'
    label 'process_low'
    label 'process_high_memory'
    label 'process_long'
    container 'mriffle/comet-tpp-to-limelight:2.8.3'

    input:
        path pepxml
        path fasta
        path comet_params
        val import_decoys
        val entrapment_prefix

    output:
        path("results.limelight.xml"), emit: limelight_xml
        path("*.stdout"), emit: stdout
        path("*.stderr"), emit: stderr

    script:

    search_comment1 = "Searched using Nextflow version ${nextflow.version}"
    search_comment2 = "Nextflow workflow: ${workflow.repository} Revision: ${workflow.revision} Git commit ID: ${workflow.commitId}"
    search_comment3 = "Nextflow command line: ${workflow.commandLine} (see attached pipeline config file)"

    decoy_import_flag = import_decoys ? '--import-decoys' : ''
    entrapment_flag = entrapment_prefix ? "--independent-decoy-prefix=${entrapment_prefix}" : ''

    """
    echo "Running Limelight XML conversion..."
        ${exec_java_command(task.memory)} \
        -c ${comet_params} \
        -f ${fasta} \
        -p ${pepxml} \
        -o results.limelight.xml \
        --add-comment "${search_comment1}" \
        --add-comment "${search_comment2}" \
        --add-comment "${search_comment3}" \
        -v ${decoy_import_flag} ${entrapment_flag} \
        > >(tee "limelight-xml-convert.stdout") 2> >(tee "limelight-xml-convert.stderr" >&2)
        

    echo "Done!" # Needed for proper exit
    """

    stub:
    """
    touch "results.limelight.xml"
    """
}
