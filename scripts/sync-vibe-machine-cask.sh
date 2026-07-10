#!/usr/bin/env bash

set -euo pipefail

repo="misty-step/vibe-machine"
cask="Casks/vibe-machine.rb"
release_json=$(mktemp)
trap 'rm -f "$release_json"' EXIT

gh api "repos/$repo/releases/latest" > "$release_json"

tag=$(jq -er '.tag_name | select(test("^v[0-9]+\\.[0-9]+\\.[0-9]+$"))' "$release_json")
version=${tag#v}

expected_asset="Vibe.Machine_${version}_aarch64.dmg"
asset_count=$(jq --arg name "$expected_asset" '[.assets[] | select(.name == $name)] | length' "$release_json")
if [[ "$asset_count" -ne 1 ]]; then
  echo "expected exactly one $expected_asset asset in $tag; found $asset_count" >&2
  exit 1
fi

asset_name=$(jq -er --arg name "$expected_asset" '.assets[] | select(.name == $name) | .name' "$release_json")
asset_url=$(jq -er --arg name "$expected_asset" '.assets[] | select(.name == $name) | .browser_download_url | select(startswith("https://github.com/misty-step/vibe-machine/releases/download/"))' "$release_json")
sha256=$(jq -er --arg name "$expected_asset" '.assets[] | select(.name == $name) | .digest | select(test("^sha256:[0-9a-f]{64}$")) | sub("^sha256:"; "")' "$release_json")
expected_url="https://github.com/misty-step/vibe-machine/releases/download/$tag/$expected_asset"
if [[ "$asset_url" != "$expected_url" ]]; then
  echo "release asset URL does not match the canonical GitHub path" >&2
  exit 1
fi

cask_url='https://github.com/misty-step/vibe-machine/releases/download/v#{version}/Vibe.Machine_#{version}_aarch64.dmg'

ruby - "$cask" "$version" "$sha256" "$cask_url" <<'RUBY'
path, version, sha256, url = ARGV
content = File.read(path)
content.sub!(/^  version ".*"$/, %(  version "#{version}")) or abort "version line missing"
content.sub!(/^  sha256 ".*"$/, %(  sha256 "#{sha256}")) or abort "sha256 line missing"
content.sub!(/^  url ".*"$/, %(  url "#{url}")) or abort "url line missing"
File.write(path, content)
RUBY

echo "vibe-machine cask synchronized to $tag ($asset_name)"
