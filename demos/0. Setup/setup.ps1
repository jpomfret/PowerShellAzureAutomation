try {
    Remove-AzResourceGroup -Name rg-psconfeu-001 -Force -ErrorAction Stop
} catch {
    Write-Warning "Failed to remove resource group: $_"
}

Describe "Resource Group doesn't exist" {
    It "should not find the resource group" {
        $result = Get-AzResourceGroup -Name rg-psconfeu-001 -ErrorAction SilentlyContinue
        $result | Should -BeNullOrEmpty
    }
}