#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $soroban = [];
map { $soroban->[$_] = 0 } (0..12);
# map { $soroban->[$_] = $_ % 10 } (0..12);
# print Dumper($soroban);

sub show_soroban
{
	my $data = shift;
	my $num_cols = scalar @$data;
	my $rahmenzeichen = '|';
	for (my $zeile = 9; $zeile >= 0; $zeile--) # Das sind die Zeilen des Sorobans
	{
		print $rahmenzeichen;
		my $spaltenzeichen = "|";
		my $trennzeichen = " ";

		for (my $spalte = 0; $spalte < $num_cols; $spalte++)
		{
			my $wert = $data->[ $spalte ] // 0; # Feldwert

			if (($zeile == 9) || ($zeile == 0))
			{
				$spaltenzeichen = '---';
				$trennzeichen   = '-';
			}
			if ($zeile == 6)
			{
				$spaltenzeichen = "-" . chr(97 + $spalte) . ($spalte % 3 ? "-" : ".");
				$trennzeichen   = '-';
			}
			elsif ($zeile == 8) # ausgeschaltete Fuenfer
			{
				$spaltenzeichen = $wert >= 5 ? ' | ' : '(=)';
			}
			elsif ($zeile == 7) # angeschaltete Fuenfer
			{
				$spaltenzeichen = $wert < 5 ? ' | ' : '(=)';
			}
			# 6 s.o. Rahmen
			elsif ($zeile == 5) # angeschaltete 1: 1,2,3,4, 6, 7, 8, 9
			{
				$spaltenzeichen = (($wert == 0) || ($wert == 5)) ? ' | ' : '(=)';
			}
			elsif ($zeile == 4) # angeschaltete 2: 0,2,3,4,  5, 7, 8, 9
			{
				$spaltenzeichen = (($wert == 1) || ($wert == 6)) ? ' | ' : '(=)';
			}
			elsif ($zeile == 3) # angeschaltete 3:   0 1   3 4 5 6  8 9
			{
				$spaltenzeichen = (($wert == 2) || ($wert == 7))  ? ' | ' : '(=)';
			}
			elsif ($zeile == 2) # angeschaltete 4
			{
				$spaltenzeichen = (($wert == 3) || ($wert == 8))  ? ' | ' : '(=)';
			}
			elsif ($zeile == 1) # unterste Zeile
			{
				$spaltenzeichen = (($wert == 4) || ($wert == 9))  ? ' | ' : '(=)';
			}
			print $trennzeichen . $spaltenzeichen;
		}
		print $trennzeichen . $rahmenzeichen . "\n";

	}
}

my $input = '';
while ($input ne 'Q')
{
	show_soroban( $soroban );
	print "INPUT> ";
	$input = <STDIN>;
	chomp($input);
	if ($input eq "clear")
	{
		my $l = scalar @$soroban;
		map { $soroban->[ $_ ] = 0 } (0..$l-1);
	}
	elsif ($input =~ m/^([a-z])([+-]?)([0-9]+)$/)
	{
		my $spalte = ord($1) - 97; # 0..x
		my $op = $2;
		my $delta_oder_ziffern = $3;

		if (($spalte < 0) || ($spalte >= scalar @$soroban))
		{
			print "FEHLER: nicht existierende Spalte $spalte\n";
			next;
		}

		my $vorzeichen = 1;
		$vorzeichen = -1 if $op eq "-";

		my $neuwert;
		if (length($op))
		{
			if (length($delta_oder_ziffern) == 1)
			{
				my $neuwert = $soroban->[ $spalte ] + ($vorzeichen * $delta_oder_ziffern);
				$neuwert = 0 if $neuwert < 0;
				$neuwert = 9 if $neuwert > 9;
				$soroban->[ $spalte ] = $neuwert;
			}
			else {
				print "Fehler: Addition/Subtraktion nicht erlaubt in einzelner Spalte.\n";
			}
			next;
		}

		# h632 : Einstellen von h:6 i:3 j:2
		my @werte = split(//, $delta_oder_ziffern);
		$spalte--;
		while (scalar @werte)
		{
			my $neuwert = shift @werte;
			$spalte++;
			unless (($spalte >= 0) && ($spalte < scalar @$soroban))
			{
				print "Fehler: Spalte ausserhalb des Sorobans: $spalte\n";
				next;
			}
			$soroban->[ $spalte ] = $neuwert;
		}
	}
}

