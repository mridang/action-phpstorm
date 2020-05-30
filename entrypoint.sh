#!/bin/sh -l

# There's no clean way to specify the scope and therefore we must use this
# nasty workaround.
# https://intellij-support.jetbrains.com/hc/en-us/community/posts/115000132670
if [ "$5" != "default" ]; then
  echo "-Didea.analyze.scope=$5" >> /opt/ide/bin/phpstorm.vmoptions
  echo "-Didea.analyze.scope=$5" >> /opt/ide/bin/phpstorm64.vmoptions
fi

/opt/ide/bin/inspect.sh $1 $2 $3 -d $1 -$4
find output -name '*.xml' ! -name '.descriptions.xml' | xargs sed -i "s/file:\/\/\\\$PROJECT_DIR\\\$//g"
find $3 -name '*.xml' ! -name '.descriptions.xml' | xargs xsltproc /problems.xslt
