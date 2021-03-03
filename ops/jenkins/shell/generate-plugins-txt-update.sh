#!/bin/bash -eu

set -o pipefail

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
url="https://updates.jenkins.io/current/update-center.actual.json"
plugin_txt_file="${current_dir}/../jcasc/jenkins_build_context/plugins.txt"
plugin_txt_diff_file="${plugin_txt_file}.diff"
tmp_plugins_txt="/tmp/plugin_new_$(date +%s).txt"

[[ ! -f $plugin_txt_file ]] && echo "Can't find jcasc/jenkins_build_context/plugins.txt" && exit 2

echo "Fetching latest plugins version from update center ..."
json=$(curl -sL ${url})
latestVersions=$(echo "${json}" | jq --raw-output '.plugins[] | .name + ":" + .version')
plugins=$(cat ${plugin_txt_file} | grep -vE '^(\s*$|#)')

echo "Generating $tmp_plugins_txt"
while read plugin; do

	plugin_no_version=${plugin%:*}
	result=$(echo "$latestVersions" | grep -E "^${plugin_no_version}:")

	if [[ "$result" != "" ]]; then
		echo "${result}" >> $tmp_plugins_txt
	else
		echo "[WARNING] Plugin ${plugin} not found"
	fi	

done <<< "${plugins}"

echo "Writing plugins.txt diff file with latest upgrades: $plugin_txt_diff_file"
diff -D NEW_STUFF --line-format %L $tmp_plugins_txt $plugin_txt_file | grep -v '^#if' | grep -v '^#endif' > $plugin_txt_diff_file

