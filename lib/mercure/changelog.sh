#!/usr/bin/env zsh
 
output="$3.markdown"
html_output="$3"
css_stylesheet="/tmp/mercure_changelog.css"
gitlab_url="http://mobigitlab.pj.fr"
 
pretty_format="| [%cr]($gitlab_url/commits/%h) | [%an]($gitlab_url/u/%cn) | %s |"
pretty_format="| %cr | %an | (%h) | %s |"

echo '<style type="text/css">' > $css_stylesheet
echo 'body { line-height: 1.6em; color:#333333; font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif; }' >> $css_stylesheet
echo 'table { font-size: 12px; margin: 45px; text-align: left; border-collapse: collapse; }' >> $css_stylesheet
echo 'table th { font-size: 14px; font-weight: normal; padding: 10px 8px; color: #039; }' >> $css_stylesheet
echo 'table td { padding: 8px; color: #669; }' >> $css_stylesheet
echo 'table .odd { background: #e8edff; }' >> $css_stylesheet
echo '</style>' >> $css_stylesheet

 
echo "# Changelog from $1 to $2" > $output
echo "" >> $output
 
echo "## Dev" >> $output
echo "" >> $output
echo "|---|---|---|---|" >> $output
git log --pretty=format:$pretty_format --abbrev-commit --date=relative $1..$2 | grep -i -v -e "mantis" -e "fix" -e "merge" -e "pod" | sed 's/Dev/dev/'  >> $output
 
echo "" >> $output
 
echo "## Mantis" >> $output
echo "" >> $output
echo "|---|---|---|---|" >> $output
git log --pretty=format:$pretty_format --abbrev-commit --date=relative $1..$2 | grep -i "mantis" | grep -v -i -e "merge"   >> $output
echo "" >> $output
 
echo "## Pods" >> $output
echo "" >> $output
echo "|---|---|---|---|" >> $output
git log --pretty=format:$pretty_format --abbrev-commit --date=relative $1..$2 | grep -i "pod" | grep -v -i -e "merge"   >> $output
echo "" >> $output
 
pandoc -H $css_stylesheet -s $output -o $html_output
