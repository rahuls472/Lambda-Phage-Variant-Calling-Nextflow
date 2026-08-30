#!/usr/bin/env nextflow

process HAPLOTYPECALLER {

    container "broadinstitute/gatk"

    publishDir "${params.output}/haplotypecaller", mode: 'copy'

    input:

    tuple(
        path(bam),
        path(bai)
    )

    tuple(
        path(reference),
        path(amb),
        path(ann),
        path(bwt),
        path(pac),
        path(sa),
        path(fai),
        path(dict)
    )
    output:
    path "${bam.baseName}.vcf"

    script:
    """
    gatk HaplotypeCaller \
        -R ${reference} \
        -I ${bam} \
        -O ${bam.baseName}.vcf
    """
}