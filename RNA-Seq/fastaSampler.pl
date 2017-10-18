#!/usr/bin/perl
use warnings;
use strict;

use Bio::Seq;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;

#GLOBALS
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

GetOptions(
	'fastaIn=s'    => \$fastaIn,
	'fastaOut=s'   => \$fastaOut,
	'sampleRate=i' => \$sampleRate,
	help           => sub { pod2usage($usage); },
) or pod2usage($usage);

if ( not( -e $fastaIn ) ) {
	die "The input $fastaIn specified by -fastIn does not exist\n";
}

my $input = Bio::SeqIO->new(
	-file   => $fastaIn,
	-format => 'fasta'
);
my $output = Bio::SeqIO->new(
	-file   => ">$fastaOut",
	-format => 'fasta'
);
my $seqCount = 0;
while ( my $seq = $input->next_seq ) {
	$seqCount++;
	if ( ( $seqCount % $sampleRate ) == 0 ) {
		$output->write_seq($seq);
	}
}

