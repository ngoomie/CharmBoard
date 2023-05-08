package CharmBoard;
use Mojo::Base 'Mojolicious', -signatures;
use CharmBoard::Schema;

# this method will run once at server start
sub startup ($app) {
  # load plugins that require no additional conf
  $app->plugin('TagHelpers');
  
  # load configuration from config file
  my $config = $app->plugin('Config' => {file => 'charmboard.conf'});

  # load dev env only stuff, if applicable
  if ( $config->{environment} eq 'dev' ) {
    $app->plugin('Renderer::WithoutCache');
    $app->renderer->cache->max_keys(0)};

  # import Mojolicious secrets
  $app->secrets($config->{secrets});

  # import password pepper value
  $app->helper(pepper => sub {$config->{pass_crypt}->{pepper}});

  ## database setup
  my ($dsn, $dbUnicode);
  if ($app->config->{database}->{type} ~~ 'sqlite') {
    $dsn = "dbi:SQLite:" . $config->{database}->{name};
    $dbUnicode = "sqlite_unicode"}
  elsif ($app->config->{database}->{type} ~~ 'mysql') {
    $dsn = "dbi:mysql:" . $config->{database}->{name};
    $dbUnicode = "mysql_enable_utf"}
  else {die "\nUnknown, unsupported, or empty database type in charmboard.conf.
    If you're sure you've set it to something supported, maybe double check your spelling?\n
    Valid options: 'sqlite', 'mysql'"};
  my $schema = CharmBoard::Schema->connect(
    $dsn,
    $config->{database}->{user},
    $config->{database}->{pass},
    {$dbUnicode => 1});
  $app->helper(schema => sub {$schema});

  # router
  my $r = $app->routes;

  # controller routes
  ## index page
  $r->get('/')->to(
    controller => 'Controller::Main',
    action => 'index');
  ## registration page
  $r->get('/register')->to(
    controller => 'Controller::Auth',
    action => 'register');
  $r->post('/register')->to(
    controller => 'Controller::Auth',
    action => 'register_do');
  ## login page
  $r->get('/login')->to(
    controller => 'Controller::Auth',
    action => 'login');
  $r->post('/login')->to(
    controller => 'Controller::Auth',
    action => 'login_do');
}

1;
