## GKE cluster creation example 
Following example shows how to create an GKE cluster.

Example configuration should be analysed in the following order:
1. Create VPC - `vpc.tf`
2. Create GKE cluster - `gke.tf`

# Usage
1. Rename `tf.vars.example` to `tf.vars`
2. Update `tf.vars` file with your project name, cluster name, cluster region, cluster zone and project ID. 
3. Initialize Terraform. Under example root folder run:
```
terraform init
```
4. Run Terraform apply:
```
terraform apply -var-file=tf.vars
```
5. To destroy resources created by this example:
```
terraform destroy -var-file=tf.vars
```
