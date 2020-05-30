#!/bin/sh -l

# There's no clean way to specify the scope and therefore we must use this
# nasty workaround.
# https://intellij-support.jetbrains.com/hc/en-us/community/posts/115000132670
if [ "$5" != "default" ]; then
  if [ ! -f /opt/ide/bin/phpstorm.vmoptions ] ; then
    echo "Cannot file /opt/ide/bin/phpstorm.vmoptions options file"
    exit
  fi
  echo "-Didea.analyze.scope=$5" >> /opt/ide/bin/phpstorm.vmoptions

  if [ ! -f /opt/ide/bin/phpstorm64.vmoptions ] ; then
    echo "Cannot file /opt/ide/bin/phpstorm64.vmoptions options file"
    exit
  fi
  echo "-Didea.analyze.scope=$5" >> /opt/ide/bin/phpstorm64.vmoptions
fi

# Run the inspection with the parameters provided. This script is a real pain to
# work with so be cautious when editing the order of the parameters.
echo "Running inspections"
/opt/ide/bin/inspect.sh "$1" "$2" "$3" -d "$1" "-$4"
if [ ! -f "$3/.descriptions.xml" ] ; then
  echo "No XML files generated in the output dir. Something is wrong."
  exit
fi


echo "Cleaning path references"
# The default run generates one file for each inspection type. We want to remove
# all the not needed ones. The user provides a comma delimited list of files to
# ignore and we simply explode and remove those
echo "$6" | awk 'BEGIN{RS=","} {print}' | xargs -I{} rm -f "$3/{}"

find "$3" -name '*.xml' ! -name '.descriptions.xml' | xargs -0 xsltproc /files.xslt | sort | uniq

# Now we'll remove the $PROJECT_DIR$ references
find "$3" -name '*.xml' ! -name '.descriptions.xml' | xargs -0 sed -i 's|$PROJECT_DIR$||g'

# Now we'll remove the file:// references
find "$3" -name '*.xml' ! -name '.descriptions.xml' | xargs -0 sed -i 's|file://||g'

# Remove all the references to GITHUB_WORKSPACE in all the XML files. The
# inspection results have file paths in the format.
# file://$PROJECT_DIR$/$GITHUB_WORKSPACE or file://$GITHUB_WORKSPACE
# Notice that $GITHUB_WORKSPACE is a variable, while $PROJECT_DIR$ is not
find "$3" -name '*.xml' ! -name '.descriptions.xml' | xargs -0 sed -i "s|$GITHUB_WORKSPACE||g"

echo "Sanity check file paths"
find "$3" -name '*.xml' ! -name '.descriptions.xml' | xargs -0 xsltproc /files.xslt | sort | uniq
find "$3" -name '*.xml' ! -name '.descriptions.xml' | xargs -0 xsltproc /files.xslt | sort | uniq | xargs -I{} test -e {}

echo "Parsing problems and reporting annotations"
# Now to iterate all the XML files, transform them and then print them.
find "$3" -name '*.xml' ! -name '.descriptions.xml' | xargs -0 xsltproc /problems.xslt
