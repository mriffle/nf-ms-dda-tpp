def exec_java_command(mem) {
    def xmx = "-Xmx${mem.toGiga()-1}G"
    return "java -Djava.aws.headless=true ${xmx} -jar /usr/local/bin/cometTPP2LimelightXML.jar"
}

process CONVERT_TO_LIMELIGHT_XML {
    publishDir "${params.result_dir}/limelight", failOnError: true, mode: 'copy'
    label 'process_low'
    label 'process_high_memory'
    container 'mriffle/comet-tpp-to-limelight:2.8.0'

    input:
        path pepxml
        path fasta
        path comet_params

    output:
        path("results.limelight.xml"), emit: limelight_xml
        path("*.stdout"), emit: stdout
        path("*.stderr"), emit: stderr

    script:

    search_comment = 'Searched using Nextflow workflow: $workflow.repository - $workflow.revision [$workflow.commitId]'
    search_comment2 = 'Nextflow command line: $workflow.commandLine (see attached pipeline config file)'

    """
    echo "Running Limelight XML conversion..."
        ${exec_java_command(task.memory)} \
        -c ${comet_params} \
        -f ${fasta} \
        -p ${pepxml} \
        -o results.limelight.xml \
        --add-comment "${search_comment}" \
        --add-comment "${search_comment2}" \
        -v \
        > >(tee "limelight-xml-convert.stdout") 2> >(tee "limelight-xml-convert.stderr" >&2)
        

    echo "Done!" # Needed for proper exit
    """

    stub:
    """
    touch "results.limelight.xml"
    """
}
