use utf8;
package Biostat::Publications::DB::Schema::Result::Abstract;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Biostat::Publications::DB::Schema::Result::Abstract

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<abstracts>

=cut

__PACKAGE__->table("abstracts");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 pmid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 text

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "pmid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "text",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 pmid

Type: belongs_to

Related object: L<Biostat::Publications::DB::Schema::Result::Publication>

=cut

__PACKAGE__->belongs_to(
  "pmid",
  "Biostat::Publications::DB::Schema::Result::Publication",
  { pmid => "pmid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-01-29 11:52:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F0N3Eqqjek5ycDqA/vPPnQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
