##################################################################################################################
#                                                                                                                #
# aws_internet_gate: Provides a resource to create a VPC Internet Gateway.                                       #
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/r/internet_gateway.html                           #
#                                                                                                                #
##################################################################################################################

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Type" = "vpc internet gateway"
    },
    {
      "Name" = "${local.environment}-${local.account}-internet-gateway"
    },
  )
}

##################################################################################################################
#                                                                                                                #
# aws_route_table: Provides details about a specific Route Table.                                                #
#                                                                                                                #
# This resource can prove useful when a module accepts a Subnet id as an input variable and needs to, for        #
# example, add a route in the Route Table.                                                                       #
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/d/route_table.html                                #
#                                                                                                                #
##################################################################################################################

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Type" = "vpc route table"
    },
    {
      "Name" = "${local.environment}-${local.account}-public-route-table"
    },
  )
}

##################################################################################################################
#                                                                                                                #
# aws_route: Provides a resource to create a routing table entry (a route) in a VPC routing table.               #
#                                                                                                                #
# NOTE on Route Tables and Routes: Terraform currently provides both a standalone Route resource and a Route     #
# Table resource with routes defined in-line. At this time you cannot use a Route Table with in-line routes in   #
# conjunction with any Route resources. Doing so will cause a conflict of rule settings and will overwrite rules.#
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/r/route.html                                      #
#                                                                                                                #
##################################################################################################################

resource "aws_route" "internet_gateway_public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

##################################################################################################################
#                                                                                                                #
# Provides a resource to create an association between a subnet and routing table.                               #
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/r/route_table_association.html                    #
#                                                                                                                #
##################################################################################################################

resource "aws_route_table_association" "public_rt_association" {
  count          = var.az_limit
  subnet_id      = element(aws_subnet.subnet_public.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

