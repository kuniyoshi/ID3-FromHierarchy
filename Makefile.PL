use 5.010000;
use ExtUtils::MakeMaker;


WriteMakefile(
    NAME              => 'ID3::FromHierarchy',
    VERSION_FROM      => 'lib/ID3/FromHierarchy.pm',
    PREREQ_PM         => {
        Readonly         => 0,
        Test::Synopsis   => 0,
    },
    LICENSE           => 'perl',
    ABSTRACT_FROM     => 'lib/ID3/FromHierarchy.pm',
    AUTHOR            => 'Kuniyoshi Kouji <kuniyoshi@cpan.org>',
);

