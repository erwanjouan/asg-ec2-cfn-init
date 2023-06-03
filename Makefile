start:
	aws cloudformation deploy \
		--stack-name asg-ec2-cfn-init \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-file infra.yml

key-pair:
	aws ec2 create-key-pair \
		--key-name k3 \
		--key-type ed25519 \
		--query "KeyMaterial" \
		--output text > k3.pem