use strict;
use warnings;
use vars qw($VERSION %IRSSI);

use Irssi;

$VERSION = '1.0';
%IRSSI = (
    authors     => 'JARED MILLER',
    contact     => 'JTMILLER@GMAIL.COM',
    name        => 'SCREAM',
    description => 'EASILY SCREAM IN IRC',
    license     => 'WTFPL',
);

sub SCREAM {
    my ($message, $server, $item) = @_;

    if (Irssi::settings_get_bool("SCREAM")) {
        $message = uc $message;
    }

    Irssi::signal_continue($message, $server, $item);
}

Irssi::signal_add("send text", \&SCREAM);
Irssi::settings_add_bool('SCREAM', 'SCREAM', 0);

print CLIENTCRAP "SCREAM.pl $VERSION loaded.";
print CLIENTCRAP "/set SCREAM on|off";
