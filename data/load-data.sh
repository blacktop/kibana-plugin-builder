#!/bin/bash
set -e

# Load malice test data into elasticsearch
elasticdump \
  --input=malice_mapping.json \
  --output=http://localhost:9200/malice \
  --type=mapping

elasticdump \
--input=malice_data.json \
--output=http://localhost:9200/malice \
  --type=data
