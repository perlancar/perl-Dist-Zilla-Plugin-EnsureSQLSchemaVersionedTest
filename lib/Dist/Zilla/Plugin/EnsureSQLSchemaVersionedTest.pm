package Dist::Zilla::Plugin::EnsureSQLSchemaVersionedTest;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Moose;
with 'Dist::Zilla::Role::InstallTool';

sub setup_installer {
    my ($self) = @_;

    my $prereqs_hash = $self->zilla->prereqs->as_string_hash;
    my $rr_prereqs = $prereqs_hash->{runtime}{requires} // {};

    # XXX should've checked found_files instead, to handle generated files
    if (defined($rr_prereqs->{"SQL::Schema::Versioned"}) &&
            !(-f "xt/author/sql_schema_versioned.t") &&
            !(-f "xt/release/sql_schema_versioned.t")
        ) {
        $self->log_fatal(["SQL::Schema::Versioned is in prereq, but xt/{author,release}/sql_schema_versioned.t has not been added, please make sure that your schema is tested by adding that file"]);
    }
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Make sure that xt/author/sql_schema_versioned.t is present

=for Pod::Coverage .+

=head1 SYNOPSIS

In dist.ini:

 [EnsureSQLSchemaVersionedTest]


=head1 DESCRIPTION

This plugin checks if L<SQL::Schema::Versioned> is in the RuntimeRequires
prereq. If it is, then the plugin requires that
C<xt/author/sql_schema_versioned.t> exists, to make sure that the dist author
has added a test for schema creation/upgrades.

Typical C<xt/author/sql_schema_versioned.t> is as follow (identifiers in
all-caps refer to project-specific names):

 #!perl

 use PROJ::MODULE;
 use Test::More 0.98;
 use Test::SQL::Schema::Versioned;
 use Test::WithDB::SQLite;

 sql_schema_spec_ok(
     $PROJ::MODULE::DB_SCHEMA_SPEC,
     Test::WithDB::SQLite->new,
 );
 done_testing;


=head1 SEE ALSO

L<SQL::Schema::Versioned>
