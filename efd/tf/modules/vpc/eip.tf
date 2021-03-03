#Create an elasticIP resource for the nat gateway
resource "aws_eip" "natgwa" {
    vpc         =   true
}

#Create an elasticIP resource for the nat gateway
resource "aws_eip" "natgwb" {
    vpc         =   true
}

#Create an elasticIP resource for the nat gateway
resource "aws_eip" "natgwc" {
    vpc         =   true
}
