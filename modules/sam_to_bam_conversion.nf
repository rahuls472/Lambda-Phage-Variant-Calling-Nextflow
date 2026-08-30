#!/usr/bin/ env nextflow

process FILE_CONVERSION {
    container "biocontainers/samtools:v1.9-4-deb_cv1"
    publishDir "${params.output}/sam_to_bam_conversion", mode: 'copy'

    input:
    path sam

    output:
    path "${sam.baseName}.bam"

    script:
    """
    samtools view -bS ${sam} > ${sam.baseName}.bam
    """
}