#!/bin/sh -l

/opt/ide/bin/inspect.sh $1 $2 $3 -d $1 -$4
find $3 -name '*.xml' ! -name '.descriptions.xml' | xargs xsltproc /problems.xslt
