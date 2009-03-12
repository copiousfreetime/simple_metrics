require 'mkmf'
have_library( "simple_metrics", "simple_metrics_new" )
create_makefile( 'simple_metrics_ext', 'src' )

