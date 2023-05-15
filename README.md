# CharmBoard

CharmBoard is forum software written in Perl, inspired by AcmlmBoard/its derivatives, the original Facepunch forums, and Knockout.chat. It's intended to be a more "fun" alternative to the bigger forum software suites available today. Though largely, it's just intended as a sort of pet project of mine for now and a way to learn Perl + Mojolicious, and some other modules I've been wanting to learn.

## Requirements

- Perl5
- `Mojolicious` ([website](https://www.mojolicious.org/), [metacpan](https://metacpan.org/pod/Mojolicious))
  - `Mojolicious::Plugin::Renderer::WithoutCache` — only needed in dev environment
- `DBI`
  - `DBIx::Class`
  - one of two `DBD` database drivers — see `INSTALLING.md` for detailed information
- `Tree::Simple`
- `Authen::Passphrase::Argon2`
- `Math::Random::Secure`

## Installation

Please see `INSTALLING.md`
