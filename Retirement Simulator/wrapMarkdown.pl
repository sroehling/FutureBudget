#!/usr/bin/perl

use FindBin qw($Bin);

$prefix = $Bin."/markdown-prefix.html";

# The markdown file being converted is expected to be passed with
# it's fully qualified path name, so we don't prefix it with $Bin.
$mdFile = "\"".shift(@ARGV)."\"";

$suffix = $Bin."/markdown-suffix.html";


open(PREFIX, "$prefix") || die "unable to open prefix file: $prefix";
while(<PREFIX>) { print; }

$markdownCmd = "perl "."\"".$Bin."/Markdown.pl"."\"";

open(MARKDOWN,"$markdownCmd  $mdFile |") || die "unable to open markdown file";
while(<MARKDOWN>) { print; }

open(SUFFIX,"$suffix") || die "unable to open suffix file: $suffix";
while(<SUFFIX>) { print; }