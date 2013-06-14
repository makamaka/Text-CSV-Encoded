
use strict;
use utf8;
use Text::CSV::Encoded coder_class => 'Text::CSV::Encoded::Coder::EncodeGuess';

my $csv  = Text::CSV::Encoded->new;


$csv->encoding( ['shiftjis', 'euc-jp'] ); # guessing euc-jp or shiftjis?
$csv->encoding_out('shiftjis');

my @fields = ( Encode::encode('euc-jp', 'これはEUC-JP'), Encode::encode('shiftjis', 'これはShift_JIS') );

ok( $csv->combine( @fields ) );

is( $csv->string, Encode::encode( 'shiftjis', '"これはEUC-JP","これはShift_JIS"' ) );


$csv->encoding_to_parse( ['shiftjis', 'euc-jp'] ); # guessing euc-jp or shiftjis?
$csv->encoding( undef );

ok( $csv->parse( Encode::encode('euc-jp', 'これはEUC-JP') ) );
is( join('', $csv->fields), 'これはEUC-JP' );


ok( $csv->parse( Encode::encode('shiftjis', 'これはShift_JIS') ) );
is( join('', $csv->fields), 'これはShift_JIS' );


$csv->encoding( ['utf-8', 'cp1252'] );
$csv->encoding_out( 'utf-8' );
ok( $csv->combine(map {Encode::encode('utf-8', $_)} qw(cow says… möo)) );
is( $csv->string, Encode::encode('utf-8', 'cow,"says…",möo'));

1;

