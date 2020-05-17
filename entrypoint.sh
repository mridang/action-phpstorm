#!/bin/sh -l

echo $1
echo $2
echo $3
echo $4
/opt/ide/bin/inspect.sh
find ./output -name '*.xml' ! -name '.descriptions.xml' | xargs xsltproc problems.xslt
