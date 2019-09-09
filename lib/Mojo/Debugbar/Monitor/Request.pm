package Mojo::Debugbar::Monitor::Request;
use Mojo::Base "Mojo::Debugbar::Monitor";

has 'icon' => '<i class="icon-tag"></i>';
has 'name' => 'Request';

sub render {
    my $self = shift;

    my $rows = '';

    foreach my $item (@{ $self->items }) {
        $rows .= sprintf(
            '<tr>
                <td>%s</td>
                <td>%s</td>
            </tr>',
            $item->{ key }, $item->{ value } || ''
        );
    }

    return sprintf(
        '<table class="debugbar-templates table">
            <thead>
                <tr>
                    <th width="30%%">Key</th>
                    <th>Value</th>
                </tr>
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

    my @items;

    $self->app->hook(after_dispatch => sub {
        my $c = shift;

        push(@items, (
            { key => 'Method', value => $c->req->method },
            { key => 'Params', value => $c->req->params->to_string },
            { key => 'Controller', value => ref $c },
            { key => 'Action', value => $c->stash('action') },
        ));
    });

    $self->items(\@items);
}

1;
