variable "git_branch" {
    description = "The current branch of the GIT repo"
    type        = "string"
}

variable "aws_role_arn" {
    description = "Role to assume when interacting with AWS"
}

variable "aws_account_id" {
    description = "AWS Account to target"
}