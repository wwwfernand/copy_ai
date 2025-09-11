require_relative "lib/copy_ai/version"

Gem::Specification.new do |spec|
  spec.name = "copy_ai"
  spec.version = CopyAi::VERSION
  spec.authors = ["Fernand Arioja"]
  spec.email = ["dev.cloud.asm@gmail.com"]
  spec.homepage = "https://github.com/wwwfernand/copy_ai"
  spec.summary = "A Ruby interface to the Copy.ai API"
  spec.description = "A Ruby client library for accessing the Copy.ai API, " \
                     "allowing developers to easily integrate Copy.ai's text generation capabilities into their Ruby applications"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.6"
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/wwwfernand/copy_ai"
  spec.metadata["changelog_uri"] = "https://github.com/wwwfernand/copy_ai/master/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{bin,lib}/**/*", "MIT-LICENSE", "Rakefile", "*.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3.4", "< 9.0"
  spec.metadata["rubygems_mfa_required"] = "true"
end
