package Template::Plugin::IncludeFile;

use Template::Plugin::Filter;
use base qw( Template::Plugin::Filter );

sub filter {
    my $text = shift;
    $text =~ tr/a-zA-Z/n-za-mN-ZA-M/;
    return $text;
}

1;
