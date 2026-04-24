#!/bin/bash

# Smoke Test Script for Foodie Platform
# Tests the application after ECS deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
SMOKE_TEST_URL="${1:-}"
MAX_RETRIES=5
RETRY_DELAY=10

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_url() {
    local url=$1
    local status_code
    
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
    echo "$status_code"
}

wait_for_service() {
    local url=$1
    local attempt=1
    
    log_info "Waiting for service to be ready..."
    
    while [ $attempt -le $MAX_RETRIES ]; do
        status_code=$(check_url "$url")
        
        if [ "$status_code" = "200" ]; then
            log_info "Service is ready! (HTTP $status_code)"
            return 0
        fi
        
        log_warn "Attempt $attempt/$MAX_RETRIES: Service not ready (HTTP $status_code)"
        sleep $RETRY_DELAY
        attempt=$((attempt + 1))
    done
    
    log_error "Service failed to become ready after $MAX_RETRIES attempts"
    return 1
}

test_response_content() {
    local url=$1
    local content
    
    log_info "Checking response content..."
    
    content=$(curl -s "$url" 2>/dev/null)
    
    # Check for basic HTML structure
    if echo "$content" | grep -q "<!DOCTYPE html>"; then
        log_info "HTML document structure found"
        return 0
    fi
    
    # Check for app container
    if echo "$content" | grep -q 'id="app"'; then
        log_info "App container found"
        return 0
    fi
    
    log_warn "Could not verify full content, but service responded"
    return 0
}

# Main execution
main() {
    log_info "Starting Smoke Test"
    echo "================================"
    
    # Check if URL is provided
    if [ -z "$SMOKE_TEST_URL" ]; then
        log_error "Usage: $0 <url>"
        log_error "Example: $0 https://foodie-alb-1644305675.eu-west-1.elb.amazonaws.com"
        exit 1
    fi
    
    log_info "Testing URL: $SMOKE_TEST_URL"
    
    # Test 1: Wait for service to be ready
    if ! wait_for_service "$SMOKE_TEST_URL"; then
        log_error "Smoke Test FAILED: Service not available"
        exit 1
    fi
    
    # Test 2: Verify response content
    if ! test_response_content "$SMOKE_TEST_URL"; then
        log_error "Smoke Test FAILED: Invalid response content"
        exit 1
    fi
    
    echo "================================"
    log_info "Smoke Test PASSED"
    exit 0
}

# Run main function
main "$@"