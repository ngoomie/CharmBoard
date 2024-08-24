package CharmBoard::Model::Schema::Source::Subforums;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use base qw(DBIx::Class::Core);

__PACKAGE__->table('subforums');
__PACKAGE__->add_columns(
  subf_id   =>
  {     data_type         => 'integer',
        is_numeric        => 1,
        is_nullable       => 0,
        is_auto_increment => 1
  },
  subf_cat  =>
  {     data_type         => 'integer',
        is_foreign_key    => 1,
        is_nullable       => 0,
  },
  subf_rank =>
  {     data_type         => 'integer',
        is_numeric        => 1,
        is_nullable       => 0,
  },
  subf_name =>
  {     data_type         => 'text',
        is_nullable       => 0,
  },
  subf_desc =>
  {     data_type         => 'text',
        is_nullable       => 1,
  }
);

__PACKAGE__->set_primary_key('subf_id');

__PACKAGE__->belongs_to(
  subf_cat => 'CharmBoard::Model::Schema::Source::Categories',
  { 'foreign.cat_id' => 'self.subf_cat' }
);

1;
__END__
