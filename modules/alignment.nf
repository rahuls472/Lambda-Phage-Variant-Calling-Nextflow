process ALIGNMENT {

    container 'quay.io/biocontainers/bwa:0.7.19--h577a1d6_1'

    publishDir "results/alignment", mode: 'copy'

    input:
    tuple val(sample_id), path(r1), path(r2)

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
    path "${sample_id}.sam"

    script:
    """
    bwa mem \
        -R "@RG\\tID:${sample_id}\\tSM:${sample_id}\\tPL:ILLUMINA" \
        ${reference} \
        ${r1} \
        ${r2} \
        > ${sample_id}.sam
    """
}