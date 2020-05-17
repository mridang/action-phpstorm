#!/bin/sh -l


/opt/ide/bin/inspect.sh
find ./output -name '*.xml' ! -name '.descriptions.xml' | xargs xsltproc problems.xslt
