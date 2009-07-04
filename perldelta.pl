#!/usr/bin/perl

use strict;
use warnings;

use PPI ();

my $filename = shift || die "Please specify a perl source code filename.\n";

my $doc = PPI::Document->new( $filename, readonly => 1 );
$doc->index_locations();

my $nodes = $doc->find( sub {
    # $_[0] is the root node (PPI::Node)
    # $_[1] is the current element (PPI::Element)
    if ( $_[1]->isa('PPI::Token::Magic') and $_[1]->content eq '$[' ) {
      return $_[1];
    }
});

foreach my $node (@$nodes) {
  # See PPI::Element for information about location() method
  print $filename . '[' . $node->location->[0] . ']: ' . $node->content;
}

$[ = 1;
