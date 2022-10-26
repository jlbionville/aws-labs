export FILE_TO_UPLOAD=/tmp/aws-sam-cli-linux-x86_64.zip
aws s3api put-object --bucket alfaco-backup --key test/$FILE_TO_UPLOAD --body $FILE_TO_UPLOAD