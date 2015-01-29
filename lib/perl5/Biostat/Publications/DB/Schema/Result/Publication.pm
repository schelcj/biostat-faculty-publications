use utf8;
package Biostat::Publications::DB::Schema::Result::Publication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Biostat::Publications::DB::Schema::Result::Publication

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<publications>

=cut

__PACKAGE__->table("publications");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 faculty_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 src_url

  data_type: 'text'
  is_nullable: 0

=head2 pubmed_url

  data_type: 'text'
  is_nullable: 1

=head2 scival_url

  data_type: 'text'
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 abstract

  data_type: 'text'
  is_nullable: 1

=head2 date

  data_type: 'text'
  is_nullable: 1

=head2 journal

  data_type: 'text'
  is_nullable: 1

=head2 volume

  data_type: 'text'
  is_nullable: 1

=head2 issue

  data_type: 'text'
  is_nullable: 1

=head2 pages

  data_type: 'text'
  is_nullable: 1

=head2 authors

  data_type: 'text'
  is_nullable: 1

=head2 year

  data_type: 'integer'
  is_nullable: 1

=head2 timescited

  data_type: 'integer'
  is_nullable: 1

=head2 pmid

  data_type: 'integer'
  is_nullable: 1

=head2 scopuseid

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "faculty_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "src_url",
  { data_type => "text", is_nullable => 0 },
  "pubmed_url",
  { data_type => "text", is_nullable => 1 },
  "scival_url",
  { data_type => "text", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "abstract",
  { data_type => "text", is_nullable => 1 },
  "date",
  { data_type => "text", is_nullable => 1 },
  "journal",
  { data_type => "text", is_nullable => 1 },
  "volume",
  { data_type => "text", is_nullable => 1 },
  "issue",
  { data_type => "text", is_nullable => 1 },
  "pages",
  { data_type => "text", is_nullable => 1 },
  "authors",
  { data_type => "text", is_nullable => 1 },
  "year",
  { data_type => "integer", is_nullable => 1 },
  "timescited",
  { data_type => "integer", is_nullable => 1 },
  "pmid",
  { data_type => "integer", is_nullable => 1 },
  "scopuseid",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 faculty

Type: belongs_to

Related object: L<Biostat::Publications::DB::Schema::Result::Faculty>

=cut

__PACKAGE__->belongs_to(
  "faculty",
  "Biostat::Publications::DB::Schema::Result::Faculty",
  { id => "faculty_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-01-29 09:15:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xCY8ns/2aT0q3aJTJ0gbOA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
