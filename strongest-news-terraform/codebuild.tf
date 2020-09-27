data "aws_caller_identity" "self" {}

resource "aws_iam_role" "ecs_emtg-framework_role" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = [
              "ecs-tasks.amazonaws.com",
              "codebuild.amazonaws.com",
            ]
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "codebuild-${var.name}-build-service-role"
  path                  = "/service-role/"
  tags                  = {}
}

resource "aws_iam_role_policy" "CodeBuildCloudWatchLogsPolicy" {
  name   = "CodeBuildCloudWatchLogsPolicy-${var.name}"
  role   = aws_iam_role.ecs_emtg-framework_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ecs-policy" {
  name   = "ecs-${var.name}-policy"
  role   = aws_iam_role.ecs_emtg-framework_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTelemetrySession",
                "ecs:UpdateContainerInstancesState",
                "ecs:Submit*",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ecs:RegisterTaskDefinition",
                "ecs:ListTaskDefinitions",
                "ecs:DescribeTaskDefinition"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "CodeBuildBasePolicy" {
  name   = "CodeBuildBasePolicy-${var.name}"
  role   = aws_iam_role.ecs_emtg-framework_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:ap-northeast-1:963907091225:log-group:/aws/codebuild/*",
                "arn:aws:logs:ap-northeast-1:963907091225:log-group:/aws/codebuild/*:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:codecommit:ap-northeast-1:963907091225:*"
            ],
            "Action": [
                "codecommit:GitPull"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases"
            ],
            "Resource": [
                "arn:aws:codebuild:ap-northeast-1:963907091225:report-group/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ecr-policy" {
  name   = "ecr-${var.name}-policy"
  role   = aws_iam_role.ecs_emtg-framework_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:CompleteLayerUpload",
                "ecr:GetAuthorizationToken",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_codebuild_project" "emtg-framework" {
  badge_enabled  = false
  build_timeout  = 60
  encryption_key = "arn:aws:kms:ap-northeast-1:963907091225:alias/aws/s3"
  name           = "codebuild-${var.name}"
  queued_timeout = 480
  service_role   = aws_iam_role.ecs_emtg-framework_role.arn
  tags           = {}

  artifacts {
    encryption_disabled    = false
    location               = aws_s3_bucket.codebuild-artifacts.bucket
    name                   = "emtg-framework"
    namespace_type         = "NONE"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "S3"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = "ap-northeast-1"
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = data.aws_caller_identity.self.account_id
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME_FLASK"
      type  = "PLAINTEXT"
      value = aws_ecr_repository.emtg-framework-flask.name
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME_NGINX"
      type  = "PLAINTEXT"
      value = aws_ecr_repository.emtg-framework-nginx.name
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME_REACT"
      type  = "PLAINTEXT"
      value = aws_ecr_repository.emtg-framework-react.name
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME_MYSQL"
      type  = "PLAINTEXT"
      value = aws_ecr_repository.emtg-framework-mysql.name
    }
    environment_variable {
      name  = "IMAGE_TAG"
      type  = "PLAINTEXT"
      value = "latest"
    }
    environment_variable {
      name  = "TASK_FAMILY"
      type  = "PLAINTEXT"
      value = aws_ecs_task_definition.emtg-framework.family
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_codecommit_repository.emtg-framework.repository_name
      status      = "ENABLED"
      stream_name = "codebuild"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    git_clone_depth     = 1
    insecure_ssl        = false
    location            = aws_codecommit_repository.emtg-framework.clone_url_http
    report_build_status = false
    type                = "CODECOMMIT"
  }
}
