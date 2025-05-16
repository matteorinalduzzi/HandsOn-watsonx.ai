#!/bin/bash

# Set API key as an environment variable
export APIKEY="{API_KEY}"
# Set Project ID as an environment variable
export PRJ_ID="{PRJ_ID}"
# Set the question
INPUT_TEXT="How far is Paris from Bangalore?"

# Use curl to get the API response and store it in a variable
API_RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  https://iam.cloud.ibm.com/identity/token \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=$APIKEY")

# Store access token in a variable from the JSON response
ACCESS_TOKEN=$(echo "$API_RESPONSE" | jq -r '.access_token')

# Print the question
echo "Q: "$INPUT_TEXT

# Make the API call to Watsonx and extract 'generated_text' from the response
API_RESPONSE=$(curl "https://eu-de.ml.cloud.ibm.com/ml/v1/text/generation?version=2023-05-29" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -s \
  -d '{
    "input": "<|start_of_role|>system<|end_of_role|>You are Granite, an AI language model developed by IBM in 2024. You are a cautious assistant. You carefully follow instructions. You are helpful and harmless and you follow ethical guidelines and promote positive behavior.<|end_of_text|><|start_of_role|>user<|end_of_role|>'"$INPUT_TEXT"'<|end_of_text|><|start_of_role|>assistant<|end_of_role|>",
    "parameters": {
      "decoding_method": "greedy",
      "max_new_tokens": 900,
      "min_new_tokens": 0,
      "stop_sequences": [],
      "repetition_penalty": 1
    },
    "model_id": "ibm/granite-3-8b-instruct",
    "project_id": "'$PRJ_ID'"
  }'
)

# Extract 'generated_text' from the JSON response using jq
GENERATED_TEXT=$(echo "$API_RESPONSE" | jq -r '.results[0].generated_text')

# Print the extracted text
echo "A: "$GENERATED_TEXT