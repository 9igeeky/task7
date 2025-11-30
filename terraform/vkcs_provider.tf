terraform {
    required_providers {
        vkcs = {
            source = "vk-cs/vkcs"
            version = "< 1.0.0"
        }
    }
}

provider "vkcs" {
    # Your user account.
    username = "${env("OS_USERNAME")}"

    # The password of the account
    password = "${env("OS_PASSWORD")}"

    # The tenant token can be taken from the project Settings tab - > API keys.
    # Project ID will be our token.
    project_id = "${env("OS_PROJECT_ID")}"
    
    # Region name
    region = "RegionOne"
    
    auth_url = "${env("OS_AUTH_URL")}"
}
