workflow "Terraform" {
  resolves = "terraform-plan"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "terraform-fmt" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.3.4"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "app"
  }
}

action "terraform-init-cognito" {
  uses = "hashicorp/terraform-github-actions/init@v0.3.4"
  needs = "terraform-fmt"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "app/cognito/user_pool"
  }
}

action "terraform-validate-cognito" {
  uses = "hashicorp/terraform-github-actions/validate@v0.3.4"
  needs = "terraform-init-cognito"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "app/cognito/user_pool"
  }
}

action "terraform-plan-cognito" {
  uses = "hashicorp/terraform-github-actions/plan@v0.3.4"
  needs = "terraform-validate"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "app/cognito/user_pool"
    TF_ACTION_WORKSPACE = "${GITHUB_REF##*/}"
  }
}