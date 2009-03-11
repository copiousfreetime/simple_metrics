require 'mkmf'
create_makefile( 'simple_metrics_ext', 'src' )

File.open("Makefile", "ab") do |f|
  f.puts 
  f.puts "test_prog: $(OBJS) test/test_sm.o"
  f.puts "\t$(CC) -o $@ $(OBJS) test_sm.o $(LIBPATH) $(DLDFLAGS) $(LOCAL_LIBS) $(LIBS)"
end
