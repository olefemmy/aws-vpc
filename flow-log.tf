##################################################################################################################
#
# Enabled VPC flow logs if enabled in variable "enable_flow_log"
# all resources in this file have a count of enable_flow_log - true==1 false==0
#
##################################################################################################################

##################################################################################################################
#
# https://www.terraform.io/docs/providers/aws/r/flow_log.html
#
##################################################################################################################

resource "aws_flow_log" "vpc_flow_log" {
  count           = var.enable_flow_log
  log_destination = aws_cloudwatch_log_group.flow_log_group[0].arn
  iam_role_arn    = aws_iam_role.flow_log_role[0].arn
  vpc_id          = aws_vpc.vpc.id
  traffic_type    = "ALL"
}

# log group required by vpc_flow_log
resource "aws_cloudwatch_log_group" "flow_log_group" {
  count             = var.enable_flow_log
  name              = "${local.environment}-${local.account}-vpc-flow-log-group"
  retention_in_days = var.flow_log_retention_in_days

  tags = merge(
    local.tags,
    {
      "Type" = "cloudwatch log group"
    },
    {
      "Name" = "${local.environment}-${local.account}-vpc-flow-log-group"
    },
  )
}

# iam role required by vpc_flow_log
resource "aws_iam_role" "flow_log_role" {
  count = var.enable_flow_log
  name  = "${local.environment}-${local.account}-vpc-flow-log"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "flow_log_policy" {
  count = var.enable_flow_log
  name  = "${local.environment}-${local.account}-vpc-flow-log-policy"
  role  = aws_iam_role.flow_log_role[0].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

