package CharmBoard::Schema::Source::Users;
use utf8;
use base qw(DBIx::Class::Core);

=pod
=encoding utf8
=head1 NAME 
CharmBoard::Schema::Source::Users - DBIx::Class
ResultSource module for the database's C<users> table
=head1 DESCRIPTION
This table contains information about users.
=head2 COLUMNS
=over
=item user_id
Contains unique IDs for users.

Data type is SQLite C<INTEGER>; MariaDB C<INT>. Cannot
be C<NULL>.

=item username
Contains a given user's username. Please do not use this
field as an identifier for users, that's what C<user_id> is
intended for, instead.

Data type is SQLite C<TEXT>. Cannot be C<NULL>.

=item email
Contains a user's email address.

Data type is SQLite C<TEXT>. Cannot be C<NULL>.

=item password
Contains the user's password in the form of a
Crypt::Passphrase string in hexadecimal form.

Data type is SQLite C<TEXT>. Cannot be C<NULL>.

=item salt
Contains the user's salt in hexadecimal form.

Data type is SQLite C<TEXT>. Cannot be C<NULL>.

=item signup_date
Contains the date the user signed up, in the format
provided by Perl's C<time> function.

Data type is SQLite C<INTEGER>. Cannot be C<NULL>.
=back
=cut

__PACKAGE__->table('users');
__PACKAGE__->add_columns(
  user_id     => {
    data_type         => 'integer',
    is_numeric        => 1,
    is_nullable       => 0,
    is_auto_increment => 1, },
  username    => {
    data_type         => 'text',
    is_numeric        => 0,
    is_nullable       => 0, },
  email       => {
    data_type         => 'text',
    is_numeric        => 0,
    is_nullable       => 0, },
  password    => {
    data_type         => 'text',
    is_numeric        => 0,
    is_nullable       => 0, },
  salt        => {
    data_type         => 'text',
    is_numeric        => 0,
    is_nullable       => 0, },
  signup_date => {
    data_type         => 'integer',
    is_numeric        => 1,
    is_nullable       => 0, });

__PACKAGE__->set_primary_key('user_id');

1