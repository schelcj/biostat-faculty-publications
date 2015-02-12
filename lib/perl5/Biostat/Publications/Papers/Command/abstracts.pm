package Biostat::Publications::Papers::Command::abstracts;

# Guidelines for pubmed API:
#
# In order not to overload the E-utility servers, NCBI recommends that
# users post no more than three URL requests per second and limit large jobs
# to either weekends or between 9:00 PM and 5:00 AM Eastern time during
# weekdays.

use Biostat::Publications::Papers -command;
use Biostat::Publications::Base qw(biostat www);

Readonly::Scalar my $PUBMED_URL_FMT => q{http://www.ncbi.nlm.nih.gov/pubmed/%d?report=xml&format=text};
Readonly::Scalar my $XPATH          => q{//PubmedArticle/MedlineCitation/Article/Abstract/AbstractText};

sub opt_spec {
  return (['import|i', 'Import abstracts from pubmed'],);
}

sub execute {
  my ($self, $opt, $args) = @_;

  if ($opt->{import}) {
    my $db    = Biostat::Publications::DB->new();
    my $agent = Mojo::UserAgent->new;

    $agent->transactor->name($USER_AGENT_ALIASES{'Linux Ubuntu Chrome'});

    for my $pub ($db->resultset('Publication')->all) {
      next unless $pub->pmid;

      unless ($pub->abstracts->count) {
        my $url      = sprintf $PUBMED_URL_FMT, $pub->pmid;
        my $content  = $agent->get($url)->res->body;
        my $parser   = XML::XPath->new(xml => $content);
        my $abstract = join($EMPTY, map {$_->string_value} $parser->find($XPATH)->get_nodelist);

        if ($abstract) {
          $pub->add_to_abstracts({text => $abstract});
        }
      }
    }
  }

  return;
}

1;

__END__

=head1 NAME

Biostat::Publications::Papers::Command::abstracts - Import publication abstracts

=cut
