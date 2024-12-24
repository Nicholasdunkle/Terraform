webapp_environment = {
    "production" = {
        serviceplan={
            serviceplannsdunkle={
                sku="S1"
                os_type="Windows"
            }
        }
        serviceapp={
            webappnsdunkle="serviceplannsdunkle"
            webappnsdunkle2="serviceplannsdunkle"
        }
    }
    
}
resource_tags = {
        tags={
            department = "Logistics"
            tier = "Tier 2"
        }
      
    }

webapp_slot = ["webappnsdunkle", "staging"]
