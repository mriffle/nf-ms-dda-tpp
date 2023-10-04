// Modules
include { COMET } from "../modules/comet"
include { TPP } from "../modules/tpp"
include { TPP_NO_PTMPROPHET } from "../modules/tpp"
include { UPLOAD_TO_LIMELIGHT } from "../modules/limelight_upload"
include { CONVERT_TO_LIMELIGHT_XML } from "../modules/limelight_xml_convert"

workflow wf_comet_tpp {

    take:
        mzml_file_ch
        comet_params
        fasta
        peptide_prophet_params
        do_ptm_prophet
        ptm_prophet_mods
        ptm_prophet_params
    
    main:

        // run comet
        COMET(mzml_file_ch, comet_params, fasta)

        // run TPP
        if(params.run_ptm_prophet) {
            TPP(
                COMET.out.pepxml.collect(), 
                fasta, 
                mzml_file_ch.collect(), 
                comet_params,
                peptide_prophet_params,
                ptm_prophet_mods,
                ptm_prophet_params
            )

            iprophet_output = TPP.out.inter_prophet_pepxml_file
        } else {
            TPP_NO_PTMPROPHET(
                COMET.out.pepxml.collect(), 
                fasta, 
                mzml_file_ch.collect(), 
                comet_params,
                peptide_prophet_params
            )

            iprophet_output = TPP_NO_PTMPROPHET.out.inter_prophet_pepxml_file
        }

        // Upload to Limelight
        if (params.limelight_upload) {

            CONVERT_TO_LIMELIGHT_XML(
                iprophet_output, 
                fasta, 
                comet_params
            )

            UPLOAD_TO_LIMELIGHT(
                CONVERT_TO_LIMELIGHT_XML.out.limelight_xml,
                mzml_file_ch.collect(),
                fasta,
                params.limelight_webapp_url,
                params.limelight_project_id,
                params.limelight_search_description,
                params.limelight_search_short_name,
                params.limelight_tags,
            )
        }
}
