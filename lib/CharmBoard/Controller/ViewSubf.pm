package CharmBoard::Controller::ViewSubf;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub subf_view {
  my $self = shift;

  my $subf_id = $self->param('id');
  my $subf_cat =
      $self->schema->resultset('Subforums')->cat_from_id($subf_id);
  my $cat_title =
      $self->schema->resultset('Categories')
      ->title_from_id($subf_cat);

  my @thread_list =
      $self->schema->resultset('Threads')->fetch_by_subf($subf_id);

  $self->render(
    template    => 'subf',
    subf_id     => $subf_id,
    cat_title   => $cat_title,
    subf_title  => $self->schema->resultset('Subforums')
        ->title_from_id($subf_id),
    thread_list => \@thread_list
  )
}

1;
__END__