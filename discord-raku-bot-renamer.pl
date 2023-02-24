# discord-raku-bot-renamer.pl
# Replace `<discord-raku-bot> <nick>` with `<nick>`

# Place this in your $HOME/.irssi/scripts/
# You can load with: /script load discord-raku-bot-renamer
# If you place this in /scripts/autorun/ then it'll start on launch.
# https://irssi.org/documentation/help/script/

use strict;
use vars qw($VERSION %IRSSI);
use Irssi;

$VERSION = '1.03';
%IRSSI   = (
  authors     => 'Jared Miller <shmup>',
  contact     => 'jared@smell.flowers',
  name        => 'discord-raku-bot-renamer',
  description => 'Replace `<discord-raku-bot> <nick>` with `<nick>`',
  license     => 'Artistic-2.0',
  url         => 'https://github.com/shmup/irssi-scripts',
  changed     => '2023-02-24',
);

my @channels = ("#raku", "#raku-dev", "#raku-beginner", "#moarvm", "#webring");

sub rename_botnick {
  my ($server, $data, $nick, $address, $target) = @_;
  if ($nick ne "discord-raku-bot") {return}; # not a bot

  my ($channel, $msg) = split(/ :/, $data, 2);
  if (!grep($channel, @channels)) {return}; # wrong channel

  my ($discord, $txt) = $msg =~ /^<(.*)>\s(.*)/;
  if ($discord eq "" or $txt eq "") {return}; # no reason to do anything

  Irssi::signal_emit(
    "event privmsg",
    $server,  "$channel :$txt",
    $discord, $address, $target
  );
  Irssi::signal_stop();
}

print CLIENTCRAP "Loaded $IRSSI{'name'} v$VERSION";
Irssi::signal_add('event privmsg', 'rename_botnick');
