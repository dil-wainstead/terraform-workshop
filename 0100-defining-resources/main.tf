provider "aws" {
  # access_key = "ASIAXVXZ7PU5S4ZGAWEO"
  # secret_key = "ghEhR8bC2dO0AGhYxEWioAfwmMCBP6v8vXTyPthm"
  # region     = "us-east-1"
}

# TODO
# Define an EC2 instance (aws_instance) with the following constraints:
# Resource identifier - exercise_0010
#
# ami = ami-07ebfd5b3428b6f4d
# instance type = t2.micro
#
# Be sure to tag it with:
# - "Name" to "exercise_0010"
# - "Terraform" to true
resource "aws_instance" "sw_exercise_0100" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"

  tags = {
    Name      = "sw_exercise_0100"
    Terraform = true
    Ooga      = "booga"
  }
}
