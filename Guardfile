# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# with Minitest::Test
guard :minitest do
  watch( %r{^test/(.*)\/?(.*)_test\.rb$} )
  watch( %r{^lib/(.*/)?([^/]+)\.rb$}     ) { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  #watch( %r{^lib/(.*/)?([^/]+)\.rb$}     ) { 'test' }
  #watch( %r{^test/test_helper\.rb$}      ) { 'test' }
end
