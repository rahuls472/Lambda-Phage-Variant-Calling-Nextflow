#!/usr/bin/env nextflow


process SAMTOOL_SORT {
    container "biocontainers/samtools:v1.9-4-deb_cv1"
    publishDir "results/samtools_sort", mode: 'copy'

    input:
    path bam

    output:
    path "${bam.baseName}_sorted.bam"

    script:
    """
    samtools sort -o ${bam.baseName}_sorted.bam ${bam}
    """
}
