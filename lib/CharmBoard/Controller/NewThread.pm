package CharmBoard::Controller::NewThread;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub thread_compose {
  my $c = shift;

  my $subf_id = $c->param('id');
  my $subf_cat =
      $c->schema->resultset('Subforums')->cat_from_id($subf_id);
  my $cat_title =
      $c->schema->resultset('Categories')
      ->title_from_id($subf_cat);

  $c->render(
      template   => 'thread_compose',
      subf_id    => $subf_id,
      cat_title  => $cat_title,
      subf_title => $c->schema->resultset('Subforums')
        ->title_from_id($subf_id),
      error      => $c->flash('error'),
      message    => $c->flash('message')
  )
}

sub thread_submit {
  my $c = shift;

  my $thread_title = $c->param('thread-title');
  my $post_content = $c->param('post-content');
  my $post_time    = time;
  my $subf_id = $c->param('id');

  my $catch_error;

  # make sure post data is valid
  try {
    ($thread_title, $post_content)
        or die "Please fill both the title and post content fields"
  } catch ($catch_error) {
    $c->flash(error => $catch_error);
    $c->redirect_to('board/:id/new')
  }

  # now send it
  
}

1;
__END__
