workflow get_config_files {

   emit:
       config_files_ch

    main:

        config_file_paths = workflow.configFiles
        config_files = config_file_paths.collect { file(it) }
        config_files_ch = Channel.fromList(config_files)
}
