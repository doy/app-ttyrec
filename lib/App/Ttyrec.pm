package App::Ttyrec;
use Moose;
# ABSTRACT: record interactive terminal sessions

use Scalar::Util 'weaken';
use Tie::Handle::TtyRec 0.04;

with 'Term::Filter';

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

sub munge_output {
    my $self = shift;
    my ($got) = @_;

    syswrite $self->ttyrec, $got;

    $got;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
