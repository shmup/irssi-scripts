# rakudiscord.pl
# Rename the <raku-discord-bot> to the <discord_nick>

use strict;
use vars qw($VERSION %IRSSI);
use Irssi;

$VERSION = '1.00';
%IRSSI = (
  authors     => 'Jared Miller <shmup>',
  contact     => 'jared@smell.flowers',
  name        => 'raku-discord-bot-renamer',
  description => 'Replace <discord-raku-bot> with <$discord_nick>',
  license     => 'Artistic-2.0',
  url         => 'https://github.com/shmup/irssi-scripts',
  changed     => '2023-02-22',
);

my @channels = ("#raku", "#raku-dev", "#raku-beginner", "#moarvm", "#webring");

sub rename_nick {
  my ($server, $data, $nick, $address, $target) = @_;
  my ($channel, $msg) = split(/ :/, $data, 2);
  my $oldnick = $nick;

  for (@channels) {
    if ($_ eq $channel) {
      if ($nick eq "discord-raku-bot") {
        my ($discord, $txt) = $msg =~ /^<(.*)>\s(.*)/;

        # fail safe
        if ($oldnick eq $discord) { continue };

        Irssi::signal_emit("event privmsg", $server, "$channel :$txt", $discord, $address, $target);
        Irssi::signal_stop();
      }
    }
  }
}

Irssi::signal_add('event privmsg', 'rename_nick');
