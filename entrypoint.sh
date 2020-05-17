#!/bin/sh -l

echo $1
echo $2
echo $3
echo $4
/opt/ide/bin/inspect.sh $1 $2 $3 -d $1 -$4
find $3 -name '*.xml' ! -name '.descriptions.xml' | xargs xsltproc problems.xslt
