#!/usr/bin/perl

# By Matt Ciocchi.
# Credit for rsync itself and many thanks go to everyone over at rsync.samba.org
#
# Sample invocation:
# ./utils/rsync_automatic.pl example 1
#
# Notes:
# ARGV[0] chooses a config from the confighandler.
# Script will fail safe and execute in debugmode by default unless ARGV[1] is true.
# This is done to avoid accidental destructive behavior from the rsync --delete flag.

use strict;
use warnings;
use Data::Dumper;
use lib::logger;
use lib::config::example;
use lib::rsync_wrapper_lockfile;

# New configurations are mapped here. Replace 'example' with your own configuration.
my $confighandler = {
    'example' => $lib::config::example::config
};

my $app = $confighandler->{$ARGV[0]} || die("Failed to initialize config from \$ARGV[1]: $ARGV[1]");
$app->{nodebugmode} = $ARGV[1];
my $logger = new lib::logger(logfile => $app->{script_logfile});
$logger->log("Initialized config:");
my $config = Dumper($app);
$logger->log($config);

unless ($app->{day_of_week}) {
    $logger->log_and_die( "Could not get date.\n");
}

unless ($ENV{'HOME'} =~ 'root') {
    $logger->log_and_die("User is not root, will not run.");
}

# Do not attempt to stat remote directories:
unless (-e "$app->{source}") {
    if (! &remote($app->{source})) {
	$logger->log_and_die("Cannot stat source $app->{source}");
    }
}

unless (-d "$app->{destination}") {
    if (! &remote($app->{destination})) {
	$logger->log_and_die("Cannot stat destination $app->{destination}");
    }
}

if ($app->{nodebugmode}) {
    $logger->log("Beginning rsync backup.");
    my $rwl = new lib::rsync_wrapper_lockfile(
	logfile => $app->{script_logfile},
	args => $app->{args}
	);
    $logger->log($rwl->exec());
    $logger->log("Finished rsync backup.\n\n");
} else {
    $logger->log("Debugmode: skipped rsync backup");
    $logger->log("Finished")
}

# Parse rsync command to determine if directory is remote:
sub remote {
    my $dir = shift(@_);
    my $result = 0;
    if ($dir =~ m/\:/) {
	$result = 1;
    }    
    return $result;
}
