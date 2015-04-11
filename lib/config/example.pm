package lib::config::example;
use DateTime;

our $config = {};
$config->{backup_dir_location} = "/media/user/backup/rsync_automatic/rsync/full/daily/";
$config->{logfile_dir} = "/var/log/rsync_automatic/";
$config->{day_of_week} = DateTime->now()->day_of_week();
$config->{command_logfile} = "$config->{logfile_dir}rsync.$config->{day_of_week}.log";
$config->{script_logfile} = "$config->{logfile_dir}script.$config->{day_of_week}.log";
$config->{source} = "/";
$config->{destination} = "$config->{backup_dir_location}$config->{day_of_week}/";
$config->{excludefile} = "/home/user/backup_excludes.list";
$config->{args} = " -ah --partial --delete --delete-excluded --exclude-from=$config->{excludefile} --log-file=$config->{command_logfile} $config->{source} $config->{destination}";
