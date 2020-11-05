#!/bin/sh

export $(cat .env)

echo "Deleting source directory …"
sudo rm -R $sourceDir
mkdir $sourceDir
echo "User-agent: * Disallow: /" > $sourceDir/robots.txt
hugo --environment development
# find $sourceDir -type f -name "*.html" -exec tidy -m -utf8 -q -access 3 --output-html yes --hide-comments yes --show-filename yes -i --vertical-space yes --wrap 80 {} \;

lftp -c "open ftp://$ftpUser:$ftpPassword@$ftpHost:21; mirror -eRv $sourceDir $destDir; quit;"
