process CREATE_BARCODE_DIR {
    tag "$meta.alias"
    label 'process_low'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ubuntu:24.04':
        'quay.io/nf-core/ubuntu:24.04' }"

    input:
    tuple val(meta), path(fastq_list)

    output:
    tuple val(meta), path("{barcode??,unclassified}"), emit: barcode_dir
    path "versions.yml"                              , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.alias}"
    """
    mkdir -p ${meta.alias}

    mv $fastq_list ${meta.alias}/.

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sed: \$(echo \$(sed --version 2>&1) | sed 's/^.*GNU sed) //; s/ .*\$//')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.alias}"
    """
    mkdir -p barcode01
    echo " " > test_1.fastq
    echo " " > test_2.fastq
    mv test_1.fastq test_2.fastq barcode01/.

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sed: \$(echo \$(sed --version 2>&1) | sed 's/^.*GNU sed) //; s/ .*\$//')
    END_VERSIONS
    """
}
