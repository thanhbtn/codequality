#!/usr/bin/env ruby
# frozen_string_literal: true

require 'erb'
require_relative 'projects'
require_relative 'merge_requests'
require_relative 'issues'
require_relative 'releases'

# QA issue script generates the issue content for the upcoming release's QA
# Usage:
# ./scripts/qa_issue.rb 10.8

release = ARGV[0]

unless release
  puts <<~USAGE
    Usage: #{$PROGRAM_NAME} <release>
    Exemple: #{$PROGRAM_NAME} 11.1

  USAGE
  exit 1
end

Releases.validate!(release)

unless ENV['GITLAB_API_PRIVATE_TOKEN']
  raise 'Please set your GitLab token in environment variable GITLAB_API_PRIVATE_TOKEN'
end

version = Versionomy.parse(release)
branch_name = Projects.branch_name_for_version(version)

# Load projects, checkout or create a new branch for the release
projects = Projects.load
projects.each(&:clone_or_update_repo)

merge_requests = MergeRequests.load version
issues = Issues.load version

# Render issue
@template = File.read(File.expand_path('./templates/qa_issue.md.erb', __dir__))
puts ERB.new(@template).result(binding)
