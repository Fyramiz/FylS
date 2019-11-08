# vim:set sw=4 ts=4 sts=4 ft=perl expandtab:
package Lstu::DB::URL::Pg;
use Mojo::Base 'Lstu::DB::URL';

sub new {
    my $c = shift;

    $c = $c->SUPER::new(@_);

    $c = $c->_slurp if ($c->short || $c->url);

    return $c;
}

sub increment_counter {
    my $c = shift;

    my $h = $c->app->dbi->db->query('UPDATE lstu SET counter = counter + 1 WHERE short = ? RETURNING counter', $c->short)->hashes->first;
    $c->counter($h->{counter});

    return $c;
}

sub remove {
    my $c = shift;

    my $disabled = $c->app->dbi->db->query('UPDATE lstu SET disabled = 1 WHERE short = ? RETURNING disabled', $c->short)->hashes->first->{disabled};
    if ($disabled) {
        if (scalar(@{$c->app->config('memcached_servers')})) {
            $c->app->chi('lstu_urls_cache')->remove($c->short);
        }
        $c = Lstu::DB::URL->new(app => $c->app);
    }

    return $disabled;
}

1;
