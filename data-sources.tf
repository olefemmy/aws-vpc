##################################################################################################################
#                                                                                                                #
# The Availability Zones data source allows access to the list of AWS Availability Zones which can be accessed   #
# by an AWS account within the region configured in the provider.                                                #
#                                                                                                                #
# This is different from the aws_availability_zone (singular) data source, which provides some details about a   #
# specific availability zone.                                                                                    #
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/d/availability_zones.html                         #
#                                                                                                                #
##################################################################################################################

data "aws_availability_zones" "available" {
}

data "aws_caller_identity" "current" {
}

