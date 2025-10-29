 cat invoice-pdf.sh
#!/bin/bash

export DPACCTOKEN="dop"
export DO_SPACES_REGION=""
export DO_SPACES_BUCKET=""
export DO_SPACES_ENDPOINT=""
export DO_SPACES_KEY=""
export DO_SPACES_SECRET=""
export AWS_ACCESS_KEY_ID=$DO_SPACES_KEY
export AWS_SECRET_ACCESS_KEY=$DO_SPACES_SECRET
export SLACK_TOKEN="slack-token"
export SLACK_CHANNEL="channel-name"



filepath=/invoice-pdfs
filename=invoice-$(date +'%Y-%m-%d').pdf # this variable will be the pdf's name with the date

mkdir -p $filepath

doctl auth init -t $DPACCTOKEN #this command line will make the server where this script has runned is trusted server


doctl invoice pdf preview $filepath/$filename  # this line will install the preview UUID from the DigitalOcean and save it with the predifined name

echo "☁️ Uploading to DigitalOcean Space..."
aws --endpoint-url "$DO_SPACES_ENDPOINT" \
  s3 cp "$filepath/$filename" "s3://${DO_SPACES_BUCKET}/${filename}" \
  --region "$DO_SPACES_REGION" \
  --acl public-read \
  --no-progress

file_url="${DO_SPACES_ENDPOINT}/${DO_SPACES_BUCKET}/${filename}"

# === Send Slack message ===
current_month=$(date +'%B %Y')
message="DigitalOcean Invoice Update – Development Environment\n\n\
This invoice represents the current month’s DigitalOcean usage for the development environment.\n\
It was automatically generated and uploaded by Youssef (DevOps Engineer).\n\
The job runs every 10 days to keep the CEO informed about the latest infrastructure costs and resource usage.\n\n\
<${file_url}|Click here to view the invoice (PDF)>"

curl -s -X POST \
  -H "Authorization: Bearer ${SLACK_TOKEN}" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data "{
    \"channel\": \"${SLACK_CHANNEL}\",
    \"text\": \"${message}\"
  }" \
  https://slack.com/api/chat.postMessage


