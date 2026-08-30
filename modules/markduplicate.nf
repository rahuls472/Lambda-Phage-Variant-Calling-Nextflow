#!/usr/bin/env nextflow

process MARKDUPLICATE {

    container "broadinstitute/gatk"

    publishDir "${params.output}/markduplicate", mode: 'copy'

    input:
    path bam

    output:
    path("${bam.baseName}_marked.bam"), emit: bam
    path("${bam.baseName}_marked.metrics"), emit: metrics   

    script:
    """
    gatk MarkDuplicates \
        -I ${bam} \
        -O ${bam.baseName}_marked.bam \
        -M ${bam.baseName}_marked.metrics
    """
}