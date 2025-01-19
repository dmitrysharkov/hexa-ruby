# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'
require 'rubocop/rake_task'

Minitest::TestTask.create # named test, sensible defaults

# or more explicitly:

Minitest::TestTask.create(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_globs = ['test/**/*_test.rb']
end

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-minitest'
end

desc 'Run tests'
task default: :test
