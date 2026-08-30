#!/usr/bin/env nextflow

process FASTP {

    container "biocontainers/fastp:v0.19.6dfsg-1-deb_cv1"

    publishDir "${params.output}/fastp", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("*_R1_trimmed.fastq"), path("*_R2_trimmed.fastq")

    script:
    """
    fastp \
        -i ${reads[0]} \
        -I ${reads[1]} \
        -o ${sample_id}_R1_trimmed.fastq \
        -O ${sample_id}_R2_trimmed.fastq
    """
}