package CharmBoard;

use utf8;
use strict;
use warnings;
use experimental qw(try smartmatch);

use Mojo::Base 'Mojolicious', -signatures;
use CharmBoard::Schema;

# this method will run once at server start
sub startup {
  my $self = shift;

  # load plugins that require no additional conf
  $self->plugin('TagHelpers');

  # load configuration from config file
  my $config =
      $self->plugin('Config' => { file => 'charmboard.conf' });

  # set this specific forum's name
  $self->helper(board_name => sub { $config->{board_name} });

  # load dev env only stuff, if applicable
  if ($config->{environment} eq 'dev') {
    $self->plugin('Renderer::WithoutCache');
    $self->renderer->cache->max_keys(0)
  }

  # import Mojolicious secrets
  $self->secrets($config->{secrets});

  # import password pepper value
  $self->helper(pepper => sub { $config->{pass_crypt}->{pepper} });

  ## database setup
  # ? this could maybe be a given/when
  {
    my ($_dsn, $_unicode);
    if ($self->config->{database}->{type} ~~ 'sqlite') {
      $_dsn     = "dbi:SQLite:" . $config->{database}->{name};
      $_unicode = "sqlite_unicode"

    } elsif ($self->config->{database}->{type} ~~ 'mariadb') {
      $_dsn     = "dbi:mysql:" . $config->{database}->{name};
      $_unicode = "mysql_enable_utf"

    } else {
      die "\nUnknown, unsupported, or empty database type
      in charmboard.conf. If you're sure you've set it to
      something supported, maybe double check your spelling?
      \n\n\t
      Valid options: 'sqlite', 'mariadb'"
    }

    our $schema = CharmBoard::Schema->connect(
      $_dsn,
      $config->{database}->{user},
      $config->{database}->{pass},
      { $_unicode => 1 }
    );

    $self->helper(schema => sub { $schema })
  }

  # router
  my $r = $self->routes;

  # view subforum
  $r->get('/subforum/:id')->to(
    controller => 'Controller::ViewSubf',
    action     => 'subf_view'
  );

  # controller routes
  ## index page
  $r->get('/')->to(
    controller => 'Controller::Index',
    action     => 'index'
  );

  ## registration page
  $r->get('/register')->to(
    controller => 'Controller::Register',
    action     => 'register'
  );
  $r->post('/register')->to(
    controller => 'Controller::Register',
    action     => 'register_do'
  );

  ## login page
  $r->get('/login')->to(
    controller => 'Controller::Login',
    action     => 'login'
  );
  $r->post('/login')->to(
    controller => 'Controller::Login',
    action     => 'login_do'
  );

  ## logout
  $r->get('/logout')->to(
    controller => 'Controller::Logout',
    action     => 'logout_do'
  )
}

1;
__END__

=pod
=head1 NAME
CharmBoard - revive the fun posting experience!

=head1 NOTES
This documentation is intended for prospective code contributors. If
you're looking to set CharmBoard up, look for the Markdown format
(.md) documentation instead.

CharmBoard uses a max line length of 70 chars and a tab size of two
spaces.

=head1 DESCRIPTION
CharmBoard is forum software written in Perl with Mojolicious,
intended to be a more fun alternative to the bigger forum suites
available today, inspired by older forum software like AcmlmBoard,
while also being more modernized in terms of security practices than
they are.
=cut
