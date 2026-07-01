#!/usr/bin/env nextflow

process BAM_INDEX {

    container "biocontainers/samtools:v1.9-4-deb_cv1"

    publishDir "results/samtools_index", mode: 'copy'

    input:
    path bam

    output:
    tuple(
        path(bam),
        path("${bam.baseName}.bam.bai")
    )

    script:
    """
    samtools index \
        ${bam} \
        ${bam.baseName}.bam.bai
    """
}