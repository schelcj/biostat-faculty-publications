use utf8;
package Biostat::Publications::DB::Schema::Result::Url;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Biostat::Publications::DB::Schema::Result::Url

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<urls>

=cut

__PACKAGE__->table("urls");

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

=head2 url

  data_type: 'text'
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
  "url",
  { data_type => "text", is_nullable => 0 },
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
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-20 09:56:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X0I30TBP/mm2ApabPz7YSA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
