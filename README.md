# gcp_static_template

A terraform template to deploy a static clientside sites to a gcp bucket. 

The domain will be the default gcp domain until I can get the domain module working. 

Instructions:
1. put your code into the build folder and run and build scripts if necessary(npm i, npm run build)
2. go into terraform directory and replace the .json file with your service key. 
3. rename the vars in terraform.tfvars
4. run terraform init, terraform plan, terraform apply