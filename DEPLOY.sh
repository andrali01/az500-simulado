#!/bin/bash
# =============================================================
# AZ-500 Simulado — Deploy Script
# Subscription: 8d2d4fdf-2429-4855-bf04-ffff895436f5
# GitHub: andrali01/az500-simulado
# =============================================================

set -e

SUBSCRIPTION_ID="8d2d4fdf-2429-4855-bf04-ffff895436f5"
RESOURCE_GROUP="rg-az500-simulado"
APP_NAME="app-az500-simulado"
LOCATION="eastus"
GITHUB_REPO="https://github.com/andrali01/az500-simulado"
GITHUB_BRANCH="main"

echo ""
echo "=================================================="
echo "  AZ-500 Simulado — Azure Static Web App Deploy"
echo "=================================================="
echo ""

# STEP 1 — Login e set subscription
echo "[1/5] Autenticando na Azure..."
az login
az account set --subscription "$SUBSCRIPTION_ID"
echo "✅ Subscription configurada: $SUBSCRIPTION_ID"

# STEP 2 — Criar Resource Group
echo ""
echo "[2/5] Criando Resource Group: $RESOURCE_GROUP..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"
echo "✅ Resource Group criado em $LOCATION"

# STEP 3 — Criar Static Web App
echo ""
echo "[3/5] Criando Azure Static Web App: $APP_NAME..."
az staticwebapp create \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --source "$GITHUB_REPO" \
  --location "$LOCATION" \
  --branch "$GITHUB_BRANCH" \
  --app-location "/" \
  --output-location "" \
  --login-with-github
echo "✅ Static Web App criado"

# STEP 4 — Pegar o deployment token
echo ""
echo "[4/5] Recuperando Deployment Token..."
DEPLOY_TOKEN=$(az staticwebapp secrets list \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "properties.apiKey" -o tsv)

echo ""
echo "=================================================="
echo "  ⚠️  SALVE ESTE TOKEN — você vai precisar dele"
echo "=================================================="
echo "  AZURE_STATIC_WEB_APPS_API_TOKEN:"
echo "  $DEPLOY_TOKEN"
echo "=================================================="

# STEP 5 — Pegar a URL
echo ""
echo "[5/5] Obtendo URL do aplicativo..."
APP_URL=$(az staticwebapp show \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "defaultHostname" -o tsv)

echo ""
echo "=================================================="
echo "  ✅ DEPLOY CONCLUÍDO!"
echo "  🌐 URL: https://$APP_URL"
echo "=================================================="
echo ""
echo "PRÓXIMO PASSO:"
echo "  Adicione o token acima como Secret no GitHub:"
echo "  https://github.com/andrali01/az500-simulado/settings/secrets/actions"
echo "  Nome do secret: AZURE_STATIC_WEB_APPS_API_TOKEN"
echo ""
