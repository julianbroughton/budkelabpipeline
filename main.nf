// Define Nextflow pipeline

// Step 1.0: Define input variables
params.rawReadsDir = "path_to_raw_reads_directory"
params.sampleIDFile = "path_to_sampleID.txt"

// Step 1.1: Decompress raw read files
process decompress {
    tag "Decompress raw reads"
    script:
    """
    gunzip ${params.rawReadsDir}/*.cdgz
    """
}

// Step 1.2: Run trim_galore on raw reads
process trim_galore {
    tag "Trim raw reads"
    input:
    file('sampleID.txt') from params.sampleIDFile
    file(read) from decompress.out

    script:
    """
    perl trimSubmit.pl ${read}
    """
}

// Step 1.3: Check and install dependencies
process check_dependencies {
    tag "Check and install dependencies"
    script:
    """
    pip install cutadapt
    curl -O 'https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip'
    unzip fastqc_v0.11.9.zip
    cutadapt --version
    perl FastQC/fastqc -v
    curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/0.6.6.tar.gz -o trim_galore.tar.gz 
    tar xvzf trim_galore.tar.gz
    """
}

// Step 1.4: Navigate to step 1 files
process navigate_files {
    tag "Navigate to step 1 files"
    script:
    """
    cd Documents/FissidensAnalyses2022_10_18/GoFlag_PipelineTemplate/A01_trimmedReads
    """
}

// Step 1.5: Run Perl script
process run_perl_script {
    tag "Run Perl script"
    script:
    """
    perl trimSubmitUTKData.pl
    """
}

// Define workflow
workflow {
    // Run processes sequentially
    decompress => trim_galore => check_dependencies => navigate_files => run_perl_script
}
