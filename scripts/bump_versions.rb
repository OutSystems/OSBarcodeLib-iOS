# bump_version.rb

require 'bundler'

# Read version level from ARGV
level = ARGV[0]

# Define the path to your .podspec file
podspec_path = "./OSBarcodeLib.podspec"

# Read the .podspec file
podspec_content = File.read(podspec_path)

# Extract current version
current_version_number = podspec_content.match(/spec.version\s*=\s*["'](\d+\.\d+\.\d+)["']/)[1]

# Parse the version into major, minor, and patch components
major, minor, patch = current_version_number.split('.').map(&:to_i)

# Increment the version based on the specified level
case level
when "major"
  major += 1
  # Reset minor and patch to 0 when major version is incremented
  minor = 0
  patch = 0
when "minor"
  minor += 1
  # Reset patch to 0 when minor version is incremented
  patch = 0
when "patch"
  patch += 1
else
  raise ArgumentError, "Invalid version bump level: #{level}. Must be one of: major, minor, patch."
end

# Combine the new version components
new_version_number = [major, minor, patch].join('.')

# Replace 'Unreleased' in the CHANGELOG.md with the new version
changelog_path = "./CHANGELOG.md"
changelog_content = File.read(changelog_path)
new_changelog_content = changelog_content.gsub("[Unreleased]", new_version_number)
File.write(changelog_path, new_changelog_content)

# Replace the old version with the new version in the .podspec content
new_podspec_content = podspec_content.gsub(/(spec.version\s*=\s*["'])\d+\.\d+\.\d+(["'])/, "\\1#{new_version_number}\\2")
File.write(podspec_path, new_podspec_content)

# Set the application name
LIBRARY_NAME = "OSBarcodeLib"

# Set the Xcode project file path
project_file = "#{LIBRARY_NAME}.xcodeproj/project.pbxproj"

# Read the project file content
file_content = File.read(project_file)

# Fetch the current MARKETING_VERSION and CURRENT_PROJECT_VERSION values
current_build_number = Integer(file_content[/CURRENT_PROJECT_VERSION = ([^;]+)/, 1])

# Set the new build numbers
new_build_number = current_build_number + 1

# Update the MARKETING_VERSION and CURRENT_PROJECT_VERSION values in the project file
updated_content = file_content.gsub(/MARKETING_VERSION = [^;]+;/, "MARKETING_VERSION = #{new_version_number};")
                              .gsub(/CURRENT_PROJECT_VERSION = [^;]+;/, "CURRENT_PROJECT_VERSION = #{new_build_number};")

# Write the updated content back to the project file
File.open(project_file, "w") { |file| file.puts updated_content }

puts "Version updated to #{new_version_number} (Build Number ##{new_build_number})"