# bump_version.rb

require 'bundler'

# Read version level from ARGV
level = ARGV[0]

# Define the path to your .podspec file
podspec_path = "./OSBarcodeLib.podspec"

# Read the .podspec file
podspec_content = File.read(podspec_path)

# Extract current version
current_version = podspec_content.match(/spec.version\s*=\s*["'](\d+\.\d+\.\d+)["']/)[1]

# Parse the version into major, minor, and patch components
major, minor, patch = current_version.split('.').map(&:to_i)

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
new_version = [major, minor, patch].join('.')

# Replace the old version with the new version in the .podspec content
new_podspec_content = podspec_content.gsub(/(spec.version\s*=\s*["'])\d+\.\d+\.\d+(["'])/, "\\1#{new_version}\\2")

# Write the new .podspec content back to the file
File.write(podspec_path, new_podspec_content)

puts "Version updated to #{new_version}"
