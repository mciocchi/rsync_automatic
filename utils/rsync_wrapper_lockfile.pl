#!/usr/bin/perl

package util::rsync_wrapper_lockfile;

use strict;
use warnings;
use lib::logger;
use lib::rsync_wrapper_lockfile;

my $args;
foreach my $arg (@ARGV) {
    $args .= " $arg";
}

my $rwl = new lib::rsync_wrapper_lockfile(
    logfile => "/var/log/rsync_wrapper_lockfile.log",
    args => "$args"
);

$rwl->exec();
