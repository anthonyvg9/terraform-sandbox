# Example of AKS cluster
Following example creates AKS cluster and its supporting resources using Azure community modules.
Example configuration should be analysed in the following order:
1. Create Virtual network - `vnet.tf`
2. Create AKS cluster - `aks.tf`

# Usage
1. Rename `tf.vars.example` to `tf.vars`
2. Update `tf.vars` file with your cluster name and cluster region.
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