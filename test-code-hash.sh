#!/bin/bash

# Test script to demonstrate code hash verification
# This shows how multiple accounts can use the same code hash

echo "================================================"
echo "Code Hash Verification Test"
echo "================================================"
echo ""

# Your reproducible build hash
EXPECTED_HASH="945a1e72327c556cb8056a3c54044ae93888c550c8397676e5d5ed0d5678e64f"
CONTRACT_ACCOUNT="hellonearme.testnet"

echo "Expected Code Hash (from reproducible build):"
echo "$EXPECTED_HASH"
echo ""

# Download the deployed contract
echo "Downloading deployed contract from $CONTRACT_ACCOUNT..."
near contract download-wasm "$CONTRACT_ACCOUNT" save-to-file ./test-downloaded.wasm network-config testnet now > /dev/null 2>&1

# Calculate hash of downloaded contract
ACTUAL_HASH=$(sha256sum ./test-downloaded.wasm | awk '{print $1}')

echo "Deployed Contract Hash:"
echo "$ACTUAL_HASH"
echo ""

# Compare
if [ "$EXPECTED_HASH" = "$ACTUAL_HASH" ]; then
    echo "✅ SUCCESS: Hashes match!"
    echo ""
    echo "This means:"
    echo "1. The deployed contract matches your reproducible build"
    echo "2. Anyone can rebuild and verify this exact code"
    echo "3. Any other account deploying this same code will have the same hash"
    echo "4. Verification services can auto-verify all instances of this hash"
else
    echo "❌ FAILED: Hashes don't match"
    echo "Expected: $EXPECTED_HASH"
    echo "Got:      $ACTUAL_HASH"
fi

echo ""
echo "================================================"
echo "Git Information for Verification:"
echo "================================================"
echo "Repository: https://github.com/flyatmidnight/testcontract"
echo "Commit: $(git rev-parse HEAD)"
echo ""
echo "To verify on SourceScan:"
echo "1. Visit: https://testnet.sourcescan.dev/"
echo "2. Submit contract: $CONTRACT_ACCOUNT"
echo "3. Use git commit: $(git rev-parse HEAD)"
echo ""

# Cleanup
rm -f ./test-downloaded.wasm

echo "Test complete!"
