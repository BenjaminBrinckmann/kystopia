#!/bin/sh

export $(cat .envProd)

echo "Deleting source directory …"
sudo rm -R $sourceDir
mkdir $sourceDir
echo "User-agent: * Disallow: /" > $sourceDir/robots.txt
hugo --environment production
find $sourceDir -type f -name "*.html" -exec tidy -m -utf8 -q -access 3 --output-html yes --hide-comments yes --show-filename yes --error-file tidy.log -i --vertical-space yes --wrap 80 {} \;

rsync -rtzzP $sourceDir/* $user@$host:$destDir
