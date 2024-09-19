deploy_devl:
	cd terraform && terraform init
	cd terraform && terraform apply --var-file=devl.tfvars -auto-approve
	python scripts/inventory.py > ansible/inventory
	cd ansible && ansible-playbook -e env=dev -i inventory create_nginx_config.yml 
	cd ansible && ansible-playbook -e env=dev -i inventory nginx_deploy.yml 

destroy_devl:
	cd terraform && terraform destroy --var-file=devl.tfvars -auto-approve
	
