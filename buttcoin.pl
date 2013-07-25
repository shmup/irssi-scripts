#!/usr/bin/env perl

use strict;
use Irssi;
use warnings;
use LWP::Simple;
use JSON;
use vars qw($VERSION %IRSSI);

$VERSION = '1.00';

%IRSSI = (
    authors     => 'Jared Tyler Miller',
    contact     => 'jtmiller@gmail.com',
    name        => 'buttcoin',
<<<<<<< .merge_file_eS4f0i
    description => 'prints out btc value/difference every x interval',
=======
    description => 'spits out new markers for buttcoin value',
>>>>>>> .merge_file_pEkC0n
    license     => 'Public Domain',
);

print CLIENTCRAP "loading buttcoin.pl $VERSION!";

<<<<<<< .merge_file_eS4f0i
Irssi::settings_add_str("buttcoin", "buttcoin_interval", "");
my $interval = Irssi::settings_get_str("buttcoin_interval") || 300000;
=======
sub message {
    my $msg = shift;
    my $server_name = 'freenode';
    my $server = Irssi::server_find_tag($server_name);
    $server->command("MSG $channel_name $msg");
}
>>>>>>> .merge_file_pEkC0n

sub check_buttcoins {
    # grab the data
    my $json = get('http://data.mtgox.com/api/1/BTCUSD/ticker');
    # decode the json
    my $data = decode_json($json);
    # grab the old score
    my $old_score = get_score() || 0;
    # grab the current highest value
    my $new_score = $data->{return}{last}{value};
<<<<<<< .merge_file_eS4f0i
    # save the new score
    set_score($new_score);
    # grab the difference
    my $diff = $new_score - $old_score;
    # grab prettier score
    my $score = $data->{return}{last}{display};
    # set the msg
    my $msg = $score . ' (' . (($diff >= 0) ? '+' : '') . sprintf("%.5f", $diff).')';
    # send the msg
    Irssi::active_win()->print("BTC $msg", 0);
}

sub get_score {
    return Irssi::settings_get_str("value");
=======

    return unless $new_score != $old_score;

    # save the new score
    set_score($new_score);
    # grab the difference
    my $difference = $new_score - $old_score;
    # grab prettier score
    my $pretty_score = $data->{return}{last}{display};

    my $msg;

    if ($difference > 0) {
        $msg = $pretty_score . ' (+'.sprintf("%.5f", $difference).')';
    } elsif ($difference < 0)  {
        $msg = $pretty_score . ' ('.sprintf("%.5f", $difference).')';
    }

    my $win = Irssi::active_win();
    $win->print("BTC $msg", 0);
}

sub get_score {
    return Irssi::settings_get_str("highscore");
>>>>>>> .merge_file_pEkC0n
}

sub set_score {
    my $score = shift;
<<<<<<< .merge_file_eS4f0i
    Irssi::settings_set_str("value", $score);
}

Irssi::settings_add_str("buttcoin", "value", "");
Irssi::timeout_add($interval, "check_buttcoins", "");

check_buttcoins(); # run first time you load script

print CLIENTCRAP "/set buttcoin_interval 250000 (in milliseconds)";
print CLIENTCRAP "buttcoin check interval: " . $interval . "ms";
=======
    Irssi::settings_set_str("highscore", $score);
}



# Irssi::signal_add("message public", "dispatch");
# Irssi::signal_add("message private", "priv_dispatch");
Irssi::settings_add_str("buttcoin", "highscore", "");

check_buttcoins();

# Irssi::settings_add_str("crawlwatch", "bannersearned", "");
# Irssi::timeout_add(60000, 'check_banners', ''); # check for new banners every 5 minutes

# print CLIENTCRAP "/set crawlwatchnicks ed edd eddy ...";
# print CLIENTCRAP "Watched nicks: " . Irssi::settings_get_str("crawlwatchnicks");
>>>>>>> .merge_file_pEkC0n
