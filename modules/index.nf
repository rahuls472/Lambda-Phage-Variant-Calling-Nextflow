#!/bin/usr/env nextflow

process INDEX {

    container 'quay.io/biocontainers/bwa:0.7.19--h577a1d6_1'

    publishDir "${params.output}/reference", mode: 'copy'

    input:
    path fasta

    output:
    tuple(
        path(fasta),
        path("${fasta.name}.amb"),
        path("${fasta.name}.ann"),
        path("${fasta.name}.bwt"),
        path("${fasta.name}.pac"),
        path("${fasta.name}.sa")
    )


    script:
    """
    bwa index ${fasta}
    """
}