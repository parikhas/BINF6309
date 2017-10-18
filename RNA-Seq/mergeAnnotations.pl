#!/bin/perl
use Bio::SearchIO;
use Bio::Search::Result::GenericResult;
use Data::Dumper;
use Bio::SeqIO;

open( $tsvfile, ">", "aipSwissProt.tsv" ) or die $!;

print $tsvfile("Trinity","\t","SwissProt","\t","SwissProtDesc","\t","eValue","\n");

my $blastXml = Bio::SearchIO->new(
	-file   => 'Trinity-GG.blastp.xml',
	-format => 'blastxml'
);

while ( my $result = $blastXml->next_result() ) {
	my $queryDesc = $result->query_description;
	if ( $queryDesc =~ /::(.*?)::/ ) {
		my $queryDescShort = $1;
		my $hit            = $result->next_hit;
		if ($hit) {
			print $tsvfile ( $queryDescShort,"\t");
			print $tsvfile ( $hit->accession,"\t");
			my $subjectDescription = $hit->description;
			if ( $subjectDescription =~ /Full=(.*?);/ ) {
				$subjectDescription = $1;
			}
			if ( $subjectDescription =~ /Full=(.*?)\[/ ) {
				$subjectDescription = $1;
			}
			print $tsvfile ($subjectDescription,"\t");
			print $tsvfile ($hit->significance,"\n");
		}
	}
}
