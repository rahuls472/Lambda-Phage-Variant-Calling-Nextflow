#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { INDEX } from './modules/index'
include { FAIDX } from './modules/faidx_index'
include { DICT_MAKING } from './modules/dict_making'

include { FASTQC } from './modules/fastqc'
include { FASTP } from './modules/fastp'
include { ALIGNMENT } from './modules/alignment'
include { FILE_CONVERSION } from './modules/sam_to_bam_conversion'
include { SAMTOOL_SORT } from './modules/samtool_sort'
include { BAM_INDEX } from './modules/samtools_index'
include { MARKDUPLICATE } from './modules/markduplicate'
include { HAPLOTYPECALLER } from './modules/Haplotypecaller'
include { REFASTQC } from './modules/re_eva'

params.output = "results"

workflow {

    reference_ch = Channel.fromPath(params.reference)

    indexed_reference_ch = INDEX(reference_ch)
    faidx_ch            = FAIDX(reference_ch)
    dict_ch             = DICT_MAKING(reference_ch)

    /*
     * Create one reference bundle
     */

    reference_bundle = indexed_reference_ch
        .combine(faidx_ch)
        .combine(dict_ch)
        .map { values ->

        println values

        tuple(*values)
            
        }

    reads_ch = Channel
    .fromFilePairs(params.input)
    
    FASTQC(reads_ch)

    fastp_ch = FASTP(reads_ch)

    REFASTQC(fastp_ch)

    aligned_ch = ALIGNMENT(
        fastp_ch,
        reference_bundle
    )

    bam_ch = FILE_CONVERSION(aligned_ch)

    sorted_bam_ch = SAMTOOL_SORT(bam_ch)

    markdup_ch = MARKDUPLICATE(sorted_bam_ch)

    marked_index_ch = BAM_INDEX(markdup_ch.bam)

    HAPLOTYPECALLER(
        marked_index_ch,
        reference_bundle
    )

}