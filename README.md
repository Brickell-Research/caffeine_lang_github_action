# caffeine-lang GitHub Action

An example integration of the [Caffeine language](https://github.com/BrickellResearch/caffeine_lang) into a GitHub Action.

How I use it today in my Terraform SLO Sync workflow (for Datadog SLOs):
```yaml
name: Sync SLOs - Caffeine Lang

on:
  push:
    branches:
      - main

jobs:
  test-binary:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: slos
    
    steps:
    - name: Checkout repository
      uses: actions/checkout@v4
    
    - name: Compile SLOs with the Caffeine Language
      uses: Brickell-Research/caffeine_lang_github_action@main
      with:
        spec_dir: slos/specifications
        inst_dir: slos/YOUR_ORG
        output_dir: slos

    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: "1.5.7"

    - name: Terraform Init
      run: |
          terraform init \
            -backend-config="path=slos/terraform.tfstate" \
            -migrate-state \
            -force-copy \
            -input=false
      env:
        TF_INPUT: "false"
        TF_IN_AUTOMATION: "true"
    
    - name: Terraform Validate
      run: terraform validate
    
    - name: Validate Datadog Credentials
      env:
        DATADOG_API_KEY: ${{ secrets.DATADOG_API_KEY }}
        DATADOG_APP_KEY: ${{ secrets.DATADOG_APP_KEY }}
      run: |
        if [ -z "$DATADOG_API_KEY" ] || [ -z "$DATADOG_APP_KEY" ]; then
          echo "Error: DATADOG_API_KEY or DATADOG_APP_KEY is not set in GitHub secrets."
          exit 1
        fi
        
        echo "Validating Datadog API credentials..."
        response_code=$(curl -s -o /dev/null -w "%{http_code}" -H "DD-API-KEY: $DATADOG_API_KEY" -H "DD-APPLICATION-KEY: $DATADOG_APP_KEY" "https://api.datadoghq.com/api/v1/validate")
        
        if [ "$response_code" -eq 200 ]; then
          echo "✅ Datadog credentials are valid."
        else
          echo "❌ Error: Datadog credentials validation failed. HTTP status code: $response_code"
          exit 1
        fi

    - name: Terraform Apply
      run: terraform apply -auto-approve
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        DATADOG_API_KEY: ${{ secrets.DATADOG_API_KEY }}
        DATADOG_APP_KEY: ${{ secrets.DATADOG_APP_KEY }}

    - name: Commit and Push Terraform State
      run: |
        git config --global user.name "GitHub Actions Bot"
        git config --global user.email "github-actions[bot]@users.noreply.github.com"
        git add -f slos/*.tfstate
        git commit -m "[SLO SYNC] Update Terraform state files [skip ci]" || exit 0
        git push
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```