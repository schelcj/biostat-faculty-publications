use utf8;
package Biostat::Publications::DB::Schema::Result::Department;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Biostat::Publications::DB::Schema::Result::Department

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<departments>

=cut

__PACKAGE__->table("departments");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 abbr

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "abbr",
  { data_type => "varchar", is_nullable => 1, size => 10 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<abbr>

=over 4

=item * L</abbr>

=back

=cut

__PACKAGE__->add_unique_constraint("abbr", ["abbr"]);

=head2 C<name>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("name", ["name"]);

=head1 RELATIONS

=head2 faculties

Type: has_many

Related object: L<Biostat::Publications::DB::Schema::Result::Faculty>

=cut

__PACKAGE__->has_many(
  "faculties",
  "Biostat::Publications::DB::Schema::Result::Faculty",
  { "foreign.dept_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-20 09:56:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hbDN/mS2LW48zQeWinfXNA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
