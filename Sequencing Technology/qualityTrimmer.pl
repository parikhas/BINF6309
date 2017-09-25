#!/usr/bin/perl
use warnings;
use strict;

use Bio::SeqIO;
use Bio::Seq::Quality;
use Getopt::Long;
use Pod::Usage;

#GLOBALS
my $left        = '';
my $right       = '';
my $interleaved = '';
my $qual        = 0;
my $usage       = "\n$0 [options]\n
Options:
	-left		left reads
	-right		Right reads
	-qual		Quality score minimun
	-help		Show this message
\n";

GetOptions(
	'left=s'        => \$left,
	'right=s'       => \$right,
	'interleaved=s' => \$interleaved,
	'qual=i'        => \$qual,
	help            => sub { pod2usage($usage); },
) or pod2usage(2);

unless ( $left and $right and $qual and $interleaved ) {
	unless ($left) {
		print "Specify file for left reads\n";
	}
	unless ($right) {
		print "Specify file for right reads\n";
	}
	unless ($interleaved) {
		print "Specify file for interleaved output\n";
	}
	unless ($qual) {
		print "Specify quality score cutoff\n", $usage;
	}
	die $usage;
}

#uses bioperl to read the first input file(Sample.R1.fastq)
my $seq_left = Bio::SeqIO->new(
	-file   => "$left",
	-format => "fastq"
);

#uses bioperl to read the second input file
my $seq_right = Bio::SeqIO->new(
	-file   => "$right",
	-format => "fastq"
);

#uses bioperl to write to the output file
my $seq_out = Bio::SeqIO->new(
	-file   => ">$interleaved",
	-format => "fastq"
);
#loop through the two input files and take pair-wise sequences; first from the R1 file, then from R2 and so on till the end
while ( my $seq_obj1 = $seq_left->next_seq() ) {
	#get the longest subsequence that has quality values above 20
	my $leftTrimmed = $seq_obj1->get_clear_range( $qual - 1 );
	#copy the description from $seq_obj1 to $leftTrimmed
	$leftTrimmed->desc( $seq_obj1->desc() );
	#write the result to the output file
	$seq_out->write_seq($leftTrimmed);
	my $seq_obj2     = $seq_right->next_seq();
	my $rightTrimmed = $seq_obj2->get_clear_range( $qual - 1 );
	$rightTrimmed->desc( $seq_obj2->desc() );
	$seq_out->write_seq($rightTrimmed);
}
