package Mounter;
use Mojo::Base 'Mojolicious';
use FindBin qw($Bin);
use File::Spec qw(catfile);

# This method will run once at server start
sub startup {
    my $self = shift;

    my $config = $self->plugin('Config' =>
        {
            file    => File::Spec->catfile($Bin, '..' ,'lstu.conf'),
            default => {
                prefix => '/'
            }
        }
    );

    $self->plugin('Mount' => {$config->{prefix} => File::Spec->catfile($Bin, '..', 'script', 'application')});
}

1;
