##################################################################################################################
#                                                                                                                #
# aws_vpc provides details about a specific VPC.                                                                 #
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/d/vpc.html                                        #
#                                                                                                                #
##################################################################################################################

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = merge(
    local.tags,
    {
      "Type" = "vpc"
    },
    {
      "Name" = "${local.environment}-${local.account}-vpc"
    },
  )
}

##################################################################################################################
#                                                                                                                #
# Provides a resource for managing the main routing table of a VPC.                                              #
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/r/main_route_table_assoc.html                     #
#                                                                                                                #
##################################################################################################################

resource "aws_main_route_table_association" "main_route_table" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_vpc.vpc.main_route_table_id
}

