# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

Bundler::GemHelper.install_tasks

task test: %i[rubocop spec]
task default: :test

# Rubocop
desc 'Run Rubocop lint checks'
task :rubocop do # rubocop:disable Rails/RakeEnvironment
  RuboCop::RakeTask.new
end

desc 'Run specs'
RSpec::Core::RakeTask.new('spec') do |task|
  task.pattern = 'spec/**/*_spec.rb'
end

YARD::Rake::YardocTask.new(:doc) do |task|
  task.files   = %w[lib/**/*.rb - README.md]
  task.options = %w[no-private]
end
