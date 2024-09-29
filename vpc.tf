resource "aws_vpc" "k8s_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "k8s_subnets" {
  count                  = 2
  vpc_id                 = aws_vpc.k8s_vpc.id
  cidr_block             = cidrsubnet(aws_vpc.k8s_vpc.cidr_block, 8, count.index)
  availability_zone      = element(data.aws_availability_zones.available.names, count.index)
}
