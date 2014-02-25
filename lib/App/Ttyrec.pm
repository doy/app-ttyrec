package App::Ttyrec;
use Moose;
# ABSTRACT: record interactive terminal sessions

use Tie::Handle::TtyRec 0.04;

with 'Term::Filter';

=head1 SYNOPSIS

  use App::Ttyrec;

  App::Ttyrec->new(
      ttyrec_file => 'nethack.ttyrec',
  )->run('nethack');

=head1 DESCRIPTION

This module handles setting up and running a terminal session which records its
output to a ttyrec file. These files can then be later read via software such
as L<Term::TtyRec::Plus>.

=cut

=attr ttyrec_file

The name of the file to write to (which can be a named pipe). Defaults to
C<ttyrecord>.

=cut

has ttyrec_file => (
    is      => 'ro',
    isa     => 'Str',
    default => 'ttyrecord',
);

=attr append

Whether or not to append to the ttyrec file. Defaults to false.

=cut

has append => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

=attr ttyrec

The L<Tie::Handle::TtyRec> instance used to actually write the ttyrec file.
Defaults to an instance created based on the values of C<ttyrec_file> and
C<append>.

=cut

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

=method run(@cmd)

Run the command specified by C<@cmd>, as though via C<system>. The output that
this command writes to the terminal will also be recorded in the file specified
by C<ttyrec_file>.

=cut

__PACKAGE__->meta->make_immutable;
no Moose;

=head1 BUGS

No known bugs.

Please report any bugs to GitHub Issues at
L<https://github.com/doy/app-ttyrec/issues>.

=head1 SEE ALSO

L<Term::TtyRec::Plus>

L<Tie::Handle::TtyRec>

L<http://0xcc.net/ttyrec/index.html.en>

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc App::Ttyrec

You can also look for information at:

=over 4

=item * MetaCPAN

L<https://metacpan.org/release/App-Ttyrec>

=item * Github

L<https://github.com/doy/app-ttyrec>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Ttyrec>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-Ttyrec>

=back

=begin Pod::Coverage

munge_output

=end Pod::Coverage

=cut

1;
