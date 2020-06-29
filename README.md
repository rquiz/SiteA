# SiteA: overview
SiteA is a simple repo designed to provide key infrastructural elements of a common webserver. 

## Design
SiteA is designed to isolate complex infrastructure aspects by wrapping tools like Terraform, Chef, ETC with structure, boilerplates, and consistent architectures.

### Terraform
This tool is used primarily to interact with Cloud Providers (AWS at the time of writing). By concentrating on networks, compute and storage layers of SiteA, this provides
a logical boundary for Terraform vs other provisioning tools in the SiteA structure.

### Chef
Configuring compute instances with the proper programs and default settings is handled via Chef.

## Usage
Simple commands to manage the components of SiteA
