# CharmBoard

CharmBoard is forum software written in Perl, inspired by chiefly AcmlmBoard and its derivatives. It's intended to be a more "fun" alternative to the bigger forum software suites available today. Though largely, it's just intended as a sort of pet project of mine for now and a way to learn Perl + Mojolicious, and some other modules I've been wanting to learn.

## Requirements

- Perl5 v5.34 or higher
- `Mojolicious` ([website](https://www.mojolicious.org/), [metacpan](https://metacpan.org/pod/Mojolicious))
  - `Mojolicious::Plugin::Model`
- `DBI`
  - `DBIx::Class`
  - one of two `DBD` database drivers — see `INSTALLING.md` for detailed information
- `Tree::Simple`
- `Authen::Passphrase::Argon2`
- `Math::Random::Secure`

## Installation

Please see `INSTALLING.md`
