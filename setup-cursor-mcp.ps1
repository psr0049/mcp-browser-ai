# Cursor MCP Server Setup Script
# This script automatically configures Browserbase MCP server in Cursor

Write-Host "Setting up Browserbase MCP Server in Cursor..." -ForegroundColor Green

# Define the Cursor MCP configuration path
$cursorMcpPath = "$env:APPDATA\Cursor\User\globalStorage\cursor.mcp"
$cursorMcpConfig = "$cursorMcpPath\mcp-config.json"

Write-Host "Cursor MCP configuration path: $cursorMcpConfig" -ForegroundColor Cyan

# Create directory if it doesn't exist
if (-not (Test-Path $cursorMcpPath)) {
    Write-Host "Creating Cursor MCP directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $cursorMcpPath -Force | Out-Null
    Write-Host "✓ Created directory: $cursorMcpPath" -ForegroundColor Green
} else {
    Write-Host "✓ Cursor MCP directory exists" -ForegroundColor Green
}

# Create the MCP configuration
$mcpConfig = @{
    mcpServers = @{
        browserbase = @{
            command = "npx"
            args = @("@browserbasehq/mcp")
            env = @{
                BROWSERBASE_API_KEY = "your_browserbase_api_key_here"
                BROWSERBASE_PROJECT_ID = "your_browserbase_project_id_here"
                GEMINI_API_KEY = "your_gemini_api_key_here"
            }
        }
    }
}

# Convert to JSON and save
$mcpConfigJson = $mcpConfig | ConvertTo-Json -Depth 10

# Check if config file exists and backup if needed
if (Test-Path $cursorMcpConfig) {
    $backupPath = "$cursorMcpConfig.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Host "Backing up existing configuration to: $backupPath" -ForegroundColor Yellow
    Copy-Item $cursorMcpConfig $backupPath
    Write-Host "✓ Backup created" -ForegroundColor Green
}

# Save the new configuration
Write-Host "Creating MCP configuration file..." -ForegroundColor Yellow
$mcpConfigJson | Out-File -FilePath $cursorMcpConfig -Encoding UTF8
Write-Host "✓ MCP configuration saved to: $cursorMcpConfig" -ForegroundColor Green

# Verify the file was created
if (Test-Path $cursorMcpConfig) {
    Write-Host "✓ Configuration file verified" -ForegroundColor Green
    
    # Display the configuration
    Write-Host "Configuration created:" -ForegroundColor Cyan
    Get-Content $cursorMcpConfig | Write-Host -ForegroundColor Gray
} else {
    Write-Host "✗ Failed to create configuration file" -ForegroundColor Red
    exit 1
}

Write-Host "🎉 Setup Complete!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart Cursor completely" -ForegroundColor White
Write-Host "2. Open Command Palette (Ctrl + Shift + P)" -ForegroundColor White
Write-Host "3. Type 'MCP' to see available commands" -ForegroundColor White
Write-Host "4. Test with: 'Navigate to https://example.com and take a screenshot'" -ForegroundColor White

Write-Host "Configuration file location:" -ForegroundColor Yellow
Write-Host $cursorMcpConfig -ForegroundColor Gray