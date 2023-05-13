package CharmBoard::Schema::Source::Subforums;
use base qw(DBIx::Class::Core);

=pod
=encoding utf8
=head1 NAME
CharmBoard::Schema::Source::Subforums - DBIx::Class
ResultSource module for the database's C<subforums> table
=head1 DESCRIPTION
This table contains information about subforums.
=head2 Columns
=over
=item subf_id
Contains unique IDs for individual subforums.

Data type is SQLite C<INTEGER>.. Cannot be C<NULL>.

=item subf_cat
Which category from the C<categories> table this subforum
belongs to and should show up as a child of.

Is foreign key of C<categories.cat_id> and as such, shares
the same datatype (C<INTEGER> in SQLite). Cannot be C<NULL>.

=item subf_rank
The order in which subforums from a given category should
be displayed, which should be unique per category group.

Data type is SQLite C<INTEGER>. Cannot be C<NULL>.

=item subf_name
The name of the subforum to be displayed in the forum list,
or anywhere else where it is relevant.

Data type is SQLite C<TEXT>. Cannot be C<NULL>.

=item subf_desc
A blurb of text describing the use of a subforum to be
displayed in the forum list.

Data type is SQLite C<TEXT>. Can be C<NULL>.
=back
=cut

__PACKAGE__->table('subforums');
__PACKAGE__->add_columns(
  subf_id   => {
    data_type         => 'integer',
    is_auto_increment => 1,
    is_nullable       => 0, },
  subf_cat => {
    data_type         => 'integer',
    is_foreign_key    => 1,
    is_auto_increment => 0,
    is_nullable       => 0, },
  subf_rank => {
    data_type         => 'integer',
    is_foreign_key    => 0,
    is_auto_increment => 0,
    is_nullable       => 0, },
  subf_name => {
    data_type         => 'text',
    is_auto_increment => 0,
    is_nullable       => 0, },
  subf_desc => {
    data_type         => 'text',
    is_auto_increment => 0,
    is_nullable       => 1, });

__PACKAGE__->set_primary_key('subf_id');

__PACKAGE__->belongs_to(
  subf_cat =>
    'CharmBoard::Schema::Source::Categories',
    {'foreign.cat_id' => 'self.subf_cat'});

1