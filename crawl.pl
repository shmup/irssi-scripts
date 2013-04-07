#!/usr/bin/env perl

use strict;
use Irssi;
use warnings;
use vars qw($VERSION %IRSSI);

$VERSION = '1.00';
%IRSSI = (
    authors     => 'Jared Tyler Miller',
    contact     => 'jtmiller@gmail.com',
    name        => 'DCSS Bot Repeater',
    description => 'Repeats ##crawl bots ' .
                   'that reference a nick' .
                   'that you specify.',
    license     => 'Public Domain',
);

print CLIENTCRAP "loading crawl.pl $VERSION!";

my $root_server = "freenode";
my $bot_name = "OCTOTROG";
my $root_chan = "##crawl";
my $target_server = "lunarnet";
my @target_chan = qw(#changeme);
my $ts = Irssi::server_find_tag($target_server);
my $rs = Irssi::server_find_tag($root_server);
my %commands = (
    'Sizzell' => ['%whereis','%dump'],
    'Gretell' => ['@??','@whereis'],
    'Sequell' => ['!chars','!cmd','!cmdinfo','!deathsin','!gamesby','!gkills','!help','!hs',
                  '!keyworddef','!killsby','!kw','!lg','!listgame','!lm','!log','!nick','!streak',
                  '!ttr','!ttyrec','!tv','!tvdef','!won'],
    'apocalypsebot' => ['!time'],
    'Henzell' => ['??','!abyss','!apt','!cdefine','!cheers','!cmdinfo','!coffee','!dump','!echo',
                  '!ftw','!function','!help','!idle','!learn','!macro','!messages','!nick',
                  '!rc','!rng','!seen','!send','!skill','!source','!tell','!time','!vault',
                  '!whereis','!wtf'],
    $bot_name => ['!add', '!remove', '!watched', '!help']
    );

sub check_if_command {
    # check if $msg starts with a command
    my ($nick, $msg, $chan) = @_;
    my $count = 0;
    for my $bot ( keys %commands ) {
        foreach my $command ( @{ $commands{$bot} } ) {
            if ((index $msg, $command) eq 0) {
                my $clean_msg = add_to_command($nick, trim($msg), trim($command));
                if ($bot eq $bot_name) {
                    if ($command eq '!add') {
                        add_nick(lc $clean_msg);
                    } elsif ($command eq '!remove') {
                        rem_nick(lc $clean_msg);
                    } elsif ($command eq '!watched') {
                        list_nicks();
                    } elsif ($command eq '!help') {
                        public_msg($chan, uc 'type !cmdinfo to see a list of all the bot commands. '.
                                          '!watched will list all nicks being monitored. !add/!rem to change list. '.
                                          '??death yak, ??death yak[2], @??death yak. praise be to trog.')
                    }
                } else {
                    private_msg($bot, $command . ' ' . $clean_msg);
                }
            }
        }
    }
}

sub add_nick {
    my $nick = shift;
    my @nicks = split(/ +/, Irssi::settings_get_str("crawlwatchnicks"));
    my $found_nick = 0;
    my $message;
    foreach my $n (@nicks) {
        if ($n eq $nick) {
            $found_nick = 1;
        }
    }

    if ($found_nick) {
        $message = uc $nick . ' already in watch list. praise be to trog.';
    } else {
        push @nicks, $nick;
        @nicks = sort @nicks;
        Irssi::settings_set_str("crawlwatchnicks", join(" ", @nicks));
        $message = uc 'i added ' . $nick . '. praise be to trog.';
    }
    public_msg($target_chan[0], $message);
}

sub rem_nick {
    my $nick = shift;
    my @nicks = split(/ +/, Irssi::settings_get_str("crawlwatchnicks"));
    my @new_nicks = ();
    my $found = 0;
    my $message;
    foreach my $n (@nicks) {
        if ($n ne $nick) {
            push @new_nicks, $n;
        } else {
            $message = uc 'i removed ' . $nick . '. praise be to trog.';
            $found = 1;
        }
    }
    if (!$found) {
        $message = uc 'no nick with that name';
    }

    public_msg($target_chan[0], $message);
    Irssi::settings_set_str("crawlwatchnicks", join(" ", @new_nicks));
}

sub list_nicks {
    public_msg($target_chan[0], uc 'i am watching ' . Irssi::settings_get_str("crawlwatchnicks") . '. praise be to trog.');
}

sub process_msg {
    my $msg = shift;

}

sub add_to_command {
    # stupid hack to add your nick to $msg if nick isn't provided
    my ($nick, $msg, $command) = @_;
    my $new_msg;
    if ($msg eq $command) {
        $new_msg = $nick;
    } else {
        $new_msg = substr($msg, length($command));
    }

    return trim($new_msg);
}

sub trim($) {
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

sub public_msg  {
    my ($chan, $msg) = @_;
    $ts->send_message($chan, $msg, 0);
}

sub private_msg {
    my ($bot, $msg) = @_;
    $rs->send_message($bot, $msg, 1)
}

sub dispatch {
    my ($server, $msg, $nick, $mask, $chan) = @_;

    # if coming from target channel
    if (lc($chan) eq lc($target_chan[0])) {
        check_if_command($nick, trim($msg), $target_chan[0]);
    }

    # root channel
    if (lc($chan) eq lc($root_chan)) {
        # return unless the nick is in the keys
        return unless (grep {lc($_) eq lc($nick)} keys %commands);
        # return unless the $player is found in the $text
        return unless (grep { lc($msg) =~ /\b\Q$_\E\b/i } split(" ", Irssi::settings_get_str("crawlwatchnicks")));
        # return unless (grep {lc($msg) =~ lc($_)} split(/ +/, Irssi::settings_get_str("crawlwatchnicks")));
        # send command if $text contains any @player names
        foreach (@target_chan) {
            public_msg($_, $msg)
        }
    }
}

sub priv_dispatch {
    my ($server, $msg, $nick, $mask) = @_;
    # return unless the nick is in the keys
    if (grep {lc($_) eq lc($nick)} keys %commands) {
        public_msg($target_chan[0], $msg)
    } else {
        $server->send_message($nick, uc $bot_name . uc ' does not concern himself with private messages', 1)
    }
}

Irssi::signal_add("message public", "dispatch");
Irssi::signal_add("message private", "priv_dispatch");
Irssi::settings_add_str("crawlwatch", "crawlwatchnicks", "");

print CLIENTCRAP "/set crawlwatchnicks ed edd eddy ...";
print CLIENTCRAP "Watched nicks: " . Irssi::settings_get_str("crawlwatchnicks");
