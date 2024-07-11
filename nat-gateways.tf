##################################################################################################################
#                                                                                                                #
# Provides an Elastic IP resource.                                                                               #
#                                                                                                                #
# Note for HA use a NAT Gateway per Subnet/Availability                                                          #
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/r/eip.html                                        #
#                                                                                                                #
##################################################################################################################

resource "aws_eip" "nat_gateway_eip" {
  domain   = "vpc"
  count = var.az_limit

  tags = merge(
    local.tags,
    {
      "Type" = "vpc eip"
    },
    {
      "Name" = "${local.account}-${local.environment}-${element(aws_subnet.subnet_public.*.availability_zone, count.index)}"
    },
  )
}

##################################################################################################################
#                                                                                                                #
# Provides a resource to create a VPC NAT Gateway.                                                               #
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/r/nat_gateway.html                                #
#                                                                                                                #
##################################################################################################################

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.az_limit
  allocation_id = element(aws_eip.nat_gateway_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.subnet_public.*.id, count.index)

  tags = merge(
    local.tags,
    {
      "Type" = "vpc nat gateway"
    },
    {
      "Name" = "${local.account}-${local.environment}-${element(aws_subnet.subnet_public.*.availability_zone, count.index)}"
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

resource "aws_route_table" "private_route_table" {
  count  = var.az_limit
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Type" = "vpc route table"
    },
    {
      "Name" = "${local.environment}-${local.account}-private-route-table-${data.aws_availability_zones.available.names[count.index]}"
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

resource "aws_route" "nat_gateway_private_route" {
  count                  = var.az_limit
  route_table_id         = element(aws_route_table.private_route_table.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat_gateway.*.id, count.index)
}

##################################################################################################################
#                                                                                                                #
# Provides a resource to create an association between a subnet and routing table.                               #
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/r/route_table_association.html                    #
#                                                                                                                #
##################################################################################################################

resource "aws_route_table_association" "private_rt_association" {
  count          = var.az_limit
  subnet_id      = element(aws_subnet.subnet_private.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}

