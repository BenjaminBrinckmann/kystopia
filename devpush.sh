#!/bin/sh

export $(cat .env)

echo "Deleting source directory …"
sudo rm -R $sourceDir
mkdir $sourceDir
echo "User-agent: * Disallow: /" > $sourceDir/robots.txt
hugo --environment development
find $sourceDir -type f -name "*.html" -exec tidy -m -utf8 -q -access 3 --output-html yes --hide-comments yes --show-filename yes --error-file tidy.log -i --vertical-space yes --wrap 80 {} \;

lftp -v -c "set ssl:verify-certificate no; set ftp:ssl-force true; set ftp:ssl-protect-data true; open ftp://$ftpUser:$ftpPassword@$ftpHost:21; mirror -eRv --parallel=30 $sourceDir $destDir; quit;"
