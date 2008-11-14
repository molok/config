# Lame-o-Nickometer for Irssi
# Copyleft 2001 Johan Kiviniemi, Ion@IRCNet

# Usage: /nickometer [-out] [-verbose] nickname

# Original Lame-o-Nickometer backend
# (c) 1998 Adam Spiers <adam.spiers@new.ox.ac.uk>

use strict;
use Irssi;
use Math::Trig;

sub nickometer ($$) {
  local $_ = shift;
  my $verbose = shift;

  my $score = 0;

  # Deal with special cases (precede with \ to prevent de-k3wlt0k)
  my %special_cost = (
		      '69'			=> 500,
		      'dea?th'			=> 500,
		      'dark'			=> 400,
		      'n[i1]ght'		=> 300,
		      'n[i1]te'			=> 500,
		      'fuck'			=> 500,
		      'sh[i1]t'			=> 500,
		      'coo[l1]'			=> 500,
		      'kew[l1]'			=> 500,
		      'lame'			=> 500,
		      'dood'			=> 500,
		      'dude'			=> 500,
		      'rool[sz]'		=> 500,
		      'rule[sz]'		=> 500,
		      '[l1](oo?|u)[sz]er'	=> 500,
		      '[l1]eet'			=> 500,
		      'e[l1]ite'		=> 500,
		      '[l1]ord'			=> 500,
		      'k[i1]ng'			=> 500,
		      'pron'			=> 1000,
		      'warez'			=> 1000,
		      'xx'			=> 100,
		      '\[rkx]0'			=> 1000,
		      '\0[rkx]'			=> 1000,
		     );

  foreach my $special (keys %special_cost) {
    my $special_pattern = $special;
    my $raw = ($special_pattern =~ s/^\\//);
    my $nick = $_;
    unless ($raw) {
      $nick =~ tr/023457+8/ozeasttb/;
    }
    punish(\$score, $special_cost{$special}, "matched special case /$special_pattern/", $verbose)
      if $nick =~ /$special_pattern/i;
  }
  
  # Allow Perl referencing
  s/^\\([A-Za-z])/$1/;
  
  # By his own admission, the nick ^Pudge is slightly lame ...
# s/\^(pudge)/$1/i;

  # C-- ain't so bad :-)
  s/^C--$/C/;
  
  # Punish consecutive non-alphas
  s/([^A-Za-z0-9]{2,})
   /my $consecutive = length($1);
    punish(\$score, slow_pow(10, $consecutive), 
	    "$consecutive total consecutive non-alphas", $verbose)
      if $consecutive;
    $1
   /egx;

  # Remove one layer of balanced brackets and punish for rest
  if (s/^([^{}]*)   (\{) (.*) (\}) ([^{}]*)   $/$1$3$5/x ||
      s/^([^\[\]]*) (\[) (.*) (\]) ([^\[\]]*) $/$1$3$5/x ||
      s/^([^()]*)   (\() (.*) (\)) ([^()]*)   $/$1$3$5/x) 
  {
    Irssi::print("Nickometer: Removed $2$4 outside parentheses; nick now $_") if $verbose;
  }
  my $parentheses = tr/(){}[]/(){}[]/;
  punish(\$score, slow_pow(10, $parentheses), 
	  "$parentheses extraneous " .
	    ($parentheses == 1 ? 'parenthesis' : 'parentheses'), $verbose)
    if $parentheses;

  # Punish k3wlt0k
  my @k3wlt0k_weights = (5, 5, 2, 5, 2, 3, 1, 2, 2, 2);
  for my $digit (0 .. 9) {
    my $occurrences = s/$digit/$digit/g || 0;
    punish(\$score, $k3wlt0k_weights[$digit] * $occurrences * 30,
	    $occurrences . ' ' .
	      (($occurrences == 1) ? 'occurrence' : 'occurrences') .
	      " of $digit", $verbose)
      if $occurrences;
  }

  # An alpha caps is not lame in middle or at end, provided the first
  # alpha is caps.
  my $orig_case = $_;
  s/^([^A-Za-z]*[A-Z].*[a-z].*?)[_-]?([A-Z])/$1\l$2/;
  
  # A caps first alpha is sometimes not lame
  s/^([^A-Za-z]*)([A-Z])([a-z])/$1\l$2$3/;
  
  # Punish uppercase to lowercase shifts and vice-versa, modulo 
  # exceptions above
  my $case_shifts = case_shifts($orig_case);
  punish(\$score, slow_pow(9, $case_shifts),
	  $case_shifts . ' case ' .
	    (($case_shifts == 1) ? 'shift' : 'shifts'), $verbose)
    if ($case_shifts > 1 && /[A-Z]/);

  # Punish lame endings (TorgoX, WraithX et al. might kill me for this :-)
  punish(\$score, 50, 'last alpha lame', $verbose) if $orig_case =~ /[XZ][^a-zA-Z]*$/;

  # Punish letter to numeric shifts and vice-versa
  my $number_shifts = number_shifts($_);
  punish(\$score, slow_pow(9, $number_shifts), 
	  $number_shifts . ' letter/number ' .
	    (($number_shifts == 1) ? 'shift' : 'shifts'), $verbose)
    if $number_shifts > 1;

  # Punish extraneous caps
  my $caps = tr/A-Z/A-Z/;
  punish(\$score, slow_pow(7, $caps), "$caps extraneous caps", $verbose) if $caps;

  # Now punish anything that's left
  my $remains = $_;
  $remains =~ tr/a-zA-Z0-9//d;
  my $remains_length = length($remains);

  punish(\$score, 50 * $remains_length + slow_pow(9, $remains_length),
	  $remains_length . ' extraneous ' .
	    (($remains_length == 1) ? 'symbol' : 'symbols'), $verbose)
    if $remains;

  Irssi::print(sprintf "Nickometer: Raw lameness score is %.2f", $score) if $verbose;

  # Use an appropriate function to map [0, +inf) to [0, 100).
  # Improvements welcome, this one is a bit sucky.
  my $percentage = 100 * 
                     (1 + tanh(($score-400)/400)) * 
                     (1 - 1/(1+$score/5)) / 2;

  my $digits = 2 * (2 - round_up(log(100 - $percentage) / log(10)));

  return sprintf "%.${digits}f", $percentage;
}

sub case_shifts ($) {
  # This is a neat trick suggested by freeside.  Thanks freeside!

  my $shifts = shift;

  $shifts =~ tr/A-Za-z//cd;
  $shifts =~ tr/A-Z/U/s;
  $shifts =~ tr/a-z/l/s;

  return length($shifts) - 1;
}

sub number_shifts ($) {
  my $shifts = shift;

  $shifts =~ tr/A-Za-z0-9//cd;
  $shifts =~ tr/A-Za-z/l/s;
  $shifts =~ tr/0-9/n/s;

  return length($shifts) - 1;
}

sub slow_pow ($$) {
  my ($x, $y) = @_;

  return $x ** slow_exponent($y);
}

sub slow_exponent ($) {
  my $x = shift;

  return 1.3 * $x * (1 - atan($x/6) *2/pi);
}

sub round_up ($) {
  my $float = shift;

  return int($float) + ((int($float) == $float) ? 0 : 1);
}

sub punish ($$$$) {
  my ($score, $damage, $reason, $verbose) = @_;

  return unless $damage;

  $$score += $damage;
  Irssi::print(sprintf "Nickometer: %.2f lameness points awarded: $reason", $damage) if $verbose;
}


sub cmd_nickometer {
    my ($data, $server, $channel) = @_;
    my ($out, $verbose, $nick) = (0, 0, "");
    foreach (split /\s+/, $data) {
	if (/^-out$/i) {
	    $out = $out ? 0 : 1;
	} elsif (/^-verbose$/i) {
	    $verbose = $verbose ? 0 : 1;
	} elsif (!$nick) {
	    $nick = $_;
	}
    }
    
    unless ($nick) {
	Irssi::print("Nickometer: USAGE: /nickometer [-out] [-verbose] nickname");
	return;
    }
    
    my $lameness = nickometer($nick, $verbose);
    if ($out) {
	$server->command("msg $channel->{name} Nickometer: $nick is $lameness% lame.");
    } else {
	Irssi::print("Nickometer: $nick is $lameness% lame.");
    }
}

Irssi::command_bind('nickometer', 'cmd_nickometer');
