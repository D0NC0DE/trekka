#!/usr/bin/env node

/**
 * Generate a secure encryption key
 * Run: node scripts/generate-encryption-key.js
 */

const crypto = require('crypto');

// Generate 32 random bytes (256 bits for AES-256)
const encryptionKey = crypto.randomBytes(32).toString('base64');

console.log('\n🔐 Generated Encryption Key:\n');
console.log(encryptionKey);

