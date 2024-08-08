package CharmBoard::Model::Schema::Source::Session;

use utf8;
use strict;
use warnings;
use experimental qw(try smartmatch);

use base qw(DBIx::Class::Core);

__PACKAGE__->table('sessions');
__PACKAGE__->add_columns(
  session_key    =>
  {     data_type   => 'text',
        is_nullable => 0,
  },
  user_id        =>
  {     data_type   => 'integer',
        is_nullable => 0,
  },
  session_expiry =>
  {     data_type   => 'numeric',
        is_nullable => 0,
  },
  is_ip_bound    =>
  {     data_type   => 'integer',
        is_nullable => 0,
  },
  bound_ip       =>
  {     data_type   => 'text',
        is_nullable => 1,
  }
);

__PACKAGE__->set_primary_key('session_key');

__PACKAGE__->belongs_to(
  user_id => 'CharmBoard::Model::Schema::Source::Users',
  'user_id'
);

1;
__END__
