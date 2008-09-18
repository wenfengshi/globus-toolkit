#! /usr/bin/env perl

use strict;
use POSIX;
use Test;

my $test_exec = 'globus-gram-client-register-cancel-test';

my $gpath = $ENV{GLOBUS_LOCATION};

if (!defined($gpath))
{
    die "GLOBUS_LOCATION needs to be set before running this script"
}
if ($ENV{CONTACT_STRING} eq "")
{
    die "CONTACT_STRING not set";
}

@INC = (@INC, "$gpath/lib/perl");

my @tests;
my @todo;
my $valgrind = "";

if (exists $ENV{VALGRIND})
{
    $valgrind = "valgrind --log-file=VALGRIND-globus_gram_client_register_cancel_test.log";
    if (exists $ENV{VALGRIND_OPTIONS})
    {
        $valgrind .= ' ' . $ENV{VALGRIND_OPTIONS};
    }
}

sub cancel_test
{
    my ($errors,$rc) = ("",0);
    my ($output);
    my ($contact, $result) = @_;

    system("$valgrind $test_exec '$contact' >/dev/null");
    $rc = $?>> 8;
    if($rc != $result)
    {
        $errors .= "Test exited with $rc. ";
    }

    if($errors eq "")
    {
        ok('success', 'success');
    }
    else
    {
        ok($errors, 'success');
    }
}
push(@tests, "cancel_test('$ENV{CONTACT_STRING}', 0);");

# Now that the tests are defined, set up the Test to deal with them.
plan tests => scalar(@tests), todo => \@todo;

foreach (@tests)
{
    eval "&$_";
}
