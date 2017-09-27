#!/usr/bin/perl
use warnings;
use strict;

use Bio::Seq;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;

#GLOBALS
my $fastaIn    = '';
my $outputfile = '';
my $usage      = "\n$0 [options]\n

Options:
	-inputfile		inputfile reads
	-help		Show this message
\n";

GetOptions(
	'fastaIn =s'   => \$fastaIn,
	'outputfile=s' => \$outputfile,
	help           => sub { pod2usage($usage); },
) or pod2usage(2);

unless ( -e $fastaIn and $outputfile ) {
	unless ( -e $fastaIn ) {
		print "Specify file for input\n";
	}

	unless ( -e $outputfile ) {
		print "Specify file for output\n";
	}

	die $usage;
}

#uses bioperl to read the input file
my $seqio_obj_in = Bio::SeqIO->new(
	-file   => "$fastaIn",
	-format => "fasta"
);

#uses bioperl to write to the outputfile
my $seqio_obj_out =
  Bio::SeqIO->new( -file => ">$outputfile", -format => "fasta" );

#hash to store kmers
my %kMerHash = ();

#hash to store occurrences of last 12 positions
my %last12Counts = ();

#reads the input file by each sequence
while ( my $seq_obj = $seqio_obj_in->next_seq() ) {
	my $seq .= $seq_obj->seq();
	processkmers( \$seq );
}

#subroutine to contain the for loop to increment the starting position of the sliding window
#starts at position zero; doesn't move past end of file; advance the window by step size
sub processkmers {
	my ($sequence) = @_;

	#declare scalars to characterize sliding window
	#Set the size of the sliding window
	my $windowSize = 21;

	#Set the step size
	my $stepSize = 1;

	#Set the sequence length
	my $seqLength = length($$sequence);
	for (
		my $windowStart = 0 ;
		$windowStart <= ( $seqLength - $windowSize ) ;
		$windowStart += $stepSize
	  )
	{

#Get a 21-mer substring from sequenceRef starting at the window start for length $windowStart
#getsequence();
		my $crisprSeq = substr( $$sequence, $windowStart, $windowSize );

#if the 21-mer ends in GG, create a hash with key=last 12 of k-mer and value is 21-mer
#Regex where $1 is the crispr, and $2 contains the last 12 of crispr.
		if ( $crisprSeq =~ /([ATGC]{9}([ATGC]{10}GG))$/ ) {

			#Put the crispr in the hash with last 12 as key, full 21 as value.
			$kMerHash{$2} = $1;
			$last12Counts{$2}++;

		}

	}
}

#Initialize the CRISPR count to zero
my $crisprCount = 0;

#Loop through the hash of last 12 counts
for my $last12Seq ( sort ( keys %last12Counts ) ) {

	#Check if count == 1 for this sequence
	if ( $last12Counts{$last12Seq} == 1 ) {

		#The last 12 seq of this CRISPR is unique in the genome.
		#Increment the CRISPR count.
		$crisprCount++;

#Put the results obtained into the object which stores it and specify the format
		my $seq_obj = Bio::Seq->new(
			-seq        => $kMerHash{$last12Seq},
			-desc       => "CRISPR",
			-display_id => "crispr_$crisprCount",
			-alphabet   => "dna"
		);

		#Write the $seq_obj to the output file
		$seqio_obj_out->write_seq($seq_obj);

	}
}
