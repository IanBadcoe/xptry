#!/bin/bash

pushd $1
find . -exec stat --format='%n %A %U %G' {} \; | sort > ~/p1.txt
popd
pushd $2
find . -exec stat --format='%n %A %U %G' {} \; | sort > ~/p2.txt
popd
diff ~/p1.txt ~/p2.txt
