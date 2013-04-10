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
    description => 'prints out btc value/difference every x interval',
    license     => 'Public Domain',
);

print CLIENTCRAP "loading buttcoin.pl $VERSION!";

Irssi::settings_add_str("buttcoin", "buttcoin_interval", "");
my $interval = Irssi::settings_get_str("buttcoin_interval") || 300000;

sub check_buttcoins {
    # grab the data
    my $json = get('http://data.mtgox.com/api/1/BTCUSD/ticker');
    # decode the json
    my $data = decode_json($json);
    # grab the old score
    my $old_score = get_score() || 0;
    # grab the current highest value
    my $new_score = $data->{return}{last}{value};
    # return if the difference is 0
    return unless $new_score != $old_score;
    # save the new score
    set_score($new_score);
    # grab the difference
    my $diff = $new_score - $old_score;
    # grab prettier score
    my $score = $data->{return}{last}{display};
    # set the msg
    my $msg = $score . ' (' . (($diff > 0) ? '+' : '') . sprintf("%.5f", $diff).')';
    # send the msg
    Irssi::active_win()->print("BTC $msg", 0);
}

sub get_score {
    return Irssi::settings_get_str("highscore");
}

sub set_score {
    my $score = shift;
    Irssi::settings_set_str("highscore", $score);
}

Irssi::settings_add_str("buttcoin", "highscore", "");
Irssi::timeout_add($interval, "check_buttcoins", "");

print CLIENTCRAP "/set buttcoin_interval 250000 (in milliseconds)";
print CLIENTCRAP "buttcoin check interval: " . $interval . "ms";
