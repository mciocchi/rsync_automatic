#!/usr/bin/perl

package lib::rsync_wrapper_lockfile;

use strict;
use warnings;
use Proc::PID::File;
use lib::logger;

sub new {
    my $class = shift(@_);
    my %params = @_;
    my $self = {};    
    $self->{args} = $params{args};
    $self->{logfile} = $params{logfile};
    $self->{logger} = new lib::logger(logfile => $self->{logfile});
    bless($self, $class);
    return $self
}

sub check_for_locks {
    my $self = shift(@_);
    if ( glob("/var/run/*rsync*")) {
	$self->{logger}->log_and_die("Other rsync lockfile found in /var/run/ dieing\n\n");
    } else {
	print("No other rsync processes found, executing\n");
	Proc::PID::File->running();
    }
}

sub exec {
    my $self = shift(@_);
    unless ($ENV{'HOME'} =~ 'root') {
	$self->{logger}->log_and_die->("User is not root, will not run.");
    }

    &check_for_locks($self);

    my $rsync_command = "rsync";
    $rsync_command .= $self->{args};
    $self->{logger}->log("executing \$rsync_command \"$rsync_command\"");
    $self->{logger}->log(system($rsync_command));

    if ($?) {
	$self->{logger}->log_and_die("rsync returned error code $? dieing");
    } else {
	$self->{logger}->log("finished rsync, no errors detected.");
    }
}

return 1
