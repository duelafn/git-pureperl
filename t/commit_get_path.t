#!perl
use strict;
use warnings;
use Test::More;
use Git::PurePerl;

my $git = Git::PurePerl->new( directory => 'test-project-nontrivial' );

my $commit = $git->master;
is( $commit->kind, 'commit' );

my $tree  = $commit->tree;
my $tree2 = $commit->get_path("/");
is( $tree->sha1, $tree2->sha1, "getting root path" );

$tree2 = $commit->get_path("");
is( $tree->sha1, $tree2->sha1, "getting root path another way" );


my $blob  = $commit->get_path("file.txt");
my $blob2 = $commit->get_path("/file.txt");

is( $blob->sha1, $blob2->sha1, "getting a file in different ways" );
is( $blob->content, 'hello world!
hello world, again
',
    "got correct file"
  );


$tree = $commit->get_path("foo");
my @directory_entries = sort map $_->filename, $tree->directory_entries;
is( @directory_entries, 2 );
is( "@directory_entries", "another_file.txt bar" );


$blob = $commit->get_path("foo/bar/yet_another_file.txt");

is( $blob->content, 'OH HAI!
', "got a deep file"
  );


$commit = $commit->parent;

$blob = $commit->get_path("foo/bar/yet_another_file.txt");

is( $blob, undef, "'yet_another_file.txt' is gone" );


$blob = $commit->get_path("foo/another_file.txt");

is( $blob->content, 'Hola
', "'another_file.txt' is still here" );


$tree = $commit->get_path("foo");
@directory_entries = sort map $_->filename, $tree->directory_entries;
is( @directory_entries, 1 );
is( "@directory_entries", "another_file.txt" );


done_testing;
