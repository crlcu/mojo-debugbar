package Mojo::Debugbar;
use Mojo::Base -base;

use Mojo::Debugbar::Monitors;
use Mojo::Loader qw(load_class);
use Mojo::Server;

our $VERSION = '0.0.1';

has 'app' => sub { Mojo::Server->new->build_app('Mojo::HelloWorld') }, weak => 1;
has 'config' => sub { {} };

has 'monitors' => sub {
    my $self = shift;

    my @monitors;

    foreach my $module (@{ $self->app->config->{ debugbar }->{ monitors } || [] }) {
        my $monitor = _monitor($module, 1);

        push(@monitors, $monitor->new(app => $self->app));
    }

    return Mojo::Debugbar::Monitors->new(
        registered  => \@monitors,
        hide_empty  => $self->app->config->{ debugbar }->{ hide_empty },
    );
};

=head2 render
    Proxy for monitors->render
=cut

sub render {
    return shift->monitors->render;
}

=head2 stop
    Proxy for monitors->stop
=cut

sub stop {
    my $self = shift;

    $self->monitors->stop;

    return $self;
}

=head2 start
    Proxy for monitors->start
=cut

sub start {
    my $self = shift;

    $self->monitors->start;

    return $self;
}


=head2 _monitor
    Load monitor
=cut

sub _monitor {
    my ($module, $fatal) = @_;

    return $module->isa('Mojo::Debugbar::Monitor') ? $module : undef
        unless my $e = load_class $module;
    $fatal && ref $e ? die $e : return undef;
}

1;
