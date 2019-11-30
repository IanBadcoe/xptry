#!/bin/bash

pushd ~/www
find . -exec stat --format='%n %A %U %G' {} \; | sort > ~/list_www.txt
popd
pushd ~/backup/www
find . -exec stat --format='%n %A %U %G' {} \; | sort > ~/list_www_cp.txt
popd
diff ~/list_www.txt ~/list_www_cp.txt
