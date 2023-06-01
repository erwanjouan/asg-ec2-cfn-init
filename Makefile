start:
	aws cloudformation deploy \
		--stack-name asg-ec2-cfn-init \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-file infra.yml
