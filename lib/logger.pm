#!/usr/bin/perl
use DateTime;
use strict;
use warnings;
use File::Basename;

package lib::logger;

sub new {
    my $class = shift(@_);
    my %params = @_;
    my $self = {};    
    $self->{logfile} = $params{logfile};
    bless($self, $class);
    return $self
}

sub log {
    my $self = shift(@_);
    my $msg = shift(@_) || "";
    my $dt = DateTime->now(
	# Make sure to adjust this to current time zone.
	time_zone => 'EST',
	);
    $dt .= " | ";
    $dt .= File::Basename::basename($0);
    $dt .= " | $msg";

    if ($self->{logfile}) {
	open(my $logfile, '>>', $self->{logfile}) or die "Could not open $self->{logfile}.";
	print($logfile "$dt\n");
 	print("$dt\n");
	close($logfile);
    } else {
	my $err  = "";
	$err .= DateTime->now( time_zone => 'EST');
	$err .= " | $msg";
	print($err);
    }
}

sub log_and_die {
    my $self = shift(@_);
    my $msg = shift(@_) || "";
    &log($self, $msg);
    die($msg);
}

return 1;
