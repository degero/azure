from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.network import NetworkManagementClient
import re
import argparse

def sanitize_name(name):
    """
    Sanitize resource names for Mermaid compatibility:
    1. Replace special characters with underscores
    2. Escape parentheses in display text
    3. Ensure the ID is valid for Mermaid
    """
    # Create a valid ID by replacing all special chars with underscore
    valid_id = re.sub(r'[^a-zA-Z0-9]', '_', name)
    
    # Escape special characters in display name
    display_name = name.replace('(', '\\(').replace(')', '\\)')
    
    return valid_id, display_name

def generate_topology(subscription_id, resource_group_name=None):
    """
    Generate topology diagram for Azure resources
    :param subscription_id: Azure subscription ID
    :param resource_group_name: Optional resource group name to filter
    :return: Mermaid diagram as string
    """
    # Authenticate using default credentials (requires azure-cli login)
    credential = DefaultAzureCredential()
    
    # Initialize the clients
    resource_client = ResourceManagementClient(credential, subscription_id)
    network_client = NetworkManagementClient(credential, subscription_id)
    
    # Initialize Mermaid diagram with styling
    mermaid_diagram = [
        ":::mermaid",
        "%%{init: {'theme': 'default', 'themeVariables': { 'fontSize': '12px' }}}%%",
        "graph TB",
        "    %% Style definitions",
        "    classDef resourceGroup fill:#f9f,stroke:#333,stroke-width:2px;",
        "    classDef resource fill:#fff,stroke:#666,stroke-width:1px;"
    ]
    
    # Track processed resources and style classes
    processed_resources = set()
    resource_group_ids = []
    resource_ids = []
    
    # Get resource groups
    if resource_group_name:
        resource_groups = [resource_client.resource_groups.get(resource_group_name)]
        print(f"Scanning resources in resource group: {resource_group_name}")
    else:
        resource_groups = resource_client.resource_groups.list()
        print("Scanning resources in all resource groups...")
    
    for rg in resource_groups:
        rg_id, rg_display = sanitize_name(rg.name)
        resource_group_ids.append(rg_id)
        
        # Add resource group to diagram
        mermaid_diagram.append(f"    {rg_id}[{rg_display}]")
        
        # Get all resources in the resource group
        resources = resource_client.resources.list_by_resource_group(rg.name)
        
        for resource in resources:
            resource_name = resource.name
            resource_type = resource.type.split('/')[-1]
            
            # Create sanitized IDs and display names
            resource_id, resource_display = sanitize_name(f"{resource_type}_{resource_name}")
            
            if resource_id not in processed_resources:
                processed_resources.add(resource_id)
                resource_ids.append(resource_id)
                
                # Add resource to diagram
                mermaid_diagram.append(f"    {resource_id}[\"{resource_display}\"]")
                mermaid_diagram.append(f"    {rg_id} --> {resource_id}")
                
                # If it's a network resource, add additional connections
                if resource.type.startswith('Microsoft.Network'):
                    try:
                        if 'virtualNetworks' in resource.type.lower():
                            subnets = network_client.subnets.list(rg.name, resource_name)
                            for subnet in subnets:
                                subnet_id, subnet_display = sanitize_name(f"Subnet_{subnet.name}")
                                resource_ids.append(subnet_id)
                                mermaid_diagram.append(f"    {subnet_id}[\"{subnet_display}\"]")
                                mermaid_diagram.append(f"    {resource_id} --> {subnet_id}")
                    except Exception as e:
                        print(f"Warning: Could not process network resource {resource_name}: {str(e)}")
    
    # Add style classes
    if resource_group_ids:
        mermaid_diagram.append(f"    class {','.join(resource_group_ids)} resourceGroup;")
    if resource_ids:
        mermaid_diagram.append(f"    class {','.join(resource_ids)} resource;")
    
    mermaid_diagram.append(":::")
    
    # Return the complete Mermaid diagram
    return "\n".join(mermaid_diagram)

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description='Generate Azure resource topology diagram')
    parser.add_argument('--subscription-id', '-s', required=True, help='Azure subscription ID')
    parser.add_argument('--resource-group', '-g', help='Resource group name (optional)')
    parser.add_argument('--output', '-o', default='azure_topology.mmd', help='Output file name (default: azure_topology.mmd)')
    
    args = parser.parse_args()
    
    try:
        diagram = generate_topology(args.subscription_id, args.resource_group)
        
        # Save to file
        with open(args.output, 'w') as f:
            f.write(diagram)
        print(f"Topology diagram has been generated and saved to '{args.output}'")
        print("\nMermaid diagram content:")
        print(diagram)
        
    except Exception as e:
        print(f"Error generating topology: {str(e)}")

if __name__ == "__main__":
    main()