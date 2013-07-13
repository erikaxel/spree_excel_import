$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
version = File.read(File.expand_path("../version",__FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spree_excel_import"
  s.version     = version
  s.author     = "Erik Axel Nielsen"
  s.email       = "spree@illumina.no"
  s.homepage    = "https://github.com/erikaxel/spree_excel_import"
  s.summary     = "N/A"
  s.description = "N/A"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.has_rdoc      = false
  s.add_dependency 'spree_core', '>=1.3.0'
  s.add_dependency 'roo', '>=1.9.3'
end
