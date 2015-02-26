#!/usr/bin/env perl

use FindBin qw($Bin);
use local::lib qq($Bin/../);
use Biostat::Publications::Base qw(biostat www);

use Mojolicious::Lite;

app->config(
  hypnotoad => {
    listen   => ['http://localhost:8080'],
    workers  => 10,
    proxy    => 1,
    pid_file => '/tmp/hypnotoad.pid',
  }
);

helper db => sub {
  state $db = Biostat::Publications::DB->new();
};

helper user => sub {
  return shift->req->headers->remote_user // 'anonymous';
};

helper dept_id => sub {
  return shift->param('dept_id') // 1;
};

helper pmid => sub {
  return shift->param('pmid') // 0;
};

helper faculty_id => sub {
  return shift->param('faculty_id') // 0;
};

helper faculty => sub {
  my $c = shift;
  return $c->db->resultset('Faculty')->find($c->faculty_id);
};

get '/departments' => sub {
  my $c = shift;
  $c->render(
    json => [
      map +{
        id   => $_->id,
        name => $_->name,
        abbr => $_->abbr,
      },
      $c->db->resultset('Department')->all()
    ]
  );
};

get '/faculty' => sub {
  my $c = shift;
  my @faculty = $c->db->resultset('Faculty')->search({dept_id => $c->dept_id});

  $c->render(
    json => [
      map +{
        id       => $_->id,
        realname => $_->realname,
        uniqname => $_->uniqname,
        gid      => $_->gid,
        dept     => $_->dept->abbr,
      },
      @faculty
    ]
  );
};

get '/publications/:faculty_id' => sub {
  my $c = shift;

  $c->render(
    json => [
      map +{
        title          => $_->title,
        timescited     => $_->timescited,
        scopuseid      => $_->scopuseid,
        author         => $_->authors,
        year           => $_->year,
        journal_title  => $_->journal,
        journal_volume => $_->volume,
        pages          => $_->pages,
        pmid           => $_->pmid,
      },
      $c->faculty->publications
    ]
  );
};

get '/abstracts/:pmid' => sub {
  my $c = shift;
  my $abstract = $c->db->resultset('Abstract')->find({pmid => $c->pmid});
  $c->render(json => {text => $abstract->text});
};

app->start;
