#!/usr/bin/env bash
set -e

package_name="faws-vcs/faws"
program_name="faws"

get_latest_release() {
  curl -s "https://api.github.com/repos/${package_name}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

latest_version=$(get_latest_release)
echo $latest_version

temporary_directory=$(mktemp -d)

release_os=$(uname -s)
release_arch=$(uname -m)
release_filename="${program_name}_${release_os}_${release_arch}.tar.gz"

echo "Installing Faws ${latest_version} for ${release_os}/${release_arch}"

package_release_url="https://github.com/${package_name}/releases/download/${latest_version}/${release_filename}"
curl -Lo ${temporary_directory}/${release_filename} $package_release_url

extract_directory="${temporary_directory}/${program_name}_${release_os}_${release_arch}"
mkdir $extract_directory

tar -xvzf "${temporary_directory}/${release_filename}" -C $extract_directory

sudo mv "${extract_directory}/${program_name}" "/usr/local/bin/${program_name}"

echo "Installed ${program_name} ${latest_version}"

echo "Removing ${temporary_directory}"

rm -rf $temporary_directory