##################################################################################################################
#                                                                                                                #
# aws_default_security_group managed the default securit group for a vpc                                         #
# toggled by "delete_default_sg_rules" variable                                                                  #
#                                                                                                                #
# Further reading: https://www.terraform.io/docs/providers/aws/r/default_security_group.html                     #
#                                                                                                                #
##################################################################################################################

resource "aws_default_security_group" "default" {
  count  = var.delete_default_sg_rules
  vpc_id = aws_vpc.vpc.id
  tags   = local.tags
}

