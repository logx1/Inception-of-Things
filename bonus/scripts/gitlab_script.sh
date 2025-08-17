#!/bin/bash

# Step 1: Create the user
gitlab-rails runner '
  root_user = User.find_by(username: "root") # Find the root user
  if root_user && root_user.namespace
    user = User.new(
      username: "abdel-ou",
      email: "abdel-ou@gmail.com",
      name: "avdelmajid el-oualy",
      password: "Facebook2000@",
      password_confirmation: "Facebook2000@",
      namespace: root_user.namespace, # Associate with the root namespace
      admin: true # Grant admin privileges
    )
    if user.save
      puts "User created successfully with admin privileges and associated with the root namespace"
    else
      puts "Failed to create user: #{user.errors.full_messages.join(", ")}"
    end
  else
    puts "Root user or namespace not found"
  end
'

# Step 2: Generate the personal access token and save it to a variable
TOKEN=$(gitlab-rails runner '
  user = User.find_by(username: "abdel-ou")
  if user
    token = user.personal_access_tokens.create!(
      name: "MyToken",
      scopes: [:api],
      expires_at: 30.days.from_now # Set an expiration date (e.g., 30 days from now)
    )
    puts token.token # Output only the token
  else
    puts "User not found: abdel-ou"
  end
')

# Step 3: Use the token to create a public repository
if [[ -n "$TOKEN" ]]; then
  echo "Your personal access token: $TOKEN"
  
  GITLAB_URL="http://localhost:8080"

  # Repository details
  PROJECT_NAME="django-app-gitlab_abdel-ou"
  VISIBILITY="public" # Set repository visibility to public

  # Create the repository using the GitLab API
  RESPONSE=$(curl --silent --request POST "${GITLAB_URL}/api/v4/projects" \
    --header "PRIVATE-TOKEN: ${TOKEN}" \
    --header "Content-Type: application/json" \
    --data "{
      \"name\": \"${PROJECT_NAME}\",
      \"visibility\": \"${VISIBILITY}\"
    }")

  # Check if the repository was created successfully
  if echo "$RESPONSE" | grep -q '"id":'; then
    echo "Repository '${PROJECT_NAME}' created successfully and is public."
  else
    echo "Failed to create repository. Response: $RESPONSE"
  fi
else
  echo "Failed to generate personal access token"
fi

 

if [[ -n "$TOKEN" ]]; then
  # GitLab instance URL
  GITLAB_URL="http://gitlab-pod"

  # Repository details
  PROJECT_NAME="django-app-gitlab"
  REPO_URL="http://oauth2:${TOKEN}@gitlab-pod/abdel-ou/${PROJECT_NAME}.git"

  # Clone the repository
  git clone "${REPO_URL}" || { echo "Failed to clone repository"; exit 1; }
  
  # Navigate into the repository directory
  cd "${PROJECT_NAME}" || exit

  # Configure Git
  git config --global user.name "Abdelmajid el-oualy"
  git config --global user.email "abdel-ou@gmail.com"

  # Add some test code
  echo "# Django App GitLab" > README.md
  mkdir config

  cp /etc/gitlab/pod.yaml config/pod.yaml


  # Initialize the repository if empty
  git checkout -b main || git checkout main

  # Stage the changes
  git add .

  # Commit the changes
  git commit -m "Initial commit with test code"

  # Push the changes
  git push -u origin main || { echo "Failed to push code"; exit 1; }

  echo "Code pushed to the repository successfully."
else
  echo "Failed to generate personal access token or create repository."
  exit 1
fi