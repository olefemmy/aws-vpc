##################################################################################################################
#                                                                                                                #
# aws_subnet: Provides an VPC subnet resource.                                                                   #
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/r/subnet.html                                     #
#                                                                                                                #
##################################################################################################################

resource "aws_subnet" "subnet_private" {
  count             = var.az_limit
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, var.az_limit, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.tags,
    {
      "Type" = "vpc subnet"
    },
    {
      "Name" = "${local.environment}-${local.account}-subnet-private-${data.aws_availability_zones.available.names[count.index]}"
    },
  )
}

##################################################################################################################
#                                                                                                                #
# NOTE: Use (var.az_limit + count.index) as we have a private subnet created above for each AZ, therefore AZ +   #
# count should increment                                                                                         #
#                                                                                                                #
##################################################################################################################

resource "aws_subnet" "subnet_public" {
  count  = var.az_limit
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(
    aws_vpc.vpc.cidr_block,
    var.az_limit,
    var.az_limit + count.index,
  )
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.tags,
    {
      "Type" = "vpc subnet"
    },
    {
      "Name" = "${local.environment}-${local.account}-subnet-public-${data.aws_availability_zones.available.names[count.index]}"
    },
  )
}

