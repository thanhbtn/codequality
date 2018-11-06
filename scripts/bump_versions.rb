#!/usr/bin/env ruby
# frozen_string_literal: true

require 'erb'
require_relative 'projects'
require_relative 'releases'

# The version update script bumps master branches VERSION and CHANGELOG
# Usage:
# ./scripts/version_bump.rb 11.1 11.2

if ARGV.count != 2
  puts <<-USAGE
    Usage: #{$PROGRAM_NAME} <old-version> <new-version>
    Example: #{$PROGRAM_NAME} 11.1 11.2
  USAGE
  exit 1
end

release = ARGV[0]
next_release = ARGV[1]

Releases.validate!(release)
Releases.validate!(next_release)

version = Versionomy.parse(release)
branch = Projects.branch_name_for_version(version)
next_version = Versionomy.parse(next_release)

puts <<~WARNING
  This will create #{branch} branches in the projects, push them and then
  update the versions in VERSION and CHANGELOG.md files for master branches and then push them too.
  Be sure that you have completed changelogs and documentations for the current versions before doing this
  as specified in the release issue.
WARNING

puts 'Ready to start. Confirm? (Y/n)'
reply = STDIN.gets.strip.downcase
exit unless reply == 'y'

projects = Projects.load

# First, create the current version branches
projects.each do |project|
  puts "Creating branch #{branch} for #{project.name}"
  project.clone_or_update_repo
  project.checkout_branch('master')
  project.checkout_branch(branch)
end

puts "Ready to push #{branch} branches. Confirm? (Y/n)"
reply = STDIN.gets.strip.downcase

if reply == 'y'
  projects.each do |project|
    puts "Pushing #{project.name}"
    project.push
  end
end

projects.each do |project|
  puts "Bumping #{project.name} to version #{next_version}"
  project.bump(next_version)
end

puts 'Ready to push master branches. Confirm? (Y/n)'
reply = STDIN.gets.strip.downcase

if reply == 'y'
  projects.each do |project|
    puts 'Pushing ' + project.name
    project.push
  end
end
