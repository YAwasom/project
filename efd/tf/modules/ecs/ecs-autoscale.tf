
#Build aws launch template
resource "aws_launch_template" "efd-launchtemplate" {
    name                                    = "wb-cmd-efd-ecs-${var.app}-${var.efd_env}-LaunchConfiguration"
    image_id                                = var.image_id #data.aws_ssm_parameter.ecsami.value
    instance_type                           = var.instance_size
    key_name                                = var.ec2_key
    disable_api_termination                 = true
    credit_specification  {
      cpu_credits = "unlimited"
    }
    block_device_mappings {
      device_name = "/dev/xvda"
      ebs {
        volume_size                             = 30
        encrypted                               = true
        kms_key_id                              = var.kms_key_id
        delete_on_termination                   = true
      }
    }
    #ebs_optimized                           = true
    vpc_security_group_ids                  =  [aws_security_group.efd-ECS-SG.id]
   
   

    block_device_mappings {
        device_name     = "/dev/xvda"

        ebs {
            volume_size = 30
        }
     
    }

iam_instance_profile{

    name = aws_iam_instance_profile.wb-cmd-efd-ecs-efd-efdECSInstanceProfile.name
}

tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "efd-ecs-${var.app}-${var.efd_env}" 
    }
  }
   user_data = base64encode(templatefile("${path.module}/${var.ecs_templatefile}", {efdenv = var.efd_env, app = var.app} ))
}

#Build autoscaling group 
#ToDO: Size/capacity should be moved to variables in tfvars
resource "aws_autoscaling_group" "efd-asg" {
    name                        =  "efd-${var.app}-${var.efd_env}-asg"
    vpc_zone_identifier        =  var.priv_subnets #[aws_subnet.private_a.id,aws_subnet.private_b.id]
    #availability_zones          =   ["${var.region}a","${var.region}b"]
    desired_capacity            =   2
    max_size                    =   2
    min_size                    =   1
    #service_linked_role_arn     =   aws_iam_service_linked_role.efdservicelinkedrole.arn
    service_linked_role_arn     = "arn:aws:iam::${var.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  launch_template{
      id                    =  aws_launch_template.efd-launchtemplate.id
      version               =  "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

}

