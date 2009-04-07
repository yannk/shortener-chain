#/usr/bin/perl
use warnings;
use strict;
use CPANPLUS::Backend;
use WWW::Shorten;

my @urls = ();
my $url = shift or die "usage: $0 <url>";

my $cb = CPANPLUS::Backend->new();
#warn Dump [$cb->search( type => 'module', allow => [ qr/^WWW::Shorten/ ])];
for my $pkg (grep { /^WWW::Shorten::/ } map { $_->module } $cb->installed) {
    no strict 'refs';
    eval "use $pkg";
    if ($@) {
        next;
    }
    my $meth = *{ "$pkg\::makeashorterlink" };
    my $new_url = eval {
        $meth->($url);
    };
    if ($@) {
        warn "Error making a short with $pkg: $@";
        next;
    }
    next unless $new_url;
    push @urls, $url;
    $url = $new_url;
}
print join "\n", reverse @urls;
print "\n";
