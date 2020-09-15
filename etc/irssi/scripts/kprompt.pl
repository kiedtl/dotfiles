#
# this kprompt script was originally forked from the
# `cmdind` script by Nei
#
# this script will indicate whether the input will
# be interpreted as a command, as an action (/me), or
# as a message to a channel by changing the prompt,
# similar to catgirl
#
# (c) Kiëd Llaentenn, Nei
# This script is licensed under the GPLv2 license
#
# https://github.com/kiedtl/dotfiles
#

use strict;
use warnings;

our $VERSION = '2.0';
our %IRSSI = (
    authors     => 'Nei, Kiëd Llaentenn',
    contact     => 'Nei <anti@conference.jabber.teamidiot.de>, Kiëd Llaentenn <kiedtl@tilde.team>',
    url         => "http://anti.teamidiot.de/",
    name        => 'kprompt',
    description => 'A catgirl-esque prompt that indicates whether the input will be interpreted as a command, an action, or a message.',
    license     => 'GNU GPLv2',
   );

# Usage
# =====
# This script requires the
#
#  uberprompt
#
# script to work. If you don't have it yet, /script install uberprompt

# Options
# =======
# /set kprompt_cmd_text <string>
# * string : Text to show in prompt when typing a command
#
# /set kprompt_action_text <string>
# * string : Text to show in prompt when sending an action (/me)
#
# /set kprompt_normal_text <string>
# * string : Text to show in prompt when sending a message

use Irssi;

my $cmd_state = 0;
my $cmdchars;
my @text;

sub check_input {
    # TODO: make this work with alternative command chars

    my $old_state = $cmd_state;
    my $inputline = Irssi::parse_special('$L');

    if ($inputline =~ /^\/me\s.*/) {
        Irssi::signal_emit('change prompt', $text[1], 'UP_ONLY');
    } elsif ($inputline =~ /^\/.*/) {
        Irssi::signal_emit('change prompt', $text[0], 'UP_ONLY');
    } else {
        Irssi::signal_emit('change prompt', $text[2], 'UP_POST');
    }
}

sub setup_changed {
    @text = (Irssi::settings_get_str('kprompt_cmd_text'),
        Irssi::settings_get_str('kprompt_action_text'),
        Irssi::settings_get_str('kprompt_normal_text'));
}

Irssi::settings_add_str('kprompt', 'kprompt_cmd_text', '$ ');
Irssi::settings_add_str('kprompt', 'kprompt_action_text', '%_*%N ');
Irssi::settings_add_str('kprompt', 'kprompt_normal_text', '');
setup_changed();
Irssi::signal_add_last('gui key pressed', 'check_input');
Irssi::signal_add('setup changed', 'setup_changed');
