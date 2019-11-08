> This repository is under development.

<img src="logo.png" width=30% height=30%>

Checkout [my blog](http://hakersparadise.blogspot.com/).

## What is Terraform? 

Terraform is a tool made by Hashicorp for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers ( aws, azure, Google cloud) as well as custom in-house solutions.

**Terraform** is similar to **Cloudformation** in AWS. Both works as a Platform as a Service (PaaS).


# Table of Contents

   * [Installation](#installation)
   * [Usage](#usage)
   * [Pricing](#pricing)

# Installation

1) Download the latest terraform binary zipped file from [this link](https://www.terraform.io/downloads.html)
```wget https://releases.hashicorp.com/terraform/0.12.13/terraform_0.12.13_linux_amd64.zip```

2) Unzip the file into /usr/local/bin location
```unzip terraform_0.xx.xx_linux_amd64.zip /usr/local/bin```

3) Change the file access modifier to executable.
```sudo chmod +x terraform```

# Usage

Initiate the directory where we have the terraform .tf file. Use --backend-config parameter if using external config file.

```terraform init --backend-config="infrastructure.config"```

Check the changes that Terraform will perform after executing the script.

```terraform plan (if not using any external file to pass the variables)```

```terraform plan --var-file="infrastructure-variables.tfvars"```

Apply the modification or creation of the infrastructure as per the code in tf script. This will ask for confirmation (yes) to go ahead.

```terraform apply```

```terraform apply --var-file="infrastructure-variables.tfvars"```

> - outputs.tf required to output all the variables after the execution of apply command.

Show the infrastructure variables created
```terraform show```

To delete all the resources/infrastructure created on AWS
```terraform destroy```

# Pricing

Terraform is an open source tool for developing resources. 
Only cost associated is for building infrastructure in providers like AWS, GCP, Azure.
Refer to the AWS pricing calculator to know the billing info regarding any resources created in AWS through Terraform.
https://calculator.s3.amazonaws.com/index.html