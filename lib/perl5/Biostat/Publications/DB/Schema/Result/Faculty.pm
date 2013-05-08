use utf8;
package Biostat::Publications::DB::Schema::Result::Faculty;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Biostat::Publications::DB::Schema::Result::Faculty

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<faculty>

=cut

__PACKAGE__->table("faculty");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 gid

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "gid",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<gid_unique>

=over 4

=item * L</gid>

=back

=cut

__PACKAGE__->add_unique_constraint("gid_unique", ["gid"]);

=head2 C<name_unique>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("name_unique", ["name"]);

=head1 RELATIONS

=head2 publications

Type: has_many

Related object: L<Biostat::Publications::DB::Schema::Result::Publication>

=cut

__PACKAGE__->has_many(
  "publications",
  "Biostat::Publications::DB::Schema::Result::Publication",
  { "foreign.faculty_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 urls

Type: has_many

Related object: L<Biostat::Publications::DB::Schema::Result::Url>

=cut

__PACKAGE__->has_many(
  "urls",
  "Biostat::Publications::DB::Schema::Result::Url",
  { "foreign.faculty_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-08 09:42:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3x78ZlkC8UEGKDhM1hZ5kQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration

__PACKAGE__->add_columns(created_at => {set_on_create => 1});
1;
