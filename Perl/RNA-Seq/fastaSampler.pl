#!/usr/bin/perl
use warnings;
use strict;

#Give use statements for the modules to be used
use Bio::Seq;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;

#GLOBALS
#Add variables for the user options and assign default values
#Put variables in the usage message to display default values on -help
my $fastaIn    = 'Trinity-GG.fasta.transdecoder.pep';
my $fastaOut   = 'subset.pep';
my $sampleRate = 1000;
my $usage      = "\n$0 [options]\n

Options:
	-fastaIn    FASTA inputfile [$fastaIn]
	-fastaOut	FASTA Outputfile [$fastaOut]
	-sampleRate	Number of output files [$sampleRate]
	-help		Show this message
\n";

#Call GetOptions to retrieve the 3 options for the user to give and print the options if user enters the help option
GetOptions(
	'fastaIn=s'    => \$fastaIn,
	'fastaOut=s'   => \$fastaOut,
	'sampleRate=i' => \$sampleRate,
	help           => sub { pod2usage($usage); },
) or pod2usage($usage);

#If input file doesn't exist then print a error statement and terminate the program
if ( not( -e $fastaIn ) ) {
	die "The input $fastaIn specified by -fastIn does not exist\n";
}

#Instantiate the Bio:SeqIO to read into the input file
my $input = Bio::SeqIO->new(
	-file   => $fastaIn,
	-format => 'fasta'
);

#Instantiate the Bio:SeqIO to write into the output file
my $output = Bio::SeqIO->new(
	-file   => ">$fastaOut",
	-format => 'fasta'
);

#Initialise a counter for the number of sequences
my $seqCount = 0;
#Loop through the sequences and increment the counter for each sequence
while ( my $seq = $input->next_seq ) {
	$seqCount++;
	#Get the remainder after dividing $seqCount by $sampleRate and if it is a multiple of the sample rate,then write the sequence to the output object
	if ( ( $seqCount % $sampleRate ) == 0 ) {
		$output->write_seq($seq);
	}
}

