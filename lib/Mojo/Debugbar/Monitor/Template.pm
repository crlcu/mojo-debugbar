package Mojo::Debugbar::Monitor::Template;
use Mojo::Base "Mojo::Debugbar::Monitor";

has 'icon' => '<i class="icon-file-code"></i>';
has 'name' => 'Templates';

sub render {
    my $self = shift;

    my $rows = '';

    foreach my $template (@{ $self->items }) {
        $rows .= sprintf('<tr><td>templates/%s.html.ep</td></tr>', $template);
    }

    return sprintf(
        '<table class="debugbar-templates table">
            <thead>
                <tr><th>Path</th></tr>
            </thead>
            <tbody>
                %s
            </tbody>
        </table>',
        $rows
    );
}

sub start {
    my $self = shift;

    my @templates;

    $self->app->hook(before_render => sub {
        my ($c, $args) = @_;

        push(@templates, $args->{ template }) if ($args->{ template });
    });

    $self->items(\@templates);
}

1;
