# NAME

reniced - renice running processes based on regular expressions

# SYNOPSIS

**reniced**
\[**-h**\]
\[**-v**\]
\[**-o** _format_\]
\[_configfile_\]

# OVERVIEW

reniced takes a list of regular expressions, looks for processes (and
threads) matching them and renices the processes to given values.
reniced can also change io priorities.

# DESCRIPTION

On start, reniced reads a configuration file.  It consists of nice
values and regular expressions.

It then scans the process table using the [ps(1)](http://man.he.net/man1/ps) command.
Whenever a process name from the CMD column matches a regular
expression, that process is reniced to the given value.  If a process
matches multiple regular expressions, all rule matches are executed in
order and the last match wins.

When run as root, reniced will scan all processes (`` `ps H -e` ``).
When run as a user, renice only scans the user's processes (`` `ps H --user` ``).

## Switches

- **-h**

    This prints the version number, a short help text and exits without
    doing anything.

- **-n**

    This activates no-op mode.  No actions are taken but everything that
    would be done is written to stdout.

- **-v**

    This activates verbose mode.  Error messages, some statistics and all
    renice actions are printed to stdout.

- **-o** _format_

    Set the [ps(1)](http://man.he.net/man1/ps) output format to filter on.  The default format is
    `comm`.  See the **-o** parameter in the [ps(1)](http://man.he.net/man1/ps) manpage for details.

- _configfile_

    This reads the regular expressions from an alternate configfile.

    The default location of the configfile is `/etc/reniced.conf` if reniced
    is run as root, `~/.reniced` otherwise.

## Configuration file format

The configuration file is composed of single lines.  Empty lines and
lines starting with a **#** are ignored.

Every line must consist of a command followed by a whitespace and a
Perl regular expression.

The regular expression is matched against the [ps(1)](http://man.he.net/man1/ps) output.  For
every matched process the command is executed.

A command generally takes the form of a character followed by a
number.  Multiple commands can be given simultaneously with no spaces
inbetween.  Sometimes the number is optional.  

### Command characters

- **n**

    Sets the nice value of a process.  Must be followed by a number,
    usually within the range of -20 to 19.

    For backwards compatibility a **n** at the beginning of the command can
    be left out (if the command starts with a number it is treated as a
    nice value).

- **r**

    Sets the io priority to the realtime scheduling class.  The optional
    number is treated as class data (typically 0-7, lower being higher
    priority).

- **b**

    Sets the io priority to the best-effort scheduling class.  The
    optional number is treated as class data (typically 0-7, lower being
    higher priority).

- **i**

    Sets the io priority to the idle scheduling class.  No number needs to
    be given as the idle scheduling class ignores the class data value.

- **o**

    Sets the OOM killer adjustment in `/proc/$PID/oom_adj` to the given
    number.  (Internally, `/proc/$PID/oom_score_adj` will be used when
    available, but for backwards compatibility this value is still
    expected the in old `oom_adj` format and will be converted
    automatically.)

### Examples

- `5 ^bash`

    gives currently running bash shells a nice value of 5

- `b2 ^tar` 

    sets currently running tar-processes to io priority best-effort within class 2

- `i torrent`

    sets currently running torrent-like applications to io priority idle

- `n-10r4 seti`

    gives currently running seti-processes a nice value of -10 and sets
    them to realtime io priority in class 4

# MODULES NEEDED

    use BSD::Resource;

This module can be obtained from [http://www.cpan.org](http://www.cpan.org).

# PROGRAMS NEEDED

    ps
    ionice

ionice is only needed if you want to change io priority.  It can be
obtained from [http://rlove.org/schedutils/](http://rlove.org/schedutils/).

You also need a suitable kernel and scheduler, e.g. Linux 2.6 with
CFQ.

# LIMITATIONS

The purpose of reniced is to renice long running server processes
(hence the **d** for daemon in it's name).

Selecting and renicing processes it not atomic: There is a small gap
between scanning the process list and renicing the processes.  If you
target short-lived processes with your regular expressions, reniced
might try to act on a process that is already gone.  In the worst case
it might renice a new process that got the same process id as the
already ended process that was matched.

# BUGS

reniced can run without the BSD::Resource module.  In this case, the
PRIO\_PROCESS is set to 0.  This works on Linux 2.6.11 i686 but it
could break on other systems.  Installing BSD::Resource is the safer
way.

Be careful using realtime priorities, don't starve other tasks.

Please report bugs to <`mitch@cgarbs.de`>.

# AUTHOR

reniced was written by Christian Garbs <`mitch@cgarbs.de`>.

# COPYRIGHT

reniced is Copyright (C) 2005, 2020 by Christian Garbs.  It is
licensed under the GNU GPL v2 or later.

# AVAILABILITY

Look for updates at [https://github.com/mmitch/reniced](https://github.com/mmitch/reniced).

# SEE ALSO

[ionice(1)](http://man.he.net/man1/ionice), [renice(1)](http://man.he.net/man1/renice), [ps(1)](http://man.he.net/man1/ps)
