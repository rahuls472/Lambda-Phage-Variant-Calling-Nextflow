#!/bin/usr/env nextflow

process REFASTQC {

    container 'biocontainers/fastqc:v0.11.9_cv8'

    publishDir "${params.output}/fastqc", mode: 'copy'

    input:
    tuple val(sample_id), path(r1), path(r2)
    output:
    path "*_fastqc.html"
    path "*_fastqc.zip"

    script:
    """
    fastqc ${r1} ${r2}
    """
}