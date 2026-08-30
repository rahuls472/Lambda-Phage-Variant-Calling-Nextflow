# 🧬 Nextflow Lambda Phage Variant Calling Pipeline

A modular and reproducible **Nextflow DSL2** pipeline for **paired-end NGS variant calling** using Docker containers.

The workflow starts with paired-end FASTQ files and performs quality control, read trimming, alignment, BAM processing, duplicate marking, BAM indexing, and variant calling using **GATK HaplotypeCaller**.

The pipeline is designed to be **dynamic**, meaning users can provide their own input reads, reference genome, and output directory directly through command-line parameters.

This project demonstrates practical bioinformatics workflow development using **Nextflow DSL2, Docker, Linux, and NGS analysis tools**.

---

## 🚀 Features

- Paired-end sequencing support
- Dynamic command-line input parameters
- Nextflow DSL2 workflow
- Modular pipeline architecture
- Docker-based reproducible execution
- Automatic reference genome indexing
- FASTQC quality control
- FASTP read trimming
- Post-trimming quality evaluation
- BWA-MEM sequence alignment
- SAM to BAM conversion
- BAM sorting
- Duplicate marking
- BAM indexing
- Variant calling using GATK HaplotypeCaller
- Custom output directory support
- Resume support using `-resume`
- Easily extendable workflow design

---

## 🧬 Pipeline Overview

The pipeline performs the following analysis steps:

```text
                         Reference Genome
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
           BWA Index        FASTA Index    Sequence Dictionary
              │                 │                 │
              └─────────────────┼─────────────────┘
                                │
                                ▼
                        Reference Bundle
                                │
                                │
Paired-End FASTQ Reads          │
          │                     │
          ▼                     │
       FASTQC                   │
          │                     │
          ▼                     │
       FASTP ───────────────────┤
          │                     │
          ├──────────────► Re-FASTQC
          │
          ▼
     BWA-MEM Alignment
          │
          ▼
      SAM → BAM
          │
          ▼
      BAM Sorting
          │
          ▼
    MarkDuplicates
          │
          ▼
       BAM Index
          │
          ▼
 GATK HaplotypeCaller
          │
          ▼
          VCF
```

## 📊 Workflow DAG

The following DAG represents the Nextflow workflow architecture:

The workflow includes parallel execution of:

- Reference indexing
- FASTA indexing
- Sequence dictionary generation
- Initial quality control
- Read trimming
- Post-trimming quality control

These processes are connected automatically by Nextflow according to their dependencies.

## 🛠️ Tools Used

| Tool | Purpose |
|---|---|
| Nextflow DSL2 | Workflow management |
| Docker | Containerized execution |
| FastQC | Sequencing quality assessment |
| fastp | Read trimming and filtering |
| BWA-MEM | Sequence alignment |
| SAMtools | BAM processing and indexing |
| Picard | Duplicate marking |
| GATK | Variant calling using HaplotypeCaller |

## 📁 Project Structure

```text
Lambda-Phage-Variant-Calling-Nextflow/
│
├── modules/
│   ├── alignment.nf
│   ├── bam_index.nf
│   ├── dict_making.nf
│   ├── faidx.nf
│   ├── fastp.nf
│   ├── fastqc.nf
│   ├── file_conversion.nf
│   ├── haplotypecaller.nf
│   ├── index.nf
│   ├── markduplicate.nf
│   └── samtool_sort.nf
│
├── screenshots/
│
├── PipelineDag.png
│
├── main.nf
├── nextflow.config
├── README.md
└── .gitignore
```

> **Note:** Users do not need to place sequencing data or reference genomes inside the repository. Input files can be stored anywhere on the system and provided dynamically through command-line parameters.

## ⚙️ Requirements

The following software must be installed:

- Java
- Nextflow
- Docker

The bioinformatics tools used by the pipeline are executed through Docker containers.

### ☕ Install Java

Nextflow requires Java.

Check whether Java is installed:

```bash
java -version
```

If Java is not installed on Ubuntu:

```bash
sudo apt update
sudo apt install default-jdk
```

Verify the installation:

```bash
java -version
```

### 🌊 Install Nextflow

Install Nextflow:

```bash
curl -s https://get.nextflow.io | bash
```

Move it to your system PATH:

```bash
sudo mv nextflow /usr/local/bin/
```

Check the installation:

```bash
nextflow -version
```

### 🐳 Install Docker

Install Docker on Ubuntu:

```bash
sudo apt update
sudo apt install docker.io
```

Start Docker:

```bash
sudo systemctl start docker
```

Enable Docker to start automatically:

```bash
sudo systemctl enable docker
```

Check Docker:

```bash
docker --version
```

Test Docker:

```bash
docker run hello-world
```

### 🔐 Run Docker Without sudo

To avoid typing `sudo` before every Docker command:

```bash
sudo usermod -aG docker $USER
```

After running this command, log out and log back in.

Then test:

```bash
docker ps
```

## 📥 Clone the Repository

Clone the repository:

```bash
git clone https://github.com/rahuls472/Lambda-Phage-Variant-Calling-Nextflow.git
```

Move into the project directory:

```bash
cd Lambda-Phage-Variant-Calling-Nextflow
```

## 📥 Input Requirements

The pipeline requires:

- Paired-end FASTQ files
- A reference genome in FASTA format
- An output directory

The input files can be stored anywhere on your computer.

### 🧬 Paired-End FASTQ Files

The pipeline uses Nextflow's `Channel.fromFilePairs()` to identify paired-end sequencing reads.

Your reads should follow a consistent naming convention.

For example:

```text
sample_1.fastq
sample_2.fastq
```

Or:

```text
sample_R1.fastq
sample_R2.fastq
```

For multiple samples:

```text
sample1_1.fastq
sample1_2.fastq

sample2_1.fastq
sample2_2.fastq
```

The input pattern should match your FASTQ naming convention.

For example:

```text
--input '/path/to/reads/*_{1,2}.fastq'
```

If your files are compressed:

```text
sample_1.fastq.gz
sample_2.fastq.gz
```

You can use:

```text
--input '/path/to/reads/*_{1,2}.fastq.gz'
```

### 🧬 Reference Genome

The reference genome must be provided in FASTA format.

For example:

```text
lambda_reference.fasta
```

The reference genome can be stored anywhere on your system.

Example:

```text
/home/user/reference/lambda_reference.fasta
```

The pipeline automatically generates the required reference files, including:

- BWA index
- FASTA index
- Sequence dictionary

These files are combined into a reference bundle used by downstream processes.

## 🚀 Running the Pipeline

The pipeline is completely dynamic.

Users provide their own:

- Input reads
- Reference genome
- Output directory

through command-line parameters.

### Basic Usage

```bash
nextflow run main.nf \
    --input '/path/to/reads/*_{1,2}.fastq' \
    --reference '/path/to/reference.fasta' \
    --output '/path/to/output_directory'
```

> **Note:** Running `nextflow run main.nf` with no parameters is no longer the correct usage for this pipeline. `--input`, `--reference`, and `--output` must be supplied so the workflow can locate your data instead of relying on files bundled in the repository.

## 🧪 Example Command

For example:

```bash
nextflow run main.nf \
    --input '/home/user/NGS_reads/*_{1,2}.fastq' \
    --reference '/home/user/reference/lambda_reference.fasta' \
    --output '/home/user/variant_results'
```

The sequencing data does not need to be copied into the project directory.

The pipeline can access files from any valid location on your system.

## ⚙️ Pipeline Parameters

| Parameter | Description |
|---|---|
| `--input` | Path pattern for paired-end FASTQ files |
| `--reference` | Path to the reference genome FASTA file |
| `--output` | Directory where pipeline results will be saved |

## 📂 Example Input Location

Your files can be organized outside the repository.

For example:

```text
NGS_Data/
│
├── sample_1.fastq
└── sample_2.fastq
```

Reference directory:

```text
Reference/
│
└── lambda_reference.fasta
```

You can then run:

```bash
nextflow run main.nf \
    --input '/path/to/NGS_Data/*_{1,2}.fastq' \
    --reference '/path/to/Reference/lambda_reference.fasta' \
    --output '/path/to/results'
```

## 🔄 Resume a Pipeline Run

If the pipeline stops because of an error or interruption, Nextflow can reuse successfully completed processes.

Run:

```bash
nextflow run main.nf \
    --input '/path/to/reads/*_{1,2}.fastq' \
    --reference '/path/to/reference.fasta' \
    --output '/path/to/output_directory' \
    -resume
```

Nextflow will reuse cached results instead of running completed processes again.

This can save significant computational time.

## 📤 Output

The output directory is defined by the user using:

```text
--output '/path/to/output_directory'
```

Depending on the `publishDir` configuration in the pipeline modules, results may include directories such as:

```text
results/
│
├── fastqc/
│   ├── FastQC reports
│   └── HTML reports
│
├── fastp/
│   ├── Trimmed FASTQ files
│   ├── JSON report
│   └── HTML report
│
├── refastqc/
│   ├── Post-trimming FastQC reports
│   └── HTML reports
│
├── alignment/
│   └── Alignment files
│
├── bam/
│   └── BAM files
│
├── sorted_bam/
│   └── Sorted BAM files
│
├── markduplicate/
│   ├── Duplicate-marked BAM files
│   └── Duplicate metrics
│
├── bam_index/
│   └── BAM index files
│
├── reference/
│   ├── BWA index files
│   ├── FASTA index
│   └── Sequence dictionary
│
└── haplotypecaller/
    └── Variant VCF files
```

The exact output structure depends on the `publishDir` configuration of the individual Nextflow modules.

## 🧬 Final Variant Calling Output

The final variant calling step uses **GATK HaplotypeCaller**.

The primary output is a VCF file containing detected genetic variants.

Example:

```text
sample_variants.vcf
```

The VCF file can contain information about:

- SNPs
- Insertions
- Deletions
- Genomic positions
- Reference alleles
- Alternate alleles
- Variant quality metrics

## 📊 Generate Nextflow Reports

Nextflow can generate useful reports describing pipeline execution.

### Execution Report

```text
-with-report execution_report.html
```

### Timeline

```text
-with-timeline execution_timeline.html
```

### Workflow DAG

```text
-with-dag PipelineDag.png
```

Example:

```bash
nextflow run main.nf \
    --input '/path/to/reads/*_{1,2}.fastq' \
    --reference '/path/to/reference.fasta' \
    --output '/path/to/output_directory' \
    -with-report execution_report.html \
    -with-timeline execution_timeline.html \
    -with-dag PipelineDag.png
```

## 🧩 Workflow Design

The pipeline follows a modular architecture.

Each bioinformatics tool is implemented as an independent Nextflow module.

```text
main.nf
│
├── index.nf
├── faidx.nf
├── dict_making.nf
├── fastqc.nf
├── fastp.nf
├── alignment.nf
├── file_conversion.nf
├── samtool_sort.nf
├── markduplicate.nf
├── bam_index.nf
└── haplotypecaller.nf
```

This architecture makes the workflow easier to:

- Maintain
- Debug
- Modify
- Extend
- Reuse
- Scale

## 🐳 Docker-Based Execution

The pipeline uses Docker containers for reproducible execution.

Instead of manually installing every bioinformatics tool and managing software dependencies, Nextflow runs the configured tools inside containers.

This provides:

- Reproducibility
- Dependency isolation
- Easier installation
- Consistent software environments
- Improved portability

The Docker configuration is defined in `nextflow.config`.

## ⚡ Parallel Execution

Nextflow automatically manages process dependencies and parallel execution.

For example, the following processes can run independently:

- Reference indexing
- FASTA indexing
- Sequence dictionary creation
- Initial FASTQC analysis

This improves workflow efficiency and makes better use of available computational resources.

## 🛡️ Input Validation

The pipeline should validate required parameters before execution.

Users must provide:

- `--input`
- `--reference`

The output directory defaults to `results` if no custom output directory is provided.

The pipeline should also verify that:

- Input FASTQ files exist
- Paired-end files are correctly matched
- The reference genome exists
- Required parameters are provided

## 📈 Example Workflow

```text
Raw Paired-End Reads
        │
        ▼
      FASTQC
        │
        ▼
      FASTP
        │
        ├──────────► Re-FASTQC
        │
        ▼
   BWA-MEM Alignment
        │
        ▼
     SAM → BAM
        │
        ▼
     BAM Sorting
        │
        ▼
   MarkDuplicates
        │
        ▼
     BAM Index
        │
        ▼
GATK HaplotypeCaller
        │
        ▼
       VCF
```

## 🧪 Example Results

The pipeline can generate:

- Raw read quality reports
- Trimmed FASTQ files
- Post-trimming quality reports
- Alignment files
- BAM files
- Sorted BAM files
- Duplicate-marked BAM files
- BAM index files
- Variant Calling Format (VCF) files

## 🚧 Future Improvements

Possible future improvements include:

- MultiQC integration
- Variant filtering
- Variant annotation using SnpEff
- Variant annotation using VEP
- BCFtools statistics
- Variant quality filtering
- Support for multiple samples
- Multi-sample variant calling
- Joint genotyping
- HPC execution profiles
- Cloud deployment
- AWS execution support
- CI/CD testing
- Automated pipeline testing
- nf-core compatible structure

## 🎓 Learning Objectives

This project demonstrates practical experience with:

- Nextflow DSL2
- Bioinformatics workflow development
- NGS data analysis
- Docker containers
- Linux
- Modular pipeline architecture
- FASTQ quality control
- Read trimming
- Sequence alignment
- BAM processing
- Duplicate marking
- Reference genome preparation
- GATK variant calling
- Workflow reproducibility

## 🔬 Technologies Used

- Nextflow DSL2
- Docker
- Java
- Linux
- FastQC
- fastp
- BWA
- SAMtools
- Picard
- GATK

## ⚠️ Important Notes

- Docker must be installed and running before executing the pipeline.
- Nextflow requires Java.
- Input FASTQ files must be correctly paired.
- The input pattern must match the naming convention of your FASTQ files.
- The reference genome must be provided in FASTA format.
- Users should have read permission for input files.
- Users should have write permission for the selected output directory.
- Interrupted workflows can be resumed using `-resume`.

## 🔁 Reproducibility

The pipeline improves reproducibility through:

- Nextflow DSL2
- Docker containers
- Modular workflow design
- Dynamic input parameters
- Automatic dependency management
- Nextflow caching
- Resume functionality

The same workflow can therefore be executed on different systems with a consistent analysis structure.

## 🤝 Contributing

Contributions, suggestions, and improvements are welcome.

You can contribute by:

- Reporting bugs
- Suggesting improvements
- Adding new modules
- Improving documentation
- Extending downstream analysis

## 👨‍💻 Author

**Rahul Kumar Singh**

M.Sc. Bioinformatics

GitHub: [rahuls472](https://github.com/rahuls472)

## 📄 License

This project is released under the MIT License.

## 🙏 Acknowledgements

This pipeline uses open-source bioinformatics software and workflow technologies including:

- Nextflow
- Docker
- FastQC
- fastp
- BWA
- SAMtools
- Picard
- GATK

⭐ If you find this project useful, consider giving the repository a star!
