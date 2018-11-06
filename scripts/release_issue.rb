#!/usr/bin/env ruby
# frozen_string_literal: true

require 'erb'
require 'versionomy'
require_relative 'projects'
require_relative 'releases'

# Release issue script generates the issue content for the upcoming release
# Usage:
# ./scripts/release_issue.rb 10-8-stable

release = ARGV[0]

unless release
  puts <<~USAGE
    Usage: #{$PROGRAM_NAME} <release>
    Exemple: #{$PROGRAM_NAME} 11.1

  USAGE
  exit 1
end

Releases.validate!(release)

version = Versionomy.parse(release)

# Load projects, checkout the master branches and verify that their VERSION file
# contains the expected version
projects = Projects.load
projects.each do |project|
  project.clone_or_update_repo
  project.checkout_branch('master')
  project.check_version_file(version)
end

branch_name = Projects.branch_name_for_version(version)
next_branch_name = Projects.branch_name_for_version(version.bump(:minor))

@template = File.read(File.expand_path('./templates/release_issue.md.erb', __dir__))
puts ERB.new(@template).result(binding)
