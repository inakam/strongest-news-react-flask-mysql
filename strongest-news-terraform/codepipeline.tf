data "aws_elb_service_account" "artifacts" {}

resource "aws_codepipeline" "emtg-framework-codepipeline" {
  name     = "${var.name}-pipeline"
  role_arn = aws_iam_role.codepipeline-role.arn
  tags     = {}

  artifact_store {
    location = aws_s3_bucket.codepipeline-artifacts.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "BranchName"           = "master"
        "PollForSourceChanges" = "false"
        "RepositoryName"       = aws_codecommit_repository.emtg-framework.id
      }
      input_artifacts = []
      name            = "Source"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeCommit"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = aws_codebuild_project.emtg-framework.id
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      configuration = {
        "ApplicationName"     = aws_codedeploy_app.emtg-framework.name
        "DeploymentGroupName" = aws_codedeploy_deployment_group.emtg-framework.deployment_group_name
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name             = "Deploy"
      output_artifacts = []
      owner            = "AWS"
      provider         = "CodeDeploy"
      run_order        = 1
      version          = "1"
    }
  }
}

data "aws_iam_policy_document" "artifacts" {
  policy_id = "EMTGSSEAndSSLPolicy-${var.name}"
  statement {
    sid    = "DenyUnEncryptedObjectUploads"
    effect = "Deny"
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.artifacts_name}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
  }

  statement {
    sid    = "DenyInsecureConnections"
    effect = "Deny"
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${var.artifacts_name}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_iam_role" "codepipeline-role" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "codepipeline.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "AWSCodePipelineServiceRole-emtg-framework-pipeline"
  path                  = "/service-role/"
  tags                  = {}
}

resource "aws_iam_role_policy" "AWSCodePipelineServiceRole" {
  name   = "AWSCodePipelineServiceRole-${var.name}"
  role   = aws_iam_role.codepipeline-role.id
  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "cloudformation.amazonaws.com",
                        "elasticbeanstalk.amazonaws.com",
                        "ec2.amazonaws.com",
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Action": [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticbeanstalk:*",
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "rds:*",
                "sqs:*",
                "ecs:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
                "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "opsworks:CreateDeployment",
                "opsworks:DescribeApps",
                "opsworks:DescribeCommands",
                "opsworks:DescribeDeployments",
                "opsworks:DescribeInstances",
                "opsworks:DescribeStacks",
                "opsworks:UpdateApp",
                "opsworks:UpdateStack"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:CreateChangeSet",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "devicefarm:ListProjects",
                "devicefarm:ListDevicePools",
                "devicefarm:GetRun",
                "devicefarm:GetUpload",
                "devicefarm:CreateUpload",
                "devicefarm:ScheduleRun"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:CreateProvisioningArtifact",
                "servicecatalog:DescribeProvisioningArtifact",
                "servicecatalog:DeleteProvisioningArtifact",
                "servicecatalog:UpdateProduct"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImages"
            ],
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role" "cwe-role" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "events.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "cwe-${var.name}-role"
  path                  = "/service-role/"
  tags                  = {}
}

resource "aws_iam_role_policy" "start-pipeline-execution" {
  name   = "start-pipeline-execution-${var.name}"
  role   = aws_iam_role.cwe-role.id
  policy = data.aws_iam_policy_document.pipeline_exec.json
}

data "aws_iam_policy_document" "pipeline_exec" {
  statement {
    sid = "pipelineExec"

    actions = [
      "codepipeline:StartPipelineExecution",
    ]

    resources = [aws_codepipeline.emtg-framework-codepipeline.arn]
  }
}

resource "aws_cloudwatch_event_rule" "cwe" {
  description = "Amazon CloudWatch イベントのルールに変更が発生すると、自動的にパイプラインを開始するために、AWS CodeCommit ソースリポジトリとブランチを削除すると、そのパイプラインの変更が検出されない場合があります。続きを読む :http://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-about-starting.html"
  event_pattern = jsonencode(
    {
      detail = {
        event = [
          "referenceCreated",
          "referenceUpdated",
        ]
        referenceName = [
          "master",
        ]
        referenceType = [
          "branch",
        ]
      }
      detail-type = [
        "CodeCommit Repository State Change",
      ]
      resources = [
        aws_codecommit_repository.emtg-framework.arn,
      ]
      source = [
        "aws.codecommit",
      ]
    }
  )
  is_enabled = true
  name       = "codepipeline-emtg-framework-master"
  tags       = {}
}

resource "aws_s3_bucket" "codepipeline-artifacts" {
  bucket        = var.artifacts_name
  acl           = "private"
  policy        = data.aws_iam_policy_document.artifacts.json
  force_destroy = true
}

