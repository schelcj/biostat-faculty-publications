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
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 faculty_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 src_url

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 pubmed_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 scival_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 date

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 journal

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 volume

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 issue

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 pages

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 authors

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 year

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 timescited

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 pmid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 scopuseid

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 created_at

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "faculty_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "src_url",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "pubmed_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "scival_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "date",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "journal",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "volume",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "issue",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "pages",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "authors",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "year",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "timescited",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "pmid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "scopuseid",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "created_at",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 abstracts

Type: has_many

Related object: L<Biostat::Publications::DB::Schema::Result::Abstract>

=cut

__PACKAGE__->has_many(
  "abstracts",
  "Biostat::Publications::DB::Schema::Result::Abstract",
  { "foreign.pmid" => "self.pmid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 faculty

Type: belongs_to

Related object: L<Biostat::Publications::DB::Schema::Result::Faculty>

=cut

__PACKAGE__->belongs_to(
  "faculty",
  "Biostat::Publications::DB::Schema::Result::Faculty",
  { id => "faculty_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-20 09:56:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vC3TSG/N/wlcvVW/MEekiQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
