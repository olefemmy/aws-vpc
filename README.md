# Creating AWS VPCs in Terraform

This module will allow you to create a fully functioning VPC in AWS via terraform. The module will create the following:

1. The VPC
2. Internet gateways
3. NAT Gateways
4. All required networking (subnets, routing tables etc)

## How to use the modue

Simple source the module from your terraform code and pass in the required variables.

```
module "vpc" {
  source = "../../modules/aws-vpc/"

  region         = "eu-west-1"
  environment    = "producion"
  service_name   = "management"
  vpc_cidr_block = "10.0.0.0/16"  
  az_limit       = 2
}
```

## What are the variables?

The module has 5 variables which do the following:

1. Region - which aws region you want the resource to be built in. (Default: eu-west-1)
2. Environment - Which environment you are creating the resource for
3. Service name - The name of the service
4. CIDR Block - The ip range to be used for the VPC
5. AZ Limit - The number of availabiity zones to use. (Default: 2)

## Clever bits

The module will take the CIDR block and the number of avaibility zones and work out the subnet sizes needed to split the block into the right number if pieces for you.
