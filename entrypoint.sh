#!/bin/sh -l

# There's no clean way to specify the scope and therefore we must use this
# nasty workaround.
# https://intellij-support.jetbrains.com/hc/en-us/community/posts/115000132670
if [ "$5" != "default" ]; then
  echo "-Didea.analyze.scope=$5" >> /opt/ide/bin/phpstorm.vmoptions
  echo "-Didea.analyze.scope=$5" >> /opt/ide/bin/phpstorm64.vmoptions
fi

/opt/ide/bin/inspect.sh $1 $2 $3 -d $1 -$4
echo $6 | awk 'BEGIN{RS=","} {print}' | xargs -I{} rm -f "$3/{}"
# Remove all the references to GITHUB_WORKSPACE in all the XML files. The
# insection results have file paths in the format.
# file://$PROJECT_DIR$/$GITHUB_WORKSPACE
# Notice that $GITHUB_WORKSPACE is a variable, while $PROJECT_DIR$ is not
find $3 -name '*.xml' ! -name '.descriptions.xml' | xargs sed -i "s/$GITHUB_WORKSPACE//g"
# Now we'll remove the file://$PROJECT_DIR$ references
find $3 -name '*.xml' ! -name '.descriptions.xml' | xargs sed -i 's/file:\\$PROJECT_DIR$//g'
# Now to iterate all the XML files, transform them and then print them.
find $3 -name '*.xml' ! -name '.descriptions.xml' | xargs xsltproc /problems.xslt
