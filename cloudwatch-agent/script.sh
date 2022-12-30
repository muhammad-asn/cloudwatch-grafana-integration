#!/bin/bash

# Amazon Cloudwatch Agent
apt-get update
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O amazon-cloudwatch-agent.deb
dpkg -i amazon-cloudwatch-agent.deb

## Agent config
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
    "metrics":{
       "metrics_collected":{
          "mem":{
             "measurement":[
               "mem_used_percent"
             ],
             "metrics_collection_interval":60
          }
       },
       "append_dimensions": {
         "InstanceId": "\${aws:InstanceId}\"
       }
    }
 }
EOF

## Restart configuration
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s