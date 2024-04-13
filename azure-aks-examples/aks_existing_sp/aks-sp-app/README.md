# Onboarding an AKS Cluster to CAST AI with an Existing Service Principal

This guide demonstrates how to onboard an AKS cluster to CAST AI using an existing Service Principal. This approach allows you to onboard a cluster that already has a Service Principal and role configured for CAST AI to use.

## Prerequisites
- CAST AI account
- CAST AI [API Access key](https://docs.cast.ai/docs/authentication#obtaining-api-access-key) with Full Access
- Client Secret passed as an exported variable

## Steps

1. **Configure `tf.vars` File**: Update the `tf.vars` file with the required values. If the AKS cluster is already managed by Terraform, you can reference those resources directly. Here's a sample configuration:
    ```hcl
    castai_api_token    = ""
    cluster_name        = ""
    cluster_region      = ""
    resource_group      = ""
    subscription_id     = ""
    subnets             = [""]
    azuread_application = ""
    ```

2. **Initialize Terraform**: Run the following command in the root folder of the example:
    ```bash
    terraform init
    ```

3. **Apply Terraform Configuration**: Run the following command to apply the configuration changes:
    ```bash
    terraform apply -var-file=tf.vars
    ```

4. **Destroy Resources (Optional)**: To remove the resources created by this example, run the following command:
    ```bash
    terraform destroy -var-file=tf.vars
    ```

If you encounter any issues during the process, refer to the [Terraform Troubleshooting Guide](https://docs.cast.ai/docs/terraform-troubleshooting) for assistance.

This example demonstrates how to seamlessly onboard an existing AKS cluster to CAST AI using an existing Service Principal.
