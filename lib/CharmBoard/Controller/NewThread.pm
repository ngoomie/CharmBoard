package CharmBoard::Controller::NewThread;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub thread_compose {
  my $self = shift;

  my $subf_id = $self->param('id');
  my $subf_cat =
      $self->schema->resultset('Subforums')->cat_from_id($subf_id);
  my $cat_title =
      $self->schema->resultset('Categories')
      ->title_from_id($subf_cat);

  $self->render(
      template   => 'thread_compose',
      subf_id    => $subf_id,
      cat_title  => $cat_title,
      subf_title => $self->schema->resultset('Subforums')
        ->title_from_id($subf_id),
      error      => $self->flash('error'),
      message    => $self->flash('message')
  )
}

sub thread_submit {
  my $self = shift;

  my $thread_title = $self->param('thread-title');
  my $post_content = $self->param('post-content');
  my $post_time    = time;

  my $catch_error;

  # make sure post data is valid
  try {
    ($thread_title, $post_content)
        or die "Please fill both the title and post content fields"
  } catch ($catch_error) {
    $self->flash(error => $catch_error);
    $self->redirect_to('/:id/new')
  }
}

1;
__END__
