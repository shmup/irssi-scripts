# rakudiscord.pl
# Replace `<raku-discord-bot> <nick>` with `<nick>`

# Place this in your $HOME/.irssi/scripts/
# You can load with: /script load raku-discord-bot-renamer
# If you place this in /scripts/autorun/ then it'll start on launch.
# https://irssi.org/documentation/help/script/

use strict;
use vars qw($VERSION %IRSSI);
use Irssi;

$VERSION = '1.02';
%IRSSI = (
  authors     => 'Jared Miller <shmup>',
  contact     => 'jared@smell.flowers',
  name        => 'raku-discord-bot-renamer',
  description => 'Replace `<discord-raku-bot> <nick>` with `<nick>`',
  license     => 'Artistic-2.0',
  url         => 'https://github.com/shmup/irssi-scripts',
  changed     => '2023-02-24',
);

my @channels = ("#raku", "#raku-dev", "#raku-beginner", "#moarvm", "#webring");

sub rename_botnick {
  my ($server, $data, $nick, $address, $target) = @_;
  if ($nick ne "discord-raku-bot") { return }; # not a bot

  my ($channel, $msg) = split(/ :/, $data, 2);
  if (!grep($channel, @channels)) { return }; # wrong channel

  my ($discord, $txt) = $msg =~ /^<(.*)>\s(.*)/;
  if ($discord eq "") { return }; # something goofy. pattern didn't match

  Irssi::signal_emit("event privmsg", $server, "$channel :$txt", $discord, $address, $target);
  Irssi::signal_stop();
}

Irssi::signal_add('event privmsg', 'rename_botnick');
