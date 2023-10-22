# frozen_string_literal: true

require_relative "lib/fruit_juice/version"

Gem::Specification.new do |spec|
  spec.name = "fruit_juice"
  spec.version = FruitJuice::VERSION
  spec.authors = ["Seth Tucker"]
  spec.email = ["crimsonknightstudios@gmail.com"]

  spec.summary = "Ruby job adapter to enqueue background jobs in Mosquito for Crystal. Uniting Ruby/Rails & Crystal!"
  spec.description = "This handy adapter will let you enqueue delayed jobs from a Ruby/Rails app and have the job processed by Mosquito in Crystal. The idea behind this came from a Ruby/Rails app needing a better way to process massive background jobs more effeciently, and a desire to stay curious and explore."
  spec.homepage = "https://github.com/crimson-knight/fruit_juice"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/crimson-knight/fruit_juice"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if RUBY_VERSION >= "2.3.0"
    spec.add_dependency "redis", ">= 4.2.0"
  else
    spec.add_dependency "redis", "4.1.0"
    spec.add_dependency "thor", "1.2.2"
  end

  if RUBY_VERSION >= "2.3.0"
    spec.add_development_dependency "appraisal", "~> 2.5"
  else
    spec.add_development_dependency "appraisal", "2.2.0"
  end
end
