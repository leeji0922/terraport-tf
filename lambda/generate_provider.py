def generate_provider(region, access_key, secret_key):
    return f'''terraform {{
        required_version = ">= 1.0"
        aws = {{
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }}
    }}
    provider "aws" {{
        region     = var.region
        access_key = var.access_key
        secret_key = var.secret_key
    }}
    '''