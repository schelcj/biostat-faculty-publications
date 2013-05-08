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

=head2 url

  data_type: 'text'
  is_nullable: 0

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 pub_date

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

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "faculty_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "url",
  { data_type => "text", is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "pub_date",
  { data_type => "text", is_nullable => 1 },
  "journal",
  { data_type => "text", is_nullable => 1 },
  "volume",
  { data_type => "text", is_nullable => 1 },
  "issue",
  { data_type => "text", is_nullable => 1 },
  "pages",
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


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-07 15:53:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XrScBPLBs/eTLJcirEhUTQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
