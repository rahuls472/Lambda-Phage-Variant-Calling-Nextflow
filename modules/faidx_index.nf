#!/usr/bin/env nextflow

process FAIDX{
    container "biocontainers/samtools:v1.9-4-deb_cv1"
    publishDir "results/reference", mode: 'copy'

    input:
    path fasta

    output:
    path "${fasta.name}*"

    script:
    """
    samtools faidx ${fasta}
    """
}


