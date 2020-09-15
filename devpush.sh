#!/bin/sh

export $(cat .env)

echo "Deleting source directory …"
sudo rm -R $sourceDir
mkdir $sourceDir
echo "User-agent: * Disallow: /" > $sourceDir/robots.txt
hugo --environment development
find $sourceDir -type f -name "*.html" -exec tidy -m -utf8 -q -access 3 --output-html yes --hide-comments yes --show-filename yes --error-file tidy.log -i --vertical-space yes --wrap 80 {} \;

lftp -c "set ftps:initial-prot ''; set ftp:ssl-force true; set ftp:ssl-protect-data true; open sftp://$ftpUser:$ftpPassword@$ftpHost:22; mirror -eRv $sourceDir $destDir; quit;"