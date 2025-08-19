#!/bin/bash

# Step 1: Create the user
echo "Creating user..."
USER_CREATION_OUTPUT=$(gitlab-rails runner '
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
')
echo "$USER_CREATION_OUTPUT"

# Step 2: Generate the personal access token
echo "Generating personal access token..."
TOKEN=$(gitlab-rails runner '
  user = User.find_by(username: "abdel-ou")
  if user
    token = user.personal_access_tokens.create!(
      name: "MyToken",
      scopes: [:api],
      expires_at: 30.days.from_now
    )
    puts token.token
  else
    puts "User not found: abdel-ou"
  end
')

if [[ -z "$TOKEN" ]]; then
  echo "Failed to generate personal access token"
  exit 1
fi

echo "Your personal access token: $TOKEN"

# Step 3: Create a public repository
echo "Creating repository..."
GITLAB_URL="http://localhost:8080"
PROJECT_NAME="django-app-gitlab-abdel-ou"
VISIBILITY="public"

RESPONSE=$(curl --silent --request POST "${GITLAB_URL}/api/v4/projects" \
  --header "PRIVATE-TOKEN: ${TOKEN}" \
  --header "Content-Type: application/json" \
  --data "{
    \"name\": \"${PROJECT_NAME}\",
    \"visibility\": \"${VISIBILITY}\"
  }")

if echo "$RESPONSE" | grep -q '"id":'; then
  echo "Repository '${PROJECT_NAME}' created successfully."
else
  echo "Failed to create repository. Response: $RESPONSE"
  # exit 1
fi

# Step 4: Clone the repository and push code
echo "Cloning repository..."
REPO_URL="http://oauth2:${TOKEN}@gitlab-pod/abdel-ou/${PROJECT_NAME}.git"
git clone "${REPO_URL}" || { echo "Failed to clone repository"; exit 1; }

cd "${PROJECT_NAME}" || exit

echo "Configuring Git..."
git config --global user.name "Abdelmajid el-oualy"
git config --global user.email "abdel-ou@gmail.com"

echo "Adding test code..."
echo "# Django App GitLab" > README.md
mkdir config
echo "sample pod configuration" > config/pod.yaml

git checkout -b main || git checkout main
git add .
git commit -m "Initial commit with test code"

echo "Pushing code to repository..."
git push -u origin main || { echo "Failed to push code"; exit 1; }

echo "Code pushed to the repository successfully."