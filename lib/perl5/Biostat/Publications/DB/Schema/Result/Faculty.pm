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
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 realname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 uniqname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 gid

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 dept_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
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
  "realname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "uniqname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "gid",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "dept_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<gid>

=over 4

=item * L</gid>

=back

=cut

__PACKAGE__->add_unique_constraint("gid", ["gid"]);

=head2 C<realname>

=over 4

=item * L</realname>

=back

=cut

__PACKAGE__->add_unique_constraint("realname", ["realname"]);

=head2 C<uniqname>

=over 4

=item * L</uniqname>

=back

=cut

__PACKAGE__->add_unique_constraint("uniqname", ["uniqname"]);

=head1 RELATIONS

=head2 dept

Type: belongs_to

Related object: L<Biostat::Publications::DB::Schema::Result::Department>

=cut

__PACKAGE__->belongs_to(
  "dept",
  "Biostat::Publications::DB::Schema::Result::Department",
  { id => "dept_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

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


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-20 09:56:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AfdCHoHMhg0nab2kq9n9aA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
