package App::Ttyrec;
use Moose;

use Scalar::Util 'weaken';
use Term::Filter;
use Tie::Handle::TtyRec;

has ttyrec_file => (
    is      => 'ro',
    isa     => 'Str',
    default => 'ttyrecord',
);

has append => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

has ttyrec => (
    is      => 'ro',
    isa     => 'FileHandle',
    lazy    => 1,
    default => sub {
        my $self = shift;
        Tie::Handle::TtyRec->new($self->ttyrec_file, append => $self->append)
    },
);

has term => (
    is      => 'ro',
    isa     => 'Term::Filter',
    lazy    => 1,
    default => sub {
        my $_self = shift;
        weaken(my $self = $_self);
        Term::Filter->new(
            callbacks => {
                munge_output => sub {
                    my $term = shift;
                    my ($got) = @_;

                    syswrite $self->ttyrec, $got;

                    $got;
                },
            },
        );
    },
    handles => ['run'],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;
