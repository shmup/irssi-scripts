#!/usr/bin/perl -w
use strict;
use vars qw/$VERSION %IRSSI $SPLASH $NAME $CONTEXT $OUTPUT/;

$| = 1;

$NAME    = 'fw';
$VERSION = '0.1';
%IRSSI   = (
  authors     => 'Jared Miller <shmup>',
  contact     => 'jared@smell.flowers',
  name        => $NAME,
  description => 'ｆｕｌｌｗｉｄｔｈ your text',
  license     => 'Artistic-2.0',
  url         => 'https://github.com/shmup/irssi-scripts',
  changed     => '2023-02-24',
);

use Irssi;
use utf8;

sub cmd_fw {
  # data - contains the parameters for /FW
  # server - the active server in window
  # witem - the active window item (eg. channel, query)
  #         or undef if the window is empty
  my ($data, $server, $witem) = @_;

  if (!$server || !$server->{connected}) {
    Irssi::print("Not connected to server");
    return;
  }
  $_ = $data;

  s/\s/\x{A0}\x{A0}/g if tr
      <!"#$%&´()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~¢£>
      <！＂＃＄％＆＇（）＊＋，－．／：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［＼］＾＿｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝～￠￡>;
#    s/\s/\x{A0}\x{A0}/g if tr
#      <!"#$%&´()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^`abcdefghijklmnopqrstuvwxyz{|}~¢£>
#      <！＂＃＄％＆＇（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［＼］＾｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝～￠￡>;;
  $data = $_;

  if (
    $witem
    && ( $witem->{type} eq "CHANNEL"
      || $witem->{type} eq "QUERY")
  ) {
    $witem->command("MSG " . $witem->{name} . " " . $data);
  } else {
    Irssi::print("no active channel/query in window");
  }
}

Irssi::command_bind('fw', 'cmd_fw');
