#!/bin/bash

# Little script to help with release management of the action
# Usage: ./release.sh <version>
#   where version is a version string of the form x.y.z

version="$1"

# Check that the version is valid
if ! [[ $version =~ ^v?[0-9]+\.[0-9]+\.[0-9]+$ ]] ; then
	>&2 echo "ERROR: Invalid version $version!"
	exit 1
fi

# Normalize the version string and parse minor/major
if [[ $version != v* ]] ; then
	version="v$version"
fi
minor="${version%.*}"
major="${minor%.*}"

# Check that the full version doesn't already exist
# The minor and major version tags will be updated
if [ $(git tag -l "$version") ]; then
	>&2 echo "ERROR: Version $version already exists!"
	exit 1
fi

echo "Releasing $version..."

versions=( $version $minor $major )
for tag in "${versions[@]}"
do
	# Delete tag if it exists
	if [ $(git tag -l "$tag") ]; then
		git push --delete origin "$tag" || true
	fi
	git tag -f "$tag"
done

git push
git push --tags
