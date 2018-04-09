source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place_or_version, fake_version = nil)
  if place_or_version =~ %r{\A(git[:@][^#]*)#(.*)}
    [fake_version, { git: Regexp.last_match(1), branch: Regexp.last_match(2), require: false }].compact
  elsif place_or_version =~ %r{\Afile:\/\/(.*)}
    ['>= 0', { path: File.expand_path(Regexp.last_match(1)), require: false }]
  else
    [place_or_version, { require: false }]
  end
end

def gem_type(place_or_version)
  if place_or_version =~ %r{\Agit[:@]}
    :git
  elsif !place_or_version.nil? && place_or_version.start_with?('file:')
    :file
  else
    :gem
  end
end

ruby_version_segments = Gem::Version.new(RUBY_VERSION.dup).segments
minor_version = ruby_version_segments[0..1].join('.')

group :test do
  gem "puppetlabs_spec_helper", '~> 2.6.0',                        require: false
  gem "rspec-puppet", '~> 2.5',                                    require: false
  gem "rspec-puppet-facts",                                        require: false
  gem "rspec-puppet-utils",                                        require: false
  gem "puppet-lint-leading_zero-check",                            require: false
  gem "puppet-lint-trailing_comma-check",                          require: false
  gem "puppet-lint-version_comparison-check",                      require: false
  gem "puppet-lint-classes_and_types_beginning_with_digits-check", require: false
  gem "puppet-lint-unquoted_string-check",                         require: false
  gem "puppet-lint-variable_contains_upcase",                      require: false
  gem "metadata-json-lint",                                        require: false
  gem "redcarpet",                                                 require: false
  gem "rubocop", '~> 0.49.1',                                      require: false
  gem "rubocop-rspec", '~> 1.15.0',                                require: false
  gem "mocha", '>= 1.2.1',                                         require: false
  gem "coveralls",                                                 require: false
  gem "simplecov-console",                                         require: false
  gem "rack", '~> 1.0',                                            require: false
  gem "parallel_tests",                                            require: false
  gem "hiera",                                                     require: false
end
group :development do
  gem "travis",                  require: false
  gem "travis-lint",             require: false
  gem "guard-rake",              require: false
  gem "overcommit", '>= 0.39.1', require: false
end
group :system_tests do
  gem "winrm",                        require: false
  gem "beaker-rspec",                 require: false
  gem "serverspec",                   require: false
  gem "beaker-puppet_install_helper", require: false
  gem "beaker-module_install_helper", require: false
end
group :release do
  gem "github_changelog_generator", require: false, git: 'https://github.com/skywinder/github-changelog-generator'
  gem "puppet-blacksmith",          require: false
  gem "voxpupuli-release",          require: false, git: 'https://github.com/voxpupuli/voxpupuli-release-gem'
  gem "puppet-strings", '~> 1.0',   require: false
end

puppet_version = ENV['PUPPET_GEM_VERSION']
puppet_type = gem_type(puppet_version)
facter_version = ENV['FACTER_GEM_VERSION']
hiera_version = ENV['HIERA_GEM_VERSION']

gems = {}

gems['puppet'] = location_for(puppet_version)

# If facter or hiera versions have been specified via the environment
# variables

gems['facter'] = location_for(facter_version) if facter_version
gems['hiera'] = location_for(hiera_version) if hiera_version

if Gem.win_platform? && puppet_version =~ %r{^(file:///|git://)}
  # If we're using a Puppet gem on Windows which handles its own win32-xxx gem
  # dependencies (>= 3.5.0), set the maximum versions (see PUP-6445).
  gems['win32-dir'] =      ['<= 0.4.9', require: false]
  gems['win32-eventlog'] = ['<= 0.6.5', require: false]
  gems['win32-process'] =  ['<= 0.7.5', require: false]
  gems['win32-security'] = ['<= 0.2.5', require: false]
  gems['win32-service'] =  ['0.8.8', require: false]
end

gems.each do |gem_name, gem_params|
  gem gem_name, *gem_params
end

# Evaluate Gemfile.local and ~/.gemfile if they exist
extra_gemfiles = [
  "#{__FILE__}.local",
  File.join(Dir.home, '.gemfile'),
]

extra_gemfiles.each do |gemfile|
  if File.file?(gemfile) && File.readable?(gemfile)
    eval(File.read(gemfile), binding)
  end
end
# vim: syntax=ruby
