#!/usr/bin/env nextflow

params.inputDir = 'input_data'
params.outputDir = 'output_data'
params.adapters = 'adapters.fasta' // Provide path to your adapter sequences file
params.reads = '*.fastq.gz' // Adjust this pattern according to your input files

process cutadapt {
    tag "Cutadapt"
    
    input:
    file(reads) from inputDir
    
    output:
    file "${outputDir}/${reads.baseName}_trimmed.fastq" into trimmed_reads
    
    script:
    """
    cutadapt -a file:${adapters} -o ${outputDir}/${reads.baseName}_trimmed.fastq ${reads}
    """
}

workflow {
    cutadapt(inputDir)
}
