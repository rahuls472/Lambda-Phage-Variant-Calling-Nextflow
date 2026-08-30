#!/usr/bin/env nextflow

process DICT_MAKING{
    container "broadinstitute/gatk"
    publishDir "${params.output}/reference", mode: 'copy'

    input:
    path fasta

    output:
    path "${fasta.baseName}.dict"

    script:
    """
    gatk CreateSequenceDictionary -R ${fasta} -O ${fasta.baseName}.dict
    """
}