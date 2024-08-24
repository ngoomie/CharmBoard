package CharmBoard::Controller::ViewSubf;

use utf8;
use strict;
use warnings;
use experimental qw(try);
no warnings 'experimental::try';
use feature ':5.34';

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub subf_view {
  my $c = shift;

  my $subf_id = $c->param('id');
  my $subf_cat =
      $c->schema->resultset('Subforums')->cat_from_id($subf_id);
  my $cat_title =
      $c->schema->resultset('Categories')
      ->title_from_id($subf_cat);

  my @thread_list =
      $c->schema->resultset('Threads')->fetch_by_subf($subf_id);

  $c->render(
    template    => 'subf',
    subf_id     => $subf_id,
    cat_title   => $cat_title,
    subf_title  => $c->schema->resultset('Subforums')
        ->title_from_id($subf_id),
    thread_list => \@thread_list
  )
}

1;
__END__