// Define Nextflow pipeline parameters
params.rawReadsDir = "path_to_raw_reads_directory"
params.sampleIDFile = "path_to_sampleID.txt"

// Combined process for handling raw reads
process handle_raw_reads {
    tag "Handle raw reads"
    input:
    file('sampleID.txt') from params.sampleIDFile

    script:
    """
    gunzip ${params.rawReadsDir}/*.cdgz
    perl trimSubmit.pl ${params.rawReadsDir}/*.fastq
    """
}

// Process for checking and installing dependencies and navigating files
process setup_environment {
    tag "Setup environment"
    script:
    """
    pip install cutadapt
    curl -O 'https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip'
    unzip fastqc_v0.11.9.zip
    cutadapt --version
    perl FastQC/fastqc -v
    cd Documents/FissidensAnalyses2022_10_18/GoFlag_PipelineTemplate/A01_trimmedReads
    perl trimSubmitUTKData.pl
    """
}

// Define workflow
workflow {
    handle_raw_reads => setup_environment
}
