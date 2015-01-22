package Biostat::Publications::Import::Factory;

use MooseX::AbstractFactory;

implementation_does [__PACKAGE__ . '::Implementation::Requires'];

implementation_class_via sub { __PACKAGE__ . '::Implementation::' . shift };

1;
